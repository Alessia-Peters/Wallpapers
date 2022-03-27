//  Extentions.swift
//  Wallpapers
//
//  Created by Alessia on 27/3/2022.
//

import SwiftUI

extension Array {
	func split() -> [[Element]] {
		let ct = self.count
		let third = ct / 3
		let splitOne = self[0 ..< third]
		let splitTwo = self[third ..< third * 2]
		let splitThree = self[third * 2 ..< ct]
		return [Array(splitOne), Array(splitTwo), Array(splitThree)]
	}
}

struct EmptyWallpapers {
	let wallpapers:[[Wallpaper]] = [[Wallpaper(id: "",
											   urls: URLs(raw: "",
														  full: "",
														  regular: "",
														  small: "",
														  thumb: ""),
											   user: User(username: "",
														  name: "",
														  profileImage: ProfileImage(image: "")), height: 0)],
									[Wallpaper(id: "",
											   urls: URLs(raw: "",
														  full: "",
														  regular: "",
														  small: "",
														  thumb: ""),
											   user: User(username: "",
														  name: "",
														  profileImage: ProfileImage(image: "")), height: 0)],
									[Wallpaper(id: "",
											   urls: URLs(raw: "",
														  full: "",
														  regular: "",
														  small: "",
														  thumb: ""),
											   user: User(username: "",
														  name: "",
														  profileImage: ProfileImage(image: "")), height: 0)]]
}

extension URLCache {
	static let imageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 10*1000*1000*1000)
}
