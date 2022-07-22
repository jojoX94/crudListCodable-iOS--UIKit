//
//  ViewController.swift
//  challenge10_12
//
//  Created by Madiapps on 22/07/2022.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate , UISearchBarDelegate, UINavigationControllerDelegate {
    
    var items = [Item]()
    var initItems = [Item]()
    var filterITems = [Item]()
    let defaults = UserDefaults.standard
    
    @IBOutlet var searchBar: UISearchBar!
    
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
        initItems = items
        
        // Appearance of navbar
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance =
            navigationController?.navigationBar.standardAppearance
        }else{
            navigationController?.navigationBar.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
        }
        
        // Add navigation bar
        searchBar.delegate = self
        searchBar.placeholder = "Search your items"
        navigationItem.titleView = searchBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterITems = searchText.isEmpty ? initItems : initItems.filter {
            $0.title.lowercased().contains(searchText.lowercased() )
        }
        items = filterITems
        tableView.reloadData()
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
        
        let acChoice = UIAlertController(title: "Rename or delete person", message: nil, preferredStyle: .actionSheet)
        acChoice.addAction(UIAlertAction(title: "Rename", style: .default) {
            [weak self] action in
            let ac = UIAlertController(title: "Rename title", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "ok", style: .default) {
                [weak self, weak ac] _ in
                guard let newName = ac?.textFields?[0].text else {return}
                item.title = newName
                self?.save()
                self?.tableView.reloadData()
            })
            
            self?.present(ac, animated: true)
        })
        acChoice.addAction(UIAlertAction(title: "Delete", style: .default) {
            [weak self] action in
            self?.items.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .bottom)
            self?.save()
            self?.tableView.reloadData()
        })
        acChoice.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(acChoice, animated: true)
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

