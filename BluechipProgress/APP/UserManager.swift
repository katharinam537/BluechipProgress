//
//  UserManager.swift
//  BluechipProgress
//
//  Created by Danylo Klymenko on 16.09.2024.
//

import Foundation

class UserManager {
    static let shared = UserManager()

    private init() {}

    func sendUserData(playerUUID: String, deviceId: String?, isProduction: Bool) {
        let urlString = "https://app.bchc.app"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let parameters: [String: Any] = [
            "playerUUID": playerUUID,
            "deviceId": deviceId ?? "",
            "system": "ios"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = jsonData
            print("!!!!!!!!!Request Body: \(String(data: jsonData, encoding: .utf8) ?? "")")
        } catch {
            print("!!!!!!!!!Error serializing JSON: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("!!!!!!!!!Error sending user data: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("!!!!!!!!!Invalid response")
                return
            }
            
            print("!!!!!!!!!HTTP Response Status Code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 200 {
                print("!!!!!!!!!User data sent successfully")
            } else {
                print("!!!!!!!!!Error sending user data: \(httpResponse.statusCode)")
            }
        }
        task.resume()
    }

}
