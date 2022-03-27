//  SearchMoreView.swift
//  Wallpapers
//
//  Created by Alessia on 28/3/2022.
//

import SwiftUI

struct SearchMoreView: View {
    var body: some View {
        Text("Search More")
			.padding(.vertical, 6)
			.padding(.horizontal)
			.background(
				.regularMaterial,
				in: RoundedRectangle(cornerRadius: 20, style: .continuous)
			)
    }
}

struct SearchMoreView_Previews: PreviewProvider {
    static var previews: some View {
        SearchMoreView()
    }
}
