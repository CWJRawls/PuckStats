//
//  Player.swift
//  PuckStats
//
//  Created by Connor Rawls on 9/25/17.
//  Copyright © 2017 Connor Rawls. All rights reserved.
//

import Foundation


class Player : PlayerEquatable {

	var playerType: PlayerType
	var name : String
	var number : Int
	
	var gpCache : Int?
	
	//computing the number of games played by the number of records with non-nil shift arrays
	var gamesPlayed : Int {
		get {
			
			if let cachedData = gpCache {
				return cachedData
			}
			
			if let myGames = games {
				
				var played : Int = 0
				
				for game in myGames {
					if let _ = game.shifts { //just check that the player made the ice
						played += 1
					}
				}
				
				gpCache = played
				
				return played
			}
			
			return 0
		}
	}
	
	var corsiCache : Float?
	
	//for getting the corsi percentage
	var corsiPct : Float? {
		get {
			
			if let cachedData = corsiCache {
				return cachedData
			}
			
			if let myGames = games {
				var cf : Int = 0, ca : Int = 0
				
				for game in myGames {
					if let gshots = game.myShots {
						cf += gshots.count
					}
					if let shotsf = game.shotsFor {
						cf += shotsf.count
					}
					if let gshotsa = game.shotsAgainst {
						ca += gshotsa.count
					}
				}
				
				if cf == 0 && ca == 0 {
					return nil
				} else {
					let ct : Float = Float(cf + ca)
					let cp : Float = Float(cf) / ct
					
					corsiCache = cp * 100.0
					
					return cp * 100.0
				}
			}
			
			return nil
		}
	}
	
	var corsiRelCache : Float?
	
	//for getting the relative corsi percentage (-50, 50)
	var corsiRelPct : Float? {
		get {
			
			if let cachedData = corsiRelCache {
				return cachedData
			}
			
			if corsiPct != nil {
				var cp : Float = corsiPct!
				
				cp -= 50.0
				
				corsiRelCache = cp
				
				return cp
				
			} else {
				return nil
			}
		}
	}
	
	var fenwickCache : Float?
	
	//get the fenwick pct for the player
	var fenwickPct : Float? {
		get {
			
			if let cachedData = fenwickCache {
				return cachedData
			}
			
			if let myGames = games {
				var ff : Int = 0, fa : Int = 0
				
				for game in myGames {
					if let mshots = game.myShots {
						for shot in mshots {
							if shot.result.rawValue > 0 {
								ff += 1
							}
						}
					}
					if let shotsf = game.shotsFor {
						for shot in shotsf {
							if shot.result.rawValue > 0 {
								ff += 1
							}
						}
					}
					if let gshotsa = game.shotsAgainst {
						for shot in gshotsa {
							if shot.result.rawValue > 0 {
								fa += 1
							}
						}
					}
				}
				
				if ff == 0 && fa == 0 {
					return nil
				} else {
					let ft : Float = Float(ff + fa)
					let fp : Float = Float(ff) / ft
					
					fenwickCache = fp * 100.0
					
					return fp * 100.0
				}
			}
			
			return nil
		}
	}
	
	var fenwickRelCache : Float?
	
	//get the relative percent
	var fenwickRelPct : Float? {
		get {
			
			if let cachedData = fenwickRelCache {
				return cachedData
			}
			
			if let fenPct = fenwickPct {
				var fp : Float = fenPct
				fp -= 50.0
				
				fenwickRelCache = fp
				
				return fp
				
			} else {
				return nil
			}
		}
	}
	
	var shotPctCache : Float?
	
	var shotPct : Float? {
		get {
			
			if let cachedData = shotPctCache {
				return cachedData
			}
			
			if let myGames = games {
				var myGoals : Float = 0, myShots : Float = 0
				
				for game in myGames {
					if let goals = game.goals {
						myGoals += Float(goals.count)
					}
					if let shots = game.myShots {
						myShots += Float(shots.count)
					}
				}
				
				if myShots > 0 {
					
					shotPctCache = (myGoals / myShots) * 100.0
					
					return (myGoals / myShots) * 100.0
				}
			}
			
			return nil
		}
	}
	
	var TOICache : Int?
	
	//for getting the total time on the ice
	var TOI : Int? {
		get {
			
			if let cachedData = TOICache {
				return cachedData
			}
			
			var totTime = 0
			
			if let gameRec = games {
				for game in gameRec {
					if let mshifts = game.shifts {
						for shift in mshifts {
							totTime += shift.duration
						}
					}
				}
			}
			
			TOICache = totTime
			
			return totTime
		}
	}
	
	var avgTOICache : Int?
	
	//getting the average time on ice per game
	var avgTOI : Int? {
		get {
			
			if let cachedData = avgTOICache {
				return cachedData
			}
			
			let gp = gamesPlayed
			
			if gp > 0 {
				if let sumTime = TOI {
				
					let avgTime = sumTime / gp
					
					avgTOICache = avgTime
					
					return avgTime
				}
			}
			
			return nil
		}
	}
	
	var plusMinusCache : Int?
	
	var plusMinus : Int? {
		get {
			
			if let cachedData = plusMinusCache {
				return cachedData
			}
			
			if let myGames = games {
				
				var gf : Int = 0, ga : Int = 0
				
				for game in myGames {
					if let goalF = game.goalsFor {
						for goal in goalF {
							if goal.type.rawValue.type > 0 {
								gf += 1
							}
						}
					}
					
					if let goalM = game.goals {
						for goal in goalM {
							if goal.type.rawValue.type > 0 {
								gf += 1
							}
						}
					}
					
					if let goalA = game.goalsAgainst {
						for goal in goalA {
							if goal.type.rawValue.type > 1 {
								ga += 1
							}
						}
					}
				}
				
				plusMinusCache = gf - ga
				
				return gf - ga
			} else {
				return nil
			}
		}
	}
	
	var avgPlusMinusCache : Float?
	
	var avgPlusMinus : Float? {
		get {
			if let cachedData = avgPlusMinusCache {
				return cachedData
			}
			
			if let pm = plusMinus {
				let avgPM : Float = Float(pm) / Float(gamesPlayed == 0 ? 1 : gamesPlayed)
				
				avgPlusMinusCache = avgPM
				
				return avgPM
			}
			
			return nil
		}
	}
	
	var faceoffPctsCache : [Float]?
	
	var faceoffPcts : [Float]? {
		get {
			
			if let cachedData = faceoffPctsCache {
				return cachedData
			}
			
			if let fftot = faceoffsTaken,
				let ffouts = faceoffResults{
				var pcts = [Float]()
				
				let floatTot : Float = Float(fftot)
				
				let winPct : Float = Float(ffouts[0]) / floatTot
				let tiePct : Float = Float(ffouts[1]) / floatTot
				let lostPct : Float = Float(ffouts[2]) / floatTot
				
				pcts.append(winPct * 100.0)
				pcts.append(tiePct * 100.0)
				pcts.append(lostPct * 100.0)
				
				faceoffPctsCache = [Float]()
				
				faceoffPctsCache?.append(winPct * 100.0)
				faceoffPctsCache?.append(tiePct * 100.0)
				faceoffPctsCache?.append(lostPct * 100.0)
				
				return pcts
			}
			
			return nil
		}
	}
	
	//caching
	var faceoffsTakenCache : Int?
	
	var faceoffsTaken : Int? {
		get {
			
			if let cachedData = faceoffsTakenCache {
				return cachedData
			}
			
			if let myGames = games {
				var tot : Int = 0
				
				for game in myGames {
					if let ff = game.faceoffs {
						tot += ff.count
					}
				}
				
				faceoffsTakenCache = tot
				
				return tot
			}
			
			return nil
		}
	}
	
	//chached results
	var faceoffResultsCache : [Int]?
	
	var faceoffResults : [Int]? {
		get {
			//check first to see if we have done this recently
			if let cachedData = faceoffResultsCache {
				return cachedData
			}
			if let myGames = games {
				var won : Int = 0, tie: Int = 0, loss: Int = 0
				
				for game in myGames {
					if let ffs = game.faceoffs {
						for ff in ffs {
							switch ff.outcome {
							case .win:
								won += 1
							case .draw:
								tie += 1
							case .loss:
								loss += 1
							}
						}
					}
				}
				
				var res = [Int]()
				
				res.append(won)
				res.append(tie)
				res.append(loss)
				
				//fill in cached calculations
				faceoffResultsCache = [Int]()
				faceoffResultsCache?.append(won)
				faceoffResultsCache?.append(tie)
				faceoffResultsCache?.append(loss)
				
				return res
			}
			
			return nil
		}
	}
	
	var faceoffResultByZoneCache : [Int]?
	
	var faceoffResultByZone : [Int]? {
		get {
			if let cachedData = faceoffResultByZoneCache {
				return cachedData
			}
			
			if let myGames = games {
				var dwon : Int = 0, dtie : Int = 0, dloss : Int = 0,nwon : Int = 0, ntie : Int = 0, nloss : Int = 0,
				owon : Int = 0, otie : Int = 0, oloss : Int = 0
				
				for game in myGames {
					if let ffs = game.faceoffs {
						for ff in ffs {
							switch ff.outcome {
							case .win:
								switch ff.zone {
								case .def:
									dwon += 1
								case .neutral:
									nwon += 1
								case .off:
									owon += 1
								}
							case .draw:
								switch ff.zone {
								case .def:
									dtie += 1
								case .neutral:
									ntie += 1
								case .off:
									otie += 1
								}
							case .loss:
								switch ff.zone {
								case .def:
									dloss += 1
								case .neutral:
									nloss += 1
								case .off:
									oloss += 1
								}
							}
						}
					}
				}
				
				var res = [Int]()
				
				res.append(dwon)
				res.append(dtie)
				res.append(dloss)
				res.append(nwon)
				res.append(ntie)
				res.append(nloss)
				res.append(owon)
				res.append(otie)
				res.append(oloss)
				
				faceoffResultByZoneCache = res
				
				return res
			}
			
			return nil
		}
	}
	
	var faceoffCountByZoneCache : [Int]?
	
	var faceoffCountByZone : [Int]? {
		get {
			if let cachedData = faceoffCountByZoneCache {
				return cachedData
			}
			
			if let myGames = games {
				
				var dzone : Int = 0, nzone : Int = 0, ozone : Int = 0
				
				for game in myGames {
					
					if let ffs = game.faceoffs {
						for ff in ffs {
							switch ff.zone {
							case .def:
								dzone += 1
							case .neutral:
								nzone += 1
							case .off:
								ozone += 1
							}
						}
					}
				}
				
				var res = [Int]()
				
				res.append(dzone)
				res.append(nzone)
				res.append(ozone)
				
				faceoffCountByZoneCache = res
				
				return res
			}
			
			return nil
		}
	}
	
	var faceoffPctByZoneCache : [Float]?
	
	var faceoffPctByZone : [Float]? {
		get {
			if let cachedData = faceoffPctByZoneCache {
				return cachedData
			}
			
			if let counts = faceoffCountByZone,
				let outs = faceoffResultByZone {
				
				var owin : Float = 0.0, otie: Float = 0.0, oloss : Float = 0.0
				var nwin : Float = 0.0, ntie: Float = 0.0, nloss : Float = 0.0
				var dwin : Float = 0.0, dtie: Float = 0.0, dloss : Float = 0.0
				
				
				for (idx, out) in outs.enumerated() {
					if idx < 3 {
						switch idx {
						case 0:
							dwin = Float(out) / Float(counts[0] == 0 ? 1 : counts[0])
						case 1:
							dtie = Float(out) / Float(counts[0] == 0 ? 1 : counts[0])
						case 2:
							dloss = Float(out) / Float(counts[0] == 0 ? 1 : counts[0])
						default:
							Swift.print("Whoops, got somewhere I shouldn't be")
						}
					} else if idx < 6 {
						switch idx {
						case 3:
							nwin = Float(out) / Float(counts[1] == 0 ? 1 : counts[1])
						case 4:
							ntie = Float(out) / Float(counts[1] == 0 ? 1 : counts[1])
						case 5:
							nloss = Float(out) / Float(counts[1] == 0 ? 1 : counts[1])
						default:
							Swift.print("Whoops, got somewhere I shouldn't be")
						}
					} else if idx < 9 {
						switch idx {
						case 6:
							owin = Float(out) / Float(counts[2] == 0 ? 1 : counts[2])
						case 7:
							otie = Float(out) / Float(counts[2] == 0 ? 1 : counts[2])
						case 8:
							oloss = Float(out) / Float(counts[2] == 0 ? 1 : counts[2])
						default:
							Swift.print("Whoops, got somewhere I shouldn't be")
						}
					}
				}
				
				var res = [Float]()
				
				res.append(dwin)
				res.append(dtie)
				res.append(dloss)
				res.append(nwin)
				res.append(ntie)
				res.append(nloss)
				res.append(owin)
				res.append(otie)
				res.append(oloss)
				
				faceoffPctByZoneCache = res
				
				return res
				
			}
			
			return nil
		}
	}
	
	var goalsCache : Int?
	
	var goals : Int? {
		get {
			
			if let cachedData = goalsCache {
				return cachedData
			}
			
			if let myGames = games {
				
				var goalCount : Int = 0
				
				for game in myGames {
					if let scores = game.goals {
						goalCount += scores.count
					}
				}
				
				goalsCache = goalCount
				
				return goalCount
			}
			
			return nil
		}
	}
	
	var goalsPerGameCache : Float?
	
	var goalsPerGame : Float? {
		get {
			if let cachedData = goalsPerGameCache {
				return cachedData
			}
			
			if let scores = goals {
				let avgGoals : Float = Float(scores) / Float(gamesPlayed == 0 ? 1 : gamesPlayed)
				
				goalsPerGameCache = avgGoals
				
				return avgGoals
			}
			
			return nil
		}
	}
	
	var assistsCache: Int?
	
	var assists : Int? {
		get {
			if let cachedData = assistsCache {
				return cachedData
			}
			
			if let myGames = games {
				
				var assistCount : Int = 0
				
				for game in myGames {
					if let helpers = game.assists {
						assistCount += helpers.count
					}
				}
				
				assistsCache = assistCount
				
				return assistCount
			}
			
			return nil
		}
	}
	
	var assistsPerGameCache : Float?
	
	var assistsPerGame : Float? {
		get {
			if let cachedData = assistsPerGameCache {
				return cachedData
			}
			
			if let helps = assists {
				let avgAssists : Float = Float(helps) / Float(gamesPlayed == 0 ? 1 : gamesPlayed)
				
				assistsPerGameCache = avgAssists
				
				return avgAssists
			}
			
			return nil
		}
	}
	
	var pointsCache : Int?
	
	var points : Int? {
		get {
			if let cachedData = pointsCache {
				return cachedData
			}
			
			if let helpers = assists,
				let scores = goals {
				
				let totPoints = helpers + scores
				
				pointsCache = totPoints
				
				return totPoints
			}
			
			return nil
		}
	}
	
	var pointsPerGameCache : Float?
	
	var pointsPerGame : Float? {
		get {
			if let cachedData = pointsPerGameCache {
				return cachedData
			}
			
			if let scores = goals,
				let helps = assists {
				let ppg : Float = Float(scores + helps) / Float(gamesPlayed == 0 ? 1 : gamesPlayed)
				
				pointsPerGameCache = ppg
				
				return ppg
			}
			
			return nil
		}
	}
	
	var games : [GameRecord]?
	
	init(name: String, number: Int, type: PlayerType) {
		self.name = name
		self.number = number
		playerType = type
	}
	
	//clear all caches when new data is added
	func clearCache() {
		gpCache = nil
		corsiCache = nil
		corsiRelCache = nil
		fenwickCache = nil
		fenwickRelCache = nil
		shotPctCache = nil
		TOICache = nil
		avgTOICache = nil
		plusMinusCache = nil
		avgPlusMinusCache = nil
		faceoffPctsCache = nil
		faceoffsTakenCache = nil
		faceoffResultsCache = nil
		faceoffPctByZoneCache = nil
		faceoffResultByZoneCache = nil
		faceoffCountByZoneCache = nil
		goalsCache = nil
		goalsPerGameCache = nil
		assistsCache = nil
		assistsPerGameCache = nil
		pointsCache = nil
		pointsPerGameCache = nil
	}
	
	/* FUNCTIONS FOR HANDLING INPUT OF GAME DATA */
	
	func addNewGame(opponent opp: String, date: Date) {
		clearCache()
		if games == nil {
			games = [GameRecord]()
		}
		
		let newGame = GameRecord(opponent: opp, GameDate: date)
		
		games?.append(newGame)
	}
	
	func addShift(game g: GameRecord, shift: Shift) -> Bool {
		if let myGames = games {
			for (idx,game) in myGames.enumerated() {
				if g == game {
					games![idx].addShift(shift: shift)
					clearCache()
					return true//breakout early on success
				}
			}
		}
		
		return false
	}
	
	func addShot(game g: GameRecord, shot: Shot, fromSource src: EventSource) -> Bool {
		if let myGames = games {
			for (idx,game) in myGames.enumerated() {
				if g == game {
					games![idx].addShot(shot: shot, fromSource: src)
					clearCache()
					return true//breakout early on success
				}
			}
		}
		
		return false
	}
	
	func addGoal(game g: GameRecord, goal: Goal, fromSource src: EventSource) -> Bool {
		if let myGames = games {
			for (idx,game) in myGames.enumerated() {
				if g == game {
					games![idx].addGoal(goal: goal, fromSource: src)
					clearCache()
					return true//breakout early on success
				}
			}
		}
		
		return false
	}

	func addFaceoff(game g: GameRecord, faceoff ff: Faceoff) -> Bool {
		if let myGames = games {
			for (idx,game) in myGames.enumerated() {
				if g == game {
					games![idx].addFaceoff(faceoffEvent: ff)
					clearCache()
					return true//breakout early on success
				}
			}
		}
		
		return false
	}
	
	func addPass(game g: GameRecord, pass: Pass) -> Bool {
		if let myGames = games {
			for (idx,game) in myGames.enumerated() {
				if g == game {
					games![idx].addPass(pass: pass)
					clearCache()
					return true //breakout early on success
				}
			}
		}
		
		return false
	}
	
	func addAssist(game g: GameRecord, assist: Assist) -> Bool {
		if let myGames = games {
			for(idx, game) in myGames.enumerated() {
				if g == game {
					games![idx].addAssist(assist: assist)
					clearCache()
					return true
				}
			}
		}
		
		return false
	}
	
	func addPenalty(game g: GameRecord, penalty: Penalty) -> Bool {
		if let myGames = games {
			for(idx,game) in myGames.enumerated() {
				if g == game {
					games![idx].addPenalty(penalty: penalty)
					clearCache()
					return true
				}
			}
		}
		
		return false
	}
	
	func getGamePerformance(game g: GameRecord) -> Dictionary<GameDataType, Any?>? {
		
		if let myGames = games {
			for game in myGames {
				if g == game {
					return game.getGamePerformace(forPlayerType: self.playerType)
				}
			}
		}
		
		return nil
	}
	
	func getAllGamePerformance() -> [Dictionary<GameDataType, Any?>]? {
		
		if let myGames = games {
			
			var records = [Dictionary<GameDataType, Any?>]()
			
			for game in myGames {
				records.append(game.getGamePerformace(forPlayerType: self.playerType))
			}
			
			return records
		}
		
		return nil
	}
	
	func removeGame(opponent: String, date: Date) {
		if let myGames = games {
			for (idx, game) in myGames.enumerated() {
				if game.opp == opponent && game.date == date {
					games!.remove(at: idx)
					break //jump out of loop at first match
				}
			}
		}
	}
}

/*====================================================
 PLAYER HELPER TYPES
======================================================*/
enum PlayerType : Int {
	case F = 1
	case D = 5
	case G = 0
	case RD = 6
	case LD = 7
	case RW = 2
	case C = 3
	case LW = 4
}

protocol PlayerEquatable : Equatable {
	var name : String {get}
	var number : Int {get}
	var playerType : PlayerType {get}
}

func ==<T: PlayerEquatable>(lhs: T, rhs: T) -> Bool {
	return lhs.name == rhs.name && lhs.number == rhs.number && lhs.playerType == rhs.playerType
}


