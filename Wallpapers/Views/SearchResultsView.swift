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
	
	var body: some View {
		ScrollView {
			VStack {
				HStack{
					WallpaperListView(index: 0, items: viewModel.searchedWallpapers!, viewModel: detailViewModel)
					WallpaperListView(index: 1, items: viewModel.searchedWallpapers!, viewModel: detailViewModel)
					WallpaperListView(index: 2, items: viewModel.searchedWallpapers!, viewModel: detailViewModel)
				}
				Button {
					Task {
						viewModel.page += 1
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
			.padding(.horizontal, 15)
		}
	}
}

//struct SearchResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchResultsView()
//    }
//}
