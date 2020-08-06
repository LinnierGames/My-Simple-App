//
//  ViewModel.swift
//  My Simple App
//
//  Created by Erick Sanchez on 8/5/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import CoreLocation // TODO: Remove this dependency after refactoring Networking.

enum AddressResult {
  case validAddress(Address)
  case invalidAddress(Address)
  case error(Error)
}

class WeatherViewModel {
  private(set) var validAddresses = [Address]()
  private(set) var invalidAddresses = [Address]()

  private let locationService: LocationService

  init(locationService: LocationService = injectLocationService()) {
    self.locationService = locationService
    self.load()
  }

  func addAddress(userInput: String, completion: @escaping (AddressResult) -> Void) {
    locationService.info(from: userInput) { result in
      switch result {
      case .success(let info):
        let coordinates = CLLocationCoordinate2D(latitude: info.latitude, longitude: info.longitude)
        Networking.fetchWeather(location: coordinates) { weather in
          let newAddress = Address()
          newAddress.rawValue = info.displayName
          newAddress.coordinates = coordinates
          newAddress.weather = weather
          self.validAddresses.insert(newAddress, at: 0)
          completion(.validAddress(newAddress))
          self.save()
        }
      case .failure:
        let newAddress = Address()
        newAddress.rawValue = userInput
        self.invalidAddresses.insert(newAddress, at: 0)
        completion(.invalidAddress(newAddress))
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
