//  SearchingViewModel.swift
//  Wallpapers
//
//  Created by Alessia on 27/3/2022.
//

import Foundation
import SwiftUI

class SearchingViewModel : ObservableObject {
	
	/// Results recieved from API
	@Published var searchedWallpapers: [[Wallpaper]]?
	
	/// Says whether or not search results are being shown
	@Published var showingResults = false
	
	/// If no results are returned
	@Published var noResults = false
	
	/// Whether or can connect to internet
	@Published var connectionState: ConnectionState = .disconnected
	
	/// Previous search, used to reset page
	private var previousSearch = String()
	
	/// Height of image columns
	private var height: [Double] = [0,0,0]
	
	/// Page of search reselt being requested
	private var page = 1
	
	/// Requests images based on a query
	/// - Parameter searchText: The item thats being searched
	func search(searchText: String) async throws {
		
		/// Throws if a connection cant be made
		do {
			try await HTTPClient.shared.checkConnection()
		} catch {
			DispatchQueue.main.async {
				self.connectionState = .noNetwork
			}
			throw HTTPError.badResponse
		}
		
		/// Increments to the next page of results
		DispatchQueue.main.async {
			self.page += 1
		}
		
		let urlString = Constants.baseUrl + Endpoints.search + searchText.replacingOccurrences(of: " ", with: "+") + Parameters.page + String(page)
		print(urlString)
		
		guard let url = URL(string: urlString) else {
			throw HTTPError.badUrl
		}
		
		guard let response: SearchResults = try await HTTPClient.shared.fetch(url: url) else {
			throw HTTPError.badResponse
		}
		
		/// Throws if no results are returned
		if response.results.isEmpty {
			DispatchQueue.main.async {
				self.showingResults = false
				self.searchedWallpapers = nil
				self.noResults = true
			}
			throw HTTPError.noResults
		}
		
		let splitResponse = response.results.splitArray(inputArray: response.results, heights: height)
		
		let splitItems = splitResponse.0
		
		height = splitResponse.1
		
		DispatchQueue.main.async {
			withAnimation {
				self.searchedWallpapers![0].append(contentsOf: splitItems[0])
				self.searchedWallpapers![1].append(contentsOf: splitItems[1])
				self.searchedWallpapers![2].append(contentsOf: splitItems[2])
				self.showingResults = true
			}
		}
	}
	
	func resetSearchResults() {
		self.searchedWallpapers = [[Wallpaper](),[Wallpaper](),[Wallpaper]()]
		self.page = 1
		self.height = [0,0,0]
	}
	
	init() {
		searchedWallpapers =  [[Wallpaper](),[Wallpaper](),[Wallpaper]()]
	}
}
