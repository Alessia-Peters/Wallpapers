//  DetailViewModel.swift
//  Wallpapers
//
//  Created by Alessia on 27/3/2022.
//

import SwiftUI

class DetailViewModel : ObservableObject {
	
	@Published var selectedWallpaper: Wallpaper?
	@Published var zoomed = false
	@Published var selectedSize: ImageSizes = .raw
	
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
	
	func widthRatio() -> Double{
		let height = (selectedWallpaper?.height)!
		let width = (selectedWallpaper?.width)!
		
		let widthRatio: Double = Double(width) / Double(height)
		
		return widthRatio * 200
	}
}
