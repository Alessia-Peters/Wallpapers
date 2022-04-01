//
//  Social.swift
//  Wallpapers
//
//  Created by Alessia on 1/4/2022.
//

import Foundation

struct Social: Codable {
	var instagram: String?
	var twitter: String?
	
	enum CodingKeys: String, CodingKey {
		case twitter = "twitter_username"
		case instagram = "instagram_username"
	}
}
