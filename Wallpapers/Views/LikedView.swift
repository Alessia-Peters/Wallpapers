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
	var body: some View {
		ZStack {
			Color.white.ignoresSafeArea()
			ScrollView {
				VStack {
					HStack {
						
						LikedImagesListView(index: 0, items: persistence.likedImages, viewModel: detailViewModel, persistence: persistence)
						LikedImagesListView(index: 1, items: persistence.likedImages, viewModel: detailViewModel, persistence: persistence)
						LikedImagesListView(index: 2, items: persistence.likedImages, viewModel: detailViewModel, persistence: persistence)
					}
				}
				.padding()
				.padding(.horizontal, 3)
			}
			VStack {
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
				.foregroundColor(.primary)
				.padding()
				.padding(.horizontal, 3)
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
