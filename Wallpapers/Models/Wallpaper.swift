//  Wallpaper.swift
//  Wallpapers
//
//  Created by Alessia on 23/3/2022.
//

import Foundation

struct Wallpaper : Identifiable, Codable {
	var id: String
	
	var urls: URLs
	var user: User
	var creationDate: String

	enum CodingKeys: String, CodingKey {
		case id, user, urls
		case creationDate = "created_at"
	}
}

struct Entry : Codable {
	var wallpapers: [Wallpaper] = Array()
}
