//  DetailView.swift
//  Wallpapers
//
//  Created by Alessia on 27/3/2022.
//

import SwiftUI

struct DetailView: View {
	@Environment(\.colorScheme) var colorScheme
	
	@ObservedObject var viewModel: DetailViewModel
	@ObservedObject var wallpaperViewModel: WallpaperViewModel
	
	@State private var liked = false
	@State private var saving = false
	@State private var value = 1.0
	
	@Binding var infoShown: Bool
	@Binding var detailShown: Bool
	
	var body: some View {
		VStack {
			HStack {
				Button {
					withAnimation {
						viewModel.zoomed = false
					}
				} label: {
					CircleButtonView(symbol: "arrow.left")
				}
				Spacer()
				Button {
					withAnimation {
						detailShown = false
						infoShown = true
					}
				} label: {
					CircleButtonView(symbol: "info")
				}
				
			}
			.padding(.top, 15)
			.padding(.horizontal, 18)
			
			Spacer()
			
			ZStack {
				
				HStack {
					AsyncImage(url: URL(string: viewModel.selectedWallpaper!.user.profileImage.image)) { image in
						image
							.resizable()
					} placeholder: {
						Color
							.purple
							.opacity(0.1)
					}
					.frame(width: 65, height: 65)
					.clipShape(Circle())
					.padding(.trailing, 7)
					
					VStack(alignment: .leading) {
						Text(viewModel.selectedWallpaper!.user.name)
							.font(.system(size: 25, weight: .semibold))
						Text(viewModel.selectedWallpaper!.user.username)
					}
					.lineLimit(1)
					.minimumScaleFactor(0.5)
					
					
					Spacer()
					
					Group {
						Button {
							withAnimation {
								liked.toggle()
							}
						} label: {
							Image(systemName: liked ? "heart.fill" : "heart")
								.foregroundColor(liked ? .red : .primary)
								.transition(.scale)
						}
						Button {
							saving = true
							Task {
								do {
									try await wallpaperViewModel.saveToLibrary(imageString: viewModel.imageSize())
								} catch {
									print(error.localizedDescription)
								}
								saving = false
							}
						} label: {
							Image(systemName: "arrow.down.circle")
								.opacity(saving ? value : 1)
								.animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: value)
								.onChange(of: saving) { newValue in
									self.value = 0.3
								}
						}
						.contextMenu {
							SaveButtonOptions(viewModel: viewModel)
						}
						.disabled(saving)
					}
					.font(.system(size: 25, weight: .medium))
					.padding(6)
				}
				.padding(.horizontal, 15)
				.padding(.vertical, 15)
				.background(
					.thinMaterial,
					in: RoundedRectangle(cornerRadius: 25, style: .continuous)
				)
				.padding(.horizontal, 18)
				.padding(.bottom)
			}
		}
		.foregroundColor(.primary)
	}
}
