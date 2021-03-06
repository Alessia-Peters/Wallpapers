//  HTTPClient.swift
//  Wallpapers
//
//  Created by Alessia on 23/3/2022.
//

import SwiftUI

enum HTTPMethods: String {
	case POST, GET, PUT, DELETE
}

enum HTTPHeaders {
	static let authentication = ("Authorization","Client-ID \(Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? "")")
	static let apiVersion = ("Accept-Version","v1")
}

enum HTTPError: Error {
	case badUrl, badResponse, errorDecodingData, invalidData, noResults
}

class HTTPClient {
	private init() { }
	
	/// Access functions on this property
	static let shared = HTTPClient()
	
	/// Fetches and decodes json into any given codeable format
	/// - Parameter url: Full url for api request
	/// - Returns: Returns object when method is assigned to explicit variable
	func fetch<T: Codable>(url: URL) async throws -> T {
		
		var request = URLRequest(url: url)
		
		request.httpMethod = HTTPMethods.GET.rawValue
		request.addValue(HTTPHeaders.authentication.1, forHTTPHeaderField: HTTPHeaders.authentication.0)
		request.addValue(HTTPHeaders.apiVersion.1, forHTTPHeaderField: HTTPHeaders.apiVersion.0)
		
		let (data, response) = try await URLSession.shared.data(for: request)
		
		guard (response as? HTTPURLResponse)?.statusCode == 200 else {
			throw HTTPError.badResponse
		}
		
		let decoder = JSONDecoder()
		
		guard let object = try? decoder.decode(T.self, from: data) else {
			throw HTTPError.errorDecodingData
		}
		
		return object
	}
	
	/// Fetches and returns UIImage to save to photo library
	/// - Parameter imageString: String of the image address
	/// - Returns: UIImage to download
	func fetchImage(imageString: String) async throws -> UIImage{
		guard let imageUrl = URL(string: imageString) else {
			throw HTTPError.badUrl
		}
		
		let (data, response) = try await URLSession.shared.data(for: URLRequest(url: imageUrl))
		
		guard (response as? HTTPURLResponse)?.statusCode == 200 else {
			throw HTTPError.badResponse
		}
		
		guard let image = UIImage(data: data) else {
			throw HTTPError.errorDecodingData
		}
		
		return image
	}
	
	/// Runs on app launch, checks to see if server can be reached
	func checkConnection() async throws {
		let url = URL(string: Constants.baseUrl)
		
		let request = URLRequest(url: url!)
		
		do {
			let _ = try await URLSession.shared.data(for: request)
		} catch {
			throw HTTPError.badResponse
		}
	}
}
