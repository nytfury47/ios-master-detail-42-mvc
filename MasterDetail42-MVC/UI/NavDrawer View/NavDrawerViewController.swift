//
//  NavDrawerViewController.swift
//  MasterDetail42-MVC
//
//  Created by gerardo carlos roderico pejo tan on 2020/11/09.
//

import UIKit

// MARK: - NavDrawerViewController

class NavDrawerViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var lastVisit: UILabel!
  
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appTitle.text = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
        lastVisit.text = "Last visit: " + AppUserDefaults.shared.getLastVisit()
    }
    
}
