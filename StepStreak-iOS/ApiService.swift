//
//  ApiService.swift
//  StepStreak-iOS
//
//  Created by Mohamad Alhaj Rahmoun on 09/07/2023.
//

import Foundation

class APIService {
    func sendData(healthData: HealthData, completion: @escaping (Error?) -> Void) {
        // URL of your API
        let url = URL(string: "http://192.168.0.89:4000/api/activities")!

        // Create a URLRequest
        var request = URLRequest(url: url)

        // Set the method to POST
        request.httpMethod = "POST"

        // Set the Content-Type header to application/json
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            // Convert the healthData to JSON and set it as the HTTP body
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(healthData)
        } catch {
            // If encoding fails, call the completion handler with the error and return
            completion(error)
            return
        }

        // Create a URLSessionDataTask to send the request
        let task = URLSession.shared.dataTask(with: request) { (_, _, error) in
            // Call the completion handler on the main queue, because this closure is executed on a background queue
            DispatchQueue.main.async {
                completion(error)
            }
        }

        // Start the task
        task.resume()
    }
}
