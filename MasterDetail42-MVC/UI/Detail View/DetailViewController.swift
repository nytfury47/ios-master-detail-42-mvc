//
//  DetailViewController.swift
//  MasterDetail42-MVC
//
//  Created by gerardo carlos roderico pejo tan on 2020/11/05.
//

import UIKit

// MARK: - DetailViewController

class DetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
  
    // MARK: - Variables And Properties
    
    var track: Track?
  
    // MARK: - View controller lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        trackImageView.sd_imageTransition = .fade
        trackImageView.sd_setImage(with: URL(string: track!.artwork ?? ""))
        titleLabel.text = track?.trackName
        genreLabel.text = "Genre: \(track?.genre ?? "")"
        priceLabel.text = "Price: $\(track?.price ?? 0.0)"
        detailTextView.text = track?.longDescription
    }
    
}
