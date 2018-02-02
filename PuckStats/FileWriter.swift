//
//  FileWriter.swift
//  PuckStats
//
//  Created by synthesis on 2/1/18.
//  Copyright © 2018 Connor Rawls. All rights reserved.
//
import Foundation

class FileWriter {
	
	//constant to get the documents directory
	let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
	
	//xml attributes
	let attributes = ["xmlns:xsi" : "http://www.w3.org/2001/XMLSchema-instance", "xmlns:xsd" : "http://www.w3.org/2001/XMLSchema"]
	
	//to hold the team
	var team : Team
	
	//initializer
	init(team: Team)
	{
		self.team = team
	}
	
	//if we want to change the team part way through
	func setTeam(team: Team)
	{
		self.team = team
	}
	
	//writing the data of the team to an xml file
	func writeToXMLFile()
	{
		//create the path to write to
		let path = documents.appending("\(team.name).team")
		
		//initialize the xml document
		let xmlDoc = AEXMLDocument()
		
		//create the root element for the xml string
		let teamElem = xmlDoc.addChild(name: "team")
		teamElem.addChild(name: "teamName", value: team.name)
		
		//check the swimmers on the team
		if let players = team.roster {
			
			//iterate through the swimmers
			for player in players {
				
				//create a new element for each swimmer
				let member = teamElem.addChild(name: "Player")
				
				//add the name and age as children
				member.addChild(name: "name", value: player.name)
				member.addChild(name: "number", value: "\(player.number)")
				
				//check if there are any games
				if let pGames = player.games {
					
					//create a child to hold the game shaifts
					let games = member.addChild(name: "games")
					
					//iterate throught the games
					for game in pGames {
						
						//create a child for each game
						let pGame = games.addChild(name: "game")
						
						if let shifts = game.shifts {
							
							for (_, shift) in shifts.enumerated() {
								let pShift = pGame.addChild(name:"shift")
								pShift.addChild(name: "period", value: "\(shift.period)")
								pShift.addChild(name: "start", value: "\(shift.start)")
								pShift.addChild(name: "duration", value: "\(shift.duration)")
							}
						}
					}
				}
			}
		}
		
		if let games = team.games {
			let gameNode = teamElem.addChild(name: "games")
			
			for game in games {
				let gameChild = gameNode.addChild(name: "game")
				gameChild.addChild(name: "opp", value: game.opp)
				gameChild.addChild(name: "date", value: "\(game.date.timeIntervalSince1970)")
			}
		}
		
		let xmlString : NSString = xmlDoc.xml as NSString
		do {
			print(xmlString)
			try xmlString.write(toFile: path, atomically: true, encoding: String.Encoding.utf16.rawValue )
		}
		catch {}
	}
	
}
