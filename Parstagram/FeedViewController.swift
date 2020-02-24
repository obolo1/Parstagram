//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Papa Kwaku  on 1/28/20.
//  Copyright © 2020 codepath. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchPosts()
        tableView.reloadData()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
            as! PostCell
        
        let post = posts[indexPath.row]
        
        let user = post["author"] as! PFUser
        cell.usernameLabel.text = user.username!
        cell.captionLabel.text = post["caption"] as? String
        
        let imageFile = post["image"] as! PFFileObject
        
        imageFile.getDataInBackground { (data, error) in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
                cell.photoView.image = UIImage(data: data!)
            }
        }
        
        
//        let UrlString = imageFile.url!
//        print(UrlString)
//        let url = URL(string: UrlString)!
//
//
//        cell.photoView.af_setImage(withURL: url)
        
        return cell
    }
    
    func fetchPosts() {
        
        let query = PFQuery(className:"Posts")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                print("Posts were found!")
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }
}
