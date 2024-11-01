//
//  SearchView.swift
//  Rick&Morty
//
//  Created by Ravan on 22.10.24.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - Variables
    private let viewModel = SearchViewModel()
    
    // MARK: - UI Components
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        
        return searchBar
    }()
    
    private let themeSwitch: UISwitch = {
        let theme = UISwitch()
        theme.translatesAutoresizingMaskIntoConstraints = false
        return theme
    }()
    
    private lazy var genderButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select Gender", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showGenderOptions), for: .touchUpInside)
        return button
    }()
    
    private lazy var statusButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select Status", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showStatusOptions), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelGenderButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelGenderFilter), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var cancelStatusButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelStatusFilter), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var filterStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [genderButton, statusButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    private lazy var genderTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "genderCell")
        
        return tableView
    }()
    
    private lazy var statusTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "statusCell")
        
        return tableView
    }()
    
    private lazy var generalCharacterCV: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 200)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(GeneralCharacterCVCell.self, forCellWithReuseIdentifier: GeneralCharacterCVCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Parent Delegations
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Functions
    func setupView() {
        view.addSubview(searchBar)
        view.addSubview(genderButton)
        view.addSubview(statusButton)
        view.addSubview(filterStack)
        view.addSubview(genderTableView)
        view.addSubview(statusTableView)
        view.addSubview(generalCharacterCV)
        view.addSubview(themeSwitch)
        view.backgroundColor = .background
        
        genderButton.addSubview(cancelGenderButton)
        statusButton.addSubview(cancelStatusButton)
        generalCharacterCV.addSubview(genderTableView)
        generalCharacterCV.addSubview(statusTableView)
        
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
            
            generalCharacterCV.topAnchor.constraint(equalTo: filterStack.bottomAnchor, constant: 16),
            generalCharacterCV.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            generalCharacterCV.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            generalCharacterCV.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        themeSwitch.addTarget(self, action: #selector(toggleTheme), for: .valueChanged)
        
        viewModel.completionHandler = { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.generalCharacterCV.reloadData()
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
    }
    
    @objc func showGenderOptions() {
        genderTableView.isHidden = !genderTableView.isHidden
    }
    
    @objc func showStatusOptions() {
        statusTableView.isHidden = !statusTableView.isHidden
    }
    
    @objc func cancelGenderFilter() {
        genderButton.setTitle("Select Gender", for: .normal)
        cancelGenderButton.isHidden = true
        viewModel.selectedGender = nil
    }
    
    @objc func cancelStatusFilter() {
        statusButton.setTitle("Select Status", for: .normal)
        cancelStatusButton.isHidden = true
        viewModel.selectedStatus = nil
    }
    
    func updateFilters(status: String?, gender: String?) {
        viewModel.selectedStatus = status
        viewModel.selectedGender = gender
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == genderTableView ? viewModel.genderOptions.count : viewModel.statusOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case genderTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "genderCell", for: indexPath)
            cell.textLabel?.text = viewModel.genderOptions[indexPath.row]
            
            return cell
        case statusTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell", for: indexPath)
            cell.textLabel?.text = viewModel.statusOptions[indexPath.row]
            
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == genderTableView {
            viewModel.selectedGender = viewModel.genderOptions[indexPath.row]
            genderButton.setTitle(viewModel.selectedGender, for: .normal)
            cancelGenderButton.isHidden = false
        } else {
            viewModel.selectedStatus = viewModel.statusOptions[indexPath.row]
            statusButton.setTitle(viewModel.selectedStatus, for: .normal)
            cancelStatusButton.isHidden = false
        }
        tableView.isHidden = true
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searched.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.row < viewModel.searched.count else {
            fatalError("Index out of range")
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GeneralCharacterCVCell.identifier, for: indexPath) as? GeneralCharacterCVCell else {
            fatalError("Unable to dequeue GeneralCharacterCWCell")
        }
        
        let searchResult = viewModel.searched[indexPath.row]
        cell.configure(with: searchResult)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCharacter = viewModel.searched[indexPath.row]
        let detailVC = Router.getDetailViewController(character: selectedCharacter)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.fetchSearch(for: searchText) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.generalCharacterCV.reloadData()
                case .failure(let error):
                    print("Ошибка поиска: \(error.localizedDescription)")
                }
            }
        }
    }
}
