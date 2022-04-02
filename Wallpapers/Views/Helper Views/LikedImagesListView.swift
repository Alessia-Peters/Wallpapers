//
//  LikedImagesListView.swift
//  Wallpapers
//
//  Created by Alessia on 2/4/2022.
//

import SwiftUI
import CachedAsyncImage

//TODO: combine this and WallpaperListview to remove boilierplate
struct LikedImagesListView: View {
	var index: Int
	var items: [[LikedImage]]
	
	@ObservedObject var viewModel: DetailViewModel
	@ObservedObject var persistence: Persistence
	
	var body: some View {
		VStack {
			ForEach(items[index]) { wallpaper in
				Button {
					Task {
						do {
							try await viewModel.fetchLikedWallpaper(id: wallpaper.id!)
						} catch {
							print("Error fetching liked wallpaper: \(error)")
						}
					}
				} label: {
					ListViewImage(url: wallpaper.thumbnail!)
				}
			}
			Spacer()
		}
	}
}

struct ListViewImage: View {
	var url: URL
	var body: some View {
		CachedAsyncImage(url: url, urlCache: .imageCache) { image in
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
