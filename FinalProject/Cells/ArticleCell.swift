//
//  ArticleCell.swift
//  FinalProject
//
//  Created by Stephen Tan on 3/4/21.
//  Copyright © 2021 Syn1. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
    var article: Article! {
        didSet {
            label.text = article.title
            if let url = URL(string: article.urlToImage ?? "") {
                articleImage.load(url: url)
            }
        }
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let articleImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.clipsToBounds = true
        
        return image
    }()
    
    func layoutCell() {
        addSubview(label)
        addSubview(articleImage)
        
        NSLayoutConstraint.activate([
            articleImage.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 55),
            articleImage.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -55),
            articleImage.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 10),
            articleImage.widthAnchor.constraint(equalToConstant: 90),
            
            label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: articleImage.trailingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -10)
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layoutCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension UIImage {
    var roundImage: UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: CGSize(width: 90, height: 90))
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 90, height: 90), false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: 10
            ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async {
            [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image.roundImage
                    }
                }
            }
        }
    }
}
