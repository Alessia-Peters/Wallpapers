//  SearchingViewModel.swift
//  Wallpapers
//
//  Created by Alessia on 27/3/2022.
//

import Foundation

class SearchingViewModel : ObservableObject {
	
	@Published var searchedWallpapers: [[Wallpaper]]?
	@Published var page = 1
	
	func search(searchText: String) async throws {
		let urlString = Constants.baseUrl + Endpoints.search + searchText
		
		guard let url = URL(string: urlString) else {
			throw HTTPError.badUrl
		}
		
		guard let response: SearchResults = try await HTTPClient.shared.fetch(url: url) else {
			throw HTTPError.badResponse
		}
		
		let splitResponse = response.results.split()
		
		DispatchQueue.main.async {
			self.searchedWallpapers = splitResponse
		}
	}
	
	func searchMore(searchText: String) async throws {
		let urlString = Constants.baseUrl + Endpoints.search + searchText + Endpoints.page + String(page)
		
		guard let url = URL(string: urlString) else {
			throw HTTPError.badUrl
		}
		
		guard let response: SearchResults = try await HTTPClient.shared.fetch(url: url) else {
			throw HTTPError.badResponse
		}
		
		let splitResponse = response.results.split()
		
		DispatchQueue.main.async {
			self.searchedWallpapers![0].append(contentsOf: splitResponse[0])
			self.searchedWallpapers![1].append(contentsOf: splitResponse[1])
			self.searchedWallpapers![2].append(contentsOf: splitResponse[2])
		}
	}
	
	func resetSearchResults() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			self.searchedWallpapers = nil
		}
	}
}
