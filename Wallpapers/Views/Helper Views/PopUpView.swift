//  PopUpView.swift
//  Wallpapers
//
//  Created by Alessia on 27/3/2022.
//

import SwiftUI

struct PopUpView: View {
	var text: String
    var body: some View {
		VStack {
        Text(text)
			.font(.system(size: 20, weight: .medium))
			.frame(minWidth: 100, maxWidth: 300)
			.frame(height: 60)
			.background(
				.ultraThinMaterial,
				in: RoundedRectangle(cornerRadius: 15)
			)
			.padding(.top)
			Spacer()
		}
    }
}

struct PopUpView_Previews: PreviewProvider {
    static var previews: some View {
        PopUpView(text: "Image Saved!")
    }
}
