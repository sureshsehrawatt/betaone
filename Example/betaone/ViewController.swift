//
//  ViewController.swift
//  betaone
//
//  Created by 58142461 on 07/24/2025.
//  Copyright (c) 2025 58142461. All rights reserved.
//

import UIKit
import betaone

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("In ViewController viewDidLoad method!")
        
        let str1 = MyObjCClass.staticMessage()
        let str2 = MySwiftClass.staticMessage()
        print(str1 as Any)
        print(str2)
        
        let str3 = MySwiftClass.init()
        print(str3)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

