//
//  ViewController.swift
//  Glabbr
//
//  Created by Rajesh Dandu on 31/10/17.
//  Copyright © 2017 Rajesh Dandu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lbl_alert: UILabel!
    @IBOutlet weak var btn_sendMessage: UIButton!
    
    
    private var glabbrServer = GlabbrServer()
    private var glabbrStream = GlabbrStream()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btn_sendMessage.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 20.0, execute: {
            self.setUI()
        })
        
        glabbrServer.setupNetworkCommunication()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // hides the send button for 20 seconds while connecting to the Server.
    func setUI(){
        self.btn_sendMessage.isHidden = false
        self.lbl_alert.isHidden = true
    }
    // sends the packet to the socket server.
    func sendMessagetoServer(){
        let glabberGateWay = GlabbrGateWay(i: 10, l: 20, s: "Glabbr")
        let data =  glabbrStream.serialize(data: glabberGateWay)
        glabbrServer.sendMessage(data: data)
    }
    
    //MARK: - Action Methods
 
    @IBAction func sendAction(_ sender: Any) {
       
        sendMessagetoServer()
    }
 
}
extension ViewController:GlabberServerDelegate{
    func didReceivedMessage(message: String) {
        print(message)
    }
}

