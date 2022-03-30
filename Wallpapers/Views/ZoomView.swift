//  ZoomView.swift
//  Wallpapers
//
//  Created by Alessia on 24/3/2022.
//

import SwiftUI
import CachedAsyncImage

struct ZoomView: View {
	
	@ObservedObject var viewModel: DetailViewModel
	@ObservedObject var wallpaperViewModel: WallpaperViewModel
	
	@State var detailShown = true
	@State var infoShown = false
	
	@State var bioSheet = false
	@State var descriptionSheet = false
	
	var body: some View {
		ZStack{
			Color.white.ignoresSafeArea().frame(minWidth: 0, maxWidth: .infinity)
			
			VStack {
				HStack {
					Spacer()
					if infoShown {
						Button {
							withAnimation {
								detailShown = true
								infoShown = false
							}
						} label: {
							CircleButtonView(symbol: "arrow.down")
								.foregroundColor(.primary)
						}
						.padding(.top, 15)
						.padding(.horizontal, 18)
					}
				}
				Spacer()
			}
			.blur(radius: bioSheet || descriptionSheet ? 4 : 0)
			
			VStack {
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
				
				.zIndex(1)
				.animation(.easeInOut, value: infoShown)
				.onTapGesture {
					withAnimation {
						if !infoShown {
							detailShown.toggle()
						} else {
							withAnimation {
								bioSheet = false
								descriptionSheet = false
							}
						}
					}
				}
				.frame(width: infoShown ? viewModel.widthRatio() : nil, height: infoShown ? 200 : nil)
				.cornerRadius(infoShown ? 15 : 0)
				.ignoresSafeArea()
				.padding(infoShown ? 15 : 0)
				
				if infoShown {
					InfoView(detailViewModel: viewModel, bioSheet: $bioSheet, descriptionSheet: $descriptionSheet)
						.disabled(bioSheet || descriptionSheet)
				}
			}
			.blur(radius: bioSheet || descriptionSheet ? 4 : 0)
			
			DetailView(viewModel: viewModel, wallpaperViewModel: wallpaperViewModel, infoShown: $infoShown, detailShown: $detailShown)
				.opacity(detailShown ? 1 : 0)
			
			if bioSheet {
				ExtraInfoView(title: "Bio", text: viewModel.selectedWallpaper!.user.bio!)
			}
			if descriptionSheet {
				ExtraInfoView(title: "Description", text: viewModel.selectedWallpaper!.description ?? viewModel.selectedWallpaper!.altDescription!)
			}
		}
		.onTapGesture {
			withAnimation {
				bioSheet = false
				descriptionSheet = false
			}
		}
	}
}
