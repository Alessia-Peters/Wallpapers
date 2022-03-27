//  ViewModel.swift
//  Wallpapers
//
//  Created by Alessia on 23/3/2022.
//

import SwiftUI

class WallpaperViewModel : ObservableObject {
	@Published var allWallpapers = [[Wallpaper]]()
	@Published var popUpText = "Image Saved!"
	
	func fetch() async throws {
		let urlString = Constants.baseUrl + Endpoints.random
		
		guard let url = URL(string: urlString) else {
			throw HTTPError.badUrl
		}
		
		guard let response: [Wallpaper] = try await HTTPClient.shared.fetch(url: url) else {
			throw HTTPError.badResponse
		}
		
		let splitResponse = response.split()
		
		DispatchQueue.main.async {
			self.allWallpapers = splitResponse
		}
	}
	
	func fetchFromLibrary() async {
		let data = Bundle.main.decode([Wallpaper].self, from: "File.json")
		
		let splitResponse = data.split()
		
		DispatchQueue.main.async {
			self.allWallpapers = splitResponse
		}
	}
	
	init() {
		allWallpapers = EmptyWallpapers.init().wallpapers
	}
}

