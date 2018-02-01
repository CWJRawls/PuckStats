//
//  GameTypes.swift
//  PuckStats
//
//  Created by Connor Rawls on 9/28/17.
//  Copyright © 2017 Connor Rawls. All rights reserved.
//

import Foundation

/*===================================================================*/

class GameRecord : GameRecordEquat {
	var opp : String
	var date : Date
	
	var shifts : [Shift]?
	var penalties : [Penalty]?
	var myShots : [Shot]?
	var shotsFor : [Shot]?
	var shotsAgainst : [Shot]?
	var goals : [Goal]?
	var goalsFor : [Goal]?
	var assists : [Assist]?
	var goalsAgainst : [Goal]?
	var faceoffs : [Faceoff]?
	var passes : [Pass]?
	
	var cachedData : [GameDataType: Any?]?
	
	
	init(opponent opp : String, GameDate date: Date) {
		self.opp = opp
		self.date = date
	}
	
	func clearCache() {
		cachedData = nil
	}
	
	func addShift(shift: Shift) {
		if shifts == nil {
			shifts = [Shift]()
		}
		
		shifts?.append(shift)
		clearCache()
	}
	
	func addShot(shot : Shot, fromSource src: EventSource) {
		switch src {
		case .mine:
			if myShots == nil {
				myShots = [Shot]()
			}
			
			myShots?.append(shot)
		case.team:
			if shotsFor == nil {
				shotsFor = [Shot]()
			}
			
			shotsFor?.append(shot)
		case .against:
			if shotsAgainst == nil {
				shotsAgainst = [Shot]()
			}
			
			shotsAgainst?.append(shot)
		}
		
		clearCache()
	}
	
	
	func addFaceoff(faceoffEvent ff: Faceoff) {
		if faceoffs == nil {
			faceoffs = [Faceoff]()
		}
		
		faceoffs?.append(ff)
		clearCache()
	}
	
	func addGoal(goal: Goal, fromSource src: EventSource) {
		switch src {
		case .mine:
			if goals == nil {
				goals = [Goal]()
			}
			
			goals?.append(goal)
		case .team:
			if goalsFor == nil {
				goalsFor = [Goal]()
			}
			
			goalsFor?.append(goal)
		case .against:
			if goalsAgainst == nil {
				goalsAgainst = [Goal]()
			}
			
			goalsAgainst?.append(goal)
		}
		
		clearCache()
	}
	
	func addPass(pass: Pass) {
		if passes == nil {
			passes = [Pass]()
		}
		
		passes?.append(pass)
		clearCache()
	}
	
	func addPenalty(penalty: Penalty) {
		if penalties == nil {
			penalties = [Penalty]()
		}
		
		penalties?.append(penalty)
		clearCache()
	}
	
	func addAssist(assist: Assist) {
		if assists == nil {
			assists = [Assist]()
		}
		
		assists?.append(assist)
		clearCache()
	}
	
	func getGamePerformace(forPlayerType type: PlayerType) -> Dictionary<GameDataType, Any?> {

		return (type.rawValue == 0 ? getGoaliePerformance(): getSkaterPerformance())
		
	}
	
	func getGoaliePerformance() -> Dictionary<GameDataType, Any?> {
		var calcData = [GameDataType: Any?]()
		
		//info about the game
		calcData[.opponent] = self.opp
		calcData[.date] = self.date
		
		if let myShifts = shifts {
			var secs : Int = 0
			
			for shift in myShifts {
				secs += shift.duration
			}
			
			let mins : Float = Float(secs) / 60.0
			
			calcData[.mins] = mins
		} else {
			calcData[.mins] = nil
		}
		
		if let shotsA = shotsAgainst {
			var onNet : Int = 0
			
			for shot in shotsA {
				onNet += (shot.result == .OnGoal ? 1 : 0)
			}
			
			calcData[.shotsOnGoal] = onNet
			
			let goalsA = (goalsAgainst == nil ? 0 : goalsAgainst!.count)
			
			calcData[.goalsAgainst] = goalsA
			
			calcData[.saves] = onNet - goalsA
			calcData[.savePct] = (onNet > 0 ? (calcData[.saves] as! Float) / Float(onNet) : 0.0)
			
			let gaa : Float? = (calcData[.mins] != nil ? (Float(goalsA) / (calcData[.mins] as! Float)) * 60.0 : nil)
			
			calcData[.goalsAgainstAverage] = gaa
			
		} else {
			calcData[.shotsOnGoal] = nil
			calcData[.goalsAgainst] = nil
			calcData[.saves] = nil
			calcData[.savePct] = nil
			calcData[.goalsAgainstAverage] = nil
		}
		
		return calcData
	}
	
	func getSkaterPerformance() -> Dictionary<GameDataType, Any?> {
	
		if let data = cachedData {
			return data
		}
		
		var calcData = [GameDataType : Any?]()
		
		//game identifiers
		calcData[.opponent] = opp
		calcData[.date] = date
		
		//corsi and fenwick variables
		var cf: Int = 0,ca : Int = 0, ff : Int = 0, fa : Int = 0

		
		if let shots = myShots {
			
			//my shots on net
			var son : Int = 0
			
			for shot in shots {
				son += (shot.result.rawValue == 2 ? 1 : 0)
				cf += 1
				ff += (shot.result.rawValue > 0 ? 1 : 0)
			}
			
			if let scores = goals {
				let sPct : Float = Float(scores.count) / Float(son == 0 ? 1 : son)
				
				calcData[.shots] = son
				calcData[.shotPct] = sPct
				
			} else {
				calcData[.shots] = son
				calcData[.shotPct] = nil
			}
		} else  {
			calcData[.shots] = nil
			calcData[.shotPct] = nil
		}
		
		if let shots = shotsFor {
			for shot in shots {
				cf += 1
				ff += (shot.result.rawValue > 0 ? 1 : 0)
			}
		}
		
		if let shots = shotsAgainst {
			for shot in shots {
				ca += 1
				fa += (shot.result.rawValue > 0 ? 1 : 0)
			}
		}
		
		//corsi values
		let cSum : Float = Float(cf + ca)
		let cPct : Float = (Float(cf) / (cSum == 0 ? 1 : cSum)) * 100.0
		calcData[.corsi] = (cSum > 0 ? cPct : nil)
		calcData[.corsiRel] = (calcData[.corsi] != nil ? (calcData[.corsi] as! Float) - 50.0 : nil)
		
		//fenwick values
		let fSum : Float = Float(ff + fa)
		calcData[.fenwick] = (fSum > 0 ? (Float(ff) / fSum) * 100.0 : nil)
		calcData[.fenwickRel] = (calcData[.fenwick] != nil ? (calcData[.fenwick] as! Float) - 50.0 : nil)
		
		
		//shift count
		calcData[.shiftCount] = (shifts == nil ? nil : shifts!.count)
		
		if let myShifts = shifts {
			var totTime : Int = 0
			
			for shift in myShifts {
				totTime += shift.duration
			}
			
			calcData[.toi] = totTime
			
			calcData[.avgShiftLength] = (myShifts.count > 0 ? Float(totTime) / Float(myShifts.count) : 0.0)
		} else {
			calcData[.toi] = nil
			calcData[.avgShiftLength] = nil
		}
		
		//plus minus
		let myGoals : Int = (goals != nil ? goals!.count : 0)
		let goalsFors : Int = (goalsFor != nil ? goalsFor!.count : 0)
		let goalsA : Int = (goalsAgainst != nil ? goalsAgainst!.count : 0)
		
		calcData[.plusMinus] = (myGoals + goalsFors) - goalsA
		calcData[.goals] = myGoals
		
		//assists
		calcData[.assists] = (assists != nil ? assists!.count : 0)
		
		//points
		calcData[.points] = (goals != nil ? goals!.count : 0) + (assists != nil ? assists!.count : 0)
		
		//penalties
		if let myPims = penalties {
			var mins : Int = 0
			
			for pen in myPims {
				mins += pen.mins
			}
			
			calcData[.pims] = mins
			calcData[.penalties] = myPims.count
		} else {
			calcData[.pims] = 0
			calcData[.penalties] = 0
		}
		
		//faceoffs YAY
		if let ffs = faceoffs {
			
			//zone totals
			var dft : Int = 0, nft : Int = 0, oft : Int = 0, ft : Int = 0
			
			//zone outcomes
			var dw : Int = 0, dd : Int = 0, dl : Int = 0
			var nw : Int = 0, nd : Int = 0, nl : Int = 0
			var ow : Int = 0, od : Int = 0, ol : Int = 0
			
			for ff in ffs {
				ft += 1
				
				switch ff.zone {
				case .def:
					dft += 1
					
					switch ff.outcome {
					case .win:
						dw += 1
					case .draw:
						dd += 1
					case .loss:
						dl += 1
					}
					
				case .neutral:
					nft += 1
					
					switch ff.outcome {
					case .win:
						nw += 1
					case .draw:
						nd += 1
					case .loss:
						nl += 1
					}
				case .off:
					oft += 1
					
					switch ff.outcome {
					case .win:
						ow += 1
					case .draw:
						od += 1
					case .loss:
						ol += 1
					}
				}
			}
			
			//total faceoffs
			calcData[.faceoffsTaken] = ft
			
			//number of instances for each outcome
			var fCounts = [Int]()
			fCounts.append(dw + nw + ow)
			fCounts.append(dd + nd + od)
			fCounts.append(dl + nl + ol)
			calcData[.faceoffCounts] = fCounts
			
			//counts by zone
			var fCountsZ = [Int]()
			fCountsZ.append(dw)
			fCountsZ.append(dd)
			fCountsZ.append(dl)
			fCountsZ.append(nw)
			fCountsZ.append(nd)
			fCountsZ.append(nl)
			fCountsZ.append(ow)
			fCountsZ.append(od)
			fCountsZ.append(ol)
			calcData[.faceoffCountsByZone] = fCountsZ
			
			//percentages
			var fPcts = [Float]()
			fPcts.append((ft > 0 ? Float(fCounts[0]) / Float(ft) : 0.0))
			fPcts.append((ft > 0 ? Float(fCounts[1]) / Float(ft) : 0.0))
			fPcts.append((ft > 0 ? Float(fCounts[2]) / Float(ft) : 0.0))
			calcData[.faceoffPcts] = fPcts
			
			//percents by zone
			var fPctsZ = [Float]()
			fPctsZ.append((dft > 0 ? Float(fCountsZ[0]) / Float(dft) : 0.0))
			fPctsZ.append((dft > 0 ? Float(fCountsZ[1]) / Float(dft) : 0.0))
			fPctsZ.append((dft > 0 ? Float(fCountsZ[2]) / Float(dft) : 0.0))
			fPctsZ.append((nft > 0 ? Float(fCountsZ[3]) / Float(nft) : 0.0))
			fPctsZ.append((nft > 0 ? Float(fCountsZ[4]) / Float(nft) : 0.0))
			fPctsZ.append((nft > 0 ? Float(fCountsZ[5]) / Float(nft) : 0.0))
			fPctsZ.append((oft > 0 ? Float(fCountsZ[6]) / Float(oft) : 0.0))
			fPctsZ.append((oft > 0 ? Float(fCountsZ[7]) / Float(oft) : 0.0))
			fPctsZ.append((oft > 0 ? Float(fCountsZ[8]) / Float(oft) : 0.0))
			calcData[.faceoffPctsByZone] = fPctsZ
			
		} else {
			calcData[.faceoffsTaken] = nil
			calcData[.faceoffCounts] = nil
			calcData[.faceoffCountsByZone] = nil
			calcData[.faceoffPcts] = nil
			calcData[.faceoffPctsByZone] = nil
		}
		
		cachedData = calcData
		
		return calcData
	}
}

/*======================================
 GAME HELPER TYPES
======================================*/
enum EventSource {
	case mine
	case team
	case against
}

protocol GameRecordEquat : Equatable {
	var date : Date {get}
	var opp: String {get}
}

func ==<T: GameRecordEquat>(lhs: T, rhs: T) -> Bool {
	return lhs.date == rhs.date && lhs.opp == rhs.opp
}

enum GameDataType {
	case opponent
	case date
	case shots
	case shotPct
	case shiftCount
	case toi
	case avgShiftLength
	case corsi
	case corsiRel
	case fenwick
	case fenwickRel
	case plusMinus
	case faceoffsTaken
	case faceoffCounts
	case faceoffCountsByZone
	case faceoffPcts
	case faceoffPctsByZone
	case goals
	case assists
	case points
	case penalties
	case pims
	case shotsOnGoal
	case saves
	case savePct
	case goalsAgainst
	case goalsAgainstAverage
	case mins
}

