//
//  HiddenWhen.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import SwiftUI


//MARK: - Hidden When

/// View modifier that hides its content when condition is satisfied.
public struct HiddenWhen: ViewModifier {
    
    //TODO: Make this a Binding?
    fileprivate let condition: Bool
    
    public func body(content: Content) -> some View {
        Group {
            if self.condition.? {
                content.hidden()
            } else {
                content
            }
        }
    }
}


//MARK: - Convenience

extension View {
    
    /// Shows this view when condition is satistifed.
    public func visible(when condition: Bool) -> some View {
        modifier(HiddenWhen(condition: condition.!))
    }
    
    /// Hides this view when condition is satistifed.
    public func hidden(when condition: Bool) -> some View {
        modifier(HiddenWhen(condition: condition))
    }
}

