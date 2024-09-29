//
//  CustomRepoCell.swift
//  FordCase
//
//  Created by Mac on 29.09.2024.
//

import UIKit
import SnapKit
import Kingfisher

class CustomRepoCell: UICollectionViewCell {
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let ownerLabel = UILabel()
    private let forkLabel = UILabel()
    private let watchLabel = UILabel()
    private let sizeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.backgroundColor = .white

        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill

        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = .black

        ownerLabel.font = UIFont.systemFont(ofSize: 14)
        ownerLabel.textColor = .darkGray

        forkLabel.font = UIFont.systemFont(ofSize: 14)
        forkLabel.textColor = .darkGray

        watchLabel.font = UIFont.systemFont(ofSize: 14)
        watchLabel.textColor = .darkGray

        sizeLabel.font = UIFont.systemFont(ofSize: 14)
        sizeLabel.textColor = .darkGray

        [profileImageView, nameLabel, ownerLabel, forkLabel, watchLabel, sizeLabel].forEach {
            contentView.addSubview($0)
        }

        setupConstraints()
    }

    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(8)
            make.width.height.equalTo(50)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-8)
        }

        ownerLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-8)
        }

        forkLabel.snp.makeConstraints { make in
            make.top.equalTo(ownerLabel.snp.bottom).offset(4)
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-8)
        }

        watchLabel.snp.makeConstraints { make in
            make.top.equalTo(forkLabel.snp.bottom).offset(4)
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-8)
        }

        sizeLabel.snp.makeConstraints { make in
            make.top.equalTo(watchLabel.snp.bottom).offset(4)
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }

    func configure(repoName: String?, ownerName: String?, forkCount: Int?, watchCount: Int?, size: Int?, profileImageUrl: String?, showExtraInfo: Bool) {
        nameLabel.text = repoName ?? "Unknown Repo"
        ownerLabel.text = ownerName != nil ? "Owner: \(ownerName!)" : "Unknown Owner"
        
        if let imageUrl = profileImageUrl, let url = URL(string: imageUrl) {
            profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            profileImageView.image = UIImage(named: "placeholder")
        }

        if showExtraInfo {
            forkLabel.isHidden = false
            watchLabel.isHidden = false
            sizeLabel.isHidden = false

            forkLabel.text = "Forks: \(forkCount ?? 0)"
            watchLabel.text = "Watches: \(watchCount ?? 0)"
            sizeLabel.text = "Size: \(size ?? 0) KB"
        } else {
            forkLabel.isHidden = true
            watchLabel.isHidden = true
            sizeLabel.isHidden = true
        }
    }
}
