//
//  ShareView.swift
//  PTN 24
//
//  Created by bhavin on 18/08/17.
//  Copyright © 2017 bhavin. All rights reserved.
//

import UIKit

class ShareView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btn_Facebook(_ sender: UIButton) {
        UIApplication.tryURL(urls: [
            "fb://profile/307929082981556",
            "http://www.facebook.com/307929082981556"
        ])
    }
    
    @IBAction func btn_Youtube(_ sender: UIButton) {
        UIApplication.tryURL(urls: [
            "youtube://www.youtube.com/channel/UC6l8kF04meZBVP-zE9y1H0A",
            "https://www.youtube.com/channel/UC6l8kF04meZBVP-zE9y1H0A"
        ])
    }
    
    @IBAction func btn_Twitter(_ sender: UIButton) {
        UIApplication.tryURL(urls: [
            "twitter://user?screen_name=narendramodi",
            "https://twitter.com/narendramodi"
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
