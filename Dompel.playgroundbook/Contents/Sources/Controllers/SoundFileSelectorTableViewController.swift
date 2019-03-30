//
//  SoundFileSelectorTableViewController.swift
//  Dompel
//
//  Created by Grant Emerson on 1/26/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import UIKit

public protocol SoundSelectorDelegate: class {
    func addSound(_ trackName: String, with color: NodeColor)
}

public class SoundFileSelectorTableViewController: UITableViewController {
    
    // MARK: Properties
    
    public weak var delegate: SoundSelectorDelegate?
    
    private let cellID = "cellID"
    
    // MARK: View Controller Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Tracks"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }

    // MARK: - Table View Data Source

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Experience.selected.urlEndings.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let trackName = Experience.selected.urlEndings[indexPath.row]
        cell.textLabel?.text = trackName
        return cell
    }
    
    // MARK: - Table View Delegate
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trackName = Experience.selected.urlEndings[indexPath.row]
        let colorSelectorVC = ColorSelectorController(collectionViewLayout: UICollectionViewFlowLayout())
        colorSelectorVC.trackName = trackName
        colorSelectorVC.delegate = delegate
        navigationController?.pushViewController(colorSelectorVC, animated: true)
    }

}
