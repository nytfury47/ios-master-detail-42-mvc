//
//  MasterViewController.swift
//  MasterDetail42-MVC
//
//  Created by gerardo carlos roderico pejo tan on 2020/11/05.
//

import UIKit
import SDWebImage

// MARK: - MasterViewController

class MasterViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var drawerView: UIView!
    @IBOutlet weak var drawerViewBack: UIButton!
    
    // MARK: - Constants
    
    private let kListCellReuseIdentifier: String = "TrackListCell"
    private let kGridCellReuseIdentifier: String = "TrackGridCell"
    private let kGridLayoutItemsPerRow: CGFloat = 3
    private let kListCellWidth: CGFloat = UIScreen.main.bounds.width
    private let kListCellHeight: CGFloat = 100
    private let kGridCellWidth: CGFloat = 100
    private let kGridCellHeight: CGFloat = 128
    private let kSegueToDetailViewIdentifier: String = "ShowTrackDetails"
    
    // MARK: - Variables And Properties
    
    var tracks: [Track]? {
        didSet {
            if isViewLoaded {
                updateNavBarTitle()
                reloadCollectionView()
                activityIndicator.stopAnimating()
            }
        }
    }
    
    private var isListLayout: Bool = AppUserDefaults.shared.getIsListLayout()
    private var isDrawerViewOpen: Bool = false
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load track data
        TrackRepository.loadTracks { (tracks, success) in
            if success == true {
                self.tracks = tracks
            } else {
                self.alertNetworkError()
            }
        }
        
        // Ready the views
        setupViews()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      super.prepare(for: segue, sender: sender)
      
      if
        segue.identifier == kSegueToDetailViewIdentifier,
        let detailViewController = segue.destination as? DetailViewController,
        let trackCell = sender as? UICollectionViewCell,
        let row = collectionView.indexPath(for: trackCell)?.row
      {
        detailViewController.track = tracks?[row]
      }
    }
    
    // MARK: - Master View manipulation methods
    
    func setupViews() {
        // Update navigation bar elements
        updateNavBar()
        
        // Update the navigation drawer frame
        updateDrawerView()
        
        // Initialize flow layout
        collectionView.collectionViewLayout = {
            let collectionFlowLayout = UICollectionViewFlowLayout()
            collectionFlowLayout.itemSize = CGSize(width: kGridCellWidth, height: kGridCellHeight)
            return collectionFlowLayout
        }()
    }
    
    func updateNavBar() {
        updateNavBarTitle()
        updateLeftBarButton()
        updateRightBarButton()
    }
    
    func updateNavBarTitle() {
        title = "Tracks (\(tracks?.count ?? 0))"
    }
    
    func updateLeftBarButton() {
        let image = UIImage(named: "menu")
        let drawerViewButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(drawerViewButtonTapped(sender:)))
        navigationItem.setLeftBarButton(drawerViewButton, animated: true)
    }
    
    func updateRightBarButton() {
        let image = UIImage(named: isListLayout ? "grid" : "list_icon")
        let toggleButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(toggleLayoutButtonTapped(sender:)))
        navigationItem.setRightBarButton(toggleButton, animated: true)
    }
    
    func updateDrawerView() {
        var drawerViewFrame = collectionView.frame
        drawerViewFrame.size.width *= 0.7
        drawerViewFrame.origin.x = -drawerViewFrame.width
        drawerView.frame = drawerViewFrame
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func toggleLayoutButtonTapped(sender: UIBarButtonItem) {
        if isDrawerViewOpen {
            return
        }
        
        isListLayout = !isListLayout
        AppUserDefaults.shared.setIsListLayout(isListLayout)
        updateRightBarButton()
        reloadCollectionView()
    }
    
    @objc func drawerViewButtonTapped(sender: UIBarButtonItem?) {
        toggleDrawerView()
    }
    
    @IBAction func drawerViewBackButtonTapped(_ sender: UIButton) {
        toggleDrawerView()
    }
    
    func toggleDrawerView() {
        var drawerViewFrame = drawerView.frame
        drawerViewFrame.origin.x = isDrawerViewOpen ? -drawerViewFrame.size.width : 0;
        
        UIView.animate(withDuration: 0.3) {
            self.drawerView.frame = drawerViewFrame
            self.drawerViewBack.alpha = self.isDrawerViewOpen ? 0 : 0.7
        }
        
        isDrawerViewOpen = !isDrawerViewOpen
        drawerViewBack.isEnabled = isDrawerViewOpen
    }
    
    func alertNetworkError() {
        let alert = UIAlertController(title: "Network Error", message: "Error occurred in fetching data from remote source. Please check your internet.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
        activityIndicator.stopAnimating()
    }
    
}

// MARK: - Collection View Data Source

extension MasterViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isListLayout {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kListCellReuseIdentifier, for: indexPath) as! TrackListCell
            if let track = tracks?[indexPath.row] {
                cell.trackImage.sd_imageTransition = .fade
                cell.trackImage.sd_setImage(with: URL(string: track.artwork ?? ""))
                cell.trackTitle.text = track.trackName
                cell.trackGenre.text = track.genre
                cell.trackPrice.text = "$\(track.price)"
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGridCellReuseIdentifier, for: indexPath) as! TrackGridCell
            if let track = tracks?[indexPath.row] {
                cell.trackImage.sd_imageTransition = .fade
                cell.trackImage.sd_setImage(with: URL(string: track.artwork ?? ""))
                cell.trackPrice.text = "$\(track.price)"
            }
            return cell
        }
    }
    
}

// MARK: - Collection View Flow Layout Delegate

extension MasterViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = isListLayout ? kListCellWidth : kGridCellWidth
        let heightPerItem = isListLayout ? kListCellHeight : kGridCellHeight
        return CGSize(width: widthPerItem, height: CGFloat(heightPerItem))
    }
    
}
