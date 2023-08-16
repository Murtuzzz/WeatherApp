//
//  SearchTableView.swift
//  WeatherApp
//
//  Created by Мурат Кудухов on 14.08.2023.
//

import UIKit


struct CityItems {
    let cityName: String
}

final class SearchTableView: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    private var tableView = UITableView()
    private let headerView = UIView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let backgroundImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named:"gradientBG2")
        return view
    }()
    
    private let cloudImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "cloud.sun.rain")
        view.tintColor = R.Colors.darkBg
        return view
    }()

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Weather"
        label.textColor = R.Colors.darkBg
        label.font = R.Fonts.avenirBook(with: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.clipsToBounds = true
        bar.searchTextField.backgroundColor = .clear
        bar.searchTextField.layer.masksToBounds = true
        bar.searchTextField.layer.cornerRadius = 10
//        bar.barTintColor = .clear
        return bar
    }()
    
    private var dataSource: [CityItems] = []
    private var filteredDataSource: [CityItems] = []
    
    init(getCityName: @escaping (String) -> ()) {
        self.getCityName = getCityName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let getCityName: (String) -> ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewApperance()
    
    }
    
    private func tableViewApperance() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchViewCell.self, forCellReuseIdentifier: SearchViewCell.id)
        
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100)
        headerView.backgroundColor = .systemGray6
        
        searchBar.delegate = self
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        
        headerView.addSubview(searchBar)
        headerView.addSubview(headerLabel)
        headerView.backgroundColor = .clear
        
        tableView.tableHeaderView = headerView
        
        APICitiesManager.shared.parseJSONFromFile { [weak self] citiesData in
            DispatchQueue.main.async {
                for index in 0...citiesData.city.count-1 {
                    self!.dataSource.append(.init(cityName:citiesData.city[index].name))
                    }
                print(self!.dataSource.count)
                self!.tableView.reloadData()
                }
            
            }
        
        view.addSubview(backgroundImage)
        view.addSubview(cloudImage)
        view.addSubview(tableView)
        
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            
            searchBar.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.widthAnchor.constraint(equalToConstant: view.bounds.width - 16),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.widthAnchor.constraint(equalToConstant: view.bounds.width),
            headerLabel.heightAnchor.constraint(equalToConstant: 30),
            
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            cloudImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cloudImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cloudImage.widthAnchor.constraint(equalToConstant: view.bounds.width/3),
            cloudImage.heightAnchor.constraint(equalTo: cloudImage.widthAnchor)
            ])
    }
    
    func updateTable() {
        tableView.reloadData()
    }
}

extension SearchTableView {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewCell.id, for: indexPath) as! SearchViewCell
        
        let cityItems = filteredDataSource[indexPath.row]
        cell.configure(cityName: cityItems.cityName)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        getCityName(filteredDataSource[indexPath.row].cityName)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Обновите результаты поиска при изменении текста в SearchBar
        filterContentForSearchText(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Сбросьте результаты поиска при нажатии на кнопку Отмена
        filterContentForSearchText("")
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredDataSource = dataSource.filter { item in
            // Фильтр по условию: элемент должен содержать введенный текст поиска (case-insensitive)
            return item.cityName.range(of: searchText, options: .caseInsensitive) != nil
        }
        tableView.reloadData()
    }
}
