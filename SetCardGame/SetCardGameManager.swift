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
		game.cards.filter { $0.onBoard }
	}
	
	func dealThree() {
		game.dealThree()
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
		case .diamond: Text("♦").rotationEffect(Angle(degrees: 90))
		case .squiggle: Text("~")
		case .oval: Text("O").rotationEffect(Angle(degrees: 90))
		}
	}
}
