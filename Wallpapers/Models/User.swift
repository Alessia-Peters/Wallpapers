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
	
	enum CodingKeys: String, CodingKey {
		case username, name
		case profileImage = "profile_image"
	}
}
