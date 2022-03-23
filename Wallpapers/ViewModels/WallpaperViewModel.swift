//  ViewModel.swift
//  Wallpapers
//
//  Created by Alessia on 23/3/2022.
//

import Foundation

class WallpaperViewModel : ObservableObject {
	@Published var wallpapers = [Wallpaper]()
	
	func fetch() async throws {
		let urlString = Constants.baseUrl + Endpoints.photos
		
		guard let url = URL(string: urlString) else {
			throw HTTPError.badUrl
		}
		
		let response: [Wallpaper] = try await HTTPClient.shared.fetch(url: url)
		
		DispatchQueue.main.async {
			self.wallpapers = response
		}
	}
	
	func debugFetch() async throws {
		
	}
}
