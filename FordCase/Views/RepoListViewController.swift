//
//  RepoListViewController.swift
//  FordCase
//
//  Created by Mac on 29.09.2024.
//

import UIKit
import SnapKit

final class RepoListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let viewModel: RepoListViewModel
    private var collectionView: UICollectionView!
    private lazy var layoutType: LayoutType = .oneViewInRow

    enum LayoutType {
        case oneViewInRow, twoViewsInRow, threeViewsInRow
    }

    init(username: String) {
        self.viewModel = RepoListViewModel(username: username)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()

        viewModel.loadCachedRepos()
        viewModel.fetchRepos()

        updateLayout()
    }

    private func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(CustomRepoCell.self, forCellWithReuseIdentifier: "repoCell")
        collectionView.delegate = self
        collectionView.dataSource = self

        let segmentControl = UISegmentedControl(items: ["1 Column", "2 Columns", "3 Columns"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(layoutChanged), for: .valueChanged)
        view.addSubview(segmentControl)
        view.addSubview(collectionView)

        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }

    private func setupBindings() {
        viewModel.onReposFetched = { [weak self] in
            self?.reloadCollectionViewSafely()
        }
    }

    @objc private func layoutChanged(segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            layoutType = .oneViewInRow
        case 1:
            layoutType = .twoViewsInRow
        case 2:
            layoutType = .threeViewsInRow
        default:
            layoutType = .oneViewInRow
        }

        updateLayout()
        collectionView.reloadData()
    }

    private func updateLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let numberOfColumns: CGFloat
            switch layoutType {
            case .oneViewInRow:
                numberOfColumns = 1
            case .twoViewsInRow:
                numberOfColumns = 2
            case .threeViewsInRow:
                numberOfColumns = 3
            }

            let totalSpacing = layout.minimumInteritemSpacing * (numberOfColumns - 1) + layout.sectionInset.left + layout.sectionInset.right
            let width = (view.frame.size.width - totalSpacing) / numberOfColumns

            layout.itemSize = CGSize(width: width, height: 100)
            layout.invalidateLayout()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.repos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "repoCell", for: indexPath) as! CustomRepoCell
        let repo = viewModel.repos[indexPath.row]

        let showExtraInfo = layoutType == .oneViewInRow
        if !repo.isInvalidated {
            cell.configure(
                repoName: repo.name,
                ownerName: repo.ownerLogin,
                forkCount: repo.forkCount,
                watchCount: repo.watchCount,
                size: repo.size,
                profileImageUrl: repo.ownerAvatarUrl,
                showExtraInfo: showExtraInfo
            )
        } else {
            cell.configure(
                repoName: "Invalid Repo",
                ownerName: "Unknown",
                forkCount: nil,
                watchCount: nil,
                size: nil,
                profileImageUrl: nil,
                showExtraInfo: false
            )
        }

        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight - 100, !viewModel.isFetching, viewModel.hasMoreData {
            viewModel.fetchRepos(isPagination: true)
        }
    }

    private func reloadCollectionViewSafely() {
        if collectionView.window != nil {
            collectionView.reloadData()
        }
    }
}
