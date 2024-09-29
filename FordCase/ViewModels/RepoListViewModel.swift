//
//  RepoListViewModel.swift
//  FordCase
//
//  Created by Mac on 29.09.2024.
//

import Foundation
import RealmSwift
import Network

class RepoListViewModel {

    let username: String
    var repos: [Repo] = []
    var page = 1
    let perPage = 10
    var isFetching = false
    var hasMoreData = true
    var onReposFetched: (() -> Void)?

    let realm = try! Realm()
    let monitor = NWPathMonitor()

    init(username: String) {
        self.username = username

        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.fetchRepos(isPagination: false)
            } else {
                self.loadCachedRepos()
            }
        }

        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }

    func loadCachedRepos() {
        DispatchQueue.main.async {
            let allRepos = self.realm.objects(Repo.self).filter("user == %@", self.username)
            self.repos = Array(allRepos.filter { !$0.isInvalidated })
            self.onReposFetched?()
        }
    }

    func fetchRepos(isPagination: Bool = false) {
        guard !isFetching && hasMoreData else { return }

        isFetching = true
        let endpoint = APIEndpoint.userRepos(username: username, page: page, perPage: perPage)

        NetworkManager.shared.request(endpoint: endpoint, type: [Repo].self) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isFetching = false

                switch result {
                case .success(let fetchedRepos):
                    if isPagination {
                        self.repos.append(contentsOf: fetchedRepos.filter { !$0.isInvalidated })
                    } else {
                        self.repos = fetchedRepos.filter { !$0.isInvalidated }
                    }

                    if fetchedRepos.count < self.perPage {
                        self.hasMoreData = false
                    } else {
                        self.page += 1
                    }

                    self.cacheRepos(repos: fetchedRepos)
                    self.onReposFetched?()

                case .failure(let error):
                    print("Error fetching repos: \(error)")
                    self.hasMoreData = false
                    self.loadCachedRepos()
                }
            }
        }
    }

    private func cacheRepos(repos: [Repo]) {
        try! realm.write {
            for repo in repos {
                realm.add(repo, update: .modified)
            }
        }
    }
}
