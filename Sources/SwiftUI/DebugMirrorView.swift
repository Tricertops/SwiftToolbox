//
//  DebugMirrorView.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

#if !os(macOS)

import UIKit
import SwiftUI


//MARK: - Mirror View

/// View that presents Mirror of given subject. Present modally.
public struct DebugMirrorView: View {
    
    /// Create a view that presents Mirror of given subject.
    public init(reflecting subject: Any) {
        self.subject = subject
    }
    
    public var body: some View {
        NavigationView {
            PageView(title: nil, reflecting: self.subject)
        }
    }
    
    private var subject: Any
}


//MARK: - Mirror Detail View

extension DebugMirrorView {
    
    public struct PageView: View {
        
        private let title: String
        private let description: String
        private let mirror: Mirror
        private let children: [Mirror.Child]
        
        fileprivate init(title: String?, reflecting subject: Any) {
            let mirror = Mirror(reflecting: subject)
            self.title = title ?? "\(mirror.subjectType)"
            self.description = String(reflecting: subject)
            self.mirror = mirror
            self.children = Array(mirror.children)
        }
        
        public var body: some View {
            List {
                self.row(
                    title: "Type",
                    suffix: self.displayStyle,
                    detail: "\(self.mirror.subjectType)",
                    code: no)
                
                if self.showDescription {
                    self.row(
                        title: "Value",
                        suffix: "",
                        detail: "\(self.description)",
                        code: no)
                }
                
                ForEach(0 ..< self.children.count) { index in
                    self.row(child: index)
                }
            }
            .listSeparatorHidden(onlyTrailing: yes)
            .navigationBarTitle(self.title)
        }
        
        private func row(child index: Int) -> some View {
            Group {
                if self.childHasDetail(index) {
                    NavigationLink(destination: self.childPage(index)) {
                        self.row(
                            title: self.displayedName(child: index),
                            suffix: self.labelSuffix(child: index),
                            detail: self.shortValueDescriptionFor(child: index),
                            code: yes)
                    }
                } else {
                    self.row(
                        title: self.displayedName(child: index),
                        suffix: self.labelSuffix(child: index),
                        detail: self.shortValueDescriptionFor(child: index),
                        code: yes)
                }
            }
        }
        
        private func row(title: String, suffix: String, detail: String, code: Bool) -> some View {
            VStack(alignment: .leading) {
                HStack(spacing: code ? 0 : nil) {
                    Text(title)
                        .font(.system(
                            code ? .body : .headline,
                            design: code ? .monospaced : .default))
                    if suffix.hasCharacters {
                        Text(suffix)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.secondary)
                    }
                }
                Text(detail)
                    .font(.system(.body, design: .monospaced))
                    .padding(.leading)
                    .foregroundColor(.secondary)
                    .lineLimit(code ? 1 : nil)
                    .truncationMode(.tail)
            }
        }
        
        private var showDescription: Bool {
            if children.isEmpty {
                return yes
            }
            // Some types have children, but we want their description, too.
            if "\(mirror.subjectType)" == "Date" {
                return yes
            }
            return no
        }
        
        private func childHasDetail(_ index: Int) -> Bool {
            let child = children[index].value
            let childMirror = Mirror(reflecting: child)
            // Simple types are not expanded.
            if isSimpleType(child: index) {
                return no
            }
            // Nil Optional is not expanded.
            if childMirror.displayStyle == .optional {
                if "\(child)" == "nil" {
                    return no
                }
            }
            return yes
        }
        
        private func labelSuffix(child index: Int) -> String {
            let child = children[index].value
            let childMirror = Mirror(reflecting: child)
            // Simple types has type annotation.
            if isSimpleType(child: index) {
                return ": \(childMirror.subjectType)"
            }
            // Some other types have type annotation, too.
            if "\(childMirror.subjectType)" == ("String" | "Date") {
                return ": \(childMirror.subjectType)"
            }
            // Optionals has a question mark.
            if childMirror.displayStyle == .optional {
                return "?"
            }
            return ""
        }
        
        private func isSimpleType(child index: Int) -> Bool {
            let childMirror = Mirror(reflecting: children[index].value)
            // Some types are not further expanded.
            return "\(childMirror.subjectType)" == ("Bool" | "Int" | "UInt" | "Double")
        }
        
        private func childPage(_ index: Int) -> PageView {
            PageView(title: displayedName(child: index), reflecting: displayedValueFor(child: index))
        }
        
        private func displayedName(child index: Int) -> String {
            // Unlabeled children show index.
            children[index].label ?? "[\(index)]"
        }
        
        private func displayedValueFor(child index: Int) -> Any {
            let child = children[index].value
            let childMirror = Mirror(reflecting: child)
            // Non-nil Optional shows its value directly.
            if childMirror.displayStyle == .optional {
                if "\(child)" != "nil" {
                    return childMirror.children.first!.value
                }
            }
            return child
        }
        
        private func shortValueDescriptionFor(child index: Int) -> String {
            let child = displayedValueFor(child: index)
            let childMirror = Mirror(reflecting: child)
            switch childMirror.displayStyle {
                case .struct, .class, .enum, .optional:
                    return "\(child)"
                case .collection:
                    return shortValueCount(childMirror, noun: "element")
                case .dictionary:
                    return shortValueCount(childMirror, noun: "pair")
                case .set:
                    return shortValueCount(childMirror, noun: "element")
                default:
                    return "\(child)"
            }
        }
        
        private func shortValueCount(_ childMirror: Mirror, noun: String) -> String {
            let count = childMirror.children.count
            switch count {
                case 0: return "empty"
                case 1: return "1 \(noun)"
                default: return "\(count) \(noun)s"
            }
        }
        
        private var displayStyle: String {
            switch mirror.displayStyle {
                case .struct: return "struct"
                case .class: return "class"
                case .enum: return "enum"
                case .optional: return "enum"
                case .collection: return "collection"
                case .dictionary: return "dictionary"
                case .set: return "set"
                default: return ""
            }
        }
    }
}


#endif
