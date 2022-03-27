//  PopUpView.swift
//  Wallpapers
//
//  Created by Alessia on 27/3/2022.
//

import SwiftUI

struct PopUpView: View {
	let screen = UIScreen.main.bounds
	var text: String
    var body: some View {
        Text(text)
			.font(.system(size: 20, weight: .medium))
			.opacity(0.8)
			.frame(width: screen.width - 70, height: 60)
			.background(
				.ultraThinMaterial,
				in: RoundedRectangle(cornerRadius: 15)
			)
			
    }
}

struct PopUpView_Previews: PreviewProvider {
    static var previews: some View {
        PopUpView(text: "Image Saved!")
    }
}
