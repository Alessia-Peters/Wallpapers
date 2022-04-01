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
	var social: Social?
	
	enum CodingKeys: String, CodingKey {
		case username, name, bio, social
		case profileImage = "profile_image"
	}
}
