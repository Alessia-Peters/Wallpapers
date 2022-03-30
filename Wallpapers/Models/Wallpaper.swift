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
	
	var description: String?
	var altDescription: String?
	
	var height: Int
	var width: Int
	
	private var uploadDate: String
	
	enum CodingKeys: String, CodingKey {
		case id, description, height, width, urls, user
		case uploadDate = "created_at"
		case altDescription = "alt_description"
	}
	
	func formatDate() -> String {
		let formatter = DateFormatter()
		
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		
		let formattedDate = formatter.date(from: uploadDate)!
		
		formatter.dateStyle = .long
		
		return formatter.string(from: formattedDate)
	}
}
