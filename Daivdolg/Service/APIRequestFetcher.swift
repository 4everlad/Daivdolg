//
//  APIRequestFetcher.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 15/05/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case badURL
    case decodingError
}

class APIRequestFetcher {
  
  static let shared = APIRequestFetcher()
  private let url = "https://currency13.p.rapidapi.com/list"
  let parameters = ["rapidapi-key":"1e7714be28mshb5433aebbd095fap16bed0jsna54da8ce8d86"]
  
  func fetchCurrenciesList(completionHandler: @escaping (Result<Currencies, NetworkError>) -> Void) {
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { response in
          if let error = response.error {
            print("Error received requestiong data: \(error.localizedDescription)")
            completionHandler(.failure(.badURL))
            return
          }
          let decoder = JSONDecoder()
          do {
            guard let data = response.data else {
              completionHandler(.failure(.decodingError))
              return }
            let currencies = try decoder.decode(Currencies.self, from: data)
            completionHandler(.success(currencies))
          } catch {
            print()
            completionHandler(.failure(.badURL))
          }
    }
  }
  
  func fetchConvertedCurrency(amount: String, from: String, to: String, completionHandler: @escaping (Result<ConvertedCurrency, NetworkError>) -> Void) {
    
  }
}
