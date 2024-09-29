//
//  Repo.swift
//  FordCase
//
//  Created by Mac on 29.09.2024.
//
import RealmSwift

class Repo: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var fullName: String
    @Persisted var isPrivate: Bool
    @Persisted var ownerLogin: String
    @Persisted var ownerAvatarUrl: String
    @Persisted var user: String
    @Persisted var forkCount: Int
    @Persisted var watchCount: Int
    @Persisted var size: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case isPrivate = "private"
        case owner
        case forkCount = "forks_count"
        case watchCount = "watchers_count"
        case size
    }

    enum OwnerKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }

    required convenience init(from decoder: Decoder) throws {
        self.init()

        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        fullName = try container.decode(String.self, forKey: .fullName)
        isPrivate = try container.decode(Bool.self, forKey: .isPrivate)
        forkCount = try container.decodeIfPresent(Int.self, forKey: .forkCount) ?? 0
        watchCount = try container.decodeIfPresent(Int.self, forKey: .watchCount) ?? 0
        size = try container.decodeIfPresent(Int.self, forKey: .size) ?? 0
        
        let ownerContainer = try container.nestedContainer(keyedBy: OwnerKeys.self, forKey: .owner)
        ownerLogin = try ownerContainer.decode(String.self, forKey: .login)
        ownerAvatarUrl = try ownerContainer.decode(String.self, forKey: .avatarUrl)
    }
}
