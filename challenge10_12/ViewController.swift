//
//  ViewController.swift
//  challenge10_12
//
//  Created by Madiapps on 22/07/2022.
//

import UIKit

class ViewController: UITableViewController {
    
    var items = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        items = [Item(image: "", title: "", subtitle: ""), Item(image: "", title: "", subtitle: "")]
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductCellTableViewCell
        
        cell.img.image = UIImage(named: "logo.png")
        cell.title.text = "Instagram"
        cell.subtitle.text = "https://www.instagram.com"
        cell.container.layer.cornerRadius = 10
        cell.container.layer.masksToBounds = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 214
    }
    

}

