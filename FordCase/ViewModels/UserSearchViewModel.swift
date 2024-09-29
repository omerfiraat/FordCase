//
//  UserSearchViewModel.swift
//  FordCase
//
//  Created by Mac on 29.09.2024.
//

import Foundation

class UserSearchViewModel {
    
    var users: [User] = []
    var page = 1
    var isFetching = false
    var hasMoreData = true
    var onUsersFetched: (() -> Void)?
    
    func resetSearch() {
        users.removeAll()
        page = 1
        hasMoreData = true
        onUsersFetched?()
    }
    
    func searchUsers(query: String, isPagination: Bool = false) {
        guard !isFetching && hasMoreData else { return }
        
        isFetching = true
        let endpoint = APIEndpoint.searchUsers(query: query, page: page)

        NetworkManager.shared.request(endpoint: endpoint, type: SearchResult.self) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false
            
            switch result {
            case .success(let searchResult):
                if isPagination {
                    self.users.append(contentsOf: searchResult.items)
                } else {
                    self.users = searchResult.items
                }
                
                self.page += 1
                self.hasMoreData = searchResult.items.count == 20
                self.onUsersFetched?()
                
            case .failure(let error):
                self.hasMoreData = false
            }
        }
    }
}
