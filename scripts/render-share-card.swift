import AppKit
import CoreText
import ImageIO

// Run on macOS from the repository root: swift scripts/render-share-card.swift
let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let fontDirectory = root.appendingPathComponent("design/share-card/fonts")
let width = 1200
let height = 630

func font(_ weight: String, size: CGFloat) -> CTFont {
    let url = fontDirectory.appendingPathComponent("LibreFranklin-\(weight).ttf")
    guard let provider = CGDataProvider(url: url as CFURL),
          let cgFont = CGFont(provider) else {
        fatalError("Unable to load \(url.path)")
    }
    return CTFontCreateWithGraphicsFont(cgFont, size, nil, nil)
}

func color(_ hex: UInt32) -> CGColor {
    CGColor(srgbRed: CGFloat((hex >> 16) & 255) / 255,
            green: CGFloat((hex >> 8) & 255) / 255,
            blue: CGFloat(hex & 255) / 255, alpha: 1)
}

let context = CGContext(data: nil, width: width, height: height,
    bitsPerComponent: 8, bytesPerRow: width * 4,
    space: CGColorSpace(name: CGColorSpace.sRGB)!,
    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
context.setAllowsAntialiasing(true)
context.setShouldAntialias(true)
context.setFillColor(color(0x0F0D16))
context.fill(CGRect(x: 0, y: 0, width: width, height: height))

// Coordinates use a top-origin baseline for easy comparison with the card.
func text(_ value: String, baseline: CGFloat, size: CGFloat,
          weight: String, hex: UInt32, tracking: CGFloat = 0) {
    let typeface = font(weight, size: size)
    let attributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key(kCTFontAttributeName as String): typeface,
        NSAttributedString.Key(kCTForegroundColorAttributeName as String): color(hex),
        NSAttributedString.Key(kCTKernAttributeName as String): tracking
    ]
    let line = CTLineCreateWithAttributedString(NSAttributedString(string: value, attributes: attributes))
    let bounds = CTLineGetBoundsWithOptions(line, .useGlyphPathBounds)
    precondition(bounds.maxX <= 1056, "Text exceeds the card's right margin: \(value)")
    context.textPosition = CGPoint(x: 72, y: CGFloat(height) - baseline)
    CTLineDraw(line, context)
    print("\(CTFontCopyPostScriptName(typeface)): \(value)")
}

context.setFillColor(color(0xED5AA0))
context.fill(CGRect(x: 0, y: 0, width: width, height: 2))
text("Aaron Grando", baseline: 346, size: 108,
     weight: "SemiBold", hex: 0xF0EDF2, tracking: -1.62)
text("AI product, platform & innovation leader", baseline: 438, size: 34,
     weight: "Regular", hex: 0xCACACA)
text("VISIT GRAN.DO →", baseline: 555, size: 24,
     weight: "Medium", hex: 0x828282, tracking: 2)
let shieldURL = root.appendingPathComponent("app/assets/images/shield.svg")
guard let shield = NSImage(contentsOf: shieldURL) else {
    fatalError("Unable to load the site's shield: \(shieldURL.path)")
}
let shieldWidth: CGFloat = 48
let shieldHeight = shieldWidth * shield.size.height / shield.size.width
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(cgContext: context, flipped: false)
shield.draw(in: CGRect(x: 72, y: CGFloat(height) - 72 - shieldHeight,
                      width: shieldWidth, height: shieldHeight),
            from: .zero, operation: .sourceOver, fraction: 1)
NSGraphicsContext.restoreGraphicsState()

let output = root.appendingPathComponent("app/assets/images/aaron-grando-og.png")
let destination = CGImageDestinationCreateWithURL(output as CFURL, "public.png" as CFString, 1, nil)!
CGImageDestinationAddImage(destination, context.makeImage()!, nil)
precondition(CGImageDestinationFinalize(destination), "Failed to write share card")
print("Saved \(width) × \(height) share card to \(output.path)")
