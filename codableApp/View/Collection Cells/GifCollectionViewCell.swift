//
//  gifCollectionViewCell.swift
//  codableApp
//
//  Created by or paztal on 02/07/2019.
//  Copyright © 2019 Or paz tal. All rights reserved.
//

import UIKit

class GifCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellImageView: CustomImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    static let identifier = "GifCollectionViewCell"
    var data: ItemMetaData?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        shouldDisplayIndicator(shouldDisplay: true)
    }

    func configureCell(withData data: ItemMetaData, indexPath: IndexPath) {
        self.data = data
        
        if let url = data.images?.fixed_height?.url {
            cellImageView.loadImageUsingUrlString(urlString: url)
            shouldDisplayIndicator(shouldDisplay: false)
        }
        
    }
    
    func shouldDisplayIndicator(shouldDisplay: Bool) {
        if shouldDisplay {
            indicator.startAnimating()
            cellImageView.image = #imageLiteral(resourceName: "loading")
        } else {
            indicator.stopAnimating()
        }
        indicator.isHidden = !shouldDisplay
    }
}
