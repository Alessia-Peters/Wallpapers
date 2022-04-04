//
//  LikedView.swift
//  Wallpapers
//
//  Created by Alessia on 1/4/2022.
//

import SwiftUI

struct LikedView: View {
	@ObservedObject var persistence: Persistence
	@ObservedObject var detailViewModel: DetailViewModel
	
	@Binding var showingLikes: Bool
	@State var background = false
	
	private let likedImageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 10*1000*1000*1000)
	
	var body: some View {
		ZStack {
			Color.primary.ignoresSafeArea().colorInvert()
			ScrollView {
				ZStack {
					VStack {
						HStack {
							LikedImagesListView(index: 0, items: persistence.likedImages, viewModel: detailViewModel, persistence: persistence, imageCache: likedImageCache)
							LikedImagesListView(index: 1, items: persistence.likedImages, viewModel: detailViewModel, persistence: persistence, imageCache: likedImageCache)
							LikedImagesListView(index: 2, items: persistence.likedImages, viewModel: detailViewModel, persistence: persistence, imageCache: likedImageCache)
						}
					}
					.padding()
					.padding(.top, 70)
					GeometryReader { proxy in
						let offset = proxy.frame(in: .named("scroll")).minY
						Color.clear.onChange(of: offset) { newValue in
							withAnimation {
								background = detailViewModel.ifScrolling(offset: offset)
							}
						}
					}
					
				}
			}
			.coordinateSpace(name: "scroll")
			VStack {
				ZStack {
					HStack {
						Button {
							withAnimation {
								showingLikes = false
							}
						} label: {
							CircleButtonView(symbol: "arrow.left")
						}
						
						Spacer()
					}
					Text("Liked Photos")
						.font(.system(size: 35, weight: .bold))
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
		}
		.onAppear {
			persistence.fetch()
		}
	}
}

struct LikedView_Previews: PreviewProvider {
	static var previews: some View {
		LikedView(persistence: Persistence(), detailViewModel: DetailViewModel(), showingLikes: .constant(true))
	}
}
