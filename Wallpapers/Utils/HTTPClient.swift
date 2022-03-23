//  HTTPClient.swift
//  Wallpapers
//
//  Created by Alessia on 23/3/2022.
//

import Foundation

enum HTTPMethods: String {
	case POST, GET, PUT, DELETE
}

enum MIMEType: String {
	case JSON = "application/json"
}

enum HTTPHeaders: String {
	case contentType = "Content-Type"
}

enum HTTPError: Error {
	case badUrl, badResponse, errorDecodingData, invalidData
}

class HTTPClient {
	private init() { }
	
	static let shared = HTTPClient()
	
	func fetch<T: Codable>(url: URL) async throws -> T {
		
		var request = URLRequest(url: url)
		
		request.httpMethod = HTTPMethods.GET.rawValue
		request.addValue(Constants.authentication, forHTTPHeaderField: "Authorization")
		
		let (data, response) = try await URLSession.shared.data(for: request)
		
		guard (response as? HTTPURLResponse)?.statusCode == 200 else {
			throw HTTPError.badResponse
		}
		
		guard let object = try? JSONDecoder().decode(T.self, from: data) else {
			throw HTTPError.errorDecodingData
		}
		
		return object
	}
}
