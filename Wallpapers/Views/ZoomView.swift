//  ZoomView.swift
//  Wallpapers
//
//  Created by Alessia on 24/3/2022.
//

import SwiftUI

struct ZoomView: View {
	@ObservedObject var wallpapers: WallpaperViewModel
	
	@State var wallpaper: Wallpaper
	@State var detailShown = true
	
	@Binding var zoomed: Bool
	
	var body: some View {
		ZStack{
			
			AsyncImage(url: URL(string: wallpaper.urls.regular)) { image in
				image
					.resizable()
					.scaledToFill()
				
			} placeholder: {
				
				Color.white
				AsyncImage(url: URL(string: wallpaper.urls.full)) { image in
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
			
			if detailShown {
				DetailView(wallpapers: wallpapers, zoomed: $zoomed, wallpaper: $wallpaper)
					.transition(.opacity)
			}
		}
		.statusBar(hidden: true)
	}
}
