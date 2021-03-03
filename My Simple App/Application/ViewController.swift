//
//  ViewController.swift
//  My Simple App
//
//  Created by Erick Sanchez on 7/20/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol HandleAddAddress: class {
    func addNewItem(placemark: MKPlacemark)
}

class ViewController: UIViewController {
  @IBOutlet weak var table: UITableView!
  var resultSearchController: UISearchController!
    
  var validAddresses = [Address]()
  var invalidAddresses = [Address]()

  @IBAction func pressAddAddress(_ sender: Any) {
    addAddess()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSearchController()
    loadAddresses()
    table.reloadData()
  }

  private func setupSearchController() {
    let locationSearchTable = LocationSearchTable()
    locationSearchTable.handleAddAddressDelegate = self
    resultSearchController = UISearchController(searchResultsController: locationSearchTable)
    resultSearchController.searchResultsUpdater = locationSearchTable
    let searchBar = resultSearchController!.searchBar
    searchBar.sizeToFit()
    searchBar.placeholder = "Search for places"
    searchBar.autocapitalizationType = .words
    searchBar.delegate = self
    navigationItem.titleView = resultSearchController?.searchBar
    resultSearchController.hidesNavigationBarDuringPresentation = false
    definesPresentationContext = true
  }
    
  private func save() {
    DataStore.save(validAddresses: validAddresses, invalidAddresses: invalidAddresses)
  }

  private func loadAddresses() {
    let userData = DataStore.load()
    validAddresses = userData.validAddresses
    invalidAddresses = userData.invalidAddresses
  }

  private func addNewAddress(userInput: String) {
    Location.coordinates(from: userInput) { location in
      guard let location = location else {
        let newAddress = Address()
        newAddress.rawValue = userInput
        self.invalidAddresses.insert(newAddress, at: 0)
        self.table.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        self.save()
        return
      }
      Networking.fetchWeather(location: location.coordinate) { weather in
        let newAddress = Address()
        newAddress.rawValue = userInput
        newAddress.coordinates = location.coordinate
        newAddress.weather = weather
        self.validAddresses.insert(newAddress, at: 0)
        self.table.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        self.save()
      }
    }
  }
    
  private func addAddess() {
    if let input = resultSearchController.searchBar.text, !input.isEmpty {
      self.addNewAddress(userInput: input)
      self.resultSearchController.searchBar.endEditing(true)
      self.resultSearchController.searchBar.text = ""
    }
  }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Valid Addresses"
    case 1:
      return "Invalid Addresses"
    default:
      return nil
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return validAddresses.count
    case 1:
      return invalidAddresses.count
    default:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      guard
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "weather cell", for: indexPath
        ) as? WeatherTableViewCell
      else {
        fatalError()
      }
      let address = validAddresses[indexPath.row]
      cell.titleLabel.text = address.rawValue
      cell.weatherLabel.text = "Temperature: \(address.weather?.temperature ?? 0)"
      cell.iconImageView.image = address.weather?.icon.image
      return cell
    case 1:
      guard
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "unknown cell", for: indexPath
        ) as? UnknownTableViewCell
      else {
        fatalError()
      }
      let address = invalidAddresses[indexPath.row]
      cell.titleLabel.text = address.rawValue
      return cell
    default:
      return UITableViewCell()
    }
  }

  func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    switch editingStyle {
    case .delete:
      switch indexPath.section {
      case 0:
        validAddresses.remove(at: indexPath.row)
      case 1:
        invalidAddresses.remove(at: indexPath.row)
      default:
        break
      }
      table.deleteRows(at: [indexPath], with: .automatic)
      save()
    default: break
    }
  }
}

extension ViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    addAddess()
  }
}

extension ViewController: HandleAddAddress {
  func addNewItem(placemark: MKPlacemark) {
    let address = Address()
    if let _ = placemark.subThoroughfare,
       let _ = placemark.thoroughfare,
       let title = placemark.title { //if we have a street number and name
      address.rawValue = title
    } else if let areaName = placemark.name,
              let cityName = placemark.locality,
              let stateName = placemark.administrativeArea,
              let country = placemark.country {
      address.rawValue = areaName == cityName ? "\(cityName), \(stateName), \(country)" : "\(areaName), \(cityName), \(stateName), \(country)"
    }
    address.coordinates = placemark.coordinate
    Networking.fetchWeather(location: placemark.coordinate) { weather in
      address.weather = weather
      self.validAddresses.insert(address, at: 0)
      self.table.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
      self.save()
      DispatchQueue.main.async {
        self.resultSearchController.searchBar.text = ""
      }
    }
  }
}
