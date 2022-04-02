//
//  Persistence.swift
//  Wallpapers
//
//  Created by Alessia on 1/4/2022.
//

import CoreData

class Persistence: ObservableObject {
	static let shared = Persistence()
	
	let container: NSPersistentContainer
	
	@Published var likedImages = [[LikedImage]]()
	
	private var unsortedLikedImages = [LikedImage]()
	
	func likeImage(image: Wallpaper) {
		let newLikedImage = LikedImage(context: container.viewContext)
		newLikedImage.id = image.id
		newLikedImage.thumbnail = URL(string: image.urls.thumb)
		newLikedImage.date = Date()
		newLikedImage.sizeRatio = Double(image.height) / Double(image.width)
		save()
		fetch()
	}
	
	func save() {
		do {
			try container.viewContext.save()
		} catch {
			print("Error Saving \(error)")
		}
	}
	
	func delete(imageID: String) {
		let fetchRequest = NSFetchRequest<LikedImage>(entityName: "LikedImage")
		fetchRequest.predicate = NSPredicate(format: "id = %@", imageID)
		
		do {
			let result = try container.viewContext.fetch(fetchRequest)

			for object in result {
				container.viewContext.delete(object)
			}
			
			fetch()
		} catch {
			print("Error Deleting: \(error)")
		}
		save()
	}
	
	func fetch() {
		let fetchRequest = NSFetchRequest<LikedImage>(entityName: "LikedImage")
		
		do {
			let imageArray = try container.viewContext.fetch(fetchRequest)
			likedImages = imageArray.splitLikedArray(input: imageArray)
			unsortedLikedImages = imageArray
		} catch {
			print("Error Fetching: \(error)")
		}
	}
	
	func checkIfLiked(id: String) -> Bool {
		fetch()
		
		var alreadyLiked = false
		unsortedLikedImages.forEach { image in
			if id == image.id {
				alreadyLiked = true
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

enum CoreDataError: Error {
	case fetchError
}
