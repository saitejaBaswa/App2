//
//  DetailsViewController.swift
//  App2
//
//  Created by Saiteja Goud Baswa on 10/10/23.
//

import UIKit
let data = ResponseData.self

class DetailsViewController: UIViewController {

    @IBOutlet weak var userLastName: UILabel!
    @IBOutlet weak var UserImg: UIImageView!
    @IBOutlet weak var userFirstName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    var img = ""
    var firstName = ""
    var lastName = ""
    var emailId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        UserImg.layer.cornerRadius = 30
        // Do any additional setup after loading the view.
        UserImg.sd_setImage(with: URL(string: "\(img)"), placeholderImage: UIImage(named: "placeholder.png"))
        userFirstName.text = "FirstName: \(firstName)"
        userLastName.text = "LastName: \(lastName)"
        userEmail.text = "Email: \(emailId)"
       
 
    }
   


}
