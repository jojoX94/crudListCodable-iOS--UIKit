//
//  ViewController.swift
//  challenge10_12
//
//  Created by Madiapps on 22/07/2022.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var items = [Item]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedData = defaults.object(forKey: "itemData") as? Data {
            let JsonDecoder = JSONDecoder()
            
            do {
                items = try JsonDecoder.decode([Item].self, from: savedData)
            } catch {
                print("Failed to decode data")
            }
        } else {
            items = [Item(image: "", title: "Instagram", subtitle: "https://www.instagram.com"), Item(image: "", title: "Instagram", subtitle: "https://www.instagram.com")]
            save()
        }
        
        // Add navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
    }
    
    @objc func addNewItem() {
        let picker = UIImagePickerController()
        let ac = UIAlertController(title: "Use camera", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Camera", style: .default) {
            [weak self] action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
            } else {
                let acError = UIAlertController(title: "Your phone don't have camera, use gallery instead", message: nil, preferredStyle: .alert)
                acError.addAction(UIAlertAction(title: "Use gallery", style: .cancel))
                self?.present(acError, animated: true)
            }
            picker.allowsEditing = true
            picker.delegate = self
            self?.present(picker, animated: true)
        })
        ac.addAction(UIAlertAction(title: "Gallery", style: .default) {
                   [weak self] action in
                       picker.allowsEditing = true
                       picker.delegate = self
                       self?.present(picker, animated: true)
               })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
               
        present(ac, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let item = Item(image: imageName, title: "Unknown sdfdslj klsdjfldsjf sdklfjlsdkfjsd klsdjflkdsjf", subtitle: "Unknown site web skldjflsdj skldjflkds ksdljfklds kdjf dksjfldskf")
        items.append(item)
        save()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        let ac = UIAlertController(title: "Modify yout title", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        let submitAction = UIAlertAction(title: "Ok", style: .default) {
            [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else {return}
            item.title = newName
            self?.save()
            self?.tableView.reloadData()
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 214
    }
    
    func save() {
        let jsonEncode = JSONEncoder()
        if let savedData = try? jsonEncode.encode(items) {
            defaults.set(savedData, forKey: "itemData")
        } else {
            print("Failed to encode data")
        }
    }

}

