//
//  WaterFallFlowLayout.swift
//  WaterFallFlow-Swift
//
//  Created by HongXiangWen on 2018/3/1.
//  Copyright © 2018年 WHX. All rights reserved.
//

import UIKit

protocol UICollectionViewDelegateWaterFallFlowLayout: UICollectionViewDelegateFlowLayout {
    
    /// 设置每个section对应的列数
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountForSection section: Int) -> Int

}

extension UICollectionViewDelegateWaterFallFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountForSection section: Int) -> Int {
        return 2
    }
    
}

class WaterFallFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - 初始化
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
        sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    // MARK: - 重写属性和方法
    override func prepare() {
        
        /// 重置属性
        contentHeight = 0
        attributesItems.removeAll()
        attributesSupplementary.removeAll()
        
        /// 计算属性
        let sections = collectionView!.numberOfSections
        for section in 0 ..< sections {
            let sectionMinimumInteritemSpacing = minimumInteritemSpacingForSection(section)
            let sectionMinimumLineSpacing = minimumLineSpacingForSection(section)
            let currentSectionInset = sectionInsetForSection(section)
            let columnCount = columnCountForSection(section)
            let headerHeight = headerHeightForSection(section)
            let footerHeight = footerHeightForSection(section)
            
            var supplementary: [String: UICollectionViewLayoutAttributes] = [String: UICollectionViewLayoutAttributes]()
            
            /// header
            if headerHeight > 0 {
                let headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: IndexPath(item: 0, section: section))
                headerAttributes.frame = CGRect(x: 0, y: contentHeight, width: collectionView!.frame.width, height: headerHeight)
                attributesItems.append(headerAttributes)
                supplementary[UICollectionElementKindSectionHeader] = headerAttributes
                contentHeight = headerAttributes.frame.maxY
            }
    
            contentHeight += currentSectionInset.top;

            /// items
            let itemCount = collectionView!.numberOfItems(inSection: section)

            var columnHeights: [CGFloat] = [CGFloat]()
            
            for _ in 0 ..< columnCount {
                columnHeights.append(contentHeight)
            }
            
            for item in 0 ..< itemCount {
                let indexPath = IndexPath(item: item, section: section)
                let columnIndex = columnHeights.index(of: minOne(columnHeights)) ?? 0
                let size = itemSizeForIndexPath(indexPath)
                let x = currentSectionInset.left + (size.width + sectionMinimumInteritemSpacing) * CGFloat(columnIndex)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: x, y: columnHeights[columnIndex], width: size.width, height: size.height)
                attributesItems.append(attributes)
                columnHeights[columnIndex] = attributes.frame.maxY + sectionMinimumLineSpacing
            }
            
            contentHeight = maxOne(columnHeights)
            
            /// footer
            if footerHeight > 0 {
                let footerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: IndexPath(item: 0, section: section))
                footerAttributes.frame = CGRect(x: 0, y: contentHeight, width: collectionView!.frame.width, height: footerHeight)
                attributesItems.append(footerAttributes)
                supplementary[UICollectionElementKindSectionFooter] = footerAttributes
                contentHeight = footerAttributes.frame.maxY
            }

            attributesSupplementary.append(supplementary)
            
            contentHeight += currentSectionInset.bottom
        }
        
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.frame.width ?? 0, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesItems.filter({ (attributes) -> Bool in
            return rect.intersects(attributes.frame)
        })
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var item = indexPath.item
        for section in 0 ..< indexPath.section {
            item += collectionView?.numberOfItems(inSection: section) ?? 0
        }
        return attributesItems[item]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesSupplementary[indexPath.section][elementKind]
    }
    
    
    // MARK: - 自定义属性
    private var attributesItems = [UICollectionViewLayoutAttributes]()
    
    private var attributesSupplementary = [[String: UICollectionViewLayoutAttributes]]()
    
    private var contentHeight: CGFloat = 0
    
    private weak var delegate: UICollectionViewDelegateWaterFallFlowLayout? {
        return collectionView?.delegate as? UICollectionViewDelegateWaterFallFlowLayout
    }
    
    
}

// MARK: - 私有方法
extension WaterFallFlowLayout {
    
    private func columnCountForSection(_ section: Int) -> Int {
        return delegate?.collectionView(collectionView!, layout: self, columnCountForSection: section) ?? 0
    }
    
    private func headerHeightForSection(_ section: Int) -> CGFloat {
        return delegate?.collectionView?(collectionView!, layout: self, referenceSizeForHeaderInSection: section).height ?? headerReferenceSize.height
    }
    
    private func footerHeightForSection(_ section: Int) -> CGFloat {
        return delegate?.collectionView?(collectionView!, layout: self, referenceSizeForFooterInSection: section).height ?? footerReferenceSize.height
    }
    
    private func sectionInsetForSection(_ section: Int) -> UIEdgeInsets {
        return delegate?.collectionView?(collectionView!, layout: self, insetForSectionAt: section) ?? sectionInset
    }
    
    private func minimumInteritemSpacingForSection(_ section: Int) -> CGFloat {
        return delegate?.collectionView?(collectionView!, layout: self, minimumInteritemSpacingForSectionAt: section) ?? minimumInteritemSpacing
    }
    
    private func minimumLineSpacingForSection(_ section: Int) -> CGFloat {
        return delegate?.collectionView?(collectionView!, layout: self, minimumLineSpacingForSectionAt: section) ?? minimumLineSpacing
    }
    
    private func itemSizeForIndexPath(_ indexPath: IndexPath) -> CGSize {
        return delegate?.collectionView?(collectionView!, layout: self, sizeForItemAt: indexPath) ?? CGSize.zero
    }
    
}















