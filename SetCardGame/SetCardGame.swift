//
//  SetCardGame.swift
//  SetCardGame
//
//  Created by Caleb Harris on 8/23/23.
//

import Foundation

struct SetCardGame {
	private(set) var cards = [Card]()
	private(set) var dealtCards = [Card]()
	
	init() {
		var id = 0
		for color in Card.Feature.allCases {
			for number in Card.Feature.allCases {
				for shape in Card.Feature.allCases {
					for shading in Card.Feature.allCases {
						cards.append(Card(color, number, shape, shading, id: id))
						id += 1
					}
				}
			}
		}
		
		cards.shuffle()
		for _ in 0..<4 {
			dealThree()
		}
	}
	
	private func match(_ card1: Card, _ card2: Card, _ card3: Card) -> Bool {
		var checks = [false, false, false, false]
		if (card1.color == card2.color && card2.color == card3.color) ||
			(card1.color != card2.color && card2.color != card3.color && card1.color != card3.color) {
			checks[0] = true
		}
		
		if (card1.number == card2.number && card2.number == card3.number) ||
			(card1.number != card2.number && card2.number != card3.number && card1.number != card3.number) {
			checks[1] = true
		}
		
		if (card1.shape == card2.shape && card2.shape == card3.shape) ||
			(card1.shape != card2.shape && card2.shape != card3.shape && card1.shape != card3.shape) {
			checks[2] = true
		}
		
		if (card1.shading == card2.shading && card2.shading == card3.shading) ||
			(card1.shading != card2.shading && card2.shading != card3.shading && card1.shading != card3.shading) {
			checks[3] = true
		}
		
		return checks[0] && checks[1] && checks[2] && checks[3]
	}
	
	mutating func dealThree() {
		for _ in 0..<3 {
			if cards.count > 0 {
				dealtCards.insert(cards.removeFirst(), at: 0)
			} else {
				break
			}
		}
	}
	
	mutating func choose(_ card: Card) {
		// if three are not matched, unselect the three
		if dealtCards.filter({$0.state == .nomatch}).count == 3 {
			dealtCards.indices.forEach({dealtCards[$0].state = .noselect})
			// if three are matched, remove the three
		} else {
			confirmMatch()
		}
		
		select(card)
		
		// determine matched cards if three cards are selected
		let selectedIndices = dealtCards.indices.filter({dealtCards[$0].state == .select})
		if selectedIndices.count == 3 {
			let matchResults = match(dealtCards[selectedIndices[0]], dealtCards[selectedIndices[1]], dealtCards[selectedIndices[2]])
			for index in selectedIndices {
				dealtCards[index].state = matchResults ? .match : .nomatch
			}
		}
	}
	
	mutating private func select(_ card: Card) {
		if let chosenIndex = dealtCards.firstIndex(where: {$0.id == card.id}) {
			if dealtCards[chosenIndex].state == .select {
				dealtCards[chosenIndex].state = .noselect
			} else {
				dealtCards[chosenIndex].state = .select
			}
		}
	}
	
	mutating func confirmMatch(deal: Bool = true) {
		if dealtCards.filter({$0.state == .match}).count == 3 {
			dealtCards.removeAll(where: {$0.state == .match})
			if deal {
				dealThree()
			}
		}
	}
	
	mutating func findMatch() {
		for index in dealtCards.indices {
			dealtCards[index].state = .noselect
		}
		
		for index1 in 0..<(dealtCards.count - 2) {
			for index2 in (index1 + 1)..<(dealtCards.count - 1) {
				for index3 in (index2 + 1)..<(dealtCards.count) {
					if match(dealtCards[index1], dealtCards[index2], dealtCards[index3]) {
						dealtCards[index1].state = .suggestion
						dealtCards[index2].state = .suggestion
						dealtCards[index3].state = .suggestion
						return
					}
				}
			}
		}
	}
	
	mutating func shuffle() {
		dealtCards.shuffle()
	}
}

struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
	var debugDescription: String {
		return "[\(id): color \(color) number \(number) shape \(shape) shading \(shading) \(state)]"
	}
	
	var id: Int
	let color: Feature
	let number: Feature
	let shape: Feature
	let shading: Feature
	var state: State = .noselect
	
	init(_ color: Feature, _ number: Feature, _ shape: Feature, _ shading: Feature, id: Int) {
		self.color = color
		self.number = number
		self.shape = shape
		self.shading = shading
		self.id = id
	}
	
	enum State {
		case match, nomatch, select, noselect, suggestion
	}
	
	enum Feature: Int, CaseIterable {
		case one = 1, two = 2, three = 3
	}
}
