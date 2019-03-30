import UIKit
import ARKit

@available(iOS 12.0, *)
public class MainViewController: UIViewController, NodeEditorDelegate {
    
    // MARK: Properties
    
    // AR Properties
    
    private let configuration: ARWorldTrackingConfiguration = {
        let config = ARWorldTrackingConfiguration()
        config.environmentTexturing = .automatic
        return config
    }()
    
    private lazy var sphereNode: SCNNode = {
        let sphereNode = SCNNode(geometry: SCNSphere(radius: 1))
        sphereNode.geometry?.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.9803921569, green: 1, blue: 1, alpha: 1)
        sphereNode.geometry?.firstMaterial?.transparency = 0.5
        sphereNode.geometry?.firstMaterial?.isDoubleSided = true
        sphereNode.geometry?.firstMaterial?.lightingModel = .physicallyBased
        sphereNode.geometry?.firstMaterial?.transparencyMode = .dualLayer
        sphereNode.geometry?.firstMaterial?.fresnelExponent = 1.5
        sphereNode.geometry?.firstMaterial?.specular.contents = #colorLiteral(red: 0.9803921569, green: 1, blue: 1, alpha: 1)
        sphereNode.geometry?.firstMaterial?.shininess = 25
        sphereNode.geometry?.firstMaterial?.selfIllumination.contents = UIColor.white
        return sphereNode
    }()
    
    private var speakerNodes = [String: SCNNode]() {
        didSet {
            playbackToggleButton.isEnabled = !speakerNodes.isEmpty
        }
    }
    
    // UI Properties
    
    private var editorViewLeadingConstraint: NSLayoutConstraint!
    
    private lazy var stateOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.8
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "Please scan and establish a large space from your environment.\nDompel is an interactive application that requires movement to experience its full immersion.\nDompel also requires headphones; please connect a pair of headphones to your device before proceeding."
        label.numberOfLines = 3
        label.textAlignment = .center
        label.font = UIFont(name: "Futura", size: 19)
        label.textColor = .white
        label.shadowColor = .gray
        label.shadowOffset = CGSize(width: -1, height: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.add(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -300),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        return view
    }()
    
    private var arStateIsReady = false {
        didSet {
            UIView.animate(withDuration: setUp ? 2 : 0.8) {
                self.stateOverlayView.alpha = self.arStateIsReady ? 0 : 0.8
            }
        }
    }
    
    private var setUp = false
    
    private var cyclesSinceLastRender = 5
    
    private var sceneView: ARSCNView = {
        let sceneView = ARSCNView()
        sceneView.preferredFramesPerSecond = 60
        sceneView.automaticallyUpdatesLighting = true
        sceneView.debugOptions = [.showFeaturePoints]
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        return sceneView
    }()
    
    private var mapperView = MapperView()
    private var nodeEditorView = NodeEditorView()
    private var reverbView = ReverbView()
    
    private var playImage = UIImage(named: "Play Icon")!
    private var stopImage = UIImage(named: "Stop Icon")!
    
    private var playbackToggleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Stop Icon")!
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .themeColor
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var editorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9700000286, green: 0.9700000286, blue: 0.9700000286, alpha: 1)
        view.clipsToBounds = true
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 3.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var toggleEditorViewButton: UIButton = {
        let button = UIButton()
        button.setTitle("<<\n\nC\nO\nL\nL\nA\nP\nS\nE\n\n<<", for: .normal)
        button.setTitleColor(.themeColor, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.titleLabel!.numberOfLines = 12
        button.titleLabel!.font = UIFont(name: "Futura", size: 16)
        button.titleLabel!.textAlignment = .center
        button.backgroundColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var experienceSelectorToggleButton: UIButton = {
        let button = UIButton.createDefault()
        button.setTitle("EXPERIENCES", for: .normal)
        return button
    }()
    
    private var resetExperienceButton: UIButton = {
        let button = UIButton.createDefault()
        button.setTitle("RESET", for: .normal)
        return button
    }()
    
    // MARK: View Controller Life Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        assignDelegates()
        addTargets()
        setUpView()
        setUpSubviews()
        setUpObservers()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run(configuration)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // MARK: Selector Functions
    
    @objc private func toggleEditorView() {
        let isOpen = (editorViewLeadingConstraint.constant == 0)
        
        let updateConstant = isOpen ? -(self.editorView.bounds.width - 45) : 0
        let updateTitle = isOpen ? ">>\n\nO\nP\nE\nN\n\n>>" : "<<\n\nC\nO\nL\nL\nA\nP\nS\nE\n\n<<"
        
        editorViewLeadingConstraint.constant = updateConstant
        
        UIView.animate(withDuration: 0.8) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
        UIView.transition(with: toggleEditorViewButton,
                          duration: 0.8,
                          options: isOpen ? .transitionFlipFromLeft : .transitionFlipFromRight,
                          animations: { [weak self] in
                            self?.toggleEditorViewButton.setTitle(updateTitle, for: .normal)
        })
    }
    
    @objc private func toggleExperienceSelectorVC() {
        let vc = ExperienceSelectorTableViewController()
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.tintColor = .themeColor
        self.presentPopUp(nc, withSize: CGSize(width: 300, height: 300),
                          by: experienceSelectorToggleButton)
    }
    
    @objc private func resetExperience() {
        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        setUpARScene()
        for node in speakerNodes.values {
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    @objc private func clearExperience() {
        for (id, node) in speakerNodes {
            node.removeFromParentNode()
            speakerNodes[id] = nil
        }
    }
    
    @objc private func togglePlayback() {
        let currentState = AudioEnvironment.shared.getPlayBackState()
        AudioEnvironment.shared.setPlaybackStateTo(!currentState)
        playbackToggleButton.setImage((currentState ? playImage : stopImage), for: .normal)
    }
    
    // MARK: Private Functions
    
    private func setUpView() {
        view.backgroundColor = .white
    }
    
    private func setUpSubviews() {
        view.add(sceneView, editorView, experienceSelectorToggleButton,
                 resetExperienceButton, playbackToggleButton, stateOverlayView)
        editorView.add(mapperView, nodeEditorView, reverbView, toggleEditorViewButton)
        
        sceneView.constrainToEdges()
        stateOverlayView.constrainToEdges()
        
        editorViewLeadingConstraint = editorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            editorViewLeadingConstraint,
            editorView.widthAnchor.constraint(equalToConstant: 944),
            editorView.heightAnchor.constraint(equalToConstant: 300),
            editorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            toggleEditorViewButton.bottomAnchor.constraint(equalTo: editorView.bottomAnchor),
            toggleEditorViewButton.topAnchor.constraint(equalTo: editorView.topAnchor),
            toggleEditorViewButton.trailingAnchor.constraint(equalTo: editorView.trailingAnchor),
            toggleEditorViewButton.widthAnchor.constraint(equalToConstant: 45),
            
            mapperView.leadingAnchor.constraint(equalTo: editorView.leadingAnchor, constant: 10),
            mapperView.topAnchor.constraint(equalTo: editorView.topAnchor, constant: 10),
            mapperView.bottomAnchor.constraint(equalTo: editorView.bottomAnchor, constant: -10),
            mapperView.widthAnchor.constraint(equalTo: mapperView.heightAnchor, constant: -21),
            
            nodeEditorView.leadingAnchor.constraint(equalTo: mapperView.trailingAnchor, constant: 10),
            nodeEditorView.topAnchor.constraint(equalTo: mapperView.topAnchor),
            nodeEditorView.bottomAnchor.constraint(equalTo: mapperView.bottomAnchor),
            nodeEditorView.widthAnchor.constraint(equalTo: nodeEditorView.heightAnchor, multiplier: 1.25, constant: -30),
            
            reverbView.leadingAnchor.constraint(equalTo: nodeEditorView.trailingAnchor, constant: 10),
            reverbView.widthAnchor.constraint(equalTo: reverbView.heightAnchor),
            reverbView.topAnchor.constraint(equalTo: mapperView.topAnchor),
            reverbView.bottomAnchor.constraint(equalTo: mapperView.bottomAnchor),
            
            experienceSelectorToggleButton.widthAnchor.constraint(equalToConstant: 135),
            experienceSelectorToggleButton.heightAnchor.constraint(equalToConstant: 55),
            experienceSelectorToggleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            experienceSelectorToggleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            playbackToggleButton.heightAnchor.constraint(equalTo: experienceSelectorToggleButton.heightAnchor),
            playbackToggleButton.widthAnchor.constraint(equalTo: playbackToggleButton.heightAnchor),
            playbackToggleButton.leadingAnchor.constraint(equalTo: experienceSelectorToggleButton.trailingAnchor, constant: 10),
            playbackToggleButton.centerYAnchor.constraint(equalTo: experienceSelectorToggleButton.centerYAnchor),
            
            resetExperienceButton.widthAnchor.constraint(equalToConstant: 135),
            resetExperienceButton.heightAnchor.constraint(equalToConstant: 55),
            resetExperienceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resetExperienceButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    private func setUpObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(clearExperience),
                                               name: .experienceChanged, object: nil)
    }
    
    private func assignDelegates() {
        mapperView.controller = self
        mapperView.delegate = self
        sceneView.session.delegate = self
        nodeEditorView.delegate = self
    }
    
    private func addTargets() {
        playbackToggleButton.addTarget(self, action: #selector(togglePlayback), for: .touchUpInside)
        toggleEditorViewButton.addTarget(self, action: #selector(toggleEditorView), for: .touchUpInside)
        experienceSelectorToggleButton.addTarget(self, action: #selector(toggleExperienceSelectorVC), for: .touchUpInside)
        resetExperienceButton.addTarget(self, action: #selector(resetExperience), for: .touchUpInside)
    }
    
    private func setUpARScene() {
        sphereNode.position = SCNVector3(0, 0, 0)
        sceneView.scene.rootNode.addChildNode(sphereNode)
    }
    
    private func createSpeakerNode(at position: SCNVector3, withColor color: NodeColor) -> SCNNode {
        let speakerScene = SCNScene(named: "Speaker.scn")!
        let speakerNode = speakerScene.rootNode.childNode(withName: "Speaker",
                                                          recursively: false)!
        speakerNode.geometry?.firstMaterial?.diffuse.contents = color.getSpeakerTexture()
        speakerNode.position = position
        speakerNode.look(at: sphereNode.position)
        return speakerNode
    }
    
    public func setSpeakerNodePositionWithID(_ id: String, to position: Vector) {
        DispatchQueue.main.async {
            let scnPosition = SCNVector3(position.x, position.y, -position.z)
            self.speakerNodes[id]?.position = scnPosition
            self.speakerNodes[id]?.look(at: self.sphereNode.position)
        }
    }
}

@available(iOS 12.0, *)
extension MainViewController: ARSessionDelegate {
    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if cyclesSinceLastRender == 10 {
            cyclesSinceLastRender = 0
            
            let transform = frame.camera.transform
            let x = transform.columns.3.x
            let y = transform.columns.3.y
            let z = transform.columns.3.z
            
            let pitch = frame.camera.eulerAngles.x.toDegrees()
            let yaw = frame.camera.eulerAngles.y.toDegrees()
            let roll = frame.camera.eulerAngles.z.toDegrees()
            
            AudioEnvironment.shared.setListenerPosition(x, y, z)
            AudioEnvironment.shared.setListenerOrientation(yaw, pitch, roll)
            
            var eulerAngles = SCNVector3(frame.camera.eulerAngles)
            eulerAngles.x = -eulerAngles.x - Float(75).toRadians()
            mapperView.setHeadOrientationTo(eulerAngles)
        } else {
            cyclesSinceLastRender += 1
        }
    }
    
    public func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .normal:
            arStateIsReady = true
            if !setUp {
                setUpARScene()
            }
        default:
            arStateIsReady = false
            break
        }
    }
}

@available(iOS 12.0, *)
extension MainViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

@available(iOS 12.0, *)
extension MainViewController: MapperDelegate {
    public func add(_ track: Track, at position: Vector) {
        let vectorPosition = SCNVector3(position.x, position.y, -position.z)
        let speakerNode = createSpeakerNode(at: vectorPosition, withColor: track.color)
        speakerNode.name = track.id
        speakerNodes[track.id] = speakerNode
        
        DispatchQueue.main.async {
            self.sceneView.prepare([speakerNode]) { _ in
                self.sceneView.scene.rootNode.addChildNode(speakerNode)
            }
        }
        
        if playbackToggleButton.currentImage == #imageLiteral(resourceName: "Play Icon") {
            playbackToggleButton.setImage(#imageLiteral(resourceName: "Stop Icon"), for: .normal)
        }
    }
    
    public func remove(_ track: Track) {
        speakerNodes[track.id]?.removeFromParentNode()
        speakerNodes[track.id] = nil
    }
}
