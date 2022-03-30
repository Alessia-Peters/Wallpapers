//  User.swift
//  Wallpapers
//
//  Created by Alessia on 23/3/2022.
//

import Foundation

struct User : Codable {
	var username: String
	var name: String
	var profileImage: ProfileImage
	var bio: String?
	var instagram: String?
	var twitter: String?
	
	enum CodingKeys: String, CodingKey {
		case username, name, bio
		case profileImage = "profile_image"
		case instagram = "instagram_username"
		case twitter = "twitter_username"
	}
}
