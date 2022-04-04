//
//ConnectedView.swift
//  Wallpapers
//
//  Created by Alessia on 29/3/2022.
//

import SwiftUI

struct ConnectedView: View {
	@ObservedObject var wallpapers: WallpaperViewModel
	@ObservedObject var detailViewModel: DetailViewModel
	
	var body: some View {
		VStack {
			HStack {
				WallpaperListView(index: 0, items: wallpapers.allWallpapers, imageCache: .mainImageCache, viewModel: detailViewModel)
				WallpaperListView(index: 1, items: wallpapers.allWallpapers, imageCache: .mainImageCache, viewModel: detailViewModel)
				WallpaperListView(index: 2, items: wallpapers.allWallpapers, imageCache: .mainImageCache, viewModel: detailViewModel)
			}
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
