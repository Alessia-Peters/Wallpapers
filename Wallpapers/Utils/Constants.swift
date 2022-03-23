//  Constants.swift
//  Wallpapers
//
//  Created by Alessia on 23/3/2022.
//

import Foundation

enum Constants {
	static let baseUrl = "https://api.unsplash.com/"
	static let authentication = "Client-ID \(Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? "")"
}

enum Endpoints {
	static let photos = "photos?per_page=200"
	static let search = "photos/search"
}

