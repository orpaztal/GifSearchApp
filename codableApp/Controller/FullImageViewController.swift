//
//  FullImageViewController.swift
//  codableApp
//
//  Created by Or paz tal on 04/07/2019.
//  Copyright © 2019 Or paz tal. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController {
   
    @IBOutlet weak var imageView: CustomImageView!
    @IBOutlet weak var musicButton: UIButton!

    var itemData: ItemMetaData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bananas"))
        getImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setMusicImage()
    }
    
    func setMusicImage() {
        let img = MusicManager.shared.isMusicPlaying ? #imageLiteral(resourceName: "pause") : #imageLiteral(resourceName: "play")
        musicButton.setImage(img, for: .normal)
    }
    
    func getImage() {
        if let data = itemData {
            if let url = data.images?.fixed_height?.url {
                imageView.loadImageUsingUrlString(urlString: url)
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        let imageToShare = [imageView.image ?? #imageLiteral(resourceName: "bananas")]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // prevent crashs
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func musicButtonTapped(_ sender: Any) {
        MusicManager.shared.setUpMusic()
        setMusicImage()
    }
}
