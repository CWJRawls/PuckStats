//
//  ViewHelper.swift
//  PuckStats
//
//  Created by synthesis on 2/1/18.
//  Copyright © 2018 Connor Rawls. All rights reserved.
//

import Foundation
	
	//helper function to create a default gamerecord object
	func createDefaultGame() -> TeamGameRecord {
		var gameRec : TeamGameRecord
		
		let opp : String = "Default Team"
		let date : Date = Date.init()
		
		gameRec = TeamGameRecord(opponent:opp, date:date)
		return gameRec
	}
