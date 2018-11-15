//
//  TableViewController.swift
//  Transition
//
//  Created by Alexey Donov on 15.11.2018.
//  Copyright © 2018 Alexey Donov. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    private lazy var sunset = UIImage(named: "Image")
    
    var segueImageView: UIImageView?

    // MARK: - Table view data source
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Gallery"
        navigationController?.addCustomTransitioning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath)

        cell.imageView?.image = sunset
        cell.textLabel?.text = "Image #\(indexPath.row)"

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imageViewController = segue.destination as? ImageViewController {
            imageViewController.title = (sender as? UITableViewCell)?.textLabel?.text
            
            segueImageView = (sender as? UITableViewCell)?.imageView
            imageViewController.image = sunset
        }
    }

}
