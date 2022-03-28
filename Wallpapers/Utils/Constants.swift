//  Constants.swift
//  Wallpapers
//
//  Created by Alessia on 23/3/2022.
//

import Foundation

enum Constants {
	static let baseUrl = "https://api.unsplash.com/"
}

enum Endpoints {
	static let photos = "photos?per_page=200"
	static let search = "search/photos?query="
	static let random = "photos/random?"
}

enum Parameters {
	static let count = "&count="
	static let page = "&page="
}
