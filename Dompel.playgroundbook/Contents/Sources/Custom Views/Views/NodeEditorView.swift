//
//  NodeEditorView.swift
//  Dompel
//
//  Created by Grant Emerson on 1/31/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import UIKit

public protocol NodeEditorDelegate: class {
    func setSpeakerNodePositionWithID(_ id: String, to position: Vector)
}

@available(iOS 12.0, *)
public class NodeEditorView: RoundedEditorModuleView {

    // MARK: Properties
    
    public weak var delegate: NodeEditorDelegate?
    
    private lazy var positionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "POSITION"
        label.font = UIFont(name: "Futura", size: 14)
        label.textAlignment = .center
        label.addBordersTo(UIRectEdge(arrayLiteral: .bottom, .right),
                           with: .black, thickness: 2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var mixTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "MIX"
        label.font = UIFont(name: "Futura", size: 14)
        label.textAlignment = .center
        label.addBordersTo(UIRectEdge(arrayLiteral: .bottom, .left),
                           with: .black, thickness: 2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var positionEditorView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = .layerMinXMaxYCorner
        view.addBordersTo(UIRectEdge(arrayLiteral: .top, .right),
                          with: .black, thickness: 2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var volumeEditorView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = .layerMaxXMaxYCorner
        view.addBordersTo(UIRectEdge(arrayLiteral: .top, .left),
                          with: .black, thickness: 2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var volumeSlider: VerticalSlider = {
        let slider = VerticalSlider(type: .vertical)
        slider.callback = { [weak self] val in
            self?.setVolumeTo(val)
        }
        slider.isEnabled = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private lazy var volumePercentageTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 18)
        label.text = "VOLUME:"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var volumePercentageValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 24)
        label.text = "0%"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var speakerPositionSlider: VerticalSlider = {
        let slider = VerticalSlider(type: .speaker)
        slider.callback = { [weak self] val in
            self?.setVerticalPositionTo(val)
        }
        slider.isEnabled = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    // MARK: View Life Cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpObservers()
        setUpView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setUpSubviews()
    }
    
    // MARK: Selector Functions
    
    @objc private func updateEditorWithTrack() {
        if let track = Track.selected {
            titleLabel.text = track.name
            
            volumeSlider.isEnabled = true
            let volumePercentage = Double(AudioEnvironment.shared.getVolumeFrom(track.id))
            volumeSlider.value = volumePercentage
            let normalizedPercent = Int((volumePercentage * 100).rounded())
            volumePercentageValueLabel.text = "\(normalizedPercent)%"
            
            speakerPositionSlider.isEnabled = true
            let speakerYPercentage = Double(AudioEnvironment.shared.getVerticalPercentageFrom(track.id))
            speakerPositionSlider.value = speakerYPercentage
        } else {
            titleLabel.text = "NO NODE SELECTED"
            volumePercentageValueLabel.text = "0%"
            volumeSlider.isEnabled = false
            
            speakerPositionSlider.isEnabled = false
        }
    }
    
    // MARK: Private Functions
    
    private func setUpView() {
        titleLabel.text = "NO NODE SELECTED"
    }
    
    private func setUpSubviews() {
        roundedView.add(positionTitleLabel, mixTitleLabel, positionEditorView, volumeEditorView)
        volumeEditorView.add(volumeSlider, volumePercentageTitleLabel, volumePercentageValueLabel)
        positionEditorView.add(speakerPositionSlider)
        
        NSLayoutConstraint.activate([
            positionTitleLabel.leadingAnchor.constraint(equalTo: roundedView.leadingAnchor),
            positionTitleLabel.trailingAnchor.constraint(equalTo: roundedView.centerXAnchor),
            positionTitleLabel.topAnchor.constraint(equalTo: roundedView.topAnchor),
            positionTitleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            mixTitleLabel.leadingAnchor.constraint(equalTo: roundedView.centerXAnchor),
            mixTitleLabel.trailingAnchor.constraint(equalTo: roundedView.trailingAnchor),
            mixTitleLabel.topAnchor.constraint(equalTo: roundedView.topAnchor),
            mixTitleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            positionEditorView.leadingAnchor.constraint(equalTo: roundedView.leadingAnchor),
            positionEditorView.trailingAnchor.constraint(equalTo: roundedView.centerXAnchor),
            positionEditorView.topAnchor.constraint(equalTo: positionTitleLabel.bottomAnchor),
            positionEditorView.bottomAnchor.constraint(equalTo: roundedView.bottomAnchor),
            
            volumeEditorView.leadingAnchor.constraint(equalTo: roundedView.centerXAnchor),
            volumeEditorView.trailingAnchor.constraint(equalTo: roundedView.trailingAnchor),
            volumeEditorView.topAnchor.constraint(equalTo: mixTitleLabel.bottomAnchor),
            volumeEditorView.bottomAnchor.constraint(equalTo: roundedView.bottomAnchor),
            
            volumeSlider.topAnchor.constraint(equalTo: volumeEditorView.topAnchor, constant: 10),
            volumeSlider.bottomAnchor.constraint(equalTo: volumeEditorView.bottomAnchor, constant: -10),
            volumeSlider.leadingAnchor.constraint(equalTo: volumeEditorView.leadingAnchor, constant: 10),
            volumeSlider.widthAnchor.constraint(equalToConstant: 40),
            
            volumePercentageTitleLabel.leadingAnchor.constraint(equalTo: volumeSlider.trailingAnchor, constant: 5),
            volumePercentageTitleLabel.trailingAnchor.constraint(equalTo: volumeEditorView.trailingAnchor, constant: -10),
            volumePercentageTitleLabel.bottomAnchor.constraint(equalTo: volumeEditorView.centerYAnchor, constant: -5),
        
            volumePercentageValueLabel.leadingAnchor.constraint(equalTo: volumePercentageTitleLabel.leadingAnchor),
            volumePercentageValueLabel.trailingAnchor.constraint(equalTo: volumePercentageTitleLabel.trailingAnchor),
            volumePercentageValueLabel.topAnchor.constraint(equalTo: volumeEditorView.centerYAnchor, constant: 5),
            
            speakerPositionSlider.leadingAnchor.constraint(equalTo: positionEditorView.leadingAnchor, constant: 10),
            speakerPositionSlider.trailingAnchor.constraint(equalTo: positionEditorView.trailingAnchor, constant: -10),
            speakerPositionSlider.topAnchor.constraint(equalTo: positionEditorView.topAnchor, constant: 10),
            speakerPositionSlider.bottomAnchor.constraint(equalTo: positionEditorView.bottomAnchor, constant: -10),
        ])
    }
    
    private func setUpObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateEditorWithTrack), name: .selectedTrackChanged, object: nil)
    }
    
    private func setVolumeTo(_ percentage: Double) {
        guard let trackID = Track.selected?.id else { return }
        AudioEnvironment.shared.setVolumeFor(trackID, to: Float(percentage))
        
        let normalizedPercent = Int((percentage * 100).rounded())
        volumePercentageValueLabel.text = "\(normalizedPercent)%"
    }
    
    private func setVerticalPositionTo(_ percentage: Double) {
        guard let track = Track.selected else { return }
        AudioEnvironment.shared.setYFromVerticalPercentage(Float(percentage), for: track.id)
        
        let vectorPosition = Vector.createFromIndex(track.index, verticalPercentage: Float(percentage))
        delegate?.setSpeakerNodePositionWithID(track.id, to: vectorPosition)
    }

}
