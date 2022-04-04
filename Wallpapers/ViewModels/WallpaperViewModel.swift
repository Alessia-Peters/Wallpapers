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
	
	/// The height of the columns of images
	private var height: [Double] = [0,0,0]
	
	/// Fetches a set of 30 random wallpapers
	func fetch() async throws {
		
		/// Throws if a connection cant be made
		do {
			try await HTTPClient.shared.checkConnection()
		} catch {
			DispatchQueue.main.async {
				self.connectionState = .noNetwork
			}
			throw HTTPError.badResponse
		}
		
		/// If connection was previously offline and and method before didnt throw, sets connection to connecting
		DispatchQueue.main.async {
			if self.connectionState == .noNetwork {
				self.connectionState = .connecting
			}
		}
		
		let urlString = Constants.baseUrl + Endpoints.random + Parameters.count + "30"
		
		guard let url = URL(string: urlString) else {
			throw HTTPError.badUrl
		}
		
		guard let response: [Wallpaper] = try await HTTPClient.shared.fetch(url: url) else {
			throw HTTPError.badResponse
		}
		
		/// Splits the returned array into a nested array to be used in columns in the view
		let splitResponse = response.splitArray(inputArray: response, heights: height)
		
		let splitItems = splitResponse.0
		
		/// Saves the height to be used again if "Load More" is pressed
		height = splitResponse.1
		
		DispatchQueue.main.async {
			withAnimation {
				self.allWallpapers[0].append(contentsOf: splitItems[0])
				self.allWallpapers[1].append(contentsOf: splitItems[1])
				self.allWallpapers[2].append(contentsOf: splitItems[2])
				self.connectionState = .connected
			}
		}
	}
	
	#if DEBUG
	/// Fetches saved json file from project directory. Used only for debugging
	func fetchFromLibrary() async throws {
		let data = Bundle.main.decode([Wallpaper].self, from: "Example.json")
		
		let splitResponse = data.splitArray(inputArray: data, heights: height)
		
		let splitItems = splitResponse.0
		
		height = splitResponse.1
		
		DispatchQueue.main.async {
			self.allWallpapers = splitItems
			self.connectionState = .connected
		}
	}
	#endif
	
	/// Saves an image to photo library
	/// - Parameter imageString: String of the image address
	func saveToLibrary(imageString: String) async throws {
		
		/// Fetches and decodes photo
		let image = try await HTTPClient.shared.fetchImage(imageString: imageString)
		
		/// Writes photos to library
		UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
		
		DispatchQueue.main.async {
			withAnimation {
				/// Shows the popup to say the image is saved
				// TODO: Make the popup show if a photo failed to save
				self.popUpActive = true
			}
		}
	}
	
	init() {
		if Bundle.main.object(forInfoDictionaryKey: "API_KEY") as! String == "" {
			fatalError("No API Key")
		}
		allWallpapers = [[Wallpaper](),[Wallpaper](),[Wallpaper]()]
	}
}

