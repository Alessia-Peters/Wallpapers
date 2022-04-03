//
//NoConnectionView.swift
//  Wallpapers
//
//  Created by Alessia on 29/3/2022.
//

import SwiftUI

struct NoConnectionView: View {
	@ObservedObject var wallpapers: WallpaperViewModel
	
	var body: some View {
			Button {
				Task {
					do {
						try await wallpapers.fetch()
					} catch {
						print(error)
					}
				}
			} label: {
				Text("Can't connect to server, tap to retry")
					.opacity(0.4)
					.foregroundColor(.primary)
			}
	}
}
