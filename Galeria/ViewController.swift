//
//  ViewController.swift
//  Galeria
//
//  Created by Juan de la Parra


import UIKit

class ViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    var items: [String] = []
    var selectedIndex: Int!
    var selectedAlbum: Int!
    var selectedAlbumName: String!
    @IBOutlet var carousel: iCarousel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                //print(jsonResponse) //Response result
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                
                guard let title = jsonArray[0]["title"] as? String else { return };
                print(title) //compiler outout -  delectus aut autem
                for i in 0 ... 99 {
                    self.items.append(jsonArray[i]["title"] as! String )
                   
                }
                self.carousel.reloadData()
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        carousel.type = .coverFlow2
        
        
        
    }

    func numberOfItems(in carousel: iCarousel) -> Int {
        return items.count
        
    }

    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        var itemView: UIImageView

       
        if let view = view as? UIImageView {
            itemView = view
            label = itemView.viewWithTag(1) as! UILabel
        } else {
            
            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            itemView.image = UIImage(named: "page.png")
            itemView.contentMode = .center

            label = UILabel(frame: itemView.bounds)
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.font = label.font.withSize(15)
            label.tag = 1
            itemView.addSubview(label)
        }

        label.text = "\(items[index])"
      

        return itemView
    }

    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int)
    {
        selectedIndex = index+1
        selectedAlbumName = items[index]
       
        self .performSegue(withIdentifier: "Albumsegue", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "Albumsegue")
        {
            let viewController : Album = segue.destination as! Album
            viewController.selectedIndex = selectedIndex
            viewController.selectedAlbum = selectedAlbum
            viewController.selectedAlbumName = selectedAlbumName
             print(selectedAlbumName)
        }
    }

}

