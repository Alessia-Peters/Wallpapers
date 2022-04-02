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
	@ObservedObject var wallpaperViewModel: WallpaperViewModel
	@ObservedObject var persistence: Persistence
	
	@State var selectedWallpaper: Wallpaper? = nil
	@State var zoomed = false
	
	@State var searchText = String()
	@Binding var searching: Bool
	
	private let screen = UIScreen.main.bounds
	
	var body: some View {
		ZStack {
			if colorScheme == .light {
				Color.white.ignoresSafeArea()
			} else {
				Color.black.ignoresSafeArea()
			}
			VStack {
				ZStack {
					HStack {
						HStack {
							TextField("Search", text: $searchText)
								.padding()
								.frame(height: 40)
								.textFieldStyle(.plain)
								.submitLabel(.search)
								.onSubmit {
									viewModel.resetSearchResults()
									viewModel.noResults = false
									Task {
										do {
											try await viewModel.search(searchText: searchText)
										} catch {
											print("Error: \(error)")
										}
									}
								}
							
							Button {
								viewModel.resetSearchResults()
								viewModel.noResults = false
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
							.disabled(searchText == "")
							
						}
						.background(
							.regularMaterial,
							in: RoundedRectangle(cornerRadius: 20, style: .continuous)
						)
						.frame(height: 25)
						Button {
							withAnimation {
								searching = false
							}
							viewModel.resetSearchResults()
						} label: {
							Text("Cancel")
						}
						.padding(.leading, 5)
					}
					.padding(.horizontal, 20)
					.padding(.top, 23)
					.background(
						Color.primary.colorInvert()
							.blur(radius: 1)
							.frame(height: 70)
							.offset(y: 5)
					)
				}
				
				Spacer()
				if viewModel.showingResults && viewModel.searchedWallpapers != nil {
					SearchResultsView(viewModel: viewModel, detailViewModel: detailViewModel, searchText: $searchText)
						.zIndex(-1)
				} else if viewModel.noResults {
					Text("No Results")
						.opacity(0.4)
					Spacer()
				} else if viewModel.connectionState == .noNetwork {
					Button {
						Task {
							do {
								try await viewModel.search(searchText: searchText)
							} catch {
								print(error)
							}
						}
					} label: {
						Text("Can't connect to server, tap to retry")
							.opacity(0.4)
							.foregroundColor(.primary)
					}
					Spacer()
				}
			}
			if selectedWallpaper != nil {
				ZoomView(viewModel: detailViewModel, wallpaperViewModel: wallpaperViewModel, persistence: persistence)
					.frame(width: screen.width, height: screen.height)
					.zIndex(5)
					.transition(.opacity)
			}
		}
	}
}

struct SearchBarView_Previews: PreviewProvider {
	static var previews: some View {
		let wallpaperViewModel = WallpaperViewModel()
		let detailViewModel = DetailViewModel()
		
		SearchBarView(detailViewModel: detailViewModel, wallpaperViewModel: wallpaperViewModel, persistence: Persistence(), searching: .constant(true))
	}
}
