//  WallpaperListView.swift
//  Wallpapers
//
//  Created by Alessia on 27/3/2022.
//

import SwiftUI
import CachedAsyncImage

struct WallpaperListView: View {
	var index: Int
	var items: [[Wallpaper]]
	
	@ObservedObject var viewModel: DetailViewModel
	
    var body: some View {
		VStack {
			ForEach(items[index]) { wallpaper in
				Button {
					withAnimation {
						viewModel.selectedWallpaper = wallpaper
						viewModel.zoomed = true
						print("Zooming Image: \(viewModel.selectedWallpaper!.id)")
					}
				} label: {
					CachedAsyncImage(url: URL(string: wallpaper.urls.thumb), urlCache: .imageCache) { image in
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
			Spacer()
		}
    }
}
//
//struct WallpaperListView_Previews: PreviewProvider {
//    static var previews: some View {
//        WallpaperListView()
//    }
//}
