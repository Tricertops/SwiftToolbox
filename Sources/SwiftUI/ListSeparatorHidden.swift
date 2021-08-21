//
//  ListSeparatorHidden.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

#if os(iOS)

import UIKit
import SwiftUI


//MARK: - List Separator Hidden

/// View modifier that hides List separators.
public struct ListSeparatorHidden: ViewModifier {
    
    fileprivate let onlyTrailing: Bool
    
    public func body(content: Content) -> some View {
        content
            .onAppear() {
                if self.onlyTrailing {
                    UITableView.appearance().tableFooterView = UIView()
                } else {
                    UITableView.appearance().separatorStyle = .none
                }
            }
    }
}


//MARK: - Convenience
 
extension View {
    
    /// Hides List separators.
    public func listSeparatorHidden(onlyTrailing: Bool = no) -> some View {
        modifier(ListSeparatorHidden(onlyTrailing: onlyTrailing))
    }
}


#endif
