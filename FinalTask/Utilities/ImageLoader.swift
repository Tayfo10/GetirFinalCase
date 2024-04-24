//
//  ImageLoader.swift
//  FinalTask
//
//  Created by Tayfun Sener on 15.04.2024.
//

import UIKit

class ImageLoader {
    static let imageCache = NSCache<NSString, UIImage>()
    static var tasks = [UIImageView: URLSessionDataTask]()
    
    static func loadImage(for imageView: UIImageView, with urlString: String?, placeholder: UIImage? = UIImage(named: "defaultPlaceholder")) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            print("Invalid or missing URL string for image.")
            imageView.image = UIImage(named: "Image1")
            return
        }
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            imageView.image = cachedImage
            return
        }
        
        imageView.image = placeholder
        tasks[imageView]?.cancel()
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    
                    imageView.image = UIImage(named: "Image1")
                }
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    imageView.image = image
                }
            }
        }
        tasks[imageView] = task
        task.resume()
    }
    
    static func cancelLoad(for imageView: UIImageView) {
        tasks[imageView]?.cancel()
        tasks.removeValue(forKey: imageView)
    }
}



