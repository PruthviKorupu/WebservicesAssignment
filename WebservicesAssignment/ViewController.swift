//
//  ViewController.swift
//  WebservicesAssignment
//
//  Created by Prathi on 03/02/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var breeds: [Dog] = [Dog]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "BreedsCell", bundle: nil), forCellReuseIdentifier: "BreedsCell")
//        register(BreedsCell.self, forCellReuseIdentifier: "BreedsCell")
        tableView.delegate = self
        tableView.dataSource = self
        loadBreeds()
        // Do any additional setup after loading the view.
    }
    
    func loadBreeds() {
        APIRequest().requestAPIInfo { [weak self] result in
            switch result {
            case .success(let dogs):
                self?.breeds = dogs
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreedsCell") as! BreedsCell
        cell.setUpView(with: breeds[indexPath.row])
        return cell
    }
}


struct Dog {
    let name: String
    let subBreed: [String]?
}

 
struct APIRequest {
    
    var resourceURL: URL
    let urlString = "https://dog.ceo/api/breeds/list/all"
   
    init() {
        resourceURL = URL(string: urlString)!
    }
    
    //create method to get decode the json
    func requestAPIInfo(completion: @escaping(Result<[Dog], Error>) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { (data, response, error) in
            
            guard error == nil else {
                print (error!.localizedDescription)
                print ("stuck in data task")
                return
            }
            
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
                var breeds = [Dog]()
                guard let breedsJson = json["message"] as? [String: [String]] else { return }
                for breedName in breedsJson.keys {
                    let subBreed = breedsJson[breedName]
                    let dog = Dog(name: breedName, subBreed: subBreed)
                    breeds.append(dog)
                }
                completion(.success(breeds))
            } catch {
                print("error")
            }
        }
        dataTask.resume()
    }
}

