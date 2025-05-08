import UIKit
import PlaygroundSupport

// swiftlint:disable identifier_name
extension UIImage {
    // swiftlint:disable:next large_tuple
    var squaredColorArray: (colors: [[UIColor?]], emptyX: Int, emptyY: Int)? {
        guard let cgImage = self.cgImage else { return nil }

        let width = cgImage.width
        let height = cgImage.height
        let size = max(width, height)

        let xOffset = (size - width) / 2
        let yOffset = (size - height) / 2

        if height > width {
            var pixel: [[UIColor?]] = Array(repeating: Array(repeating: nil, count: size), count: xOffset)

            for x in xOffset..<(xOffset + width) {
                pixel.append(cgImage.getPixelColors(
                    for: (0..<height).map { CGPoint(x: x - xOffset, y: $0) }
                ))
            }

            pixel.append(contentsOf: Array(
                repeating: Array(repeating: nil, count: size),
                count: size - xOffset - width
            ))
            return (pixel, xOffset, 0)
        } else {
            var pixel: [[UIColor?]] = []
            for y in 0..<width {
                pixel.append([])
                pixel[y].append(contentsOf: Array(repeating: nil, count: yOffset))
                pixel[y].append(contentsOf: cgImage.getPixelColors(for: (0..<height).map {
                    CGPoint(x: y, y: $0)
                }))
                pixel[y].append(contentsOf: Array(repeating: nil, count: size - yOffset - height))
            }
            return (pixel, 0, yOffset)
        }
    }

    func extend() -> UIImage? {
        guard var (image, spaceX, spaceY) = self.squaredColorArray else { return nil }
                
        if spaceX > 0 {
            spaceX += 3
            image[image.count - spaceX..<image.count].fillColors()
            image = image.mirror
            image[image.count - spaceX..<image.count].fillColors()
            image = image.mirror
        }
        
        if spaceY > 0 {
            spaceY += 3
            image = image.rotatedClockwise
            image[image.count - spaceY..<image.count].fillColors()
            image = image.mirror
            image[image.count - spaceY..<image.count].fillColors()
            image = image.mirror
            image = image.rotatedCounterclockwise
        }

        return image.image
    }
}

extension ArraySlice where Element == [UIColor?] {
    mutating func fillColors() {
        for x in self.startIndex + 2..<self.endIndex {
            for y in self[x].startIndex..<self[x].endIndex {
                var colors = if let c1 = self[x - 2][y], let c2 = self[x - 1][y] {
                    [
                        UIColor.colorVector(from: c1, to:c2) // d3
                    ]
                } else {
                    []
                }
                if y >= 2, let c1 = self[x - 2][y - 2], let c2 = self[x - 1][y - 1] {
                    colors.append(UIColor.colorVector(
                        from: c1,
                        to: c2
                    )) // d4
                }

                if y < self[x].count - 2 {
                    if let c1 = self[x][y + 2], let c2 = self[x][y + 1]{
                        colors.append(UIColor.colorVector(
                            from: c1,
                            to: c2
                        )) // d1
                    }
                    
                    if let c1 = self[x - 2][y + 2], let c2 = self[x - 1][y + 1]{
                        colors.append(UIColor.colorVector(
                            from: c1,
                            to: c2
                        )) // d2
                    }
                }
                if let colors = colors as? [UIColor]{
                    self[x][y] = colors.medianColor
                }
            }
        }
    }
}

extension Array where Element == [UIColor?] {
    var rotatedClockwise: Self {
        let n = self.count
        var rotated = self
        
        for i in 0..<n {
            for j in 0..<n {
                rotated[j][n - 1 - i] = self[i][j]
            }
        }

        return rotated
    }

    var rotatedCounterclockwise: Self {
        let n = self.count
        var rotated = self
        for i in 0..<n {
            for j in 0..<n {
                rotated[n - 1 - j][i] = self[i][j]
            }
        }
        return rotated
    }

    var mirror: Self {
       self.reversed()
    }
    
    var image: UIImage? {
        let width = self.count
        let height = self.first?.count ?? 0

        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        for x in 0..<width {
            for y in 0..<height {
                guard let color = self[x][y] else { continue }
                context.setFillColor(color.cgColor)
                context.fill(CGRect(x: x, y: y, width: 1, height: 1))
            }
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
// swiftlint:enable identifier_name

extension CGImage {
    enum PixelFormat {
        case RGBA, BGRA, ARGB, RGB, Unknown
    }

    private var getPixelFormat: PixelFormat {
        let bitsPerPixel = self.bitsPerPixel
        let alphaInfo = self.alphaInfo
        let colorSpaceModel = self.colorSpace?.model

        return switch (bitsPerPixel, alphaInfo, colorSpaceModel) {
        case (32, .premultipliedLast, .rgb), (32, .last, .rgb), (32, .noneSkipLast, .rgb):
            .RGBA

        case (32, .premultipliedFirst, .rgb), (32, .first, .rgb):
            .ARGB

        case (32, .noneSkipFirst, .rgb):
            .BGRA

        case (24, .none, .rgb):
            .RGB

        default:
            .Unknown
        }
    }

    private func getColor(
        from data: UnsafePointer<UInt8>,
        of byteIndex: Int,
        with pixelFormat: PixelFormat
    ) -> UIColor? {
        switch pixelFormat {
        case .RGBA:
            return UIColor(
                red: CGFloat(data[byteIndex]) / 255.0,
                green: CGFloat(data[byteIndex + 1]) / 255.0,
                blue: CGFloat(data[byteIndex + 2]) / 255.0,
                alpha: CGFloat(data[byteIndex + 3]) / 255.0
            )

        case .BGRA:
            return UIColor(
                red: CGFloat(data[byteIndex + 2]) / 255.0,
                green: CGFloat(data[byteIndex + 1]) / 255.0,
                blue: CGFloat(data[byteIndex]) / 255.0,
                alpha: CGFloat(data[byteIndex + 3]) / 255.0
            )

        case .ARGB:
            return UIColor(
                red: CGFloat(data[byteIndex + 1]) / 255.0,
                green: CGFloat(data[byteIndex + 2]) / 255.0,
                blue: CGFloat(data[byteIndex + 3]) / 255.0,
                alpha: CGFloat(data[byteIndex]) / 255.0
            )

        case .RGB:
            return UIColor(
                red: CGFloat(data[byteIndex]) / 255.0,
                green: CGFloat(data[byteIndex + 1]) / 255.0,
                blue: CGFloat(data[byteIndex + 2]) / 255.0,
                alpha: 1.0 // No alpha channel in RGB format
            )

        case .Unknown:
            return nil
        }
    }

    func getPixelColors(for points: [CGPoint]) -> [UIColor?] {
        guard let providerData = self.dataProvider?.data else {
            return []
        }

        guard let data = CFDataGetBytePtr(providerData) else {
            return []
        }

        let bytesPerPixel = self.bitsPerPixel / 8
        let bytesPerRow = self.bytesPerRow
        let pixelFormat = self.getPixelFormat

        return points.compactMap { point in
            guard
                point.x >= 0, point.x < CGFloat(self.width),
                point.y >= 0, point.y < CGFloat(self.height)
            else {
                return nil
            }

            let byteIndex = Int(point.y) * bytesPerRow + Int(point.x) * bytesPerPixel

            guard byteIndex + (bytesPerPixel - 1) < CFDataGetLength(providerData) else {
                return nil
            }
            return getColor(from: data, of: byteIndex, with: pixelFormat)
        }
    }
}


extension Collection where Element == UIColor {
    var mostUsedColor: UIColor? {
        self
            .reduce(into: [:]) {colorCount, color in
                colorCount[color, default: 0] += 1
            }
            .max { $0.value < $1.value }?.key
    }

    var medianColor: UIColor? {
        let rgbValues = self.compactMap { $0.rgbComponents }
        guard !rgbValues.isEmpty else { return nil }

        return .init(
            red: rgbValues.map { $0.r }.median,
            green: rgbValues.map { $0.g }.median,
            blue: rgbValues.map { $0.b }.median,
            alpha: rgbValues.map { $0.a }.median
        )
    }

    var averageColor: UIColor? {
        let rgbValues = self.compactMap { $0.rgbComponents }
        guard !rgbValues.isEmpty else { return nil }

        return .init(
            red: rgbValues.map { $0.r }.average,
            green: rgbValues.map { $0.g }.average,
            blue: rgbValues.map { $0.b }.average,
            alpha: rgbValues.map { $0.a }.average
        )
    }
}

extension UIColor {
    // swiftlint:disable:next large_tuple - only used here
    var rgbComponents: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        return self.getRed(&r, green: &g, blue: &b, alpha: &a) ? (r, g, b, a) : nil
    }

    static func colorVector(from color1: UIColor, to color2: UIColor) -> UIColor {
        let (r1, g1, b1, a1) = color1.rgbComponents ?? (0, 0, 0, 0)
        let (r2, g2, b2, a2) = color2.rgbComponents ?? (0, 0, 0, 0)

        let vr = r2 - r1
        let vg = g2 - g1
        let vb = b2 - b1
        let va = a2 - a1

        var newR = r2 + vr
        var newG = g2 + vg
        var newB = b2 + vb
        var newA = a2 + va

        newR = max(0.0, min(1.0, newR))
        newG = max(0.0, min(1.0, newG))
        newB = max(0.0, min(1.0, newB))
        newA = max(0.0, min(1.0, newA))

        return UIColor(red: newR, green: newG, blue: newB, alpha: newA)
    }
}

extension Collection where Element == CGFloat {
    var median: CGFloat {
        guard !self.isEmpty else { return 0 }
        let sorted = self.sorted()
        let mid = sorted.count / 2
        return sorted.count.isMultiple(of: 2) ? (sorted[mid - 1] + sorted[mid]) / 2 : sorted[mid]
    }

    var average: CGFloat {
        guard !self.isEmpty else { return 0 }
        return self.reduce(0, +) / CGFloat(self.count)
    }
}

var image = UIImage(named: "radio_chablais.jpg")!.extend()
let imageView = UIImageView(image: image)
imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
PlaygroundPage.current.liveView = imageView
