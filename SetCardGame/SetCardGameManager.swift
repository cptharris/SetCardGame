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
	private(set) var cardSize = CGSize(width: 70, height: 100)
	func setCardWidth(_ width: CGFloat) {
		cardSize = CGSize(width: width, height: width * 2/3)
	}
	
	var getOnBoardCards: [Card] {
		game.dealtCards
	}
	
	func dealThree() {
		game.dealThree()
	}
	
	var remainingCards: Int {
		game.cards.count
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
		switch self.shading {
		case .open:
			Group {base.strokeBorder(lineWidth: 5).foregroundColor(getColor())}
		case .striped:
			Group {base.strokeBorder(lineWidth: 5).foregroundColor(getColor()).stripeBackground(color: getColor())}
		case .solid:
			Group {base.fill(getColor())}
		}
	}
}
