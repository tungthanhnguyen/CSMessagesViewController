//
//  Created by Jesse Squires
//  http://www.hexedbits.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//
//
//  Converted to Swift by Tung Thanh Nguyen
//  Copyright © 2016 Tung Thanh Nguyen.
//  Released under an MIT license: http://opensource.org/licenses/MIT
//
//  GitHub
//  https://github.com/tungthanhnguyen/CSMessagesViewController
//

import Foundation
import UIKit

class CSTableViewController: UITableViewController
{
	//////////////////////////////////////////////////////////////////////////////
	// MARK: - View lifecycle

	override func viewDidLoad()
	{
		super.viewDidLoad()

		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false

		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem()

		//self.title = "CSMessagesViewController"
		self.title = "MessageView Demo"
	}

	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)

		if (self.tableView.indexPathForSelectedRow != nil)
		{
			self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
		}
	}

	//////////////////////////////////////////////////////////////////////////////

	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 2
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return 2
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let CellIdentifier: String = "CellIdentifier"
		var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)

		if (cell == nil)
		{
			cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: CellIdentifier)
			cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
		}

		if (indexPath.section == 0)
		{
			switch indexPath.row
			{
			case 0:
				cell?.textLabel?.text = "Push via storyboard"

			case 1:
				cell?.textLabel?.text = "Push programmatically"

			default:
				break
			}
		}
		else if (indexPath.section == 1)
		{
			switch indexPath.row
			{
			case 0:
				cell?.textLabel?.text = "Modal via storyboard"

			case 1:
				cell?.textLabel?.text = "Modal programmatically"

			default:
				break
			}
		}

		return cell!
	}

	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
	{
		return (section == tableView.numberOfSections - 1) ? "Copyright © 2016\nTung Thanh Nguyen\nMIT License" : nil
	}

	/*
	// Override to support conditional editing of the table view.
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}
	*/

	/*
	// Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
				// Delete the row from the data source
				tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
				// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		}    
	}
	*/

	/*
	// Override to support rearranging the table view.
	override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

	}
	*/

	/*
	// Override to support conditional rearranging of the table view.
	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the item to be re-orderable.
		return true
	}
	*/

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Table view delegate

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		if (indexPath.section == 0)
		{
			switch indexPath.row
			{
			case 0:
				self.performSegue(withIdentifier: "seguePushDemoVC", sender: self)

			case 1:
				let vc: CSDemoViewController = CSDemoViewController()
				self.navigationController?.pushViewController(vc, animated: true)

			default:
				break
			}
		}
		else if (indexPath.section == 1)
		{
			switch indexPath.row
			{
			case 0:
				self.performSegue(withIdentifier: "segueModalDemoVC", sender: self)

			case 1:
				let vc: CSDemoViewController = CSDemoViewController()
				vc.delegateModal = self
				let nc: UINavigationController = UINavigationController(rootViewController: vc)
				self.present(nc, animated: true, completion: nil)

			default:
				break
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// MARK: - Segues

	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if segue.identifier == "segueModalDemoVC"
		{
			let nc: UINavigationController = segue.destination as! UINavigationController
			let vc: CSDemoViewController = nc.topViewController as! CSDemoViewController
			vc.delegateModal = self
		}
	}

	//////////////////////////////////////////////////////////////////////////////
}

////////////////////////////////////////////////////////////////////////////////
// MARK: - Demo delegate

extension CSTableViewController: CSDemoViewControllerDelegate
{
	func didDismissCSDemoViewController(_ vc: CSDemoViewController)
	{
		self.dismiss(animated: true, completion: nil)
	}
}

///////////////////////////////////////////////////////////////////////////////
