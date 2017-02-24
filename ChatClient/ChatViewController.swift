//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Lum Situ on 2/22/17.
//  Copyright © 2017 Lum Situ. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var chatText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var messages: [PFObject] = []
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatViewController.refreshMessages), userInfo: nil, repeats: true)
        
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSendButton(_ sender: Any)
    {
        let chat = PFObject(className: "Message")
        
        chat["text"] = chatText.text
        chat["user"] = PFUser.current()
        
        chat.saveInBackground
            {
            (success: Bool, error: Error?) -> Void in
            if (success)
            {
                print("Success!")
                // The object has been saved.
            } else
            {
                print("Error: \(error?.localizedDescription)")
                // There was a problem, check error.description
            }
            }
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        let message = messages[indexPath.row]
        let user = message["user"] as? PFUser
        let userName = user?.username
        
        let text = message["text"] as? String
        
        cell.userLabel.text = userName
        cell.chatLabel.text = text
        
        self.tableView.reloadData()
        
        return cell
    }
    
    func refreshMessages()
    {
        let query = PFQuery(className:"Message")
        query.includeKey("user")
        query.findObjectsInBackground
        {
                (objects: [PFObject]?, error: Error?) -> Void in
                
                if error == nil
                {
                    // The find succeeded.
                    //print("yeeee")
                    // Do something with the found objects
                    if let object = objects
                    {
                        self.messages = object
                    }
                } else
                {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.localizedDescription)")
                }
                self.tableView.reloadData()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
}
