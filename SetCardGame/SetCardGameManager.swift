//
//  SetCardGameManager.swift
//  SetCardGame
//
//  Created by Captain Harris on 8/23/23.
//

import Foundation
import SwiftUI

class SetCardGameManager: ObservableObject {
	typealias Card = SetCardGame.Card
	@Published private var game = SetCardGame()
	
	var deckCards: [Card] {
		game.deckCards
	}
	
	var dealtCards: [Card] {
		game.dealtCards
	}
	
	func dealThree() {
		game.dealThree()
	}
	
	var disCards: [Card] {
		game.disCards
	}
	
	func choose(_ card: Card) {
		game.choose(card)
	}
	
	func newGame() {
		game = SetCardGame()
		for _ in 0..<4 {
			dealThree()
		}
	}
	
	func hint() {
		game.hint()
	}
	
	var matchExists: Bool {
		game.findMatch() != nil ? true : false
	}
	
	func shuffle() {
		game.shuffle()
	}
}
