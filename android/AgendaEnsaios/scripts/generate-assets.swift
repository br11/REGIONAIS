import AppKit
import Foundation

let workspaceRoot = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
let repositoryRoot = workspaceRoot
    .appendingPathComponent("../..", isDirectory: true)
    .standardizedFileURL
let sourceIconURL = repositoryRoot
    .appendingPathComponent("pwa/icon/icon-512.png")
let resourceRoot = workspaceRoot
    .appendingPathComponent("android/app/src/main/res", isDirectory: true)

func render(
    source: NSImage,
    to destination: URL,
    width: Int,
    height: Int,
    imageScale: CGFloat,
    transparentBackground: Bool
) throws {
    guard let bitmap = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: width,
        pixelsHigh: height,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    ), let context = NSGraphicsContext(bitmapImageRep: bitmap) else {
        throw NSError(domain: "AndroidAssetGeneration", code: 1)
    }

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = context
    context.imageInterpolation = .high

    let bounds = CGRect(x: 0, y: 0, width: width, height: height)
    (transparentBackground ? NSColor.clear : NSColor.white).setFill()
    bounds.fill()

    let imageSide = CGFloat(min(width, height)) * imageScale
    let imageRect = CGRect(
        x: (CGFloat(width) - imageSide) / 2,
        y: (CGFloat(height) - imageSide) / 2,
        width: imageSide,
        height: imageSide
    )
    source.draw(in: imageRect, from: .zero, operation: .sourceOver, fraction: 1)

    context.flushGraphics()
    NSGraphicsContext.restoreGraphicsState()

    guard let data = bitmap.representation(using: .png, properties: [:]) else {
        throw NSError(domain: "AndroidAssetGeneration", code: 2)
    }
    try data.write(to: destination)
}

guard let source = NSImage(contentsOf: sourceIconURL) else {
    fatalError("Could not load PWA icon at \(sourceIconURL.path)")
}

let fileManager = FileManager.default
let resourceEnumerator = fileManager.enumerator(
    at: resourceRoot,
    includingPropertiesForKeys: [.isRegularFileKey]
)
var generatedCount = 0

while let fileURL = resourceEnumerator?.nextObject() as? URL {
    guard fileURL.pathExtension == "png" else { continue }

    if ["ic_launcher.png", "ic_launcher_round.png"].contains(fileURL.lastPathComponent) {
        guard let existing = NSBitmapImageRep(data: try Data(contentsOf: fileURL)) else {
            throw NSError(domain: "AndroidAssetGeneration", code: 3)
        }
        try render(
            source: source,
            to: fileURL,
            width: existing.pixelsWide,
            height: existing.pixelsHigh,
            imageScale: 1,
            transparentBackground: false
        )
        generatedCount += 1
    } else if fileURL.lastPathComponent == "ic_launcher_foreground.png" {
        guard let existing = NSBitmapImageRep(data: try Data(contentsOf: fileURL)) else {
            throw NSError(domain: "AndroidAssetGeneration", code: 4)
        }
        try render(
            source: source,
            to: fileURL,
            width: existing.pixelsWide,
            height: existing.pixelsHigh,
            imageScale: 0.66,
            transparentBackground: true
        )
        generatedCount += 1
    } else if fileURL.lastPathComponent == "splash.png" {
        guard let existing = NSBitmapImageRep(data: try Data(contentsOf: fileURL)) else {
            throw NSError(domain: "AndroidAssetGeneration", code: 5)
        }
        try render(
            source: source,
            to: fileURL,
            width: existing.pixelsWide,
            height: existing.pixelsHigh,
            imageScale: 0.48,
            transparentBackground: false
        )
        generatedCount += 1
    }
}

print("Generated \(generatedCount) Android icon and splash assets.")
