//  ContentView.swift
//  Wallpapers
//
//  Created by Alessia on 23/3/2022.
//

import SwiftUI

struct HomeView: View {
	
	@StateObject var wallpapers = WallpaperViewModel()
	@StateObject var detailViewModel = DetailViewModel()
	
	@State var searching = false
	
	var body: some View {
		ZStack {
			ScrollView {
				VStack {
					Image("Logo")
						.resizable()
						.scaledToFit()
						.frame(height: 30)
						.padding(.horizontal, 90)
						.padding(.vertical,5)
						.foregroundColor(.primary)
						.fixedSize()
					
					if wallpapers.connectionState == .connected{
						HStack {
							WallpaperListView(index: 0, items: wallpapers.allWallpapers, viewModel: detailViewModel)
							WallpaperListView(index: 1, items: wallpapers.allWallpapers, viewModel: detailViewModel)
							WallpaperListView(index: 2, items: wallpapers.allWallpapers, viewModel: detailViewModel)
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
					} else if wallpapers.connectionState == .noNetwork {
						Text("Cant connect to server")
							.opacity(0.4)
					}
				}
			}
			.padding(.horizontal, 6)
			VStack {
				HStack {
					Button {
						withAnimation {
							searching.toggle()
						}
					} label: {
						CircleButtonView(symbol: "magnifyingglass")
					}
					
					Spacer()
					
					Button {
						
					} label: {
						CircleButtonView(symbol: "heart")
					}
				}
				.foregroundColor(.primary)
				.padding()
				.padding(.horizontal, 9)
				.offset(y: -16)
				Spacer()
			}
			if searching {
				SearchBarView(detailViewModel: detailViewModel, searching: $searching)
					.zIndex(5)
			}
			if detailViewModel.zoomed {
				ZoomView(viewModel: detailViewModel)
//					.frame(width: screen.width, height: screen.height)
					.zIndex(5)
					.transition(.opacity)
			}
			if detailViewModel.popUpActive {
				PopUpView(text: "Image Saved!")
					.onAppear {
						DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
							withAnimation {
								detailViewModel.popUpActive = false
							}
						}
					}
					.transition(.move(edge: .top))
					.zIndex(5)
			}
		}
		.padding(.horizontal)
		.onAppear {
			Task {
				do {
					#if DEBUG
					try await wallpapers.fetchFromLibrary()
					#else
					try await wallpapers.fetch()
					#endif
				} catch {
					print(error)
				}
			}
		}
		.statusBar(hidden: true)
	}
}
//
//struct ContentView_Previews: PreviewProvider {
//	static var previews: some View {
//		HomeView()
//	}
//}
