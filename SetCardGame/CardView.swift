//
//  CardView.swift
//  SetCardGame
//
//  Created by Caleb Harris on 8/30/23.
//

import SwiftUI

/// Draw a card.
struct CardView: View {
	let card: Card
	let isFaceUp: Bool
	
	init(_ card: Card, isFaceUp: Bool = true) {
		self.card = card
		self.isFaceUp = isFaceUp
	}
	
	var body: some View {
		GeometryReader {geometry in
			ZStack {
				getCardWithShading()
				if isFaceUp {
					let shapes = getShape()
						.aspectRatio(Constants.shapeAspectRatio, contentMode: .fit)
						.frame(height: (geometry.size.width * Constants.cardAspectRatio) / 3)
						.foregroundColor(getColor())
					VStack {
						ForEach(0..<card.number.rawValue, id: \.self) {_ in
							shapes
						}
					}
				}
			}
		}
		.aspectRatio(Constants.cardAspectRatio, contentMode: .fit)
	}
	
	private func getColor() -> Color {
		switch card.color {
		case .one: return Color.red
		case .two: return Color.green
		case .three: return Color.purple
		}
	}
	
	@ViewBuilder private func getShape() -> some View {
		switch card.shape {
		case .one: DiamondShape()
		case .two: Rectangle()
		case .three: Ellipse()
		}
	}
	
	@ViewBuilder func getCardWithShading() -> some View {
		let base = RoundedRectangle(cornerRadius: 10)
		let baseBorder = base
			.strokeBorder(lineWidth: Constants.cardBorder)
			.foregroundColor(strokeColor())
		
		if isFaceUp {
			switch card.shading {
			case .one:
				base.fill(.white)
				baseBorder
			case .two:
				base.fill(.white)
				baseBorder
					.stripeBackground(color: .black, numStripes: 20)
			case .three:
				base.fill(.black)
				baseBorder
			}
		} else {
			base
		}
	}
	
	func strokeColor() -> Color {
		switch card.state {
		case .match: return Color.green
		case .nomatch: return Color.red
		case .select: return Color.yellow
		case .suggestion: return Color.blue
		default: return Color.black
		}
	}
	
	private struct Constants {
		static let cardAspectRatio: CGFloat = 2/3
		static let shapeAspectRatio: CGFloat = 2
		static let cardBorder: CGFloat = 5
	}
}

struct CardView_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			HStack {
				CardView(Card(.one, .one, .one, .one, id: 0))
				CardView(Card(.two, .one, .one, .one, id: 0))
				CardView(Card(.three, .one, .one, .one, id: 0))
			}
			HStack {
				CardView(Card(.one, .one, .one, .one, id: 0))
				CardView(Card(.one, .two, .one, .one, id: 0))
				CardView(Card(.one, .three, .one, .one, id: 0))
			}
			HStack {
				CardView(Card(.one, .one, .one, .one, id: 0))
				CardView(Card(.one, .one, .two, .one, id: 0))
				CardView(Card(.one, .one, .three, .one, id: 0))
			}
			HStack {
				CardView(Card(.one, .one, .one, .one, id: 0))
				CardView(Card(.one, .one, .one, .two, id: 0))
				CardView(Card(.one, .one, .one, .three, id: 0))
			}
		}.padding()
	}
}
