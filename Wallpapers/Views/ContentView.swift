//  ContentView.swift
//  Wallpapers
//
//  Created by Alessia on 23/3/2022.
//

import SwiftUI

struct ContentView: View {
	
	@StateObject var wallpapers = WallpaperViewModel()
	@StateObject var detailViewModel = DetailViewModel()
	
	@State var searching = false
	
	let screen = UIScreen.main.bounds
	
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
					
					
					HStack {
						WallpaperListView(index: 0, items: wallpapers.allWallpapers, viewModel: detailViewModel)
						WallpaperListView(index: 1, items: wallpapers.allWallpapers, viewModel: detailViewModel)
						WallpaperListView(index: 2, items: wallpapers.allWallpapers, viewModel: detailViewModel)
					}
					Button {
						Task {
							do {
								try await wallpapers.fetchMore()
							} catch {
								print(error)
							}
						}
					} label: {
						SearchMoreView()
					}
				}
				.padding(.horizontal, 6)
			}
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
				.offset(y: -20)
				Spacer()
			}
			if searching {
				SearchBarView(detailViewModel: detailViewModel, searching: $searching)
					.zIndex(5)
			}
			if detailViewModel.zoomed {
				ZoomView(viewModel: detailViewModel)
					.frame(width: screen.width, height: screen.height)
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
		.onAppear {
//#if DEBUG
//			Task {
//				await wallpapers.fetchFromLibrary()
//			}
//#else
			Task {
				do {
					try await wallpapers.fetch()
				} catch {
					print(error)
				}
			}
//#endif
		}
		.statusBar(hidden: true)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
