//
//  ViewController.swift
//  WaterFall-swift
//
//  Created by HongXiangWen on 2018/3/1.
//  Copyright © 2018年 WHX. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = WaterFallFlowLayout()
        collectionView.collectionViewLayout = layout
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 2 {
            return 0
        }
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            let label = header.viewWithTag(1000) as! UILabel
            label.text = "头部\(indexPath.section)"
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
            let label = footer.viewWithTag(1000) as! UILabel
            label.text = "尾部\(indexPath.section)"
            return footer
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.randomColor(from: 200, to: 230)
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateWaterFallFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountForSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth - 40) / 3, height: CGFloat(arc4random()%60 + 100))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 3 {
            return CGSize.zero
        }
        return CGSize(width: screenWidth, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize.zero
        }
        return CGSize(width: screenWidth, height: 40)
    }
    
}
