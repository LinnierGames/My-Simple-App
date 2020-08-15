//
//  DataStore.swiUserWeathert
//  My Simple App
//
//  Created by Erick Sanchez on 7/23/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

typealias AllAddressesResource = AnyReactableResource<[Address]>

/// Save, delete and load `Address` objects from persistence.
protocol AddressStore {
  func storeAddress(name: String)
  func storeAddress(name: String, latitude: Double, longitude: Double, weather: Weather)
  func addresses() -> AllAddressesResource
  func delete(address: Address)
}
