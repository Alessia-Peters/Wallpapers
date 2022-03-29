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
	
	@State var liked = false
	@State var saving = false
	@State private var value = 1.0
	
	private let screen = UIScreen.main.bounds
	
	
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
							.fontWeight(.light)
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
							Button {
								viewModel.selectedSize = .raw
							} label: {
								HStack {
									if viewModel.selectedSize == .raw {
										Image(systemName: "checkmark")
									}
									Text("Raw")
								}
							}
							Button {
								viewModel.selectedSize = .full
							} label: {
								HStack {
									if viewModel.selectedSize == .full {
										Image(systemName: "checkmark")
									}
									Text("Full")
								}
							}
							Button {
								viewModel.selectedSize = .regular
							} label: {
								HStack {
									if viewModel.selectedSize == .regular {
										Image(systemName: "checkmark")
									}
									Text("Regular")
								}
							}
							Button {
								viewModel.selectedSize = .small
							} label: {
								HStack {
									if viewModel.selectedSize == .small {
										Image(systemName: "checkmark")
									}
									Text("Small")
								}
							}
							
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
