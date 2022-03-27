//  DetailView.swift
//  Wallpapers
//
//  Created by Alessia on 27/3/2022.
//

import SwiftUI

struct DetailView: View {
	@Environment(\.colorScheme) var colorScheme
	
	@ObservedObject var wallpapers: WallpaperViewModel
	
	@Binding var zoomed: Bool
	@Binding var wallpaper: Wallpaper
	
	@State var liked = false
	@State var saving = false
	@State private var value = 1.0
	
	private let screen = UIScreen.main.bounds
	
	
	var body: some View {
		VStack {
			HStack {
				Button {
					withAnimation {
						zoomed = false
					}
				} label: {
					Image(systemName: "arrow.left")
						.font(.system(size: 25, weight: .semibold))
						.foregroundColor(.white)
						.padding(8)
						.background(
							.thinMaterial,
							in: Circle()
						)
				}
				.padding()
				Spacer()
			}
			.offset(y: 30)
			.frame(width: screen.width)
			
			
			Spacer()
			ZStack {
				
				HStack {
					AsyncImage(url: URL(string: wallpaper.user.profileImage.image)) { image in
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
						Text(wallpaper.user.name)
							.font(.system(size: 25, weight: .semibold))
						Text(wallpaper.user.username)
							.fontWeight(.light)
					}
					.lineLimit(1)
					.minimumScaleFactor(0.5)
					.foregroundColor(.white)
					.padding()
					
					Spacer()
					
					Group {
						Button {
							withAnimation {
								liked.toggle()
							}
						} label: {
							Image(systemName: liked ? "heart.fill" : "heart")
								.foregroundColor(liked ? .red : .white)
								.transition(.scale)
						}
						Button {
							saving = true
							Task {
								do {
									try await wallpapers.saveToLibrary(imageString: wallpaper.urls.raw)
								} catch {
									print(error.localizedDescription)
									wallpapers.popUpText = "\(error.localizedDescription)"
								}
								withAnimation {
									wallpapers.popUpActive = true
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
					.foregroundColor(.white)
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
		.foregroundColor(.black)
	}
}
