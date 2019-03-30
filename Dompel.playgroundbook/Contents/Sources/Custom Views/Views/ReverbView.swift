//
//  ReverbView.swift
//  Dompel
//
//  Created by Grant Emerson on 2/11/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import UIKit

@available(iOS 12.0, *)
public class ReverbView: RoundedEditorModuleView {
    
    // MARK: Properties
    
    private let reverbTypes = ["SM Room", "M Room", "L Room", "M Hall", "L Hall",
                               "Plate", "M Chamber", "L Chamber", "Cathedral",
                               "L Room 2", "M Hall 2", "M Hall 3", "L Hall 2"]
    
    private lazy var dBMarkingView = DecibelMarkingView()
    
    private lazy var volumeSlider: VerticalSlider = {
        let slider = VerticalSlider(type: .vertical)
        slider.callback = { [weak self] percentage in
             AudioEnvironment.shared.setReverbVolumeTo(Float(percentage))
        }
        slider.value = 0.15
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private lazy var gainAdjustmentView: UIView = {
        let view = UIView()
        view.addBordersTo(UIRectEdge(arrayLiteral: .top, .right),
                                    with: .black, thickness: 2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var reverbTypeSelector: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.addBordersTo(UIRectEdge(arrayLiteral: .top, .left),
                                with: .black, thickness: 2)
        pickerView.selectRow(6, inComponent: 0, animated: false)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    private lazy var gainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "GAIN"
        label.font = UIFont(name: "Futura", size: 14)
        label.textAlignment = .center
        label.addBordersTo(UIRectEdge(arrayLiteral: .bottom, .right),
                           with: .black, thickness: 2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var presetTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "PRESET"
        label.font = UIFont(name: "Futura", size: 14)
        label.textAlignment = .center
        label.addBordersTo(UIRectEdge(arrayLiteral: .bottom, .left),
                           with: .black, thickness: 2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View Life Cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setUpSubviews()
    }
    
    // MARK: Private Functions
    
    private func setUpView() {
        titleLabel.text = "REVERB"
    }
    
    private func setUpSubviews() {
        roundedView.add(gainTitleLabel, presetTitleLabel, reverbTypeSelector, gainAdjustmentView)
        gainAdjustmentView.add(dBMarkingView, volumeSlider)
        
        
        NSLayoutConstraint.activate([
            gainTitleLabel.topAnchor.constraint(equalTo: roundedView.topAnchor),
            gainTitleLabel.leadingAnchor.constraint(equalTo: roundedView.leadingAnchor),
            gainTitleLabel.trailingAnchor.constraint(equalTo: roundedView.centerXAnchor),
            gainTitleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            presetTitleLabel.topAnchor.constraint(equalTo: roundedView.topAnchor),
            presetTitleLabel.leadingAnchor.constraint(equalTo: roundedView.centerXAnchor),
            presetTitleLabel.trailingAnchor.constraint(equalTo: roundedView.trailingAnchor),
            presetTitleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            gainAdjustmentView.leadingAnchor.constraint(equalTo: roundedView.leadingAnchor),
            gainAdjustmentView.trailingAnchor.constraint(equalTo: roundedView.centerXAnchor),
            gainAdjustmentView.topAnchor.constraint(equalTo: gainTitleLabel.bottomAnchor),
            gainAdjustmentView.bottomAnchor.constraint(equalTo: roundedView.bottomAnchor),
            
            dBMarkingView.trailingAnchor.constraint(equalTo: gainAdjustmentView.centerXAnchor),
            dBMarkingView.widthAnchor.constraint(equalToConstant: 40),
            dBMarkingView.topAnchor.constraint(equalTo: gainAdjustmentView.topAnchor, constant: 10),
            dBMarkingView.bottomAnchor.constraint(equalTo: gainAdjustmentView.bottomAnchor, constant: -10),
            
            volumeSlider.leadingAnchor.constraint(equalTo: gainAdjustmentView.centerXAnchor),
            volumeSlider.widthAnchor.constraint(equalToConstant: 40),
            volumeSlider.topAnchor.constraint(equalTo: gainAdjustmentView.topAnchor, constant: 10),
            volumeSlider.bottomAnchor.constraint(equalTo: gainAdjustmentView.bottomAnchor, constant: -10),
            
            reverbTypeSelector.leadingAnchor.constraint(equalTo: roundedView.centerXAnchor),
            reverbTypeSelector.trailingAnchor.constraint(equalTo: roundedView.trailingAnchor),
            reverbTypeSelector.topAnchor.constraint(equalTo: presetTitleLabel.bottomAnchor),
            reverbTypeSelector.bottomAnchor.constraint(equalTo: roundedView.bottomAnchor)
        ])
    }
}

@available(iOS 12.0, *)
extension ReverbView: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        AudioEnvironment.shared.setReverbTypeTo(row)
    }
}

@available(iOS 12.0, *)
extension ReverbView: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reverbTypes.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reverbTypes[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: reverbTypes[row], attributes: [.font: UIFont(name: "Futura", size: 14)!])
    }
}
