//
//  ChannelsViewController.swift
//  onice
//
//  Created by Chaitali Sawant on 04/12/24.
//

import UIKit

class ChannelsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = ChannelsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // Load channels when the view is loaded
        Task {
            await self.viewModel.loadChannels()
            self.collectionView.reloadData()
            
            if let errorMessage = self.viewModel.errorMessage {
                self.showAlert(errorMessage)
            }
        }
    }
}

    // MARK: - UICollectionView DataSource
extension ChannelsViewController : UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 //self.viewModel.channels.filter({ })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.channels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelCell", for: indexPath)
        let channel = self.viewModel.channels[indexPath.row]
        (cell.viewWithTag(100) as? UILabel)?.text = channel.name
        return cell
    }

    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
