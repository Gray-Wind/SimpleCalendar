//
//  PatternImage.swift
//  SimpleCalendar
//
//  Created by Ilia Kolomeitsev on 26/02/2019.
//  Copyright © 2019 Ilia Kolomeitsev. All rights reserved.
//

import UIKit

func drawCustomImage(size: CGSize) -> UIImage {
	let bounds = CGRect(origin: .zero, size: size)
	let opaque = false
	let scale: CGFloat = 0
	UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
	let context = UIGraphicsGetCurrentContext()!

	context.setStrokeColor(UIColor.blue.cgColor)

//	context.stroke(bounds)

	context.beginPath()
	context.move(to: CGPoint(x: -bounds.midX, y: bounds.maxY))
	context.addLine(to: CGPoint(x: bounds.maxX, y: -bounds.midY))
	context.move(to: CGPoint(x: bounds.minX, y: bounds.maxY + bounds.midY))
	context.addLine(to: CGPoint(x: bounds.maxX + bounds.midX, y: bounds.minY))

//	context.move(to: CGPoint(x: bounds.minX - 1, y: bounds.maxY + 1))
//	context.addLine(to: CGPoint(x: bounds.maxX + 1, y: bounds.minY - 1))
//	context.move(to: CGPoint(x: bounds.minX - 1, y: bounds.minY + 1))
//	context.addLine(to: CGPoint(x: bounds.minX + 1, y: bounds.minY - 1))
//	context.move(to: CGPoint(x: bounds.maxX - 1, y: bounds.maxY + 1))
//	context.addLine(to: CGPoint(x: bounds.maxX + 1, y: bounds.maxY - 1))
	context.strokePath()

	let image = UIGraphicsGetImageFromCurrentImageContext()
	UIGraphicsEndImageContext()
	return image!
}
