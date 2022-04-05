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

/// Cache for CachedAsyncImage package
extension URLCache {
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
	/// Allows for more extensive conditional modifiers
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

struct ForEachWithIndex<
Data: RandomAccessCollection,
	Content: View
>: View where Data.Element: Identifiable, Data.Element: Hashable {
	let data: Data
	@ViewBuilder let content: (Data.Index, Data.Element) -> Content
	
	var body: some View {
		ForEach(Array(zip(data.indices, data)), id: \.1) { index, element in
			content(index, element)
		}
	}
}
