//
//  BlurViewController.swift
//  LambdaTimeline
//
//  Created by Morgan Smith on 9/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import CoreImage
import Photos

class BlurViewController: UIViewController {
    
    @IBOutlet weak var blurSlider: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    
    private let context = CIContext(options: nil)
    let filter = CIFilter(name: "CIGaussianBlur")!
    
    var originalImagePost: UIImage?
    var savedPhoto: UIImage?
    
    var originalImage: UIImage? {
        didSet {
            guard let image = originalImage else { return }
            
            var scaledSize = imageView.bounds.size
            let scale = UIScreen.main.scale
            
            scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
            
            let scaledImage = image.imageByScaling(toSize: scaledSize)
            self.scaledImage = scaledImage
        }
    }
    
    var scaledImage: UIImage? {
        didSet {
            imageView.image = scaledImage
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBlurSlider()
        guard let postImage = originalImagePost else { return }
        originalImage = postImage
        imageView.image = originalImage
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
    }
    
    @IBAction func doneEditing(_ sender: Any) {
        
    }
    
    
    @IBAction func blurChanged(_ sender: UISlider) {
        updateImage()
    }
    
    
    private func updateImage() {
        if let scaledImage = scaledImage {
            imageView.image = image(byFiltering: scaledImage)
            
        } else {
            imageView.image = nil
        }
    }
    
    private func image(byFiltering image: UIImage) -> UIImage {
        
        guard let cgImage = image.cgImage else { return image}
        
        let ciImage = CIImage(cgImage: cgImage)
        
        filter.setValue(ciImage, forKey: "inputImage")
        filter.setValue(blurSlider.value, forKey: "inputRadius")
        
        guard let outputImage =  filter.outputImage else { return image }
        
        guard let outputCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image }
        savedPhoto = UIImage(cgImage: outputCGImage)
        return UIImage(cgImage: outputCGImage)
    }
    
    
    func setUpBlurSlider() {
        if let inputRadiusDictionary = filter.attributes["inputRadius"] as? [String: Any],
            let sliderMin = inputRadiusDictionary[kCIAttributeSliderMin] as? Float,
            let sliderMax = inputRadiusDictionary[kCIAttributeSliderMax] as? Float,
            let identity = inputRadiusDictionary[kCIAttributeIdentity] as? Float {
            
            blurSlider.minimumValue = sliderMin
            blurSlider.maximumValue = sliderMax
            blurSlider.value = identity
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveBlur" {
            if let imageVC = segue.destination as? ImagePostViewController, let photo = savedPhoto {
                imageVC.filteredImage = photo
            }
        }
    }
    
}

