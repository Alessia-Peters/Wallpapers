//
//LinkBackground.swift
//  Wallpapers
//
//  Created by Alessia on 30/3/2022.
//

import SwiftUI

struct LinkBackground: View {
	var text: String
	var backgroundColor: UInt
	var imageName: String
	var body: some View {
		ZStack {
			Color(hex: backgroundColor)
			HStack {
				Image(imageName)
					.resizable()
					.scaledToFit()
					.padding(15)
				
				Text(text)
					.foregroundColor(.white)
					.fontWeight(.bold)
				Spacer()
			}
		}
		.cornerRadius(15)
		.padding(.horizontal, 20)
		.frame(height: 60)
		.padding(.top, 10)
	}
}

struct LinkBackground_Previews: PreviewProvider {
	static var previews: some View {
		LinkBackground(text: "Twitter", backgroundColor: 0x1EA1F1, imageName: "Twitter")
	}
}
