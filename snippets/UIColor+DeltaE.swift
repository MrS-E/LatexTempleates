//
//  UIColor+DeltaE.swift
//  visoelec-radio
//
//  Created by Simeon Stix on 28.01.2025.
//

import CoreGraphics
import UIKit

// Source: https://zschuessler.github.io/DeltaE
// swiftlint:disable large_tuple identifier_name - all private
extension UIColor {
    private static func pivotRGB(_ value: CGFloat) -> CGFloat {
        /*
         sRGB gamma correction constants:
         0.04045: threshold for gamma correction
         0.055: offset in the gamma formula
         1.055: scale factor in gamma formula
         2.4: exponent for gamma correction
         12.92: scale factor for linear segment
         */
        (value > 0.04045) ? pow((value + 0.055) / 1.055, 2.4) : value / 12.92
    }

    private static func pivotXYZ(_ value: Double) -> Double {
        /*
         Constants for XYZ to Lab conversion:
         0.008856: threshold for the nonlinear segment in XYZ to Lab conversion
         7.787: multiplier for the linear segment
         16.0 / 116.0: offset added in the linear segment
         */
        (value > 0.008856) ? pow(value, 1.0 / 3.0) : (7.787 * value) + (16.0 / 116.0)
    }

    private static func calculateDeltaE(
        lab1: (L: Double, a: Double, b: Double),
        lab2: (L: Double, a: Double, b: Double)
    ) -> Double {
        let deltaL = lab1.L - lab2.L
        let deltaA = lab1.a - lab2.a
        let deltaB = lab1.b - lab2.b

        return sqrt(deltaL * deltaL + deltaA * deltaA + deltaB * deltaB)
    }

    static func deltaE(_ lhs: UIColor, _ rhs: UIColor) -> Double {
        let lab1 = lhs.rgbToLab()
        let lab2 = rhs.rgbToLab()

        return calculateDeltaE(lab1: lab1, lab2: lab2)
    }

    private func rgbToLab() -> (L: Double, a: Double, b: Double) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let R = Self.pivotRGB(red) * 100
        let G = Self.pivotRGB(green) * 100
        let B = Self.pivotRGB(blue) * 100

        // Reference white point D65
        let X = R * 0.4124564 + G * 0.3575761 + B * 0.1804375
        let Y = R * 0.2126729 + G * 0.7151522 + B * 0.0721750
        let Z = R * 0.0193339 + G * 0.1191920 + B * 0.9503041

        // Reference white point for D65 illuminant
        let x = Self.pivotXYZ(X / 95.047)
        // Reference white Y value for D65
        let y = Self.pivotXYZ(Y / 100.000)
        // Reference white Z value for D65
        let z = Self.pivotXYZ(Z / 108.883)

        return ((116 * y) - 16, 500 * (x - y), 200 * (y - z))
    }
}
// swiftlint:enable large_tuple identifier_name
