//
//  ListViewImage.swift
//  Wallpapers
//
//  Created by Alessia on 4/4/2022.
//

import SwiftUI
import CachedAsyncImage

struct ListViewImage: View {
	var url: URL
	var imageCache: URLCache
	
	var body: some View {
		CachedAsyncImage(url: url, urlCache: .mainImageCache) { image in
			image
				.resizable()
				.scaledToFit()
		} placeholder: {
			Color
				.accentColor
				.opacity(0.1)
				.frame(height: 150)
		}
		.cornerRadius(15)
		.padding(3)
	}
}
