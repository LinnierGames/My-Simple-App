//
//  ViewModel.swift
//  My Simple App
//
//  Created by Erick Sanchez on 8/5/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

enum AddressResult {
  case validAddress(Address)
  case invalidAddress(Address)
  case error(Error)
}

class WeatherViewModel {
  private(set) var validAddresses = [Address]()
  private(set) var invalidAddresses = [Address]()

  init() {
    self.load()
  }

  func addAddress(userInput: String, completion: @escaping (AddressResult) -> Void) {
    Location.coordinates(from: userInput) { location in
      guard let location = location else {
        let newAddress = Address()
        newAddress.rawValue = userInput
        self.invalidAddresses.insert(newAddress, at: 0)
        completion(.invalidAddress(newAddress))
        self.save()
        return
      }

      Networking.fetchWeather(location: location.coordinate) { weather in
        let newAddress = Address()
        newAddress.rawValue = userInput
        newAddress.coordinates = location.coordinate
        newAddress.weather = weather
        self.validAddresses.insert(newAddress, at: 0)
        completion(.validAddress(newAddress))
        self.save()
      }
    }
  }

  func removeValidAddress(at index: Int) {
    guard self.validAddresses.indices.contains(index) else {
      return assertionFailure("Given index out of range, \(index)")
    }

    self.validAddresses.remove(at: index)
    self.save()
  }

  func removeInvalidAddress(at index: Int) {
    guard invalidAddresses.indices.contains(index) else {
      return assertionFailure("Given index out of range, \(index)")
    }

    self.invalidAddresses.remove(at: index)
    self.save()
  }

  // MARK: - Private

  private func load() {
    let userData = DataStore.load()
    self.validAddresses = userData.validAddresses
    self.invalidAddresses = userData.invalidAddresses
  }

  private func save() {
    DataStore.save(validAddresses: self.validAddresses, invalidAddresses: self.invalidAddresses)
  }
}
