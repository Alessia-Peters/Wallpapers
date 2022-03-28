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
	
	var height: Int
	var width: Int
}
