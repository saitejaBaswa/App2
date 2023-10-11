//
//  ViewController.swift
//  App2
//
//  Created by Saiteja Goud Baswa on 09/10/23.
//

import UIKit
import Alamofire
import SDWebImage

struct ResponseData: Decodable {

    let support: Support
    let totalPages: Int
    let perPage: Int
    let data: [User]
    let total: Int
    let page: Int

    enum CodingKeys: String, CodingKey {

        case support
        case totalPages = "total_pages"
        case perPage = "per_page"
        case data
        case total
        case page
    }
}

struct Support: Decodable {

    let url: String
    let text: String
}
struct User: Decodable {

    let email: String
    let id: Int
    let lastName: String
    let firstName: String
    let avatar: String

    enum CodingKeys: String, CodingKey {
        case email
        case id
        case lastName = "last_name"
        case firstName = "first_name"
        case avatar
    }

}

class ViewController: UIViewController{
    @IBOutlet weak var searchBar: UISearchBar!
    

    var userDetails = [User]()
    var userItem = [User]()
    var searching = false
    @IBOutlet weak var dataTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.dataTableView.register(UINib(nibName:"TableViewCell", bundle: nil), forCellReuseIdentifier: "cell1")
        
        makeApiHit { result in
            print(result)
            DispatchQueue.main.async {
                self.userDetails = result
                self.dataTableView.reloadData()
            }
        }
    }
    func makeApiHit(completion: @escaping ([User])->()){
            let url = "https://reqres.in/api/users"
            AF.request(url).responseData { response in
                switch response.result {
                case .success(let jsonData):
                    let decoder = JSONDecoder()
                    do {
                        let responseData = try decoder.decode(ResponseData.self, from: jsonData)
                        completion(responseData.data)
                        print(responseData.data)
                    } catch {
                        print("Error decoding: \(error)")
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
extension ViewController:UITableViewDelegate,UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return userItem.count
        }else{
            return userDetails.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! TableViewCell
      //  cell.userImage.image =
        if searching{
            cell1.nameLabel.text = userItem[indexPath.row].firstName
            cell1.emailLable.text = userItem[indexPath.row].email
            cell1.userImage.sd_setImage(with: URL(string: "\(userItem[indexPath.row].avatar)"), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            cell1.nameLabel.text = userDetails[indexPath.row].firstName
            cell1.emailLable.text = userDetails[indexPath.row].email
            cell1.userImage.sd_setImage(with: URL(string: "\(userDetails[indexPath.row].avatar)"), placeholderImage: UIImage(named: "placeholder.png"))
            //userDetails[indexPath.row].firstName
            //        cell.emailLable.text = userDetails[indexPath.row].email
        }
        return cell1
            
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "DetailsViewController") as? DetailsViewController{
           // vc.img = sd_setImage(with: URL(string: "\(userDetails[indexPath.row].avatar)"), placeholderImage: UIImage(named: "placeholder.png"))
            if searching{
                vc.img = userItem[indexPath.row].avatar
                vc.firstName = userItem[indexPath.row].firstName
                vc.emailId = userItem[indexPath.row].email
                vc.lastName = userItem[indexPath.row].lastName
            }else{
                vc.img = userDetails[indexPath.row].avatar
                vc.firstName = userDetails[indexPath.row].firstName
                vc.emailId = userDetails[indexPath.row].email
                vc.lastName = userDetails[indexPath.row].lastName
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      /*  userItem = userDetails.filter({$0.firstName.prefix(searchText.count) == searchText} || {$0.email.prefix(searchText.count) == searchText})
        (
            {$0.firstName.prefix(searchText.count) == searchText})*/
        if searchBar.text == nil || searchBar.text == ""{
            searching = false
            self.dataTableView.reloadData()
        }else{
            searching = true

            userItem = userDetails.filter {
                $0.firstName.contains(searchText.lowercased())
                || $0.email.contains(searchText.lowercased())}

            self.dataTableView.reloadData()
        }
           
        
    }
}
