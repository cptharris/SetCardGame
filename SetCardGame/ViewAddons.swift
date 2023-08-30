//
//  ViewAddons.swift
//  SetCardGame
//
//  Created by Captain Harris on 8/30/23.
//

import SwiftUI

extension View {
	@ViewBuilder func isHidden(_ toHide: Bool, remove: Bool = false) -> some View {
		if toHide {
			if !remove {
				self.hidden()
			}
		} else {
			self
		}
	}
	
	func stripeBackground(color: Color, numStripes: Int) -> some View {
		self.background() {
			HStack(spacing: 0) {
				ForEach(0..<numStripes, id: \.self) { number in
					if number == 0 {
						Color.clear
					}
					Color.clear
					color.frame(width: 1)
					if number == numStripes - 1 {
						Color.clear
						Color.clear
					}
				}
			}
		}
	}
}

struct DiamondShape: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		path.addLines([
			CGPoint(x: rect.minX, y: rect.midY),
			CGPoint(x: rect.midX, y: rect.minY),
			CGPoint(x: rect.maxX, y: rect.midY),
			CGPoint(x: rect.midX, y: rect.maxY),
			CGPoint(x: rect.minX, y: rect.midY)
		])
		return path
	}
}
