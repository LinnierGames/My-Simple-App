//
//  AddressStoreImpl.swift
//  My Simple App
//
//  Created by Erick Sanchez on 8/12/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import Foundation

func injectAddressStore() -> AddressStore {
  AddressStoreImpl(
    internalUserDefaults: InternalUserDefaultsImpl(userDefaults: UserDefaults.standard)
  )
}

// TODO: load and save off the main thread.

class AddressStoreImpl: AddressStore {
  private static let userAddressesKey = "USER_ADDRESSES"

  fileprivate let storeDidChange = Event<Void>()

  fileprivate let internalUserDefaults: InternalUserDefaults

  init(internalUserDefaults: InternalUserDefaults) {
    self.internalUserDefaults = internalUserDefaults
  }

  func addresses() -> AllAddressesResource {
    return AnyReactableResource(base: AllAddressesReactableResource(store: self))
  }

  func storeAddress(name: String) {
    let addressObject = AddressObject(
      identifier: UUID(),
      name: name,
      longitude: nil,
      latitude: nil,
      temperature: nil,
      iconName: nil
    )
    let newAddresses = [addressObject] + self.loadData()
    self.saveData(addresses: newAddresses)
  }

  func storeAddress(name: String, latitude: Double, longitude: Double, weather: Weather) {
    let addressObject = AddressObject(
      identifier: UUID(),
      name: name,
      longitude: longitude,
      latitude: latitude,
      temperature: weather.temperature,
      iconName: weather.iconName
    )
    let newAddresses = [addressObject] + self.loadData()
    self.saveData(addresses: newAddresses)
  }

  func delete(address: Address) {
    let idMatcher: (AddressObject) -> Bool = { $0.identifier == address.identifier }
    var addressesData = self.loadData()

    guard let indexToRemove = addressesData.firstIndex(where: idMatcher) else {
      return assertionFailure("Failed to delete given address, not found in database: \(address)")
    }

    addressesData.remove(at: indexToRemove)
    self.saveData(addresses: addressesData)
  }

  // MARK: - Private

  private func saveData(addresses: [AddressObject]) {
    do {
      let newAddressesData = try JSONEncoder().encode(addresses)
      self.internalUserDefaults.set(newAddressesData, forKeyPath: Self.userAddressesKey)
      self.internalUserDefaults.synchronize()
      self.storeDidChange.publish()
    } catch {
      assertionFailure("Failed to encode addresses: \(error)")
    }
  }

  fileprivate func loadData() -> [AddressObject] {
    guard
      let addressesDataOptional = self.internalUserDefaults.object(
        forKey: Self.userAddressesKey
      ) as? Data?
    else {
      assertionFailure("Value at user key is not Data")
      return []
    }

    guard let addressesData = addressesDataOptional else { return [] }

    do {
      return try JSONDecoder().decode([AddressObject].self, from: addressesData)
    } catch {
      assertionFailure("Failed to decode data: \(error)")
      return []
    }
  }
}

private class AllAddressesReactableResource: ReactableResource {
  let didChangeEvent = Event<Void>()
  private(set) var resource = [Address]()

  private let store: AddressStoreImpl

  init(store: AddressStoreImpl) {
    self.store = store
    store.storeDidChange.add(self, handler: self.updateResources)
    self.updateResources()
  }

  private func updateResources() {
    self.resource = self.store.loadData().map(Address.init)
    self.didChangeEvent.publish()
  }
}
