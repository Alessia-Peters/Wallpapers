//  ContentView.swift
//  Wallpapers
//
//  Created by Alessia on 23/3/2022.
//

import SwiftUI

struct ContentView: View {
	@StateObject var wallpapers = WallpaperViewModel()
	
	@State var selectedWallpaper: Wallpaper? = nil
	
	@State var zoomed = false
	
	let screen = UIScreen.main.bounds
	
	private let columns = [
		GridItem(.flexible()),
		GridItem(.flexible()),
		GridItem(.flexible())
	]
	
	var body: some View {
		ZStack {
			ScrollView {
				HStack {
					WallpaperListView(index: 0, wallpapers: wallpapers, selectedWallpaper: $selectedWallpaper, zoomed: $zoomed)
					WallpaperListView(index: 1, wallpapers: wallpapers, selectedWallpaper: $selectedWallpaper, zoomed: $zoomed)
				}
				.refreshable {
					Task {
						try await wallpapers.fetch()
					}
				}
			}
			if selectedWallpaper != nil {
				ZoomView(wallpapers: wallpapers, wallpaper: selectedWallpaper!, zoomed: $zoomed)
					.frame(width: screen.width, height: screen.height)
					.zIndex(5)
					.transition(.opacity)
			}
			if wallpapers.imageSaved {
				PopUpView(text: "Image Saved!")
					.onAppear {
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
							wallpapers.imageSaved = false
						}
					}
			}
		}
		.onAppear {
			Task {
				do {
					try await wallpapers.fetch()
				} catch {
					print(error)
				}
			}
		}
		.onChange(of: zoomed) { newValue in
			if newValue == false {
				withAnimation {
					selectedWallpaper = nil
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
