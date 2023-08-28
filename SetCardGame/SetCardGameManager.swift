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
		game.confirmMatch(deal: false)
		game.dealThree()
	}
	
	var remainingCards: Int {
		game.cards.count
	}
	
	func choose(_ card: Card) {
		game.choose(card)
	}
	
	func newGame() {
		game = SetCardGame()
	}
	
	func findMatch() {
		game.confirmMatch()
		game.findMatch()
	}
	
	func shuffle() {
		game.shuffle()
	}
}

extension Card {
	func getColor() -> Color {
		switch self.color {
		case .one: return Color.red
		case .two: return Color.green
		case .three: return Color.purple
		}
	}
	
	@ViewBuilder func getShape() -> some View {
		switch self.shape {
		case .one: DiamondShape()
		case .two: Rectangle()
		case .three: Ellipse()
		}
	}
	
	@ViewBuilder func getCardWithShading() -> some View {
		let base = RoundedRectangle(cornerRadius: 10)
		let lineWidth: CGFloat = 5
		switch self.shading {
		case .one:
			base.strokeBorder(lineWidth: lineWidth)
				.foregroundColor(strokeColor())
		case .two:
			base.strokeBorder(lineWidth: lineWidth)
				.foregroundColor(strokeColor())
				.stripeBackground(color: .black, numStripes: 20)
		case .three:
			base
			base.strokeBorder(lineWidth: lineWidth)
				.foregroundColor(strokeColor())
		}
	}
	
	func strokeColor() -> Color {
		switch state {
		case .match: return Color.green
		case .nomatch: return Color.red
		case .select: return Color.yellow
		case .suggestion: return Color.blue
		default: return Color.black
		}
	}
}
