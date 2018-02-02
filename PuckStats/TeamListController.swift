//
//  TeamListController.swift
//  PuckStats
//
//  Created by synthesis on 2/1/18.
//  Copyright © 2018 Connor Rawls. All rights reserved.
//

import Foundation
import UIKit

class TeamListController : UITableViewController {
	
	
	var teams : [Team]!
	
	//the edit button is pressed
	@IBAction func toggleEditingMode(_ sender: UIButton)
	{
		print("Edit Pressed")
		if isEditing {
			sender.setTitle("Edit", for: .normal)
			setEditing(false, animated: true)
		}
		else {
			sender.setTitle("Done", for: .normal)
			setEditing(true, animated: true)
		}
	}
	
	//when the add button is pressed
	@IBAction func addNewItem(_ sender: UIButton)
	{
		print("New Pressed")
		let newTeam = Team()
		teams.append(newTeam)
		
		let index = teams.count - 1
		
		let indexPath = IndexPath(row: index, section: 0)
		tableView.insertRows(at: [indexPath], with: .automatic)
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return teams.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
		//let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
		
		if teams.count > indexPath.row {
			let item = teams[indexPath.row]
			
			cell.textLabel?.text = item.getName()
			
			return cell
		}
		
		cell.textLabel?.text = "No Swimmers"
		cell.detailTextLabel?.text = "No Times"
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete{
			teams.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toTeam" {
			if let row = tableView.indexPathForSelectedRow?.row {
				let team = teams[row]
				
				let detailViewController = segue.destination as! TeamViewController
				detailViewController.team = team
				detailViewController.teamList = self
			}
		}
		/*else if segue.identifier == "toExport"
		{
		//make sure files exist before trying to share them
		writer.writeToXMLFile()
		let detailViewController = segue.destination as! ExportViewController
		detailViewController.team = team
		}*/
	}
	
	
	func reloadCells(team: Team) {
		
		var paths = [IndexPath]()
		
		for (index, element) in teams.enumerated(){
			if team.compareNames(team: element){
				let indexPath = IndexPath(item: index, section: 0)
				paths.append(indexPath)
				
			}
		}
		
		if paths.count > 0 {
			tableView.reloadRows(at: paths, with: .top)
		}
	}
}
