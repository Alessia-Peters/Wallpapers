//  Extentions.swift
//  Wallpapers
//
//  Created by Alessia on 27/3/2022.
//

import SwiftUI

enum ImageSizes {
	case raw, full, regular, small
}

enum ConnectionState {
	case connected, connecting, disconnected, noNetwork
}

extension Array {
	
	private func minIndex(someArray: [Double]) -> Int? {
		return someArray.indices.min { someArray[$0] < someArray[$1] }
	}
	
	func splitArray(input: [Wallpaper], heights: [Double]) -> ([[Wallpaper]],[Double]) {
		
		var splitArray = [[Wallpaper](),[Wallpaper](),[Wallpaper]()]
		
		var itemHeights = heights
		
		input.forEach { item in
			
			let itemHeight: Double = Double(item.height) / Double(item.width) /// Calculates the ratio of the height and width of the image
			
			let randomPosition = (0...2).randomElement() /// Creates random position of nil is thrown
			
			let smallestHeight = minIndex(someArray: itemHeights) /// Calculates smalled position in itemheights
			
			splitArray[(smallestHeight ?? randomPosition)!].append(item) /// Adds wallpaper to smallest array or random array
			itemHeights[(smallestHeight ?? randomPosition)!] += itemHeight /// Adds height to corresponding height
		}
		
		return (splitArray, itemHeights)
	}
	
	//TODO: figure out a way to combine these and remove boilerplate
	
	func splitLikedArray(input: [LikedImage]) -> [[LikedImage]] {
		var splitArray = [[LikedImage](),[LikedImage](),[LikedImage]()]
		
		var itemHeights = [Double(),Double(),Double()]
		
		input.forEach { item in
			
			let itemHeight = item.sizeRatio
			
			let randomPosition = (0...2).randomElement() /// Creates random position of nil is thrown
			
			let smallestHeight = minIndex(someArray: itemHeights) /// Calculates smalled position in itemheights
			
			splitArray[(smallestHeight ?? randomPosition)!].append(item) /// Adds wallpaper to smallest array or random array
			itemHeights[(smallestHeight ?? randomPosition)!] += itemHeight /// Adds height to corresponding height
		}
		
		return splitArray
	}
}

extension URLCache {
	static let imageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 10*1000*1000*1000)
}

extension Color {
	init(hex: UInt, alpha: Double = 1) {
		self.init(
			.sRGB,
			red: Double((hex >> 16) & 0xff) / 255,
			green: Double((hex >> 08) & 0xff) / 255,
			blue: Double((hex >> 00) & 0xff) / 255,
			opacity: alpha
		)
	}
}

extension View {
	@ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
		if condition {
			transform(self)
		} else {
			self
		}
	}
}
