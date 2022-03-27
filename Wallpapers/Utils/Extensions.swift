//  Extentions.swift
//  Wallpapers
//
//  Created by Alessia on 27/3/2022.
//

import SwiftUI

extension Array {
	func split() -> [[Element]] {
		let ct = self.count
		let half = ct / 2
		let leftSplit = self[0 ..< half]
		let rightSplit = self[half ..< ct]
		return [Array(leftSplit), Array(rightSplit)]
	}
}

extension Collection where Indices.Iterator.Element == Index {
	subscript (safe index: Index) -> Iterator.Element? {
		return indices.contains(index) ? self[index] : nil
	}
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

struct EmptyWallpapers {
	let wallpapers:[[Wallpaper]] = [[Wallpaper(id: "",urls: URLs(raw: "",full: "",regular: "",small: "",thumb: ""),user: User(username: "",name: "",profileImage: ProfileImage(image: "")))],[Wallpaper(id: "",urls: URLs(raw: "",full: "",regular: "",small: "",thumb: ""),user: User(username: "",name: "",profileImage: ProfileImage(image: "")))]]
}

extension URLCache {
	static let imageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 10*1000*1000*1000)
}
