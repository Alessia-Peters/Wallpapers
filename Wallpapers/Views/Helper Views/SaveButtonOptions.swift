//
//SaveButtonOptions.swift
//  Wallpapers
//
//  Created by Alessia on 30/3/2022.
//

import SwiftUI

struct SaveButtonOptions: View {
	@ObservedObject var viewModel: DetailViewModel
	var body: some View {
		Group {
			Button {
				viewModel.selectedSize = .raw
			} label: {
				HStack {
					if viewModel.selectedSize == .raw {
						Image(systemName: "checkmark")
					}
					Text("Raw")
				}
			}
			Button {
				viewModel.selectedSize = .full
			} label: {
				HStack {
					if viewModel.selectedSize == .full {
						Image(systemName: "checkmark")
					}
					Text("Full")
				}
			}
			Button {
				viewModel.selectedSize = .regular
			} label: {
				HStack {
					if viewModel.selectedSize == .regular {
						Image(systemName: "checkmark")
					}
					Text("Regular")
				}
			}
			Button {
				viewModel.selectedSize = .small
			} label: {
				HStack {
					if viewModel.selectedSize == .small {
						Image(systemName: "checkmark")
					}
					Text("Small")
				}
			}
		}
	}
}

//struct SaveButtonOptions_Previews: PreviewProvider {
//	static var previews: some View {
//		SaveButtonOptions()
//	}
//}
