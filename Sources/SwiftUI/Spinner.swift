//
//  Spinner.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

#if os(iOS)

import UIKit
import SwiftUI


//MARK: - Spinner View

/// View that displays a spinning activity indicator.
/// - Note: Use `.hidden()` to control visibility.
/// - Note: Use `.imageScale(.large)` to make it large.
public struct Spinner: UIViewRepresentable {
    
    public init(color: UIColor = .label) {
        self.color = color
    }
    
    private let color: UIColor
    
    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIActivityIndicatorView {
        let isLarge = context.environment.imageScale == .large
        let view = UIActivityIndicatorView(style: isLarge ? .large : .medium)
        view.color = color
        view.startAnimating()
        return view
    }
    
    public func updateUIView(_ view: UIActivityIndicatorView, context: UIViewRepresentableContext<Self>) {
        // No updates.
    }
}


#endif
