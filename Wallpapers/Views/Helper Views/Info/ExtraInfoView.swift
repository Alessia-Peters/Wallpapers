//
//ExtraInfoView.swift
//  Wallpapers
//
//  Created by Alessia on 30/3/2022.
//

import SwiftUI


//TODO: Implement a method to find length of text and decide whether or not this view is needed
struct ExtraInfoView: View {
	@ObservedObject var viewModel: DetailViewModel
	var title: String
	var text: String
    var body: some View {
		ZStack {
			Color.clear
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
				.ultraThinMaterial,
				in: RoundedRectangle(cornerRadius: 20)
			)
			.padding()
		}
		.opacity(viewModel.sheetOpacity)
		.transition(.opacity)
    }
}

struct ExtraInfoView_Previews: PreviewProvider {
    static var previews: some View {
		ExtraInfoView(viewModel: DetailViewModel(), title: "", text: "")
    }
}
