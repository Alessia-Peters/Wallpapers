//  Extentions.swift
//  Wallpapers
//
//  Created by Alessia on 27/3/2022.
//

import SwiftUI

/// Sizes that unsplash provides
enum ImageSizes {
	case raw, full, regular, small
}

/// States weather or not there is a connection
enum ConnectionState {
	case connected, connecting, disconnected, noNetwork
}

extension Array {
	
	/// Finds the smallest item in an array
	/// - Parameter someArray: Array to find smallest item from
	/// - Returns: Index of smallest item, returns nil if there isnt one
	private func minIndex(someArray: [Double]) -> Int? {
		return someArray.indices.min { someArray[$0] < someArray[$1] }
	}
	
	/// Splits array into a nested array of 3, sorts based on height to keep them even
	/// - Parameters:
	///   - inputArray: Array to sort
	///   - heights: Saved heights of previously sorted arrays
	/// - Returns: Sorted array, and their corresponding heights
	func splitArray(inputArray: [Wallpaper], heights: [Double]) -> ([[Wallpaper]],[Double]) {
		
		/// Initializes the array that the items will be split into
		var splitArray = [[Wallpaper](),[Wallpaper](),[Wallpaper]()]
		
		var itemHeights = heights
		
		inputArray.forEach { item in
			
			/// Calculates the ratio of the height and width of the image
			let itemHeight: Double = Double(item.height) / Double(item.width)
			
			/// Creates random position of nil is thrown
			let randomPosition = (0...2).randomElement()
			
			/// Calculates smalled position in itemheights
			let smallestHeight = minIndex(someArray: itemHeights)
			
			/// Adds wallpaper to smallest array or random array
			splitArray[(smallestHeight ?? randomPosition)!].append(item)
			
			/// Adds height to corresponding height
			itemHeights[(smallestHeight ?? randomPosition)!] += itemHeight
		}
		
		return (splitArray, itemHeights)
	}
	
	//TODO: figure out a way to combine these and remove boilerplate
	
	/// Same as previous item, just for the CoreData LikedImage item
	/// - Parameter inputArray: Array to sort
	/// - Returns: Sorted array
	func splitLikedArray(inputArray: [LikedImage]) -> [[LikedImage]] {
		var splitArray = [[LikedImage](),[LikedImage](),[LikedImage]()]
		
		var itemHeights = [Double(),Double(),Double()]
		
		inputArray.forEach { item in
			
			let itemHeight = item.sizeRatio
			
			let randomPosition = (0...2).randomElement()
			
			let smallestHeight = minIndex(someArray: itemHeights)
			
			splitArray[(smallestHeight ?? randomPosition)!].append(item)
			itemHeights[(smallestHeight ?? randomPosition)!] += itemHeight 
		}
		
		return splitArray
	}
}

extension URLCache {
	/// Cache for CachedAsyncImage package
	static let mainImageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 0)
}

extension Color {
	/// Set a color with a hexidecimal value
	/// - Parameters:
	///   - hex: Hex color (0x003085)
	///   - alpha: Opacity
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
	/// Allows for more extensive conditional variables
	/// - Parameters:
	///   - condition: The state that is watched
	///   - transform: The modication the gets applied to a view if the condition is true
	/// - Returns: The view, based on condition
	@ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
		if condition {
			transform(self)
		} else {
			self
		}
	}
}
