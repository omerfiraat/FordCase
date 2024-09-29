//
//  UserCell.swift
//  FordCase
//
//  Created by Mac on 29.09.2024.
//

import UIKit
import SnapKit
import Kingfisher

class UserCell: UICollectionViewCell {
    
    // Kullanıcı profili ve adı için elemanlar
    let profileImageView = UIImageView()
    let usernameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        // Profil resminin köşelerini yuvarla
        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill

        // Kullanıcı adı için label ayarı
        usernameLabel.font = UIFont.systemFont(ofSize: 16)
        usernameLabel.textColor = .black
        usernameLabel.numberOfLines = 1

        // İçerik görünümüne ekleme ve SnapKit ile layout ayarlama
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)

        // SnapKit ile layout
        profileImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(8)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.height.equalTo(50) // Profil resminin boyutu
        }

        usernameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(8)
            make.centerY.equalTo(contentView.snp.centerY)
            make.right.equalTo(contentView.snp.right).offset(-8)
        }
    }

    // Kullanıcı adı ve profil fotoğrafını hücreye yükle
    func configure(username: String, profileImageUrl: String?) {
        usernameLabel.text = username

        if let imageUrl = profileImageUrl, let url = URL(string: imageUrl) {
            // Profil fotoğrafını Kingfisher ile yükle
            profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            profileImageView.image = UIImage(named: "placeholder")
        }
    }
}
