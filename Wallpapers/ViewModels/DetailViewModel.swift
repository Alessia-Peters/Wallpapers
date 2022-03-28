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
	@Published var selectedSize: ImageSizes = .raw
	
	func saveToLibrary(imageString: String) async throws {
		
		let image = try await HTTPClient.shared.fetchImage(imageString: imageString)
		
		UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
	}
	
	func imageSize() -> String{
		var selectedImage: String
		
		switch selectedSize {
		case .raw:
			selectedImage = selectedWallpaper!.urls.raw
		case .full:
			selectedImage = selectedWallpaper!.urls.full
		case .regular:
			selectedImage = selectedWallpaper!.urls.regular
		case .small:
			selectedImage = selectedWallpaper!.urls.small
		}
			
		return selectedImage
			
	}
}
