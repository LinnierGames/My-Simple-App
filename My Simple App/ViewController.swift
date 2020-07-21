//
//  ViewController.swift
//  My Simple App
//
//  Created by Erick Sanchez on 7/20/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import UIKit
import CoreLocation

class Address {
  var rawValue: String?
  var coordinates: CLLocationCoordinate2D?
  var weather: Weather?
}

struct WeatherIcon {
  let name: String
  let image: UIImage
}

struct Weather {
  let temperature: CGFloat
  let icon: WeatherIcon
}

struct WeatherData: Decodable {
  let temperature: Float
  let rawIcon: String

  enum CodingKeys: String, CodingKey {
    case temperature
    case rawIcon = "raw-icon"
  }
}

class ViewController: UIViewController {
  @IBOutlet weak var table: UITableView!

  var validAddresses = [Address]()
  var invalidAddresses = [Address]()

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

  override func viewDidLoad() {
    super.viewDidLoad()

    self.load()
    self.table.reloadData()
  }

  func save() {
    let userDefaults = UserDefaults.standard

    let addressObjects = validAddresses.map { address in
      return [
        "address": address.rawValue!,
        "latitude": address.coordinates!.latitude,
        "longitude": address.coordinates!.longitude,
        "temperature" : Double(address.weather!.temperature),
        "raw-icon": address.weather!.icon.name
      ]
    }
    userDefaults.setValue(addressObjects, forKeyPath: "user-addresses")
    let invalidAddressObjects = invalidAddresses.map { address in
      return [
        "address": address.rawValue!,
      ]
    }
    userDefaults.setValue(invalidAddressObjects, forKeyPath: "invalid-addresses")
  }

  func load() {
    let userDefaults = UserDefaults.standard
    if let validAddressObjects = userDefaults.array(forKey: "user-addresses") as? [[String: Any]] {
      validAddresses = validAddressObjects.compactMap { object in
        guard
          let value = object["address"] as? String,
          let latitude = object["latitude"] as? Double,
          let longitude = object["longitude"] as? Double,
          let temerature = object["temperature"] as? Double,
          let rawIcon = object["raw-icon"] as? String
        else {
          return nil
        }

        let address = Address()
        address.rawValue = value
        address.coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        address.weather = Weather(
          temperature: CGFloat(temerature),
          icon: WeatherIcon(name: rawIcon, image: UIImage(named: rawIcon)!)
        )

        return address
      }
    }

    if let invalidAddressObjects = userDefaults.array(forKey: "invalid-addresses") as? [[String: Any]] {
      invalidAddresses = invalidAddressObjects.compactMap { object in
        guard let value = object["address"] as? String else {
          return nil
        }

        let address = Address()
        address.rawValue = value

        return address
      }
    }
  }

  func addNewAddress(userInput: String) {
    let geoCoder = CLGeocoder()
    geoCoder.geocodeAddressString(userInput) { (placemarkers, error) in
      let insertAddressInUnknown = {
        let newAddress = Address()
        newAddress.rawValue = userInput
        self.invalidAddresses.insert(newAddress, at: 0)
        self.table.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        self.save()
      }

      if let error = error {
        insertAddressInUnknown()
      } else {
        guard let location = placemarkers?.first?.location else { return insertAddressInUnknown() }
        self.fetchWeather(location: location.coordinate) { weather in
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
  }

  func fetchWeather(location: CLLocationCoordinate2D, completion: @escaping (Weather) -> Void) {
    var queryItems =
      URLComponents(url: URL(string: "www.weather.com/")!, resolvingAgainstBaseURL: false)!
    queryItems.queryItems = [
      URLQueryItem(name: "long", value: String(location.longitude)),
      URLQueryItem(name: "lat", value: String(location.latitude)),
    ]
    let url = queryItems.url!
    let urlSession = injectURLSession()
    urlSession.dataTask(with: URLRequest(url: url)) { (data, _, error) in
      if let error = error {
        print("something went wrong", error)
        return
      }

      guard let data = data else { return }
      let weatherData = try! JSONDecoder().decode(WeatherData.self, from: data)
      completion(
        Weather(
          temperature: CGFloat(weatherData.temperature),
          icon: WeatherIcon(name: weatherData.rawIcon, image: UIImage(named: weatherData.rawIcon)!)
        )
      )
    }.resume()
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
        withIdentifier: "weather cell", for: indexPath
      ) as! WeatherTableViewCell

      let address = validAddresses[indexPath.row]
      cell.titleLabel.text = address.rawValue
      cell.weatherLabel.text = "Temperature: \(address.weather?.temperature ?? 0)"
      cell.iconImageView.image = address.weather?.icon.image

      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "unknown cell", for: indexPath
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

