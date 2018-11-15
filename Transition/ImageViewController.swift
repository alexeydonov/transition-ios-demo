//
//  ImageViewController.swift
//  Transition
//
//  Created by Alexey Donov on 15.11.2018.
//  Copyright © 2018 Alexey Donov. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var image: UIImage?

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.image = image
        }
    }
    
}
