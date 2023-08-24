//
//  ContentView.swift
//  SetCardGame
//
//  Created by Caleb Harris on 8/23/23.
//

import SwiftUI

struct SetCardGameView: View {
	@ObservedObject var gameKeeper = SetCardGameManager()
	
	var body: some View {
		VStack(spacing: 0) {
			AspectVGrid(gameKeeper.getOnBoardCards, aspectRatio: 2/3) {card in
				CardView(card)
					.padding(2)
			}
			
			Button("Deal 3") {
				gameKeeper.dealThree()
			}
		}
		.padding(5)
	}
}

private struct CardView: View {
	let card: Card
	init(_ card: Card) {
		self.card = card
	}
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 10).fill(card.getColor())
			VStack {
				card.getShape().isHidden(card.number.rawValue > 1)
				card.getShape()
				card.getShape().isHidden(card.number.rawValue > 2, remove: true)
				card.getShape().isHidden(card.number.rawValue == 1, remove: true).opacity(0)
			}
			.font(.bold(.system(size: 300))())
			.minimumScaleFactor(0.01)
			.aspectRatio(2/3, contentMode: .fit)
		}
	}
}

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
}

struct SetCardGameView_Previews: PreviewProvider {
	static var previews: some View {
		SetCardGameView()
	}
}
