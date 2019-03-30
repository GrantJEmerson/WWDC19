//
//  ExperienceSelectorTableViewController.swift
//  Dompel
//
//  Created by Grant Emerson on 1/29/19.
//  Copyright © 2019 Grant Emerson. All rights reserved.
//

import UIKit

public class ExperienceSelectorTableViewController: UITableViewController {
    
    // MARK: Properties
    
    private let cellID = "ExperienceCellID"
    
    // MARK: View Controller Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Experiences"
        navigationController!.navigationBar.titleTextAttributes = [.font: UIFont(name: "Futura", size: 20)!]
        tableView.register(ExperienceCell.self, forCellReuseIdentifier: cellID)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToSelection()
    }
    
    // MARK: Private Functions
    
    private func scrollToSelection() {
        guard let selectedExperienceIndex = Experience.all.firstIndex(where: { (e) -> Bool in
            return Experience.selected.name == e.name
        }) else { return }
        tableView.selectRow(at: IndexPath(row: selectedExperienceIndex, section: 0),
                            animated: true, scrollPosition: .middle)
    }

    // MARK: - Table View Data Source

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Experience.all.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ExperienceCell
        let experience = Experience.all[indexPath.row]
        cell.textLabel?.text = experience.name
        cell.detailTextLabel?.text = "Artist: \(experience.artist)\nGenre: \(experience.genre)"
        cell.textLabel!.font = UIFont(name: "Futura", size: 17)
        cell.detailTextLabel!.font = UIFont(name: "Futura", size: 12)
        cell.detailTextLabel?.numberOfLines = 2
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Experience.selected = Experience.all[indexPath.row]
        dismiss(animated: true)
    }
}

public class ExperienceCell: UITableViewCell {
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
