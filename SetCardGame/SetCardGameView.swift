//
//  ContentView.swift
//  SetCardGame
//
//  Created by Captain Harris on 8/23/23.
//

import SwiftUI

struct SetCardGameView: View {
	@ObservedObject var gameKeeper = SetCardGameManager()
	
	@Namespace private var cardNamespace
	
	var body: some View {
		VStack(spacing: 0) {
			cardView
			
			bottomPanel
				.padding(5)
		}
		.padding(5)
	}
	
	private var bottomPanel: some View {
		HStack {
			cardStackView(cardSet: gameKeeper.deckCards, isFaceUp: false)
				.overlay {
					HStack(spacing: 2) {
						Text("S").foregroundColor(.red)
						Text("E").foregroundColor(.green)
						Text("T").foregroundColor(.blue)
					}.rotationEffect(.degrees(90)).font(.title)
				}
				.onTapGesture {
					withAnimation {
						gameKeeper.dealThree()
					}
				}
			Spacer()
			gameMenu
			Spacer()
			cardStackView(cardSet: gameKeeper.disCards, isFaceUp: true)
		}
	}
	
	private var gameMenu: some View {
		Menu {
			Section {
				Button {
					gameKeeper.hint()
				} label: {
					Label("Hint", systemImage: "questionmark.circle")
				}
				Button {
					withAnimation {
						gameKeeper.shuffle()
					}
				} label: {
					Label("Shuffle", systemImage: "shuffle")
				}
			}
			Button {
				withAnimation {
					gameKeeper.newGame()
				}
			} label: {
				Label("New Game", systemImage: "play.square.stack")
			}
		} label: {
			Label("", systemImage: "square.and.pencil")
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
			}
		}
		.frame(width: Constants.miniCardWidth, height: Constants.miniCardWidth / Constants.cardAspectRatio)
	}
	
	/// Draw all the dealt cards
	private var cardView: some View {
		GeometryReader { geometry in
			let gridItemWidth = max(gridItemWidthThatFits(
				count: gameKeeper.dealtCards.count,
				size: geometry.size,
				atAspectRatio: Constants.cardAspectRatio), 70)
			
			ScrollView {
				LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemWidth), spacing: 0)], spacing: 0) {
					ForEach(gameKeeper.dealtCards) { card in
						CardViewEffect(card)
							.padding(2)
							.onTapGesture {
								withAnimation {
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
	}
}

struct SetCardGameView_Previews: PreviewProvider {
	static var previews: some View {
		SetCardGameView()
	}
}
