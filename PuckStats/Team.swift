//
//  Team.swift
//  PuckStats
//
//  Created by Connor Rawls on 10/1/17.
//  Copyright © 2017 Connor Rawls. All rights reserved.
//

import Foundation

class Team {
	var name : String
	var roster : [Player]?
	var games : [TeamGameRecord]?
	var inactive : [Player]?
	
	init(name : String) {
		self.name = name
	}
	
	func addPlayer(playerToAdd p: Player) {
		
		//check for duplication
		if let players = roster {
			for player in players {
				if player == p {
					return //exit on duplicate player
				}
			}
		}
		
		//make sure the roster exists
		roster = (roster == nil ? [Player]() : roster)
		
		//add the player
		roster!.append(p)
		
	}
	
	//for adding a new game
	func addGame(opponent opp: String, date: Date) {
		
		if let players = roster {
			for player in players {
				player.addNewGame(opponent: opp, date: date)
			}
		}
		
	}
	
	//for adding a game from file
	func addCompletedGame(gameRec: TeamGameRecord) {
		
	}
}
