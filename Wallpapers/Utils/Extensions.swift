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
			
			let itemHeight: Double = Double(item.height) / Double(item.width)
			
			let randomPosition = (0...2).randomElement() /// Creates random position of nil is thrown
			
			let smallestHeight = minIndex(someArray: itemHeights) /// Calculates smalled position in itemheights
			
			splitArray[(smallestHeight ?? randomPosition)!].append(item) /// Adds wallpaper to smallest array or random array
			itemHeights[(smallestHeight ?? randomPosition)!] += itemHeight /// Adds height to corresponding height
		}
		
		return (splitArray, itemHeights)
	}
}

extension URLCache {
	static let imageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 10*1000*1000*1000)
}
