//
//  ListSeparatorHidden.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import SwiftUI


//MARK: - List Separator Hidden

/// View modifier that hides List separators.
public struct ListSeparatorHidden: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .onAppear() {
                UITableView.appearance().separatorStyle = .none
            }
    }
}


//MARK: - Convenience
 
extension View {
    
    /// Hides List separators.
    public func listSeparatorHidden() -> some View {
        modifier(ListSeparatorHidden())
    }
}

