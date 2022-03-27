//  ProfileImage.swift
//  Wallpapers
//
//  Created by Alessia on 23/3/2022.
//

import Foundation

struct ProfileImage : Codable {
	var image: String
	
	enum CodingKeys: String, CodingKey {
		case image = "large"
	}
}
