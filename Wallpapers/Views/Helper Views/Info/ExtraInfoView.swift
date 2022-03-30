//
//ExtraInfoView.swift
//  Wallpapers
//
//  Created by Alessia on 30/3/2022.
//

import SwiftUI

struct ExtraInfoView: View {
	var title: String
	var text: String
    var body: some View {
		ZStack {
			VStack(alignment: .leading) {
				Text(title)
					.font(.system(size: 50, weight: .bold))
				Text(text.capitalized)
					.font(.system(size: 20))
				Spacer()
			}
			.frame(height: 300)
			.padding()
			.background(
				.regularMaterial,
				in: RoundedRectangle(cornerRadius: 20)
			)
			.padding()
		}
		.transition(.move(edge: .bottom))
    }
}

struct ExtraInfoView_Previews: PreviewProvider {
    static var previews: some View {
		ExtraInfoView(title: "", text: "")
    }
}
