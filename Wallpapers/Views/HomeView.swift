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
						.padding(.bottom)
						.foregroundColor(.primary)
						.fixedSize()
					
					if wallpapers.connectionState == .connected{
						ConnectedView(wallpapers: wallpapers, detailViewModel: detailViewModel)
					} else if wallpapers.connectionState == .noNetwork {
						NoConnectionView(wallpapers: wallpapers)
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

					.transition(.opacity)
					.zIndex(5)
				
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
