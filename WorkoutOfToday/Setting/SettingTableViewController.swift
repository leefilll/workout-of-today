//
//  SettingTableViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/08.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath)
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = Version.version
            break
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "버젼"
        default:
            return nil
        }
    }
}


extension SettingTableViewController {
    private func setup() {
        if let navigationController = navigationController {
            navigationController.navigationBar.prefersLargeTitles = true
            title = "설정"
        }
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
    }
}
