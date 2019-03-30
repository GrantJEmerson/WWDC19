//
//  MapperView.swift
//  Dompel
//
//  Created by Grant Emerson on 1/26/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import UIKit
import SceneKit
import AVFoundation

public protocol MapperDelegate: class {
    func add(_ track: Track, at position: Vector)
    func remove(_ track: Track)
}

@available(iOS 12.0, *)
public class MapperView: UIView {
    
    // MARK: Properties
    
    public weak var controller: UIViewController?
    public weak var delegate: MapperDelegate?
    
    private let numOfCells = 12
    private let cellID = "MapperCell"
    
    private var selectedIndex = 0
    
    private var isEditing = false
    
    private var tracks = [Track?](repeating: nil, count: 12)
    
    private lazy var mapperTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "MAPPER"
        label.font = UIFont(name: "Futura-BOLD", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var editingButton: UIButton = {
        let button = UIButton()
        button.titleLabel!.font = UIFont(name: "Arial Rounded MT Bold", size: 14)
        button.setTitle("EDIT", for: .normal)
        button.setTitleColor(.themeColor, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.addTarget(self, action: #selector(toggleEditing), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var headNode: SCNNode?
    
    private lazy var headSCNView: SCNView = {
        let headSCNView = SCNView()
        
        let headScene = SCNScene(named: "Head.scn")!
        headNode = headScene.rootNode.childNode(withName: "Head", recursively: false)!

        headSCNView.scene = headScene
        headSCNView.backgroundColor = .clear
        headSCNView.translatesAutoresizingMaskIntoConstraints = false
        return headSCNView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CircularLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.backgroundColor = .darkGray
        collectionView.clipsToBounds = true
        collectionView.layer.cornerRadius = 25
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
        
    // MARK: View Life Cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        setUpObservers()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setUpSubviews()
    }
    
    // MARK: Selector Functions
    
    @objc private func clearInterface() {
        if isEditing {
            toggleEditing()
        }
        tracks = [Track?](repeating: nil, count: 12)
        selectedIndex = 0
        Track.selected = nil
        collectionView.reloadData()
    }
    
    @objc private func toggleEditing() {
        isEditing.toggle()
        if isEditing {
            Track.selected = nil
            collectionView.deselectItem(at: IndexPath(item: selectedIndex, section: 0), animated: true)
        }
        collectionView.reloadData()
        editingButton.setTitle(isEditing ? "DONE" : "EDIT", for: .normal)
    }
    
    // MARK: Private Functions
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.cornerRadius = 25
        layer.borderWidth = 3.5
        layer.borderColor = UIColor.darkGray.cgColor
    }
    
    private func setUpSubviews() {
        add(mapperTitleLabel, editingButton, collectionView)
        collectionView.add(headSCNView)
        
        NSLayoutConstraint.activate([
            mapperTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            mapperTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            mapperTitleLabel.heightAnchor.constraint(equalToConstant: 21),
            
            collectionView.topAnchor.constraint(equalTo: mapperTitleLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            headSCNView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            headSCNView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            headSCNView.widthAnchor.constraint(equalToConstant: 50),
            headSCNView.heightAnchor.constraint(equalToConstant: 50),
            
            editingButton.heightAnchor.constraint(equalToConstant: 25),
            editingButton.centerYAnchor.constraint(equalTo: mapperTitleLabel.centerYAnchor),
            editingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            editingButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setUpObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(clearInterface),
                                               name: .experienceChanged, object: nil)
    }
    
    private func getNextTrackNameFrom(_ name: String) -> String {
        var nextNum = 0
        for track in tracks {
            if let track = track {
                if track.name.hasPrefix(name) {
                    if track.name == name {
                        nextNum = max(1, nextNum)
                    } else {
                        nextNum = max(nextNum, (Int("\(track.name.last!)")! + 1))
                    }
                }
            }
        }
        var trackName = name
        if (nextNum != 0) { trackName += " \(nextNum)" }
        return trackName
    }
    
    private func removeTrackAt(_ indexPath: IndexPath) {
        guard let track = tracks[indexPath.item] else { return }
        delegate?.remove(track)
        AudioEnvironment.shared.removeTrack(track)
        tracks[indexPath.item] = nil
        collectionView.reloadItems(at: [indexPath])
    }
    
    // MARK: Public Functions
    
    public func setHeadOrientationTo(_ eulerAngles: SCNVector3) {
        guard let headNode = headNode else { return }
        headNode.eulerAngles = eulerAngles
    }
}

@available(iOS 12.0, *)
extension MapperView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TrackCell
        if isEditing {
            removeTrackAt(indexPath)
        } else {
            if let track = cell.track {
                Track.selected = track
            } else {
                let vc = SoundFileSelectorTableViewController()
                vc.delegate = self
                let nc = UINavigationController(rootViewController: vc)
                nc.navigationBar.tintColor = .themeColor
                controller?.presentPopUp(nc, withSize: CGSize(width: 300, height: 150), by: cell, direction: .down)
                selectedIndex = indexPath.item
            }
        }
    }
}

@available(iOS 12.0, *)
extension MapperView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfCells
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! TrackCell
        if let track = tracks[indexPath.item] {
            cell.track = track
        }
        cell.editing = isEditing
        return cell
    }
}

@available(iOS 12.0, *)
extension MapperView: SoundSelectorDelegate {
    public func addSound(_ trackName: String, with color: NodeColor) {
        guard let url = Bundle.main.url(forResource: "\(Experience.selected.folderID) \(trackName)", withExtension: "mp3"),
                let file = try? AVAudioFile(forReading: url) else {
                print("File not found!")
                return
        }
        
        let position = Vector.createFromIndex(selectedIndex)
        let id = AudioEnvironment.shared.addTrack(file, at: position)
        
        let track = Track(id: id, name: getNextTrackNameFrom(trackName), index: selectedIndex, color: color)
        tracks[selectedIndex] = track
        
        let cellIndexPath = IndexPath(item: selectedIndex, section: 0)
        collectionView.reloadItems(at: [cellIndexPath])
        
        delegate?.add(track, at: position)
        
        Track.selected = track
    }
}
