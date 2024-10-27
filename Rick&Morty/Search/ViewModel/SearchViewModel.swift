//
//  SearchViewModel.swift
//  Rick&Morty
//
//  Created by Ravan on 23.10.24.
//


import Alamofire
import Foundation

class SearchViewModel {
    
    lazy var baseUrl = "https://rickandmortyapi.com/api/character/"
    var searched: [SearchModel] = []
    var completionHandler: ((Result<[SearchModel], Error>) -> Void)?
    var currentSearchText: String = ""
    
    var selectedStatus: String? {
        didSet { fetchWithFilters() }
    }
    var selectedGender: String? {
        didSet { fetchWithFilters() }
    }
    
    private func fetchWithFilters() {
        fetchSearch(for: currentSearchText) { [weak self] result in
            self?.completionHandler?(result)
        }
    }
    
    func fetchSearch(for searchTerm: String, completion: @escaping (Result<[SearchModel], Error>) -> Void) {
        currentSearchText = searchTerm
        var endpoint = "?name=\(searchTerm)"
        
        if let status = selectedStatus, !status.isEmpty {
            endpoint += "&status=\(status)"
        }
        if let gender = selectedGender, !gender.isEmpty {
            endpoint += "&gender=\(gender)"
        }
        
        let urlString = "\(baseUrl)\(endpoint)"
        searched = []
        
        AF.request(urlString).validate().responseDecodable(of: SearchResponse.self) { response in
            switch response.result {
            case .success(let searchResponse):
                self.searched = searchResponse.results
                completion(.success(searchResponse.results))
            case .failure(let error):
                print("Ошибка: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}

