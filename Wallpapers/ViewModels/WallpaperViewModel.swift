//  ViewModel.swift
//  Wallpapers
//
//  Created by Alessia on 23/3/2022.
//

import SwiftUI

class WallpaperViewModel : ObservableObject {
	@Published var allWallpapers = [[Wallpaper]]()
	@Published var popUpActive = false
	@Published var popUpText = "Image Saved!"
	
	func fetch() async throws {
		let urlString = Constants.baseUrl + Endpoints.photos
		
		guard let url = URL(string: urlString) else {
			handleError(error: HTTPError.badUrl)
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
	
	func saveToLibrary(imageString: String) async throws {
		
		let image = try await HTTPClient.shared.fetchImage(imageString: imageString)
		
		UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
	}
	
	func handleError(error: HTTPError) {
		switch error {
		case .badUrl:
			popUpText = "URL could not be parsed (error code -1)"
			popUpActive = true
			
		case .errorDecodingData:
			popUpText = "Data could not be decoded (error code -2)"
			popUpActive = true
			
		case .badResponse:
			popUpText = "Server could not be reached (error code -3)"
			popUpActive = true
			
		case .invalidData:
			popUpText = "Returned data not useable (error code -4)"
			popUpActive = true
		}
	}
	
	init() {
		allWallpapers = EmptyWallpapers.init().wallpapers
	}
}

