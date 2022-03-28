//  ViewModel.swift
//  Wallpapers
//
//  Created by Alessia on 23/3/2022.
//

import SwiftUI

class WallpaperViewModel : ObservableObject {
	@Published var allWallpapers = [[Wallpaper]]()
	@Published var popUpText = "Image Saved!"
	@Published var connectionState: ConnectionState = .disconnected
	
	private var height: [Double] = [0,0,0]
	
	func fetch() async throws {
		
		do {
			try await checkConnection()
		} catch {
			connectionState = .noNetwork
			throw HTTPError.badResponse
		}
		
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
			self.connectionState = .connected
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
	
	func fetchFromLibrary() async throws {
		let data = Bundle.main.decode([Wallpaper].self, from: "File.json")
		
		let splitResponse = data.splitArray(input: data, heights: height)
		
		let splitItems = splitResponse.0
		
		height = splitResponse.1
		
		DispatchQueue.main.async {
			self.allWallpapers = splitItems
			self.connectionState = .connected
		}
	}
	
	
	/// Runs on app launch, checks to see if server can be reached
	func checkConnection() async throws {
		let url = URL(string: Constants.baseUrl)
		
		var request = URLRequest(url: url!)
		
		request.httpMethod = HTTPMethods.GET.rawValue
		request.addValue(HTTPHeaders.authentication.1, forHTTPHeaderField: HTTPHeaders.authentication.0)
		
		request.httpMethod = HTTPMethods.GET.rawValue
		request.addValue(HTTPHeaders.authentication.1, forHTTPHeaderField: HTTPHeaders.authentication.0)
		request.addValue(HTTPHeaders.apiVersion.1, forHTTPHeaderField: HTTPHeaders.apiVersion.0)
		
		do {
			let _ = try await URLSession.shared.data(for: request)
		} catch {
			throw HTTPError.badResponse
		}
	}
	
	init() {
//		allWallpapers = EmptyWallpapers.init().wallpapers
	}
}

