//
//  ProfileViewController.swift
//  WorkoutOfToday
//
//  Created by Lee on 2020/04/20.
//  Copyright © 2020 Lee. All rights reserved.
//

import UIKit

/*
 요약 =
 
 키
 몸무게
 평균 운동 시간
 주당 운동 횟수
 
 차트 =
 몸무게 변화
 운동량 변화
 */

class ProfileViewController: BaseViewController {
    
    // MARK: Model
    
    fileprivate var summaries: [String] = [
        "키", "몸무게", "평균 운동 시간"
    ]
    
    enum Section {
        static let summary = 0
        static let highlights = 1
    }
    
    // MARK: View
    
    private weak var tableView: UITableView!
    
    override var navigationBarTitle: String {
        return "프로필"
    }
    
    
    override func setup() {
        configureTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        let profileBarItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                             target: self,
                                             action: #selector(profileDidSeleted(_:)))
        navigationItem.rightBarButtonItem = profileBarItem
    }
    
    private func configureTableView() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SummaryTableViewCell.self)
        tableView.register(HighlightsTableViewCell.self)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        self.tableView = tableView
    }
    
}

// MARK: objc functions

extension ProfileViewController {
    
    @objc
    private func profileDidSeleted(_ sender: UIButton) {
        
    }
}

// MARK: TableView DataSource

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case Section.summary:
                return summaries.count
            case Section.highlights:
                return 4
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == Section.summary {
            let cell = tableView.dequeueReusableCell(SummaryTableViewCell.self,
                                                     for: indexPath)
            cell.subtitleLabel.text = summaries[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(HighlightsTableViewCell.self,
                                                     for: indexPath)
            
            return cell
        }
    }
}

// MARK: TableView Delegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        if section == Section.summary {
            return 80
        } else {
            return 300
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = TableHeaderView()
        switch section {
            case Section.summary:
                headerView.label.text = "요약"
                break
            case Section.highlights:
                headerView.label.text = "하이라이트"
                break
            default:
                break
        }
        return headerView
    }
}
