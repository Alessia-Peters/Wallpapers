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
	
	
	var body: some View {
		ZStack {
			Color.primary.ignoresSafeArea().colorInvert()
			ScrollView {
				ZStack {
					VStack {
						HStack {
							LikedImagesListView(index: 0, items: persistence.likedImages, viewModel: detailViewModel, persistence: persistence)
							LikedImagesListView(index: 1, items: persistence.likedImages, viewModel: detailViewModel, persistence: persistence)
							LikedImagesListView(index: 2, items: persistence.likedImages, viewModel: detailViewModel, persistence: persistence)
						}
					}
					.padding()
					.padding(.horizontal, 3)
					.padding(.top, 60)
					GeometryReader { proxy in
						let offset = proxy.frame(in: .named("scroll")).minY
						Color.clear.onChange(of: offset) { newValue in
							if offset > -0.5 {
								withAnimation {
									background = false
								}
							} else {
								withAnimation {
									background = true
								}
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
