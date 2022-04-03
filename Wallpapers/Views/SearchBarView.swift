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
	
	@State var zoomed = false
	
	@State var searchText = String()
	@Binding var searching: Bool
	@State var background = false
	
	private let screen = UIScreen.main.bounds
	
	var body: some View {
		ZStack {
			if colorScheme == .light {
				Color.white.ignoresSafeArea()
			} else {
				Color.black.ignoresSafeArea()
			}
			VStack {
				
				
//				Spacer()
				if viewModel.showingResults && viewModel.searchedWallpapers != nil {
						SearchResultsView(viewModel: viewModel, detailViewModel: detailViewModel, searchText: $searchText, background: $background)
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
			VStack {
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
							.accessibilityIdentifier("Search Field")
						
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
						.accessibilityIdentifier("Search For Results")
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
					.accessibilityIdentifier("Cancel")
					.padding(.leading, 5)
				}
				.padding(.horizontal, 19)
				.padding(.vertical, 25)
				.if(background) { view in
					view.background(
						.bar
					)
				}
				Spacer()
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
