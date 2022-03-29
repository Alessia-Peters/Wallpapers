//  ZoomView.swift
//  Wallpapers
//
//  Created by Alessia on 24/3/2022.
//

import SwiftUI
import CachedAsyncImage

struct ZoomView: View {
	@ObservedObject var viewModel: DetailViewModel
	
	private let screen = UIScreen.main.bounds
	
	@State var detailShown = true
	
	var body: some View {
		ZStack{
			Color.white.ignoresSafeArea()
			ZStack {
				AsyncImage(url: URL(string: viewModel.selectedWallpaper!.urls.full)!) { image in
					image
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(minWidth: 0, maxWidth: .infinity)
					
				} placeholder: {
					CachedAsyncImage(url: URL(string: viewModel.selectedWallpaper!.urls.thumb), urlCache: .imageCache) { image in
						image
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(minWidth: 0, maxWidth: .infinity)
						
					} placeholder: {
						ProgressView()
					}
				}
			}
			.ignoresSafeArea()
			.onTapGesture {
				withAnimation {
					detailShown.toggle()
				}
			}
			
			DetailView(viewModel: viewModel)
				.opacity(detailShown ? 1 : 0)
				.disabled(detailShown ? false : true)
		}
	}
}
