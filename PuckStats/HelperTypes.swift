//
//  HelperType.swift
//  PuckStats
//
//  Created by Connor Rawls on 9/28/17.
//  Copyright © 2017 Connor Rawls. All rights reserved.
//

import Foundation

/*================================================================
Helper Types
================================================================*/

//struct for holding data about individual shift times
struct Shift {
	var start : Int = 0 //time in seconds that the shift started
	var duration : Int = 0 //time in seconds that the shift lasted
	var period : Period = Period(num: 1, duration: 1200) //the period of play that the shift ocurred in
}

//struct for holding data about the current period of play
struct Period {
	var num : Int = 1 //which period it is (starting at 1)
	var duration : Int = 1200 //length in seconds of the period (really to be used when aggregating stats across a game
}

//struct for holding data about penalties taken
struct Penalty {
	var mins : Int = 2 //length in mins of the penalty
	var time : Int = 0 //when in the period the penalty ocurred
	var period : Period = Period(num: 1, duration: 1200)
	var type : PenaltyType = PenaltyType.Tripping
}

//enum for the type of penalty taken
enum PenaltyType : String {
	case Hooking = "Hooking"
	case Roughing = "Roughing"
	case Tripping = "Tripping"
	case Slashing = "Slashing"
	case Holding = "Holding"
	case HighStick = "High Sticking"
	case Boarding = "Boarding"
	case Elbow = "Elbowing"
	case Body = "Body Contact"
	case Sport = "Unsportsmanlike"
	case Head = "Head Contact"
	case Delay = "Delay Of Game"
	case Many = "Too Many Players"
}

//struct to hold data about how many shots were taken
struct Shot {
	var time : Int = 0
	var result : ShotResult = ShotResult.Miss
	var period : Period = Period(num: 1, duration: 1200)
}

enum ShotResult : Int{
	case Miss = 1//used for corsi, fenwick
	case Block = 0 //used for corsi
	case OnGoal = 2 //used for corsi, fenwick, shooting pct
}

//struct for holding data about a goal
struct Goal {
	var period : Period = Period(num: 1, duration: 1200)
	var time : Int = 0 //time in seconds in the period at which the goal was scored
	var type : GoalType = GoalType.even
}

enum GoalType {
	case even
	case pp
	case sh
	case en
}

extension GoalType : RawRepresentable {
	typealias RawValue = GoalTypeRaw
	
	init?(rawValue: RawValue) {
		if rawValue.desc == "Even Strength" && rawValue.type == 1 {
			self = .even
		} else if  rawValue.desc == "Power Play" && rawValue.type == 0 {
			self = .pp
		} else if rawValue.desc == "Short-Handed" && rawValue.type == 2 {
			self = .sh
		} else if rawValue.desc == "Empty Net" && rawValue.type == 3 {
			self = .en
		} else {
			self = .even
		}
		
	}
	
	var rawValue : RawValue {
		switch self {
		case .even:
			return GoalTypeRaw(type: 1, desc: "Even Strength")
		case .pp:
			return GoalTypeRaw(type: 0, desc: "Power Play")
		case .sh:
			return GoalTypeRaw(type: 2, desc: "Short-Handed")
		case .en:
			return GoalTypeRaw(type: 3, desc: "Empty Net")
		}
	}
}

struct GoalTypeRaw {
	
	var type: Int = 0
	var desc: String = "Even Strength"
}


struct Assist {
	var period : Period = Period(num: 1, duration: 1200)
	var time : Int = 0
}

struct Faceoff {
	var period : Period
	var time : Int
	var zone : Zone
	var outcome : FaceoffOutcome
}

enum Zone {
	case off
	case neutral
	case def
}

extension Zone : RawRepresentable {
	typealias RawValue = ZoneTypeRaw
	
	init?(rawValue: RawValue) {
		if rawValue.desc == "Offensive" && rawValue.type == 0 {
			self = .off
		} else if  rawValue.desc == "Neutral" && rawValue.type == 1 {
			self = .neutral
		} else if rawValue.desc == "Defensive" && rawValue.type == 2 {
			self = .def
		} else {
			self = .neutral
		}
		
	}
	
	var rawValue : RawValue {
		switch self {
		case .off:
			return ZoneTypeRaw(type: 0, desc: "Offensive")
		case .neutral:
			return ZoneTypeRaw(type: 1, desc: "Neutral")
		case .def:
			return ZoneTypeRaw(type: 2, desc: "Defensive")
		}
	}
}

struct ZoneTypeRaw {
	
	var type: Int = 1
	var desc: String = "Neutral"
}

enum FaceoffOutcome {
	case win
	case draw
	case loss
}

extension FaceoffOutcome :RawRepresentable {
	typealias RawValue = FORaw
	
	init?(rawValue: RawValue) {
		if rawValue.desc == "Win" && rawValue.type == 0 {
			self = .win
		} else if rawValue.desc == "Draw" && rawValue.type == 1 {
			self = .draw
		} else if rawValue.desc == "Loss" && rawValue.type == 2 {
			self = .loss
		} else {
			self = .draw
		}
	}
	
	var rawValue : RawValue {
		switch self {
		case .win:
			return FORaw(type: 0, desc: "Win")
		case .draw:
			return FORaw(type: 1, desc: "Draw")
		case .loss:
			return FORaw(type: 2, desc: "Loss")
		}
	}
}

struct FORaw {
	var type: Int = 1
	var desc: String = "Draw"
}

struct Pass {
	var period : Period = Period(num: 1, duration: 1200)
	var time : Int = 0
	var complete : Bool = true
}
