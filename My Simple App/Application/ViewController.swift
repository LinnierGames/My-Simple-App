//
//  ViewController.swift
//  My Simple App
//
//  Created by Erick Sanchez on 7/20/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreLocation

protocol CellIdentifiable {
  static var identifier: String { get }
}

class ViewController: UIViewController {
  var table: UITableView = {
    let table = UITableView()
    table.backgroundColor = .white
    // When you're writing programatic UI using anchors, this property has to
    //   be disabled on all views. At larger dev shops, there will likely be some sort
    //   of view framework and system views (eg UILabel, UIButton) will not be used
    //   directly. The wrapper views will disable this property for you in that case.
    table.translatesAutoresizingMaskIntoConstraints = false
    table.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
    table.register(UnknownTableViewCell.self, forCellReuseIdentifier: UnknownTableViewCell.identifier)
    return table
  }()

  var validAddresses = [Address]()
  var invalidAddresses = [Address]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    setupLayout()

    self.load()
    self.table.reloadData()
  }

  private func save() {
    DataStore.save(validAddresses: validAddresses, invalidAddresses: invalidAddresses)
  }

  private func load() {
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
  
  @objc func pressAddAddress(_ sender: Any) {
    let alertNewAddress = UIAlertController(
      title: "New Address", message: "enter a new address", preferredStyle: .alert)
    alertNewAddress.addTextField { textField in
      textField.textContentType = .addressCityAndState
      textField.placeholder = "e.g. Santa Rosa, CA"
    }
    let saveButton = UIAlertAction(title: "Save", style: .default) { _ in
      self.addNewAddress(userInput: alertNewAddress.textFields![0].text ?? "")
    }
    alertNewAddress.addAction(saveButton)
    alertNewAddress.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(alertNewAddress, animated: true)
  }
  
  private func setupViews() {
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pressAddAddress(_:)))
    table.delegate = self
    table.dataSource = self
    view.addSubview(table)
  }
  
  private func setupLayout() {
    NSLayoutConstraint.activate([
      table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
    ])
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
      let cell = tableView.dequeueReusableCell(
        withIdentifier: WeatherTableViewCell.identifier, for: indexPath
      ) as! WeatherTableViewCell

      let address = validAddresses[indexPath.row]
      cell.titleLabel.text = address.rawValue
      cell.weatherLabel.text = "Temperature: \(address.weather?.temperature ?? 0)"
      cell.iconImageView.image = address.weather?.icon.image

      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(
        withIdentifier: UnknownTableViewCell.identifier, for: indexPath
      ) as! UnknownTableViewCell

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

