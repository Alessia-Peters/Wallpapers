//  CircleButtonView.swift
//  Wallpapers
//
//  Created by Alessia on 27/3/2022.
//

import SwiftUI

struct CircleButtonView: View {
	var symbol: String
    var body: some View {
		Image(systemName: symbol)
			.font(.system(size: 20, weight: .semibold))
			.frame(width: 25, height: 25)
			.padding(8)
			.background(
				.thinMaterial,
				in: Circle()
			)
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
		CircleButtonView(symbol: "arrow.left")
    }
}
