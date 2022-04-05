//  ContentView.swift
//  Wallpapers
//
//  Created by Alessia on 23/3/2022.
//

import SwiftUI

struct HomeView: View {
	
	@StateObject var wallpapers = WallpaperViewModel()
	@StateObject var detailViewModel = DetailViewModel()
	@ObservedObject var persistence: Persistence
	
	@State var searching = false
	@State var showingLikes = false
	@State var background = false
	
	var body: some View {
		ZStack {
			if wallpapers.connectionState == .connected {
				ScrollView {
					ZStack {
						ConnectedView(wallpapers: wallpapers, detailViewModel: detailViewModel)
							.padding(.top, 86)
						GeometryReader { proxy in
							let offset = proxy.frame(in: .named("scroll")).minY
							Color.clear.onChange(of: offset) { _ in
								withAnimation {
									background = detailViewModel.ifScrolling(offset: offset)
								}
							}
						}
					}
				}
				.coordinateSpace(name: "scroll")
			} else if wallpapers.connectionState == .noNetwork {
				NoConnectionView(wallpapers: wallpapers)
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
					.accessibilityIdentifier("Search Button")
					
					Spacer()
					Text("Home")
						.font(.system(size: 35, weight: .bold))
					Spacer()
					Button {
						withAnimation {
							showingLikes.toggle()
						}
					} label: {
						CircleButtonView(symbol: "heart")
					}
					.accessibilityIdentifier("Likes Button")
				}
				.foregroundColor(.primary)
				.padding()
				.padding(.horizontal, 3)
				.if(background) { view in
					view.background(
						.bar
					)
				}
				Spacer()
			}
			
			
			if searching {
				SearchBarView(detailViewModel: detailViewModel, wallpaperViewModel: wallpapers, persistence: persistence, searching: $searching)
					.zIndex(5)
			}
			
			if detailViewModel.zoomed {
				ZoomView(viewModel: detailViewModel, wallpaperViewModel: wallpapers, persistence: persistence)
					.transition(.opacity)
					.zIndex(5)
			}
			
			if showingLikes {
				LikedView(persistence: persistence, detailViewModel: detailViewModel, wallpaperViewModel: wallpapers, showingLikes: $showingLikes)
					.zIndex(4)
			}
			
			if wallpapers.popUpActive {
				PopUpView(text: "Image Saved!")
					.onAppear {
						DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
							withAnimation {
								wallpapers.popUpActive = false
							}
						}
					}
					.transition(.move(edge: .top))
					.zIndex(5)
			}
		}
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

//struct ContentView_Previews: PreviewProvider {
//	static var previews: some View {
//		HomeView()
//	}
//}
