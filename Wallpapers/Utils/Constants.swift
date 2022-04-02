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
	static let search = "search/photos?query="
	static let random = "photos/random?"
	static let id = "photos/"
}

enum Parameters {
	static let count = "&count="
	static let page = "&page="
}
