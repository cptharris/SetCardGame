//
//  SetCardGameApp.swift
//  SetCardGame
//
//  Created by Captain Harris on 8/23/23.
//

import SwiftUI

@main
struct SetCardGameApp: App {
	@StateObject var gameKeeper = SetCardGameManager()
	var body: some Scene {
		WindowGroup {
			SetCardGameView(gameKeeper: gameKeeper)
		}
	}
}
