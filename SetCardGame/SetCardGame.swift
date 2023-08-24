//
//  SetCardGame.swift
//  SetCardGame
//
//  Created by Caleb Harris on 8/23/23.
//

import Foundation

struct SetCardGame {
	private(set) var cards = [Card]()
	
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
		dealThree()
		dealThree()
		dealThree()
		dealThree()
	}
	
	mutating func dealThree() {
		if let firstIndex = cards.firstIndex(where: { !$0.onBoard}) {
			for index in firstIndex..<(firstIndex + 3) {
				cards[index].onBoard = true
				print(cards[index].color)
			}
		}
	}
	
	func choose(_ card: Card) {
		
	}
}

struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
	var debugDescription: String {
		return "[\(id): \(color) \(number) \(shape) \(shading) \(onBoard ? "on board" : "not on board")]"
	}
	
	var id: Int
	let color: Colour
	let number: Number
	let shape: Shape
	let shading: Shading
	var onBoard: Bool = false
	
	init(_ color: Colour, _ number: Number, _ shape: Shape, _ shading: Shading, id: Int) {
		self.color = color
		self.number = number
		self.shape = shape
		self.shading = shading
		self.id = id
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
