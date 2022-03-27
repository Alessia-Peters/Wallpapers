//  DetailViewModel.swift
//  Wallpapers
//
//  Created by Alessia on 27/3/2022.
//

import SwiftUI

class DetailViewModel : ObservableObject {
	
	@Published var popUpActive = false
	@Published var selectedWallpaper: Wallpaper?
	@Published var zoomed = false
	
	func saveToLibrary(imageString: String) async throws {
		
		let image = try await HTTPClient.shared.fetchImage(imageString: imageString)
		
		UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
	}
}
