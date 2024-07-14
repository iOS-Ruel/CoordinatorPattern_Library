//
//  DetailImageTableViewCell.swift
//  CamPlace
//
//  Created by Chung Wussup on 6/19/24.
//

import UIKit

class DetailImageTableViewCell: UITableViewCell {
    
    private lazy var placeScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.delegate = self
        
        sv.alwaysBounceVertical = false
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.isScrollEnabled = true
        sv.isPagingEnabled = true
        sv.bounces = false
        return sv
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPageIndicatorTintColor = .black
        pc.pageIndicatorTintColor = .white
        pc.backgroundColor = .lightGray.withAlphaComponent(0.6)
        pc.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
        pc.layer.cornerRadius = 10
        pc.layer.masksToBounds = true
        
        return pc
    }()
    
    private var imageUrlList: [String] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(placeScrollView)
        contentView.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            placeScrollView.heightAnchor.constraint(equalToConstant: 300),
            placeScrollView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            placeScrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            placeScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            placeScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            placeScrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    func setupCell(imageUrls: [String]) {
        imageUrlList.removeAll()
        
        pageControl.numberOfPages = 0
        
        for subview in placeScrollView.subviews {
            subview.removeFromSuperview()
        }
        
        imageUrls.forEach {
            imageUrlList.append($0)
        }
        
        self.pageControl.numberOfPages = self.imageUrlList.count
        self.setupImagesInScrollView()
        
        self.contentView.layoutIfNeeded()
        placeScrollView.contentSize = CGSize(width: contentView.frame.width * CGFloat(imageUrlList.count), 
                                             height: 300)
    }
    
    private func setupImagesInScrollView() {
        placeScrollView.contentSize = CGSize(width: contentView.frame.width * CGFloat(imageUrlList.count), 
                                             height: 300)
        
        for (index, imageUrl) in imageUrlList.enumerated() {
            let imageView = UIImageView()
            imageView.loadImage(from: imageUrl)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            placeScrollView.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: placeScrollView.leadingAnchor, constant: CGFloat(index) * contentView.frame.width),
                imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: placeScrollView.heightAnchor),
                imageView.topAnchor.constraint(equalTo: placeScrollView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: placeScrollView.bottomAnchor)
            ])
        }
    }
    
    @objc private func pageChanged() {
        let page = pageControl.currentPage
        let offset = CGFloat(page) * contentView.frame.width
        placeScrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }
    
    
}

extension DetailImageTableViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / contentView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
