//
//  PhotoDetail.swift
//
//

import UIKit

class PhotoDetail: UIViewController {
   
    var selectedIndex: Int!
    var selectedAlbum: Int!
    var selectedAlbumName: String!
    @IBOutlet var detalle: UIImageView!
    @IBOutlet var label: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let uri = String(selectedIndex)
        print(selectedIndex)
        let endpoint = "https://jsonplaceholder.typicode.com/photos?id=\(uri)"
        print(endpoint)
        guard let url = URL(string: endpoint) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
              
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
               
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                print(jsonArray)
                print(jsonArray[0])
                let url = URL(string: jsonArray[0]["url"] as! String)
                let titulo = jsonArray[0]["title"] as! String
                
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        self.detalle.image = UIImage(data: data!)
                        
                        self.label.textAlignment = .center
                
                       
                        self.label.text = titulo
                        
                    }
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "Back2")
        {
            let viewController : Album = segue.destination as! Album
            viewController.selectedIndex = selectedAlbum
            viewController.selectedAlbumName = selectedAlbumName
        }
        
    }
    
}

