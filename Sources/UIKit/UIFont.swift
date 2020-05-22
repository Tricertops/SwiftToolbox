//
//  UIFont.swift
//  Swift Toolbox by Tricertops
//
//  https://github.com/Tricertops/SwiftToolbox
//

import class UIKit.UIFont
import class UIKit.UIFontDescriptor
import CoreText.SFNTLayoutTypes


extension UIFont {
    
    /// Creates a new font with given features.
    public func withFeature(_ features: Feature...) -> UIFont {
        var settings = self.fontDescriptor.fontAttributes[.featureSettings] as! [[UIFontDescriptor.FeatureKey: Int]]
        for feature in features {
            settings.append([
                .typeIdentifier: feature.key,
                .featureIdentifier: feature.value,
            ])
        }
        let descriptor = self.fontDescriptor.addingAttributes([.featureSettings: settings])
        return UIFont(descriptor: descriptor, size: 0)
    }
}


//MARK: - Features

extension UIFont {
    
    /// Representation of a font feature.
    public struct Feature {
        fileprivate let key: Int
        fileprivate let value: Int
        
        static let proportionalNumbers = Feature(key: kNumberSpacingType, value: kProportionalNumbersSelector)
        static let monospacedNumbers = Feature(key: kNumberSpacingType, value: kMonospacedNumbersSelector)
        static let rareLigatures = Feature(key: kLigaturesType, value: kRareLigaturesOnSelector)
        static let superscript = Feature(key: kVerticalPositionType, value: kSuperiorsSelector)
        static let `subscript` = Feature(key: kVerticalPositionType, value: kInferiorsSelector)
        static let lowercaseNumbers = Feature(key: kNumberCaseType, value: kLowerCaseNumbersSelector)
        static let uppercaseNumbers = Feature(key: kNumberCaseType, value: kUpperCaseNumbersSelector)
        static let enableContextualAlternatives = Feature(key: kContextualAlternatesType, value: kContextualAlternatesOnSelector)
        static let disableContextualAlternatives = Feature(key: kContextualAlternatesType, value: kContextualAlternatesOffSelector)
        static let smallCaps = Feature(key: kLowerCaseType, value: kLowerCaseSmallCapsSelector)
        static func characterAlternatives(_ value: Int) -> Feature { Feature(key: kCharacterAlternativesType, value: value) }
    }
}

