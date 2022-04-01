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
	@Published var sheetOpacity: Double = 0
	@Published var sheetActive = false
	@Published var bioSheet = false
	@Published var descriptionSheet = false
	
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
	
	func hideDetails() {
		withAnimation {
			sheetOpacity = 0
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.bioSheet = false
				self.descriptionSheet = false
				self.sheetActive = false
			}
		}
	}
	
	func showDetails(type: SheetTypes) {
		if sheetActive == false {
			withAnimation {
				sheetActive = true
				sheetOpacity = 1
				switch type {
				case .bio:
					bioSheet = true
				case .description:
					descriptionSheet = true
				}
			}
		}
	}
	
	enum SheetTypes {
		case bio, description
	}
}
