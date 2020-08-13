//
//  ViewController.swift
//  My Simple App
//
//  Created by Erick Sanchez on 7/20/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import UIKit

class WeatherViewController: UITableViewController {
  private let viewModel = WeatherViewModel()

  convenience init() {
    self.init(style: .grouped)
  }

  // MARK: - Override UITableViewController

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(
    _ tableView: UITableView,
    titleForHeaderInSection section: Int
  ) -> String? {
    switch section {
    case 0:
      return "Valid Addresses"
    case 1:
      return "Invalid Addresses"
    default:
      return nil
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return self.viewModel.validAddresses.count
    case 1:
      return self.viewModel.invalidAddresses.count
    default:
      return 0
    }
  }

  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
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

  override func tableView(
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
      self.tableView.deleteRows(at: [indexPath], with: .automatic)
    default: break
    }
  }

  // MARK: - Override UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()
    self.layoutView()
    self.setUpAndReloadTableView()
    self.title = "My App"
  }

  // MARK: - Private

  private func layoutView() {
    self.navigationItem.rightBarButtonItem =
      UIBarButtonItem(barButtonSystemItem: .add, target: self, action: .pressAdd)
  }

  private func setUpAndReloadTableView() {
    self.tableView.register(WeatherTableViewCell.self)
    self.tableView.register(UnknownTableViewCell.self)
    self.tableView.reloadData()
  }

  private func addNewAddress(userInput: String) {
    self.viewModel.addAddress(userInput: userInput) { result in
      switch result {
      case .validAddress:
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
      case .invalidAddress:
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
      case .error(let error):
        print("Something went wrong, \(error)")
      }
    }
  }

  @objc fileprivate func pressAdd(_ button: Any) {
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
}

extension Selector {
  fileprivate static let pressAdd = #selector(WeatherViewController.pressAdd(_:))
}
