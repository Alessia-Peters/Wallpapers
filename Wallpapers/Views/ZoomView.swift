//  ZoomView.swift
//  Wallpapers
//
//  Created by Alessia on 24/3/2022.
//

import SwiftUI
import CachedAsyncImage

struct ZoomView: View {
	@ObservedObject var wallpapers: WallpaperViewModel
	
	@State var wallpaper: Wallpaper
	@State var detailShown = true
	
	@Binding var zoomed: Bool
	
	var body: some View {
		ZStack{
			CachedAsyncImage(url: URL(string: wallpaper.urls.full)!, urlCache: .imageCache) { image in
				image
					.resizable()
					.scaledToFill()
				
			} placeholder: {
				
				Color.white
				CachedAsyncImage(url: URL(string: wallpaper.urls.small), urlCache: .imageCache) { image in
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
			
			DetailView(wallpapers: wallpapers, zoomed: $zoomed, wallpaper: $wallpaper)
				.opacity(detailShown ? 1 : 0)
				.disabled(detailShown ? false : true)
			
		}
		.statusBar(hidden: true)
	}
}
