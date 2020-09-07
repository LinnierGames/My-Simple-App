//
//  ReactableResource.swift
//  My Simple App
//
//  Created by Erick Sanchez on 8/12/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

protocol ReactableResource {
  associatedtype Resource
  var resource: Resource { get }
  var didChangeEvent: Event<Void> { get }
}
