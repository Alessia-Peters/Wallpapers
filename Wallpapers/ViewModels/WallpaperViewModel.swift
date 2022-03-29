//  ViewModel.swift
//  Wallpapers
//
//  Created by Alessia on 23/3/2022.
//

import SwiftUI

class WallpaperViewModel : ObservableObject {
	
	@Published var allWallpapers: [[Wallpaper]]
	@Published var popUpText = "Image Saved!"
	@Published var connectionState: ConnectionState = .disconnected
	@Published var popUpActive = false
	
	private var height: [Double] = [0,0,0]
	
	func fetch() async throws {
		
		do {
			try await HTTPClient.shared.checkConnection()
		} catch {
			DispatchQueue.main.async {
				self.connectionState = .noNetwork
			}
			throw HTTPError.badResponse
		}
		
		let urlString = Constants.baseUrl + Endpoints.random + Parameters.count + "30"
		
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
			self.connectionState = .connected
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
	
	func saveToLibrary(imageString: String) async throws {
		
		let image = try await HTTPClient.shared.fetchImage(imageString: imageString)
		
		UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
		
		DispatchQueue.main.async {
			withAnimation {
				self.popUpActive = true
			}
		}
	}
	
	init() {
		allWallpapers = [[Wallpaper](),[Wallpaper](),[Wallpaper]()]
	}
}

