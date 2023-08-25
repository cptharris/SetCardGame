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
			cardsView
				.animation(.default, value: gameKeeper.getOnBoardCards)
			
			Button("Deal 3") {
				gameKeeper.dealThree()
			}
			.disabled(gameKeeper.remainingCards == 0)
		}
		.padding(5)
	}
	
	private var cardsView: some View {
		GeometryReader { geometry in
			let _ = gameKeeper.setCardWidth(max( gridItemWidthThatFits(
				count: gameKeeper.getOnBoardCards.count,
				size: geometry.size,
				atAspectRatio: 2/3), 70))
			
			ScrollView {
				LazyVGrid(columns: [GridItem(.adaptive(minimum: gameKeeper.cardSize.width), spacing: 0)], spacing: 0) {
					ForEach(gameKeeper.getOnBoardCards) { card in
						CardView(card, gameKeeper)
							.aspectRatio(2/3, contentMode: .fit)
							.padding(2)
					}
				}
			}
		}
	}
	
	private func gridItemWidthThatFits(count: Int, size: CGSize, atAspectRatio aspectRatio: CGFloat) -> CGFloat {
		let count = CGFloat(count)
		var columnCount = 1.0
		repeat {
			let width = size.width / columnCount
			let height = width / aspectRatio
			let rowCount = (count / columnCount).rounded(.up)
			
			if rowCount * height < size.height {
				return (width).rounded(.down)
			}
			columnCount += 1
		} while columnCount < count
		return min(size.width / count, size.height * aspectRatio).rounded(.down)
	}
}

private struct CardView: View {
	let card: Card
	let gameKeeper: SetCardGameManager
	init(_ card: Card, _ gameKeeper: SetCardGameManager) {
		self.card = card
		self.gameKeeper = gameKeeper
	}
	
	var body: some View {
		ZStack {
			card.getCardWithShading()
			let base = card.getShape()
				.frame(width: (gameKeeper.cardSize.width) * 9 / 12,
					   height: (gameKeeper.cardSize.height / 3))
			VStack {
				base
				base.isHidden(card.number.rawValue > 1, remove: true)
				base.isHidden(card.number.rawValue > 2, remove: true)
			}
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
	
	func stripeBackground(color: Color) -> some View {
		self.background() {
			HStack(spacing: 0) {
				ForEach(0..<6) { number in
					Color.clear
					color.frame(width: 3)
					if number == 6 - 1 { // last
						Color.clear
					}
				}
			}
		}
	}
}

struct DiamondShape: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		path.addLines([
			CGPoint(x: 0, y: rect.height / 2),
			CGPoint(x: rect.width / 2, y: 0),
			CGPoint(x: rect.width, y: rect.height / 2),
			CGPoint(x: rect.width / 2, y: rect.height),
			CGPoint(x: 0, y: rect.height / 2)
		])
		return path
	}
}

struct SetCardGameView_Previews: PreviewProvider {
	static var previews: some View {
		SetCardGameView()
	}
}
