//
//  Persistence.swift
//  Wallpapers
//
//  Created by Alessia on 1/4/2022.
//

import CoreData

class Persistence: ObservableObject {
	
	let container: NSPersistentContainer
	
	/// All images the user has liked
	@Published var likedImages = [[LikedImage]]()
	
	/// Saves a selected image as a LikedImage to CoreData
	/// - Parameter image: Image to be liked
	func likeImage(image: Wallpaper) {
		let newLikedImage = LikedImage(context: container.viewContext)
		newLikedImage.id = image.id
		newLikedImage.thumbnail = URL(string: image.urls.thumb)
		newLikedImage.date = Date()
		newLikedImage.sizeRatio = Double(image.height) / Double(image.width)
		save()
		fetch()
	}
	
	/// Writes changes to CoreData
	func save() {
		do {
			try container.viewContext.save()
		} catch {
			print("Error Saving \(error)")
		}
	}
	
	/// Removes a liked image
	/// - Parameter imageID: The ID String of the image to be removed from CoreData
	func delete(imageID: String) {
		let fetchRequest = NSFetchRequest<LikedImage>(entityName: "LikedImage")
		
		/// Fetches an image based on the given ID
		fetchRequest.predicate = NSPredicate(format: "id = %@", imageID)
		
		do {
			let result = try container.viewContext.fetch(fetchRequest)

			for object in result {
				/// Deletes image
				container.viewContext.delete(object)
			}
			
			fetch()
		} catch {
			print("Error Deleting: \(error)")
		}
		save()
	}
	
	/// Fetches all instances of LikedImage
	func fetch() {
		let fetchRequest = NSFetchRequest<LikedImage>(entityName: "LikedImage")
		
		/// Fetches images based on date like (newest to oldest)
		let sort = NSSortDescriptor(key: #keyPath(LikedImage.date), ascending: false)
		
		fetchRequest.sortDescriptors = [sort]
		
		do {
			let imageArray = try container.viewContext.fetch(fetchRequest)
			
			/// Splits and sets the image array
			likedImages = imageArray.splitLikedArray(inputArray: imageArray)
			
		} catch {
			print("Error Fetching: \(error)")
		}
	}
	
	/// Checks to see if the user has liked an image
	/// - Parameter id: The ID of the image being checked
	/// - Returns: A bool on whether or not an image has been like
	func checkIfLiked(id: String) -> Bool {
		fetch()
		
		var alreadyLiked = false
		likedImages.forEach { imageSet in
			imageSet.forEach { image in
				if id == image.id {
					alreadyLiked = true
				}
			}
		}
		
		return alreadyLiked
	}
	
	init() {
		likedImages = [[LikedImage](),[LikedImage](),[LikedImage]()]
		
		container = NSPersistentContainer(name: "Data Model")
		container.loadPersistentStores { description, error in
			if let error = error {
				print("Core Data failed to load: \(error.localizedDescription)")
			}
		}
	}
	
}
