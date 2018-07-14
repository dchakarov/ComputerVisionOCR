//
//  ComputerVisionOCR.swift
//  ComputerVisionOCR
//
//  Created by Dimitar Chakarov on 14/07/2018.
//

import Foundation

open class ComputerVisionOCR {
	open static let shared = ComputerVisionOCR()

	private var apiKey: String?
	private var baseUrl: String?
	
	private init() {}
	
	open func configure(apiKey: String, baseUrl: String) {
		self.apiKey = apiKey
		self.baseUrl = baseUrl
	}
	
	open func requestOCRData(_ imageData: Data, language: String = "unk", detectOrientation: Bool = true, completion: @escaping (_ response: Data? ) -> Void) {
		guard let apiKey = apiKey, let baseUrl = baseUrl else {
			fatalError("Please run configure first!")
		}
		let requestUrl = URL(string: "\(baseUrl)/ocr?language=\(language)&detectOrientation=\(detectOrientation)")
		var request = URLRequest(url: requestUrl!)
		request.setValue(apiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
		request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
		request.httpBody = imageData
		request.httpMethod = "POST"
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard error == nil else {
				completion(nil)
				return
			}
			completion(data)
		}
		
		task.resume()
	}
	
	open func requestOCRString(_ imageData: Data, language: String = "unk", detectOrientation: Bool = true, completion: @escaping (_ response: [String]? ) -> Void) {
		
		func parseResponse(responseData: Data) throws -> [String] {
			let decoder = JSONDecoder()
			let response = try decoder.decode(OCRResponse.self, from: responseData)
			let result = response.regions.reduce([], { (result, regions) in
				return result + regions.lines.reduce([], { (result, lines) in
					return result + lines.words.reduce([], { (result, words) in
						return result + [words.text]
					})
				})
			})
			return result
		}
		
		struct OCRResponse: Codable {
			struct Regions: Codable {
				struct Lines: Codable {
					struct Words: Codable {
						let boundingBox: String
						let text: String
					}
					let boundingBox: String
					let words: [Words]
				}
				let boundingBox: String
				let lines: [Lines]
			}
			let regions: [Regions]
		}
		
		requestOCRData(imageData) { data in
			guard let data = data else {
				completion(nil)
				return
			}
			do {
				let result = try parseResponse(responseData: data)
				completion(result)
			} catch {
				completion(nil)
			}
		}
	}
}
