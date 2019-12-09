//
//  Album.swift
//
//

import UIKit

class Album: UIViewController, iCarouselDataSource, iCarouselDelegate {
    var ids: [Int] = []
    var items: [String] = []
    var selectedIndex: Int!
    var selectedPhoto: Int!
    var selectedAlbum: Int!
    var selectedAlbumName: String!
    @IBOutlet var carousel2: iCarousel!
    @IBOutlet var label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.text = self.selectedAlbumName
        label.tag = 1
        let uri = String(selectedIndex)
        let endpoint = "https://jsonplaceholder.typicode.com/photos?albumId=\(uri)"
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
                for i in 0 ... jsonArray.count-1 {
                    self.items.append(jsonArray[i]["thumbnailUrl"] as! String )
                    self.ids.append(jsonArray[i]["id"] as! Int)
                }
                self.carousel2.reloadData()
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        carousel2.type = .coverFlow2
        
    }
    
   
    @IBAction func goback(_ sender: Any) {
        self .performSegue(withIdentifier: "Back1", sender: nil)
    }
    
    func numberOfItems(in carousel2: iCarousel) -> Int {
        
        return items.count
        
    }
    
    func carousel(_ carousel2: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
       
        var itemView: UIImageView
       
        if let view = view as? UIImageView {
            itemView = view
        } else {
            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            itemView.contentMode = .center
            let url = URL(string: items[index])
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    itemView.image = UIImage(data: data!)
                }
            }
            
           
        }
        
        return itemView
    }
    
    func carousel(_ carousel2: iCarousel, didSelectItemAt index: Int)
    {
        selectedPhoto = self.ids[index]

        self .performSegue(withIdentifier: "Detail", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "Detail")
        {
            let viewController : PhotoDetail = segue.destination as! PhotoDetail
            viewController.selectedAlbum = selectedIndex
            viewController.selectedIndex = selectedPhoto
            viewController.selectedAlbumName = selectedAlbumName
        }
        
    }
    
    func carousel(_ carousel2: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
    
}

