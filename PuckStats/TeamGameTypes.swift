//
//  TeamGameTypes.swift
//  PuckStats
//
//  Created by Connor Rawls on 10/2/17.
//  Copyright © 2017 Connor Rawls. All rights reserved.
//

import Foundation

class TeamGameRecord : GameRecordEquat {

	var opp : String
	var date : Date
	
	init(opponent: String, date : Date){
		self.opp = opponent
		self.date = date
	}
	
	func getDescription() -> String {
		var desc : String = "vs. " + opp
		desc += date.description
		
		return desc
	}
	
}

/* HELPER TYPES */

//used for tracking where play was happening
struct ZoneTransition {
	var period : Period
	var time : Int //time in seconds
	var fromLoc : ZoneLocation //where play started
	var toLoc : ZoneLocation //where it transitioned to
}

enum ZoneLocation {
	case offensive
	case neutral
	case defensive
}

struct TeamShot {
	var source : EventSource
	var shooter : Player? //nil when shot by opposing team
	var shot : Shot //use original struct
}

struct TeamPenalty {
	var player : Player
	var penalty : Penalty //reuse completed type
}

struct TeamGoal {
	var source : EventSource
	var scorer : Player? //nil when against
	var assists : [Player]? //nil when against or unassissted
	var goal : Goal //use original struct
}

struct PlayerChange {
	var players : [Player] //a list of the current players on the ice
	var period : Period
	var time : Int
}

struct TeamFaceoff {
	var player : Player
	var faceoff : Faceoff //original struct
}

struct TeamPass {
	var player : Player
	var pass : Pass
}
