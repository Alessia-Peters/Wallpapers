//  SearchingViewModel.swift
//  Wallpapers
//
//  Created by Alessia on 27/3/2022.
//

import Foundation

class SearchingViewModel : ObservableObject {
	
	@Published var searchedWallpapers: [[Wallpaper]]?
	@Published var showingResults = false
	@Published var page = 1
	@Published var noResults = false
	
	private var height: [Double] = [0,0,0]
	
	func search(searchText: String) async throws {
		let urlString = Constants.baseUrl + Endpoints.search + searchText.replacingOccurrences(of: " ", with: "+") + Parameters.page + String(page)
		
		guard let url = URL(string: urlString) else {
			throw HTTPError.badUrl
		}
		
		guard let response: SearchResults = try await HTTPClient.shared.fetch(url: url) else {
			throw HTTPError.badResponse
		}
		
		
		if response.results.isEmpty {
			DispatchQueue.main.async {
				self.showingResults = false
				self.searchedWallpapers = nil
				self.noResults = true
			}
			throw HTTPError.noResults
		}
		
		let splitResponse = response.results.splitArray(input: response.results, heights: height)
		
		let splitItems = splitResponse.0
		
		DispatchQueue.main.async {
			self.height = splitResponse.1
			self.searchedWallpapers![0].append(contentsOf: splitItems[0])
			self.searchedWallpapers![1].append(contentsOf: splitItems[1])
			self.searchedWallpapers![2].append(contentsOf: splitItems[2])
			self.showingResults = true
		}
	}

	func resetSearchResults() {
			self.searchedWallpapers = [[Wallpaper](),[Wallpaper](),[Wallpaper]()]
	}
	
	init() {
		searchedWallpapers =  [[Wallpaper](),[Wallpaper](),[Wallpaper]()]
	}
}
