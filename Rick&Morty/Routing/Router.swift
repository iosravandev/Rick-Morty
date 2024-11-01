//
//  Router.swift
//  Rick&Morty
//
//  Created by Nihad Ismayilov on 01.11.24.
//

import Foundation

class Router {
    private init() {}
    
    static func getSearchViewController() -> SearchViewController {
        let vc = SearchViewController()
        
        return vc
    }
    
    static func getDetailViewController(character: SearchModel?) -> DetailViewController {
        let vc = DetailViewController()
        vc.character = character
        return vc
    }
}
