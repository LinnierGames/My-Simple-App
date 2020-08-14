import Foundation

/// One to many communication of a value's updates.
///
/// # Example
/// ```
/// class KeyboardListner {
///   let keyboardHeight: Event<CGFloat>
///
///   ...
/// }
///
/// class MyViewController {
///   let keyboard = KeyboardListner()
///
///   init() {
///     self.keyboard.keyboardHeight.add(self) { [weak self] newHeight in
///       self?.updateUIToNewKeyboardHeight(newHeight)
///     }
///   }
/// }
/// ```
class Event<Value> {

  typealias Subscription = (Value) -> Void
  typealias Subscriber = AnyObject

  private let lock = DispatchQueue.global()
  private var subscriptions: [ObjectIdentifier: Subscription] = [:]

  /// Add subscriber to be notified when this event is published.
  ///
  /// - Note: only unique subscribers can be added to the same event. If the same subscriber
  /// subscribes the same event, the previous subscription will be overwritten.
  func add(_ subscriber: Subscriber, handler: @escaping Subscription) {
    let subscriberKey = ObjectIdentifier(subscriber)

    self.lock.async {
      self.subscriptions[subscriberKey] = handler
    }
  }

  /// Publish and notify the subscribers of the given value.
  func publish(_ value: Value) {
    self.lock.async {
      let subscriptions = self.subscriptions.values

      for subscription in subscriptions {
        DispatchQueue.main.async {
          subscription(value)
        }
      }
    }
  }
}

extension Event where Value == Void {
  func publish() {
    self.publish(())
  }
}
