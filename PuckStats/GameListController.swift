//
//  GameListController.swift
//  PuckStats
//
//  Created by synthesis on 2/1/18.
//  Copyright © 2018 Connor Rawls. All rights reserved.
//

import Foundation
import UIKit

class GameListController : UITableViewController {
	
	//the team object (should be set by parent controller
	var team : Team!
	
	//The file writer object for updating team data
	var writer : FileWriter! //to be written
	
	
	@IBAction func toggeEditingMode(_ sender: UIButton) {
		if isEditing {
			sender.setTitle("Edit", for: .normal)
			setEditing(false, animated: true)
		} else {
			sender.setTitle("Done", for: .normal)
			setEditing(true, animated: true)
		}
	}
	
	@IBAction func addNewItem(_ sender: UIButton) {
		let game : TeamGameRecord = createDefaultGame()
		team.addGame(game: game)
		
		var index = 0
		
		if let games = team.games {
			index = games.count - 1
			
			let indexPath = IndexPath(row: index, section: 0)
			tableView.insertRows(at: [indexPath], with: .automatic)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let statusBarHeight = UIApplication.shared.statusBarFrame.height
		
		let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
		
		tableView.contentInset = insets
		tableView.scrollIndicatorInsets = insets
		
		writer = FileWriter(team: team) //to be written
		
		writer.writeToXMLFile() //to be written
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
		if let check = team.games {
			return check.count
		}
		
		return 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
		//let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
		
		if let check = team.games{
			let item = check[indexPath.row]
			
			cell.textLabel?.text = item.opp
			cell.detailTextLabel?.text = "\(item.date.description)"
			
			return cell
		}
		
		cell.textLabel?.text = "No Games"
		cell.detailTextLabel?.text = "No Dates"
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete{
			team.removeGame(atIndex: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}
}
