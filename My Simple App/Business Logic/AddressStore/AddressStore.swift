//
//  DataStore.swiUserWeathert
//  My Simple App
//
//  Created by Erick Sanchez on 7/23/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

typealias AllAddressesResource = AnyReactableResource<[Address]>

/// Save and load `Address` objects from persistence.
protocol AddressStore {
  func store(address: Address) // TODO: use primitive types for the params.
  func addresses() -> AllAddressesResource
  func delete(address: Address)
}
