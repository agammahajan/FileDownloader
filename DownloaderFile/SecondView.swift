//
//  SecondView.swift
//  DownloaderFile
//
//  Created by Agam Mahajan on 11/08/16.
//  Copyright © 2016 Agam Mahajan. All rights reserved.
//

import Foundation
import UIKit

class SecondView : UIViewController {
    
    @IBOutlet var Image: UIImageView!
    override func viewDidLoad() {
        let data = NSData(contentsOfURL: destinationUrl!)
        Image.image = UIImage(data: data!)
    }
}
