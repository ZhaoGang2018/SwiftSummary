//
//  ZGStoryboardSecondViewController.swift
//  SwiftSummary
//
//  Created by jing_mac on 2020/6/22.
//  Copyright © 2020 jing_mac. All rights reserved.
//

import UIKit

class ZGStoryboardSecondViewController: XHBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "storyboard-2"
    }

}

extension ZGStoryboardSecondViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row % 2 == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader{
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer", for: indexPath)
            return footer
        }
    }
    
}


class ZGCustomFlowLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        setupSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSelf()
    }
    
    private func setupSelf(){
        minimumLineSpacing = 10
        minimumInteritemSpacing = 0
        itemSize = CGSize(width: 90, height: 60)
        scrollDirection = .vertical
        sectionInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
}
