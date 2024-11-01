//
//  SearchView.swift
//  Rick&Morty
//
//  Created by Ravan on 22.10.24.
//

import UIKit
import Foundation

enum Theme: String {
    case light
    case dark
    
    var interfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

    static func save(theme: Theme) {
        UserDefaults.standard.set(theme.rawValue, forKey: "selectedTheme")
    }

    static func load() -> Theme {
        let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme")
        return Theme(rawValue: savedTheme ?? "light") ?? .light
    }
}



class SearchView: UIViewController {
    
    var cellView = GeneralCharacterCWCell()
    
    private let viewModel = SearchViewModel()
    
    let statusOptions = ["alive", "dead", "unknown"]
    let genderOptions = ["Male", "Female", "genderless", "unknown"]
    
    var selectedStatus: String?
    var selectedGender: String?
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let themeSwitch: UISwitch = {
        let theme = UISwitch()
        theme.translatesAutoresizingMaskIntoConstraints = false
        return theme
    }()
    
    lazy var genderButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select Gender", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showGenderOptions), for: .touchUpInside)
        return button
    }()
    
    lazy var statusButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select Status", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showStatusOptions), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelGenderButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelGenderFilter), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var cancelStatusButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelStatusFilter), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var filterStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [genderButton, statusButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    lazy var genderTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var statusTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var generalCharacterCW: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 200)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(GeneralCharacterCWCell.self, forCellWithReuseIdentifier: GeneralCharacterCWCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        
        view.addSubview(searchBar)
        view.addSubview(genderButton)
        view.addSubview(statusButton)
        view.addSubview(filterStack)
        view.addSubview(genderTableView)
        view.addSubview(statusTableView)
        view.addSubview(generalCharacterCW)
        view.addSubview(themeSwitch)
        view.backgroundColor = .white
        
        genderButton.addSubview(cancelGenderButton)
        statusButton.addSubview(cancelStatusButton)
        generalCharacterCW.addSubview(genderTableView)
        generalCharacterCW.addSubview(statusTableView)
        
        NSLayoutConstraint.activate([
            
            themeSwitch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            themeSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            searchBar.topAnchor.constraint(equalTo: themeSwitch.bottomAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            filterStack.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            filterStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            genderTableView.topAnchor.constraint(equalTo: filterStack.bottomAnchor, constant: 20),
            genderTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            genderTableView.trailingAnchor.constraint(equalTo: genderButton.trailingAnchor, constant: -16),
            genderTableView.heightAnchor.constraint(equalToConstant: 150),
            
            statusTableView.topAnchor.constraint(equalTo: filterStack.bottomAnchor, constant: 20),
            statusTableView.leadingAnchor.constraint(equalTo: statusButton.leadingAnchor, constant: 16),
            statusTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statusTableView.heightAnchor.constraint(equalToConstant: 150),
            
            cancelGenderButton.topAnchor.constraint(equalTo: genderButton.topAnchor, constant: 0),
            cancelGenderButton.trailingAnchor.constraint(equalTo: genderButton.trailingAnchor, constant: 0),
            cancelGenderButton.bottomAnchor.constraint(equalTo: genderButton.bottomAnchor, constant: 0),
            cancelGenderButton.widthAnchor.constraint(equalToConstant: 40),
            
            cancelStatusButton.topAnchor.constraint(equalTo: statusButton.topAnchor, constant: 0),
            cancelStatusButton.trailingAnchor.constraint(equalTo: statusButton.trailingAnchor, constant: 0),
            cancelStatusButton.bottomAnchor.constraint(equalTo: statusButton.bottomAnchor, constant: 0),
            cancelStatusButton.widthAnchor.constraint(equalToConstant: 40),
            
            generalCharacterCW.topAnchor.constraint(equalTo: filterStack.bottomAnchor, constant: 16),
            generalCharacterCW.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            generalCharacterCW.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            generalCharacterCW.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        
        themeSwitch.addTarget(self, action: #selector(toggleTheme), for: .valueChanged)
        applyTheme()
        
        genderTableView.register(UITableViewCell.self, forCellReuseIdentifier: "genderCell")
        statusTableView.register(UITableViewCell.self, forCellReuseIdentifier: "statusCell")
        searchBar.delegate = self
        
        viewModel.completionHandler = { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.generalCharacterCW.reloadData()
                case .failure(let error):
                    print("Error fetching results: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc func toggleTheme() {
        let selectedTheme: Theme = themeSwitch.isOn ? .dark : .light
        Theme.save(theme: selectedTheme)
        applyTheme()
    }
    
    func applyTheme() {
        let theme = Theme.load()
        themeSwitch.isOn = (theme == .dark)
        view.window?.overrideUserInterfaceStyle = theme.interfaceStyle
        view.backgroundColor = theme == .dark ? .black : .white
        searchBar.barTintColor = theme == .dark ? .clear : .white
        genderButton.setTitleColor(theme == .dark ? .white : .black, for: .normal)
        statusButton.setTitleColor(theme == .dark ? .white : .black, for: .normal)
        for cell in generalCharacterCW.visibleCells {
            if let characterCell = cell as? GeneralCharacterCWCell {
                characterCell.applyThemeInCell(theme)
            }
        }
    }
    
    @objc func showGenderOptions() {
        genderTableView.isHidden = !genderTableView.isHidden
    }
    
    @objc func showStatusOptions() {
        statusTableView.isHidden = !statusTableView.isHidden
    }
    
    @objc func cancelGenderFilter() {
        selectedGender = nil
        genderButton.setTitle("Select Gender", for: .normal)
        cancelGenderButton.isHidden = true
        viewModel.selectedGender = nil
    }
    
    @objc func cancelStatusFilter() {
        selectedStatus = nil
        statusButton.setTitle("Select Status", for: .normal)
        cancelStatusButton.isHidden = true
        viewModel.selectedStatus = nil
    }
    
    func updateFilters(status: String?, gender: String?) {
        viewModel.selectedStatus = status
        viewModel.selectedGender = gender
    }
    
}

extension SearchView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == genderTableView ? genderOptions.count : statusOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableView == genderTableView ? "genderCell" : "statusCell", for: indexPath)
        cell.textLabel?.text = tableView == genderTableView ? genderOptions[indexPath.row] : statusOptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == genderTableView {
            selectedGender = genderOptions[indexPath.row]
            genderButton.setTitle(selectedGender, for: .normal)
            viewModel.selectedGender = selectedGender
            cancelGenderButton.isHidden = false
        } else {
            selectedStatus = statusOptions[indexPath.row]
            statusButton.setTitle(selectedStatus, for: .normal)
            viewModel.selectedStatus = selectedStatus
            cancelStatusButton.isHidden = false
        }
        tableView.isHidden = true
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searched.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.row < viewModel.searched.count else {
            fatalError("Index out of range")
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GeneralCharacterCWCell.identifier, for: indexPath) as? GeneralCharacterCWCell else {
            fatalError("Unable to dequeue GeneralCharacterCWCell")
        }
        let searchResult = viewModel.searched[indexPath.row]
        
        cell.configure(with: searchResult)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCharacter = viewModel.searched[indexPath.row]
        let detailVC = DeatilsView()
        detailVC.character = selectedCharacter
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

extension SearchView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.fetchSearch(for: searchText) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.generalCharacterCW.reloadData()
                case .failure(let error):
                    print("Ошибка поиска: \(error.localizedDescription)")
                }
            }
        }
    }
}
