//
//  Cities.swift
//  WeatherApp
//
//  Created by Мурат Кудухов on 22.07.2023.
//

import UIKit

final class CitiesView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        tableViewApperance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableViewApperance() {
        tableView = UITableView(frame: bounds, style: .plain)
        tableView.register(CitiesCell.self, forCellReuseIdentifier: CitiesCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tableView)
        
//        NSLayoutConstraint.activate([
//            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            tableView.topAnchor.constraint(equalTo: topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
//
//        ])
        
    }
    
}

extension CitiesView {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CitiesCell.id, for: indexPath)
        
        cell.textLabel?.text = "\(indexPath.row)"
        print(indexPath.row)
        
        cell.backgroundColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 70.0
       }
}
