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
			.isHidden(gameKeeper.remainingCards == 0, remove: true)
		}
		.padding(5)
	}
	
	private var cardsView: some View {
		GeometryReader { geometry in
			let gridItemWidth = max(gridItemWidthThatFits(
				count: gameKeeper.getOnBoardCards.count,
				size: geometry.size,
				atAspectRatio: 2/3), 70)
			
			ScrollView {
				LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemWidth), spacing: 0)], spacing: 0) {
					ForEach(gameKeeper.getOnBoardCards) { card in
						CardView(card: card)
							.aspectRatio(2/3, contentMode: .fit)
							.padding(2)
							.onTapGesture {
								gameKeeper.choose(card)
							}
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
	
	var body: some View {
		GeometryReader {geometry in
			ZStack {
				card.getCardWithShading()
				let shapes = card.getShape()
					.aspectRatio(2, contentMode: .fit)
					.frame(height: (geometry.size.width * 2/3) / 3)
					.foregroundColor(card.getColor())
				VStack {
					ForEach(0..<card.number.rawValue, id: \.self) {_ in
						shapes
					}
				}
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
	
	func stripeBackground(color: Color, numStripes: Int) -> some View {
		self.background() {
			HStack(spacing: 0) {
				ForEach(0..<numStripes, id: \.self) { number in
					Color.clear
					color.frame(width: 1)
					if number == numStripes - 1 {
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
