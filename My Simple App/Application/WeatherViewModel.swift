//
//  ViewModel.swift
//  My Simple App
//
//  Created by Erick Sanchez on 8/5/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

protocol WeatherViewModelDelegate: AnyObject {
  func weatherDidUpdate(_ viewModel: WeatherViewModel)
}

class WeatherViewModel {
  weak var delegate: WeatherViewModelDelegate?

  private(set) var validAddresses = [Address]()
  private(set) var invalidAddresses = [Address]()

  private let locationService: LocationService
  private let addressStore: AddressStore
  private let networkService: NetworkingService
  private let allAddressesResource: AllAddressesResource

  init(
    locationService: LocationService = injectLocationService(),
    dataStore: AddressStore = injectAddressStore(),
    networkService: NetworkingService = injectNetworkingService()
  ) {
    self.locationService = locationService
    self.addressStore = dataStore
    self.networkService = networkService
    self.allAddressesResource = self.addressStore.addresses()

    self.allAddressesResource.didChangeEvent.add(subscriber: self, handler: self.populuateAddresses)
    self.populuateAddresses()
  }

  func addAddress(userInput: String) {
    locationService.info(from: userInput) { result in
      switch result {
      case .success(let info):
        self.networkService.process(
        request: WeatherRequestByCooridnates(
          longitude: info.longitude, latitude: info.latitude)
        ) { result in
          switch result {
          case .success(let weather):
            let formatedName = info.displayName ?? userInput
            self.addressStore.storeAddress(
              name: formatedName,
              latitude: info.latitude,
              longitude: info.longitude,
              weather: weather
            )
          case .failure(let error):
            print("failed to fetch weather: \(error)")
          }
        }
      case .failure:
        self.addressStore.storeAddress(name: userInput)
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
