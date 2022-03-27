//  SearchBarView.swift
//  Wallpapers
//
//  Created by Alessia on 27/3/2022.
//

import SwiftUI

struct SearchBarView: View {
	@Environment(\.colorScheme) var colorScheme
	
	@StateObject var viewModel = SearchingViewModel()
	@ObservedObject var detailViewModel: DetailViewModel
	
	@State var selectedWallpaper: Wallpaper? = nil
	@State var zoomed = false
	
	@State var searchText = String()
	@Binding var searching: Bool
	
	let screen = UIScreen.main.bounds
	
	var body: some View {
		ZStack {
			if colorScheme == .light {
				Color.white.ignoresSafeArea()
			} else {
				Color.black.ignoresSafeArea()
			}
			VStack {
				HStack {
					HStack {
						TextField("Search", text: $searchText)
							.padding()
							.frame(height: 40)
							.textFieldStyle(.plain)
						
						Button {
							Task {
								do {
									try await viewModel.search(searchText: searchText)
								} catch {
									print("Error: \(error)")
								}
							}
						} label: {
							Image(systemName: "magnifyingglass")
						}
						.padding(.trailing)
						
					}
					.background(
						.regularMaterial,
						in: RoundedRectangle(cornerRadius: 20, style: .continuous)
					)
					.padding(.leading,18)
					.offset(y: 4)
					.frame(height: 25)
					Button {
						withAnimation {
							searching = false
						}
						viewModel.resetSearchResults()
					} label: {
						Text("Cancel")
					}
					.padding(.top, 8)
					.padding(.trailing)
					.padding(.leading, 5)
				}
				Spacer()
				if viewModel.searchedWallpapers != nil {
					SearchResultsView(viewModel: viewModel, detailViewModel: detailViewModel, selectedWallpaper: $selectedWallpaper, searchText: $searchText)
					.padding(.top)
					.padding(.horizontal, 6)
				}
			}
			if selectedWallpaper != nil {
				ZoomView(viewModel: detailViewModel)
					.frame(width: screen.width, height: screen.height)
					.zIndex(5)
					.transition(.opacity)
			}
		}
	}
}

//struct SearchBarView_Previews: PreviewProvider {
//	static var previews: some View {
//		SearchBarView(searching: .constant(true))
//	}
//}
