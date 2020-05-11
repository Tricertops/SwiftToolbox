//
//  Notification.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import Foundation


//MARK: - Observation

extension Notification.Name {
    
    /// Convenience for observing the receiver. All parameters are optional except the handler.
    ///
    ///     let observation = UIApplication.didBecomeActiveNotification.observe { notification in
    ///         // Handle observation.
    ///     }
    ///     // Later:
    ///     observation.cancel()
    ///
    /// The returned object represents the observation. You can cancel it manually or let it deinit to cancel.
    /// It is best to store the observation in an object property to tie it up with its lifetime.
    public func observe(from object: Any? = nil, via center: NotificationCenter = .default, on queue: OperationQueue? = nil, using handler: @escaping (Notification) -> Void) -> Notification.Observation {
        let observer = center.addObserver(forName: self, object: object, queue: queue, using: handler)
        return Notification.Observation(observer: observer, center: center)
    }
}

extension Notification {
    
    /// Object returned from `Notification.Name.observe()` that represents the established observation. Can be cancelled.
    public final class Observation {
        
        /// Cancels the observation of notification and cleans up.
        public func cancel() {
            if let observer = observer {
                center?.removeObserver(observer)
            }
            center = nil
            observer = nil
        }
        
        /// Automatically cleans up on deinit.
        deinit {
            cancel()
        }
        
        /// Internal initializer.
        fileprivate init(observer: AnyObject, center: NotificationCenter) {
            self.observer = observer
            self.center = center
        }
        
        /// The notification center from which to remove on cancellation.
        private var center: NotificationCenter?
        
        /// The internal object from NotificationCenter which to remove on cancellation.
        private var observer: AnyObject?
    }
}

