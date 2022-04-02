//  WallpapersApp.swift
//  Wallpapers
//
//  Created by Alessia on 23/3/2022.
//

import SwiftUI

@main
struct WallpapersApp: App {
	@StateObject private var persistence = Persistence()
	var body: some Scene {
		WindowGroup {
			HomeView(persistence: persistence)
				.environment(\.managedObjectContext, persistence.container.viewContext)
		}
	}
}
