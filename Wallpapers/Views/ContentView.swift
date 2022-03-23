//  ContentView.swift
//  Wallpapers
//
//  Created by Alessia on 23/3/2022.
//

import SwiftUI

struct ContentView: View {
	@StateObject var wallpapers = WallpaperViewModel()
	
	private let columns = [
		GridItem(.flexible()),
		GridItem(.flexible()),
		GridItem(.flexible())
	]
	
	var body: some View {
		VStack {
			ScrollView {
				LazyVGrid(columns: columns) {
					ForEach(wallpapers.wallpapers) { wallpaper in
						AsyncImage(url: URL(string: wallpaper.urls.thumb)) { image in
							image
								.resizable()
								.scaledToFit()
						} placeholder: {
							Color
								.purple
								.opacity(0.1)
						}
						.cornerRadius(15)
						.padding(3)
//						.frame(width: 200, height: 300)
					}
				}
			}
			.refreshable {
				Task {
					try await wallpapers.fetch()
				}
			}
			.onAppear {
				Task {
					try await wallpapers.fetch()
				}
				
//				wallpapers.wallpapers = Bundle.main.decode([Wallpaper].self, from: "File.json")
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
