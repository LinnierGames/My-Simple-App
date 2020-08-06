//
//  ViewController.swift
//  My Simple App
//
//  Created by Erick Sanchez on 7/20/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
  private let viewModel = WeatherViewModel()

  @IBOutlet weak var table: UITableView!

  @IBAction func pressAddAddress(_ sender: Any) {
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

  // MARK: - Override UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    self.table.register(WeatherTableViewCell.self)
    self.table.register(UnknownTableViewCell.self)
    self.table.reloadData()
  }

  // MARK: - Private

  private func addNewAddress(userInput: String) {
    self.viewModel.addAddress(userInput: userInput) { result in
      switch result {
      case .validAddress:
        self.table.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
      case .invalidAddress:
        self.table.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
      case .error(let error):
        print("Something went wrong, \(error)")
      }
    }
  }
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
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
      return self.viewModel.validAddresses.count
    case 1:
      return self.viewModel.invalidAddresses.count
    default:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell = tableView.dequeueReusableCell(for: indexPath) as WeatherTableViewCell
      let address = self.viewModel.validAddresses[indexPath.row]
      cell.configure(address)

      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(for: indexPath) as UnknownTableViewCell
      let address = self.viewModel.invalidAddresses[indexPath.row]
      cell.textLabel?.text = address.rawValue

      return cell
    default:
      assertionFailure("Unexpected indexPath, \(indexPath)")
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
        self.viewModel.removeValidAddress(at: indexPath.row)
      case 1:
        self.viewModel.removeInvalidAddress(at: indexPath.row)
      default:
        break
      }
      self.table.deleteRows(at: [indexPath], with: .automatic)
    default: break
    }
  }
}
