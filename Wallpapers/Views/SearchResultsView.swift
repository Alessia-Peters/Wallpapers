//  SearchResultView.swift
//  Wallpapers
//
//  Created by Alessia on 27/3/2022.
//

import SwiftUI

struct SearchResultsView: View {
	@ObservedObject var viewModel: SearchingViewModel
	@ObservedObject var detailViewModel: DetailViewModel
	
	@Binding var selectedWallpaper: Wallpaper?
//	@Binding var zoomed: Bool
	
    var body: some View {
		HStack{
			WallpaperListView(index: 0, items: viewModel.searchedWallpapers!, viewModel: detailViewModel)
			WallpaperListView(index: 1, items: viewModel.searchedWallpapers!, viewModel: detailViewModel)
			WallpaperListView(index: 2, items: viewModel.searchedWallpapers!, viewModel: detailViewModel)
		}
    }
}

//struct SearchResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchResultsView()
//    }
//}
