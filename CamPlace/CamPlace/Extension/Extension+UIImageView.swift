//
//  Extension+UIImageView.swift
//  CamPlace
//
//  Created by Chung Wussup on 6/20/24.
//

import UIKit
import Combine

extension UIImageView {
    private static var cancellables = Set<AnyCancellable>()
    
    func loadImage(from urlString: String) {
        ImageLoader.loadImageFromUrl(urlString)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.image = image
            }
            .store(in: &UIImageView.cancellables)
    }
}
