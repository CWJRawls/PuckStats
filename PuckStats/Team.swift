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
	
	func addGame(game: TeamGameRecord) {
		
		if games == nil {
			self.games = [TeamGameRecord]()
		}
		games!.append(game)
		
		if let players = roster {
			for player in players {
				player.addNewGame(opponent: game.opp, date: game.date)
			}
		}
	}
	
	//for adding a new game
	func addGame(opponent opp: String, date: Date) {
		
		let newGame = TeamGameRecord(opponent: opp, date: date)
		
		if let players = roster {
			for player in players {
				player.addNewGame(opponent: opp, date: date)
			}
		}
		
		games?.append(newGame)
		
	}
	
	//for adding a game from file
	func addCompletedGame(gameRec: TeamGameRecord) {
		games?.append(gameRec)
	}
	
	func getGameList() -> [String] {
		var gameDesc : [String] = [String]()
		
		//generate string desciptions of games played
		if let myGames = games {
			for game in myGames {
				gameDesc.append(game.getDescription())
			}
		}
		//check if there are any entries in the array or respond with placeholder text
		if gameDesc.count == 0 {
			gameDesc.append("No Games Available")
		}
		
		return gameDesc
	}
	//remove a game
	func removeGame(atIndex idx: Int) {
		if let _ = games {
			if games!.count > idx { //check if the game even exists
				
				if let players = roster {
					for player in players {
						player.removeGame(opponent: games![idx].opp, date: games![idx].date)
					}
				}
				
				games!.remove(at: idx)
			}
		}
	}
}
