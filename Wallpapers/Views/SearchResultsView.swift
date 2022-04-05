//  SearchResultView.swift
//  Wallpapers
//
//  Created by Alessia on 27/3/2022.
//

import SwiftUI
import SwiftUIMasonry

struct SearchResultsView: View {
	@ObservedObject var viewModel: SearchingViewModel
	@ObservedObject var detailViewModel: DetailViewModel
	@ObservedObject var wallpaperViewModel: WallpaperViewModel
	
	@Binding var searchText: String
	@Binding var background: Bool
	
	var body: some View {
		ScrollView {
			VStack {
				ZStack {
					VMasonry(columns: wallpaperViewModel.columnAmount, content: {
						ForEach(viewModel.searchedWallpapers!) { wallpaper in
							Button {
								withAnimation {
									detailViewModel.selectedWallpaper = wallpaper
									detailViewModel.zoomed = true
									print("Zooming Image: \(detailViewModel.selectedWallpaper!.id)")
								}
							} label: {
								ListViewImage(url: URL(string: wallpaper.urls.thumb)!, imageCache: viewModel.searchImageCache)
							}
						}
					})
					GeometryReader { proxy in
						let offset = proxy.frame(in: .named("scroll")).minY
						Color.clear.onChange(of: offset) { _ in
							withAnimation {
								background = detailViewModel.ifScrolling(offset: offset, offsetMax: 75)
							}
						}
					}
				}
				Button {
					Task {
						do {
							try await viewModel.search(searchText: searchText)
						} catch {
							print(error)
						}
					}
				} label: {
					SearchMoreView()
				}
			}
			.padding(.top, 62)
			.padding(.horizontal)
			.padding(.top)
		}
		.coordinateSpace(name: "scroll")
	}
}

struct SearchResultView_Previews: PreviewProvider {
	static var previews: some View {
		let viewModel = SearchingViewModel()
		let detailViewModel = DetailViewModel()
		
		SearchResultsView(viewModel: viewModel, detailViewModel: detailViewModel, wallpaperViewModel: WallpaperViewModel(), searchText: .constant(""), background: .constant(true))
	}
}
