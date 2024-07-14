//
//  DetailInfoTableViewCell.swift
//  CamPlace
//
//  Created by Chung Wussup on 6/19/24.
//

import UIKit

class DetailInfoTableViewCell: UITableViewCell {
    private var mainStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 5
        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private var placeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private var introLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private var homepageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private var sbrsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private var telLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.isUserInteractionEnabled = true
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        selectionStyle = .none
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupGestures()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(mainStackView)
        [placeNameLabel, introLabel, addressLabel, sbrsLabel, telLabel, homepageLabel].forEach { mainStackView.addArrangedSubview($0)  }
        
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupGestures() {
        let telTapGesture = UITapGestureRecognizer(target: self, action: #selector(telLabelTapped))
        telLabel.addGestureRecognizer(telTapGesture)
        
        let homepageTapGesture = UITapGestureRecognizer(target: self, action: #selector(homepageLabelTapped))
        homepageLabel.addGestureRecognizer(homepageTapGesture)
    }
    
    @objc private func telLabelTapped() {
        if let telNumber = telLabel.text?.replacingOccurrences(of: "연락처: ", with: ""),
           let url = URL(string: "tel://\(telNumber)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc private func homepageLabelTapped() {
        if let homepageURL = homepageLabel.text,
           let url = URL(string: homepageURL) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    func setupCell(content: LocationBasedListModel) {
        placeNameLabel.text = content.title
        introLabel.text = content.intro
        
        addressLabel.text = "\(content.doNm) \(content.sigunguNm)\n\(content.subTitle ?? "") \(content.addr2)"
        
        let homepageText = content.homepage
        let homepageAttributedString = NSMutableAttributedString(string: homepageText)
        homepageAttributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: homepageText.count))
        homepageAttributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: NSRange(location: 0, length: homepageText.count))
        homepageLabel.attributedText = homepageAttributedString
        
        sbrsLabel.text = "특징: \(content.sbrsCl)\n애완동물: \(content.animalCmgCl)"
        
        let telText = "연락처: \(content.tel)"
        let telAttributedString = NSMutableAttributedString(string: telText)
        telAttributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 4))
        telAttributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: NSRange(location: 5, length: telText.count - 5))
        telLabel.attributedText = telAttributedString
        
    }
    
}
