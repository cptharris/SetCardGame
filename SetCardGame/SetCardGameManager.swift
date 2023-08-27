//
//  SetCardGameManager.swift
//  SetCardGame
//
//  Created by Caleb Harris on 8/23/23.
//

import Foundation
import SwiftUI

class SetCardGameManager: ObservableObject {
	@Published private var game = SetCardGame()
	
	var getOnBoardCards: [Card] {
		game.dealtCards
	}
	
	func dealThree() {
		game.dealThree()
	}
	
	var remainingCards: Int {
		game.cards.count
	}
	
	func choose(_ card: Card) {
		game.choose(card)
	}
}

extension Card {
	func getColor() -> Color {
		switch self.color {
		case .first: return Color.red
		case .second: return Color.green
		case .third: return Color.purple
		}
	}
	
	@ViewBuilder func getShape() -> some View {
		switch self.shape {
		case .diamond: DiamondShape()
		case .squiggle: Rectangle()
		case .oval: Ellipse()
		}
	}
	
	@ViewBuilder func getCardWithShading() -> some View {
		let base = RoundedRectangle(cornerRadius: 10)
		let lineWidth: CGFloat = 5
		switch self.shading {
		case .open:
			base.strokeBorder(lineWidth: lineWidth)
				.foregroundColor(strokeColor())
		case .striped:
			base.strokeBorder(lineWidth: lineWidth)
				.foregroundColor(strokeColor())
				.stripeBackground(color: .black, numStripes: 20)
		case .solid:
			base
			base.strokeBorder(lineWidth: lineWidth)
				.foregroundColor(strokeColor())
		}
	}
	
	func strokeColor() -> Color {
		if isSelected {
			return Color.yellow
		} else if isMatched == .yes {
			return Color.green
		} else if isMatched == .no {
			return Color.red
		} else {
			return Color.black
		}
	}
}
