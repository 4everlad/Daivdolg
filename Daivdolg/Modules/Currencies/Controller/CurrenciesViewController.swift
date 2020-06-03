//
//  CurrenciesViewController.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 15/05/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import UIKit

protocol CurrenciesViewControllerDelegate: class {
  func setCurrency(code: String)
}

class CurrenciesViewController: UIViewController {
  
  // MARK: - Properties
  private var currenciesList: Currencies
  weak var delegate: CurrenciesViewControllerDelegate?
  
  @IBOutlet private weak var tableView: UITableView!
  private let searchController = UISearchController(searchResultsController: nil)
  
  private var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  private var isFiltering: Bool {
    return searchController.isActive && !isSearchBarEmpty
  }
  
  // MARK: - Init
  init(currencies: Currencies) {
    self.currenciesList = currencies
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = Constants.Texts.Currencies.title
    configureTableView()
    configureSearchController()
    configureCloseButton()
  }
  
  // MARK: - Configure
  private func configureTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UINib(nibName: "CurrencyCell", bundle: nil), forCellReuseIdentifier: "CurrencyCell")
  }
  
  private func configureSearchController() {
    searchController.isActive = true
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = Constants.Texts.Currencies.searchBarTitle
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    definesPresentationContext = true
  }
  
  private func configureCloseButton() {
    let leftButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped(_:)))
    navigationItem.leftBarButtonItem = leftButton
  }
  
  // MARK: - Actions
  @objc func closeTapped(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - UITableView
extension CurrenciesViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { if isFiltering {
    return currenciesList.getFilteredCurriencesNumber()
    }
    return currenciesList.getCurrenciesNumber()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as? CurrencyCell
    guard let tableViewCell = cell else { return UITableViewCell() }
    if isFiltering {
      tableViewCell.code = currenciesList.getFilteredCurrencyCode(at: indexPath.row)
      tableViewCell.name = currenciesList.getFilteredCurrencyName(at: indexPath.row)
    } else {
      tableViewCell.code = currenciesList.getCurrencyCode(at: indexPath.row)
      tableViewCell.name = currenciesList.getCurrencyName(at: indexPath.row)
    }
    return tableViewCell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // guard let
    if isFiltering {
      let currencyCode = currenciesList.getFilteredCurrencyCode(at: indexPath.row)
      delegate?.setCurrency(code: currencyCode)
      dismiss(animated: true, completion: nil)
    } else {
      let currencyCode = currenciesList.getCurrencyCode(at: indexPath.row)
      delegate?.setCurrency(code: currencyCode)
      dismiss(animated: true, completion: nil)
    }
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - UISearchController
extension CurrenciesViewController: UISearchResultsUpdating {
  
  private func filterContentForSearchText(_ searchText: String) {
    currenciesList.filterCurrencies(searchText: searchText)
    tableView.reloadData()
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}
