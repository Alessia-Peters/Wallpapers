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
					ListViewImage(url: URL(string: wallpaper.urls.thumb)!)
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
