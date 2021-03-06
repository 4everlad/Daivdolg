//
//  Currencies.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 16/05/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import Foundation

struct Currency: Decodable {
  var code: String
  var name: String
  var symbol: String?
}

struct ConvertedCurrency: Decodable {
  var time: String
  var amount: Float
}

struct Currencies: Decodable {
    var currencies: [Currency]
}

class CurrenciesModel {
  
  // MARK: - properties
  var requestFetcher = APIRequestFetcher.shared
  
  private var currencies: [Currency] = []
  private var filteredCurrencies: [Currency] = []
  
  // MARK: - Init
  init() {
    self.getCurrencies()
  }
  
  // MARK: - External methods
  func filterCurrencies(searchText: String) {
    filteredCurrencies = currencies.filter { (currency: Currency) -> Bool in
      return (currency.code.lowercased().contains(searchText.lowercased()) ||
        currency.name.lowercased().contains(searchText.lowercased()))
    }
  }
  
  func getFilteredCurriencesNumber() -> Int {
    return filteredCurrencies.count
  }
  
  func getCurrenciesNumber() -> Int {
    return currencies.count
  }
  
  func getFilteredCurrencyCode(at indexPath: Int) -> String {
    return filteredCurrencies[indexPath].code
  }
  
  func getCurrencyCode(at indexPath: Int) -> String {
    return currencies[indexPath].code
  }
  
  func getFilteredCurrencyName(at indexPath: Int) -> String {
    return filteredCurrencies[indexPath].name
  }
  
  func getCurrencyName(at indexPath: Int) -> String {
    return currencies[indexPath].name
  }
  
  // MARK: - Private methods
  private func getCurrencies() {
    requestFetcher.fetchCurrenciesList(completionHandler: { result in
      switch result {
      case .success(let currencies):
        self.currencies = currencies.currencies
      case .failure(let error):
        print(error.localizedDescription)
        DispatchQueue.main.async {
          self.getOfflineCurrencies()
        }
      }
    })
  }
  
  private func getOfflineCurrencies() {
    guard
      let url = Bundle.main.url(forResource: "currencies", withExtension: "json"),
      let data = try? Data(contentsOf: url)
      else {
        return
    }
    do {
      let decoder = JSONDecoder()
      let currencies = try decoder.decode([String: String].self, from: data)
        self.currencies = currencies.map({ Currency(code: $0.key, name: $0.value) })
    } catch {
      return
    }
  }

}
