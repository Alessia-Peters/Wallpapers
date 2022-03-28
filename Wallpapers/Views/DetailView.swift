//  DetailView.swift
//  Wallpapers
//
//  Created by Alessia on 27/3/2022.
//

import SwiftUI

struct DetailView: View {
	@Environment(\.colorScheme) var colorScheme
	
	@ObservedObject var viewModel: DetailViewModel
	
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
				.padding()
				Spacer()
			}
			.offset(y: 20)
			.frame(width: screen.width)
			
			
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
					
					VStack(alignment: .leading) {
						Text(viewModel.selectedWallpaper!.user.name)
							.font(.system(size: 25, weight: .semibold))
						Text(viewModel.selectedWallpaper!.user.username)
							.fontWeight(.light)
					}
					.lineLimit(1)
					.minimumScaleFactor(0.5)
					.padding()
					
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
									try await viewModel.saveToLibrary(imageString: viewModel.selectedWallpaper!.urls.raw)
								} catch {
									print(error.localizedDescription)
								}
								withAnimation {
									viewModel.popUpActive = true
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
						.disabled(saving)
					}
					.font(.system(size: 25, weight: .medium))
					.padding(5)
				}
				.padding(.horizontal)
				.padding(.vertical, 10)
				.background(
					.thinMaterial,
					in: RoundedRectangle(cornerRadius: 20, style: .continuous)
				)
				.padding()
				.frame(width: screen.width)
				
			}
			.padding(.bottom)
		}
		.foregroundColor(.primary)
	}
}
