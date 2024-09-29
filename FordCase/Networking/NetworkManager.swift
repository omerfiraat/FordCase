//
//  NetworkManager.swift
//  FordCase
//
//  Created by Mac on 29.09.2024.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidResponse
    case noData
    case failedRequest
    case rateLimitExceeded(resetTime: TimeInterval)  // Rate limit hatası
    case invalidData
    case unauthorized  // 401 hatası için
    case forbidden  // 403 hatası için
}


class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    private let baseURL = "https://api.github.com"
    
    func request<T: Decodable>(endpoint: APIEndpoint, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let url = "\(baseURL)\(endpoint.path)"
        
        print("Requesting URL: \(url) with method: \(endpoint.method.rawValue)")
        
        AF.request(url, method: endpoint.method, parameters: endpoint.parameters).validate().responseDecodable(of: T.self) { response in
            
            // Response Status Code'u logla
            print("Response Status Code: \(response.response?.statusCode ?? 0)")
            
            // Rate limit başlıklarını kontrol et
            if let headers = response.response?.allHeaderFields,
               let remaining = headers["X-RateLimit-Remaining"] as? String,
               let resetTime = headers["X-RateLimit-Reset"] as? String,
               remaining == "0" {
                let resetTimestamp = TimeInterval(resetTime) ?? 0
                let resetDate = Date(timeIntervalSince1970: resetTimestamp)
                let timeRemaining = resetDate.timeIntervalSinceNow
                print("Rate limit aşıldı. Yeniden deneme için \(timeRemaining) saniye bekleyin.")
                completion(.failure(.rateLimitExceeded(resetTime: timeRemaining)))
                return
            }
            
            switch response.result {
            case .success(let data):
                // JSON verilerini logla
                print("Response Data: \(data)")
                completion(.success(data))
                
            case .failure(let error):
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 401:
                        completion(.failure(.unauthorized))
                    case 403:
                        completion(.failure(.forbidden))
                    default:
                        print("Error fetching data: \(error)")
                        completion(.failure(.failedRequest))
                    }
                } else {
                    completion(.failure(.failedRequest))
                }
            }
        }
    }
}
