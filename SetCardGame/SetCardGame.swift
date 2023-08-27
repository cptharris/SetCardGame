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
		for color in Card.Colour.allCases {
			for number in Card.Number.allCases {
				for shape in Card.Shape.allCases {
					for shading in Card.Shading.allCases {
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
		if dealtCards.filter({$0.isMatched == .no}).count == 3 {
			dealtCards.indices.forEach({dealtCards[$0].isMatched = .unknown})
			// if three are matched, remove the three
		} else if dealtCards.filter({$0.isMatched == .yes}).count == 3 {
			dealtCards.removeAll(where: {$0.isMatched == .yes})
			dealThree()
		}
		
		select(card)
		
		// determine matched cards if three cards are selected
		let selectedIndices = dealtCards.indices.filter({dealtCards[$0].isSelected})
		if selectedIndices.count == 3 {
			let matchResults = match(dealtCards[selectedIndices[0]], dealtCards[selectedIndices[1]], dealtCards[selectedIndices[2]])
			for index in selectedIndices {
				dealtCards[index].isMatched = matchResults ? .yes : .no
				dealtCards[index].isSelected = false
			}
		}
	}
	
	mutating private func select(_ card: Card) {
		if let chosenIndex = dealtCards.firstIndex(where: {$0.id == card.id}) {
			if dealtCards[chosenIndex].isSelected {
				dealtCards[chosenIndex].isSelected = false
			} else {
				dealtCards[chosenIndex].isSelected = true
			}
		}
	}
}

struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
	var debugDescription: String {
		return "[\(id): \(color) \(number) \(shape) \(shading) \(isSelected ? "" : "un")selected]"
	}
	
	var id: Int
	let color: Colour
	let number: Number
	let shape: Shape
	let shading: Shading
	var isSelected: Bool = false
	var isMatched: Matched = .unknown
	
	init(_ color: Colour, _ number: Number, _ shape: Shape, _ shading: Shading, id: Int) {
		self.color = color
		self.number = number
		self.shape = shape
		self.shading = shading
		self.id = id
	}
	
	enum Matched {
		case yes, no, unknown
	}
	
	enum Colour: CaseIterable {
		case first, second, third
	}
	
	enum Number: Int, CaseIterable {
		case one = 1, two = 2, three = 3
	}
	
	enum Shape: CaseIterable {
		case diamond, squiggle, oval
	}
	
	enum Shading: CaseIterable {
		case open, striped, solid
	}
}
