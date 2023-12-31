//
//  ApiService.swift
//  StepStreak-iOS
//
//  Created by Mohamad Alhaj Rahmoun on 09/07/2023.
//

import Foundation
import KeychainSwift

class APIService {
    func sendData(healthData: HealthData, completion: @escaping (Error?) -> Void) {
        let keychain = KeychainSwift()

        // URL of your API
        let url = URL(string: "\(Endpoint.apiURL)/activities")!

        // Create a URLRequest
        var request = URLRequest(url: url)

        // Set the method to POST
        request.httpMethod = "POST"

        // Set the Content-Type header to application/json
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(keychain.get("token")!)", forHTTPHeaderField: "Authorization")

        do {
            // Convert the healthData to JSON and set it as the HTTP body
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(healthData)
        } catch {
            // If encoding fails, call the completion handler with the error and return
            completion(error)
            return
        }

        // Create a URLSessionDataTask to send the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(error)
                    return
                }

                // Check for HTTP response status codes
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...299:
                        completion(nil)
                    case 401:
                        completion(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey : "Token expired. Please refresh the page."]))
                    default:
                        completion(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey : "Received HTTP \(httpResponse.statusCode)"]))
                    }
                } else {
                    completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "No valid HTTP response received."]))
                }
            }
        }

        task.resume()
    }
    
    func sendDeviceTokenToServer() {
        let url = URL(string: "\(Endpoint.apiURL)users")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let keychain = KeychainSwift()
        let token = keychain.get("apn-token")
        let body: [String: Any?] = ["notification_token": token, "device_type": "ios"]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue("Bearer \(keychain.get("token")!)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error sending token: \(error?.localizedDescription ?? "No error description")")
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            keychain.set(token!, forKey: "server-apn-token")
            print("Response from server: \(responseString ?? "No response")")
        }
        task.resume()
    }

}
