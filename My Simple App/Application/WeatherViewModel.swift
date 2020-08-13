//
//  ViewModel.swift
//  My Simple App
//
//  Created by Erick Sanchez on 8/5/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import CoreLocation // TODO: Remove this dependency after refactoring Networking.

protocol WeatherViewModelDelegate: AnyObject {
  func weatherDidUpdate(_ viewModel: WeatherViewModel)
}

class WeatherViewModel {
  weak var delegate: WeatherViewModelDelegate?

  private(set) var validAddresses = [Address]()
  private(set) var invalidAddresses = [Address]()

  private let locationService: LocationService
  private let addressStore: AddressStore
  private let allAddressesResource: AllAddressesResource

  init(
    locationService: LocationService = injectLocationService(),
    dataStore: AddressStore = injectAddressStore()
  ) {
    self.locationService = locationService
    self.addressStore = dataStore
    self.allAddressesResource = self.addressStore.addresses()

    self.allAddressesResource.didChangeEvent.add(self, handler: self.populuateAddresses)
    self.populuateAddresses()
  }

  func addAddress(userInput: String) {
    locationService.info(from: userInput) { result in
      switch result {
      case .success(let info):
        let coordinates = CLLocationCoordinate2D(latitude: info.latitude, longitude: info.longitude)
        Networking.fetchWeather(location: coordinates) { weather in
          var newAddress = Address()
          newAddress.rawValue = info.displayName
          newAddress.latitude = info.latitude
          newAddress.longitude = info.longitude
          newAddress.weather = weather
          self.addressStore.store(address: newAddress)
        }
      case .failure:
        var newAddress = Address()
        newAddress.rawValue = userInput
        self.addressStore.store(address: newAddress)
      }
    }
  }

  func removeValidAddress(at index: Int) {
    guard self.validAddresses.indices.contains(index) else {
      return assertionFailure("Given index out of range, \(index)")
    }

    let addressToRemove = self.validAddresses[index]
    self.addressStore.delete(address: addressToRemove)
  }

  func removeInvalidAddress(at index: Int) {
    guard invalidAddresses.indices.contains(index) else {
      return assertionFailure("Given index out of range, \(index)")
    }

    let addressToRemove = self.invalidAddresses[index]
    self.addressStore.delete(address: addressToRemove)
  }

  // MARK: - Private

  private func populuateAddresses() {
    var validAddresses = [Address]()
    var invalidAddresses = [Address]()
    for address in self.allAddressesResource.resource {
      if address.weather != nil {
        validAddresses.append(address)
      } else {
        invalidAddresses.append(address)
      }
    }

    self.validAddresses = validAddresses
    self.invalidAddresses = invalidAddresses
    self.delegate?.weatherDidUpdate(self)
  }
}
