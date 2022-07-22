//
//  ViewController.swift
//  challenge10_12
//
//  Created by Madiapps on 22/07/2022.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var items = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        items = [Item(image: "", title: "Instagram", subtitle: "https://www.instagram.com"), Item(image: "", title: "Instagram", subtitle: "https://www.instagram.com")]
        
        // Add navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
    }
    
    @objc func addNewItem() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let item = Item(image: imageName, title: "Unknown", subtitle: "Unknown site web")
        items.append(item)
        tableView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductCellTableViewCell
        
        let item = items[indexPath.row]
        if item.image == "" {
            cell.img.image = UIImage(named: "logo.png")
        } else {
            let path = getDocumentsDirectory().appendingPathComponent(item.image)
            cell.img.image = UIImage(contentsOfFile: path.path)
        }
        
        cell.title.text = item.title
        cell.subtitle.text = item.subtitle
        cell.container.layer.cornerRadius = 10
        cell.container.layer.masksToBounds = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 214
    }
    

}

