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
	
	/// Fetches a single liked wallpaper when it is selected from the liked menu
	/// - Parameter id: The ID of the wallpaper being requestedwe
	func fetchLikedWallpaper(id: String) async throws {
		let urlString = Constants.baseUrl + Endpoints.id + id
		
		guard let url = URL(string: urlString) else {
			throw HTTPError.badUrl
		}
		
		guard let response: Wallpaper = try await HTTPClient.shared.fetch(url: url) else {
			throw HTTPError.badResponse
		}
		
		DispatchQueue.main.async {
			self.selectedWallpaper = response
			withAnimation {
				self.zoomed = true
			}
			print("Zooming Image: \(id)")
		}
	}
	
	/// Gets needed size for download
	/// - Returns: URL (as string) for image being downloaded
	func imageSize() -> String {
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
	
	/// Calculates the ratio needed for the view in InfoView
	/// - Returns: The width for the image shown
	func widthRatio() -> Double {
		let height = (selectedWallpaper?.height)!
		let width = (selectedWallpaper?.width)!
		
		let widthRatio: Double = Double(width) / Double(height)
		
		return widthRatio * 200
	}
	
	/// Hides the extra details in InfoView
	/// Needed since animations don't work without it
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
	
	/// Shows the extra details in InfoView
	/// - Parameter type: whether its a bio or description
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
	
	/// Detects if the background up the top should be shown
	/// - Parameters:
	///   - offset: Current offset of the scroll view
	///   - offsetMax: Offset required to show the background
	/// - Returns: Whether or not the background should appear
	func ifScrolling(offset: CGFloat, offsetMax: CGFloat = -0.5) -> Bool {
		if offset > offsetMax {
			return false
		} else {
			return true
		}
	}
	
	/// Types of info sheets
	enum SheetTypes {
		case bio, description
	}
}
