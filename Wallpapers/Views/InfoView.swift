//
//InfoView.swift
//  Wallpapers
//
//  Created by Alessia on 30/3/2022.
//

import SwiftUI

struct InfoView: View {
	@ObservedObject var detailViewModel: DetailViewModel
	
	var body: some View {
		VStack {
			VStack(alignment: .leading) {
				Divider()
					.padding(.horizontal, 20)
				ScrollView {
					VStack {
						InfoSegmentBackground(imageName: "person", itemName: "Name", text: detailViewModel.selectedWallpaper!.user.name)
						Divider()
						InfoSegmentBackground(imageName: "at", itemName: "Username", text: detailViewModel.selectedWallpaper!.user.username)
						if detailViewModel.selectedWallpaper!.user.bio != nil {
							Divider()
							Button {
								withAnimation {
									detailViewModel.showDetails(type: .bio)
								}
							} label: {
								InfoSegmentBackground(imageName: "info.circle", itemName: "Bio", text: detailViewModel.selectedWallpaper!.user.bio!)
							}
						}
					}
					.padding(.horizontal, 25)
					.padding(.vertical, 13)
					.background(
						.thinMaterial,
						in: RoundedRectangle(cornerRadius: 15)
					)
					.padding(20)
					Divider()
						.padding(.horizontal, 20)
					HStack {
						VStack {
							InfoSegmentBackground(imageName: "cloud", itemName: "Upload Date", text: detailViewModel.selectedWallpaper!.formatDate())
							Divider()
							if detailViewModel.selectedWallpaper!.description != nil || detailViewModel.selectedWallpaper!.altDescription != nil {
								Button {
									withAnimation {
										detailViewModel.showDetails(type: .description)
									}
								} label: {
									InfoSegmentBackground(imageName: "book.closed", itemName: "Description", text: (detailViewModel.selectedWallpaper!.description ?? detailViewModel.selectedWallpaper!.altDescription)!.capitalized)
									Spacer()
								}
								Divider()
							}
							
							InfoSegmentBackground(imageName: "arrow.up.left.and.arrow.down.right", itemName: "Size", text:  detailViewModel.selectedWallpaper!.height.description + "x" + detailViewModel.selectedWallpaper!.width.description)
						}
					}
					.padding(.horizontal, 25)
					.padding(.vertical, 13)
					.background(
						.thinMaterial,
						in: RoundedRectangle(cornerRadius: 15)
					)
					.padding(20)
					
					if (detailViewModel.selectedWallpaper!.user.social!.instagram != nil) || (detailViewModel.selectedWallpaper!.user.social!.twitter != nil) {
						Divider()
							.padding(.horizontal, 20)
							.padding(.bottom, 10)
					}
					
					if detailViewModel.selectedWallpaper!.user.social!.twitter != nil {
						Link(destination: URL(string: "https://twitter.com/\(detailViewModel.selectedWallpaper!.user.social!.twitter!)")!) {
							LinkBackground(text: "Twitter", backgroundColor: 0x1EA1F1, imageName: "Twitter")
						}
					}
					if detailViewModel.selectedWallpaper?.user.social!.instagram != nil {
						Link(destination: URL(string: "https://instagram.com/\(detailViewModel.selectedWallpaper!.user.social!.instagram!)")!) {
							LinkBackground(text: "Instagram", backgroundColor: 0xF57130, imageName: "Instagram")
						}
					}
				}
				.font(.system(size: 22, weight: .medium))
			}
		}
	}
}

struct InfoView_Previews: PreviewProvider {
	static var previews: some View {
		InfoView(detailViewModel: DetailViewModel())
	}
}
