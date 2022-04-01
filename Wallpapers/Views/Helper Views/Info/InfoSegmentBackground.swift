//
//  InfoSegmentBackground.swift
//  Wallpapers
//
//  Created by Alessia on 30/3/2022.
//

import SwiftUI

struct InfoSegmentBackground: View {
	var imageName: String
	var itemName: String
	var text: String
	
	var body: some View {
		HStack {
			Image(systemName: imageName)
				.frame(width: 25, height: 25)
				.font(.system(size: 25))
				.padding(.trailing)
				
			Text(text)
				.lineLimit(2)
				
			Spacer()
		}
		.foregroundColor(.primary)
		.padding(.vertical,4)
	}
}

struct InfoSegmentBackground_Previews: PreviewProvider {
	static var previews: some View {
		InfoSegmentBackground(imageName: "person", itemName: "debug", text: "Hello World")
	}
}
