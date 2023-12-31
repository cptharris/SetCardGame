//
//  ContentView.swift
//  SetCardGame
//
//  Created by Captain Harris on 8/23/23.
//

import SwiftUI

struct SetCardGameView: View {
	typealias Card = SetCardGame.Card
	
	@ObservedObject var gameKeeper: SetCardGameManager
	
	@Namespace private var cardNamespace
	
	var body: some View {
		VStack(spacing: 0) {
			cardView
			
			bottomPanel
				.padding(Constants.inset)
		}
		.padding(Constants.inset)
		.onAppear {
			withAnimation(Constants.halfSpeed.delay(1)) {
				gameKeeper.startingDeal()
			}
		}
	}
	
	private var bottomPanel: some View {
		HStack(spacing: 0) {
			cardStackView(cardSet: gameKeeper.deckCards, isFaceUp: false)
				.overlay {
					HStack(spacing: 2) {
						Text("S").foregroundColor(.red)
						Text("E").foregroundColor(.green)
						Text("T").foregroundColor(.blue)
					}
					.rotationEffect(.degrees(gameKeeper.deckCards.isEmpty ? 0 : 90))
					.font(.title)
				}
				.onTapGesture {
					withAnimation(Constants.halfSpeed) {
						gameKeeper.dealThree()
					}
				}
			Spacer()
			gameMenu
				.buttonStyle(.plain)
				.foregroundColor(.accentColor)
			Spacer()
			cardStackView(cardSet: gameKeeper.disCards, isFaceUp: true)
		}
	}
	
	private var gameMenu: some View {
		HStack(spacing: 15) {
			Button {
				withAnimation {
					gameKeeper.hint()
				}
			} label: {
				Label("", systemImage: "questionmark.circle")
					.foregroundColor(gameKeeper.matchExists ? .accentColor : .red)
					.disabled(!gameKeeper.matchExists)
			}
			
			Button {
				withAnimation(Constants.halfSpeed) {
					gameKeeper.shuffle()
				}
			} label: {
				Label("", systemImage: "shuffle")
			}
			
			Button {
				for i in 0...1 {
					withAnimation(Constants.halfSpeed.delay(Double(i))) {
						if i == 0 {
							gameKeeper.newGame()
						} else {
							gameKeeper.startingDeal()
						}
					}
				}
			} label: {
				Label("", systemImage: "play.square.stack")
			}
		}
	}
	
	private func CardViewEffect(_ card: Card, isFaceUp: Bool = true) -> some View {
		CardView(card, isFaceUp: isFaceUp)
			.matchedGeometryEffect(id: card.id, in: cardNamespace)
			.transition(.asymmetric(insertion: .identity, removal: .identity))
	}
	
	private func cardStackView(cardSet: [Card], isFaceUp: Bool) -> some View {
		ZStack {
			ForEach(cardSet) { card in
				CardViewEffect(card, isFaceUp: isFaceUp)
					.offset(card.offset)
					.rotationEffect(Angle(degrees: card.rot))
			}
		}
		.frame(width: Constants.miniCardWidth, height: Constants.miniCardWidth / Constants.cardAspectRatio)
		.padding(Constants.inset)
	}
	
	/// Draw all the dealt cards
	private var cardView: some View {
		GeometryReader { geometry in
			let gridItemWidth = max(gridItemWidthThatFits(
				count: gameKeeper.dealtCards.count,
				size: geometry.size,
				atAspectRatio: Constants.cardAspectRatio), Constants.minCardWidth)
			
			ScrollView {
				LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemWidth), spacing: 0)], spacing: 0) {
					ForEach(gameKeeper.dealtCards) { card in
						CardViewEffect(card)
							.padding(2)
							.onTapGesture {
								withAnimation(Constants.halfSpeed) {
									gameKeeper.choose(card)
								}
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
	
	private struct Constants {
		static let cardAspectRatio: CGFloat = 2/3
		static let shapeAspectRatio: CGFloat = 2
		static let miniCardWidth: CGFloat = 60
		static let minCardWidth: CGFloat = 70
		static let inset: CGFloat = 5
		static let halfSpeed: Animation = .default.speed(0.5)
	}
}

struct SetCardGameView_Previews: PreviewProvider {
	static var previews: some View {
		SetCardGameView(gameKeeper: SetCardGameManager())
	}
}
