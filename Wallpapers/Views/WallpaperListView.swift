//  WallpaperListView.swift
//  Wallpapers
//
//  Created by Alessia on 27/3/2022.
//

import SwiftUI
import CachedAsyncImage

struct WallpaperListView: View {
	var index: Int
	
	@ObservedObject var wallpapers: WallpaperViewModel
	
	@Binding var selectedWallpaper: Wallpaper?
	@Binding var zoomed: Bool
	
    var body: some View {
		VStack {
			ForEach(wallpapers.allWallpapers[index]) { wallpaper in
				Button {
					withAnimation {
						selectedWallpaper = wallpaper
						zoomed = true
					}
				} label: {
					CachedAsyncImage(url: URL(string: wallpaper.urls.small), urlCache: .imageCache) { image in
						image
							.resizable()
							.scaledToFit()
					} placeholder: {
						Color
							.purple
							.opacity(0.1)
							.frame(height: 300)
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
