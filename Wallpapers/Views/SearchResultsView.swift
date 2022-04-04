//  SearchResultView.swift
//  Wallpapers
//
//  Created by Alessia on 27/3/2022.
//

import SwiftUI

struct SearchResultsView: View {
	@ObservedObject var viewModel: SearchingViewModel
	@ObservedObject var detailViewModel: DetailViewModel
	
	@Binding var searchText: String
	@Binding var background: Bool
	
	private let searchImageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 0)
	
	var body: some View {
		ScrollView {
			VStack {
				ZStack {
					HStack{
						WallpaperListView(index: 0, items: viewModel.searchedWallpapers!, imageCache: searchImageCache, viewModel: detailViewModel)
						WallpaperListView(index: 1, items: viewModel.searchedWallpapers!, imageCache: searchImageCache, viewModel: detailViewModel)
						WallpaperListView(index: 2, items: viewModel.searchedWallpapers!, imageCache: searchImageCache, viewModel: detailViewModel)
					}
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
		
		SearchResultsView(viewModel: viewModel, detailViewModel: detailViewModel, searchText: .constant(""), background: .constant(true))
	}
}
