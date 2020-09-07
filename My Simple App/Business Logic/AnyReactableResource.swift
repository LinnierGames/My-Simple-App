//
//  AnyReactableResource.swift
//  My Simple App
//
//  Created by Erick Sanchez on 8/12/20.
//  Copyright © 2020 Erick Sanchez. All rights reserved.
//

import Foundation

class AnyReactableResource<Resource>: ReactableResource {
  var resource: Resource {
    return base.resource
  }

  var didChangeEvent: Event<Void> {
    return base.didChangeEvent
  }

  private let base: AbstractReactableResource<Resource>

  init<T: ReactableResource>(base: T) where T.Resource == Resource {
    self.base = BaseReactableResource(base: base)
  }
}

private class BaseReactableResource<
  Resource,
  Type: ReactableResource
>: AbstractReactableResource<Resource> where Type.Resource == Resource {
  let base: Type

  init(base: Type) {
    self.base = base
  }

  override var resource: Resource {
    return base.resource
  }

  override var didChangeEvent: Event<Void> {
    return base.didChangeEvent
  }
}

private class AbstractReactableResource<Resource>: ReactableResource {
  var resource: Resource {
    fatalError("not implemented")
  }

  var didChangeEvent: Event<Void> {
    fatalError("not implemented")
  }
}
