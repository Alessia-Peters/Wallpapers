//  ViewModel.swift
//  Wallpapers
//
//  Created by Alessia on 23/3/2022.
//

import SwiftUI

class WallpaperViewModel : ObservableObject {
	@Published var allWallpapers = [[Wallpaper]]()
	@Published var imageSaved = false
	
	func fetch() async throws {
		let urlString = Constants.baseUrl + Endpoints.photos
		
		guard let url = URL(string: urlString) else {
			throw HTTPError.badUrl
		}
		
		let response: [Wallpaper] = try await HTTPClient.shared.fetch(url: url)
		
		let splitResponse = response.split()
		
		DispatchQueue.main.async {
			self.allWallpapers = splitResponse
		}
	}
	
	func saveToLibrary(imageString: String) async throws {
		
		let image = try await HTTPClient.shared.fetchImage(imageString: imageString)
		
		UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
		
		imageSaved = true
	}
	
	init() {
		allWallpapers = EmptyWallpapers.init().wallpapers
		
		
		//		do {
		//		try await fetch()
		//		} catch {
		//			print(error)
		//		}
	}
}

