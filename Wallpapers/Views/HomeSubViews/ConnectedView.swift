//
//ConnectedView.swift
//  Wallpapers
//
//  Created by Alessia on 29/3/2022.
//

import SwiftUI
import SwiftUIMasonry

struct ConnectedView: View {
	@ObservedObject var wallpapers: WallpaperViewModel
	@ObservedObject var detailViewModel: DetailViewModel
	
	var body: some View {
		VStack {
			VMasonry(columns: wallpapers.columnAmount, content: {
				ForEach(wallpapers.allWallpapers) { wallpaper in
					Button {
						withAnimation {
							detailViewModel.selectedWallpaper = wallpaper
							detailViewModel.zoomed = true
							print("Zooming Image: \(detailViewModel.selectedWallpaper!.id)")
						}
					} label: {
						ListViewImage(url: URL(string: wallpaper.urls.thumb)!, imageCache: .mainImageCache)
					}
				}
			})
			.padding(.horizontal)
			Button {
				Task {
					do {
						try await wallpapers.fetch()
					} catch {
						print(error)
					}
				}
			} label: {
				SearchMoreView()
			}
		}
	}
}
