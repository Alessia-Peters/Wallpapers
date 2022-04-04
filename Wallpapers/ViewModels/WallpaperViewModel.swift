//  ViewModel.swift
//  Wallpapers
//
//  Created by Alessia on 23/3/2022.
//

import SwiftUI

class WallpaperViewModel : ObservableObject {
	
	@Published var allWallpapers: [Wallpaper]
	@Published var popUpText = "Image Saved!"
	@Published var connectionState: ConnectionState = .disconnected
	@Published var popUpActive = false
	@Published var columnAmount = 3
	
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
		
		DispatchQueue.main.async {
			withAnimation {
				self.allWallpapers.append(contentsOf: response)
				self.connectionState = .connected
			}
		}
	}
	
	#if DEBUG
	/// Fetches saved json file from project directory. Used only for debugging
	func fetchFromLibrary() async throws {
		let data = Bundle.main.decode([Wallpaper].self, from: "Example.json")
		
		DispatchQueue.main.async {
			self.allWallpapers = data
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
		allWallpapers = [Wallpaper]()
		
		switch UIDevice.current.userInterfaceIdiom {
		case .pad:
			columnAmount = 5
		default:
			break
		}
	}
}

