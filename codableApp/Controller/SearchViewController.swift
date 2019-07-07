//
//  ViewController.swift
//  codableApp
//
//  Created by Or paz tal on 02/07/2019.
//  Copyright © 2019 Or paz tal. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noResultsView: UIView!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var searchData: SearchResultsMetaData?
    var results = [ItemMetaData]()
    
    var itemsPerRow: CGFloat = 3
    var loadMore: Bool = false
    var selectedIndex = -1
    
    let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewSetup()
        searchBar.delegate = self
        shouldDisplayIndicator(shouldDisplay: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setMusicImage()
    }
    
    func collectionViewSetup() {
        let nib = UINib(nibName: GifCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: GifCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let imageView : UIImageView = {
            let iv = UIImageView()
            iv.image = #imageLiteral(resourceName: "bananas")
            iv.contentMode = .scaleAspectFill
            return iv
        }()
        collectionView.backgroundView = imageView
    }
    
    func setMusicImage() {
        let img = MusicManager.shared.isMusicPlaying ? #imageLiteral(resourceName: "pause") : #imageLiteral(resourceName: "play")
        musicButton.setImage(img, for: .normal)
    }
    
    func shouldDisplayIndicator(shouldDisplay: Bool) {
        if shouldDisplay {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
        indicator.isHidden = !shouldDisplay
    }
    
    func showHideNoResultsView(noResults: Bool) {
        DispatchQueue.main.async {
            self.collectionView.isHidden = noResults
            self.noResultsView.isHidden = !noResults
        }
    }
    
    func showAlert(title: String, text: String, preferredStyle: UIAlertControllerStyle = .alert) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: preferredStyle)
        
        switch preferredStyle {
        case .alert:
            let action = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(action)
            
        case .actionSheet:
            let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelActionButton)
            
            let option1 = UIAlertAction(title: "2", style: .default) { _ in
                self.itemsPerRow = 2
                self.collectionView.reloadData()
            }
            alert.addAction(option1)
            
            let option2 = UIAlertAction(title: "3", style: .default) { _ in
                self.itemsPerRow = 3
                self.collectionView?.reloadData()
            }
            alert.addAction(option2)
            
            let option3 = UIAlertAction(title: "4", style: .default) { _ in
                self.itemsPerRow = 4
                self.collectionView?.reloadData()
            }
            alert.addAction(option3)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fullImageVCSegue", let vc = segue.destination as? FullImageViewController {
            vc.itemData = results[selectedIndex]
        }
    }
    
    @IBAction func displayOptionsButtonTapped(_ sender: Any) {
        showAlert(title: "Gif Search App", text: "Choose number of Images per row", preferredStyle: .actionSheet)
    }
    
    @IBAction func musicButtonTapped(_ sender: Any) {
        MusicManager.shared.setUpMusic()
        setMusicImage()
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifCollectionViewCell.identifier, for: indexPath) as? GifCollectionViewCell {
            let data = results[indexPath.row]
            cell.configureCell(withData: data, indexPath: indexPath)
            return cell
        }
        
        // should not get here
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "fullImageVCSegue", sender: self)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // there will be n + 1 evenly sized spaces, where n is the number of items in the row
        // the space size can be taken from the left section inset
        // subtracting this from the view's width and dividing by the number of items in a row gives you the width for each item
        let paddingSpace: CGFloat = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / (itemsPerRow + 1)
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    // return the spacing between the cells, headers, and footers. Used a constant for that
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // controls the spacing between each line in the layout. this should be matched the padding at the left and right
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.loadMore = true
        
        guard let searchText = searchBar.text, searchText.count > 0 else {
            self.results.removeAll()
            self.collectionView.reloadData()
            self.loadMore = false
            showAlert(title: "Oops", text: "You didn't typed anything\n Please enter a value to search")
            return
        }
        
        self.searchData = nil
        self.results.removeAll()
        self.collectionView.reloadData()
        callSearchApi(searchText: searchText, offset: 0)
    }
    
    func searchBarViewSearchEndWithError(withError error: String) {
        print(error)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height && !loadMore {
            loadMore = !loadMore
            didScrollToBottom()
        }
    }
    
    func didScrollToBottom() {
        if let text = searchBar.text, let totalItems = searchData?.pagination?.total_count {
            if results.count < totalItems {
                callSearchApi(searchText: text, offset: results.count)
            }
        }
    }
    
    func callSearchApi (searchText: String, offset: Int) {
        GiphyManager.shared.giphySearchQuery(query: searchText, offset: offset) { results, error in

            if let error = error {
                print("Error searching: \(error)")
                self.showHideNoResultsView(noResults: true)
                return
            }
            
            if let results = results {
                self.searchData = results
                for item in results.data {
                    self.results.append(item)
                }
                self.loadMore = false
                self.showHideNoResultsView(noResults: false)
                self.collectionView.reloadData()
            }
                
            else {
                self.showHideNoResultsView(noResults: true)
            }
        }
    }
}

