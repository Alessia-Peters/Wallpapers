//  ZoomView.swift
//  Wallpapers
//
//  Created by Alessia on 24/3/2022.
//

import SwiftUI
import CachedAsyncImage

struct ZoomView: View {
	@ObservedObject var viewModel: DetailViewModel
	
	@State var detailShown = true
	
	var body: some View {
		ZStack{
			CachedAsyncImage(url: URL(string: viewModel.selectedWallpaper!.urls.full)!, urlCache: .imageCache) { image in
				image
					.resizable()
					.scaledToFill()
				
			} placeholder: {
				
				Color.white
				CachedAsyncImage(url: URL(string: viewModel.selectedWallpaper!.urls.small), urlCache: .imageCache) { image in
					image
						.resizable()
						.scaledToFill()
					
				} placeholder: {
					ProgressView()
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
