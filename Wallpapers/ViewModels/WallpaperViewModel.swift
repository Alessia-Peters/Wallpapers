//  ViewModel.swift
//  Wallpapers
//
//  Created by Alessia on 23/3/2022.
//

import SwiftUI

class WallpaperViewModel : ObservableObject {
	@Published var allWallpapers = [[Wallpaper]]()
	@Published var popUpText = "Image Saved!"
	
	private var height: [Double] = [0,0,0]
	
	func fetch() async throws {
		let urlString = Constants.baseUrl + Endpoints.random
		
		guard let url = URL(string: urlString) else {
			throw HTTPError.badUrl
		}
		
		guard let response: [Wallpaper] = try await HTTPClient.shared.fetch(url: url) else {
			throw HTTPError.badResponse
		}
		
		let splitResponse = response.splitArray(input: response, heights: height)
		
		let splitItems = splitResponse.0
		
		height = splitResponse.1
		
		DispatchQueue.main.async {
			self.allWallpapers = splitItems
		}
	}
	
	func fetchMore() async throws {
		let urlString = Constants.baseUrl + Endpoints.random
		
		guard let url = URL(string: urlString) else {
			throw HTTPError.badUrl
		}
		
		guard let response: [Wallpaper] = try await HTTPClient.shared.fetch(url: url) else {
			throw HTTPError.badResponse
		}
		
		let splitResponse = response.splitArray(input: response, heights: height)
		
		let splitItems = splitResponse.0
		
		height = splitResponse.1
		
		DispatchQueue.main.async {
			self.allWallpapers[0].append(contentsOf: splitItems[0])
			self.allWallpapers[1].append(contentsOf: splitItems[1])
			self.allWallpapers[2].append(contentsOf: splitItems[2])
		}
	}
	
	func fetchFromLibrary() async {
		let data = Bundle.main.decode([Wallpaper].self, from: "File.json")
		
		let splitResponse = data.splitArray(input: data, heights: height)
		
		let splitItems = splitResponse.0
		
		height = splitResponse.1
		
		DispatchQueue.main.async {
			self.allWallpapers = splitItems
		}
	}
	
	init() {
		allWallpapers = EmptyWallpapers.init().wallpapers
	}
}

