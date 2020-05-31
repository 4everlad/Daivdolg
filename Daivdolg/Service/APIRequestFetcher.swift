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
  private let url = "http://openexchangerates.org/api/currencies.json"
  
  func fetchRequest(completionHandler: @escaping (Result<[Currency], NetworkError>) -> Void) {
    AF.request(url).validate().responseJSON { response in
      do {
        let decoder = JSONDecoder()
        guard let data = response.data else {
          completionHandler(.failure(.decodingError))
          return }
        let currenciesDictionary = try decoder.decode([String: String].self, from: data)
        let currencies = currenciesDictionary.map({ Currency(code: $0.key, name: $0.value) })
        completionHandler(.success(currencies))
      } catch {
        completionHandler(.failure(.badURL))
      }
    }
  }
}
