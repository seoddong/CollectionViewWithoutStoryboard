//
//  MainViewController.swift
//  CollectionViewWithoutStoryboard
//
//  Created by SeoDongHee on 2016. 6. 8..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // 1. Add CollectionView without Storyboard
    // Well, wut?! We need to adopt three protocols, why there’s only two? This is because UICollectionViewDelegateFlowLayout inherits from UICollectionViewDelegate, so by writing only UICollectionViewDelegateFlowLayout we adopt both of them. By the way, if you’d need to implement UIScrollViewDelegate methods in your project, by writing UICollectionViewDelegateFlowLayout you automatically adopt UIScrollViewDelegate too.
    var collectionView: UICollectionView!
    
    // 2. Set up CollectionView and its layout
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    // 화면 로테이션 시 제대로 화면을 뿌려주기 위한 변수
    var currentOffset: CGPoint!
    var currentIndex: Int = 0
    var indexPathRow: Int = 0
    
    let barSize: CGFloat = 0.0 //44.0
    var dataArray: [String] = []
    let reuseCellIdentifier = "reuseCellIdentifier"
    let reuseHeaderIdentifier = "reuseHeaderIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // If the delegate object does not implement the collectionView:layout:insetForSectionAtIndex: method, the flow layout uses the value in this property to set the margins for each section.
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // If the delegate does not implement the collectionView:layout:sizeForItemAtIndexPath: method, the flow layout uses the value in this property to set the size of each cell.
        // layout.itemSize = CGSize(width: 90, height: 120)
        
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        
        print("self.view.frame=\(self.view.frame)")
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(MainCollectionViewCell.self, forCellWithReuseIdentifier: reuseCellIdentifier)
//        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)  // UICollectionReusableView
        collectionView.pagingEnabled = true
        collectionView.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(collectionView)
        
        loadImages()
        
        self.automaticallyAdjustsScrollViewInsets = false
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImages() {
        
        for ii in 1...20 {
            self.dataArray.append(String(format: "%003d", ii))
        }
        print("dataArray=\(dataArray)")

        
        
    }
    
    // Detect device's rotation 1
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        // size는 New Size이며 old size는 self.view.bounds.size로 확인 가능하다.
        print("4 self.collectionView.frame=\(self.collectionView.frame)")
        print("4 size=\(size)")
        
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            //bool 값이 ture 면 가로
            
        } else {
            //bool 값이 false 면 세로
            
        }
        
//        let barSize = self.collectionView.frame.origin.y
//        let newSize = CGSize(width: size.width, height: size.height - barSize)
        
        
        self.collectionView.frame.size = size
        
        let currentSize = self.collectionView.bounds.size
        let offset = CGFloat(self.indexPathRow) * size.height
        print("offset=\(offset)")
        self.collectionView.setContentOffset(CGPointMake(0, offset), animated: true)
        print("self.collectionView.contentOffset=\(self.collectionView.contentOffset)")
        
        // Suppress the layout errors by invalidating the layout
        self.collectionView.collectionViewLayout.invalidateLayout();
        
        
        // Where is the best location of super? Top of this method or bottom?
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }

    // Detect device's rotation 2
    override func viewWillLayoutSubviews() {
        //        let frame = self.view.frame
        //        self.collectionView.frame = CGRectMake(frame.origin.x, frame.origin.y + barSize, frame.size.width, frame.size.height - barSize)
        print("self.collectionView.frame=\(self.collectionView.frame)")
        super.viewWillLayoutSubviews()
        self.collectionView.collectionViewLayout.invalidateLayout();
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        print("indexPath=\(indexPath.row)")

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseCellIdentifier, forIndexPath: indexPath) as! MainCollectionViewCell

        let imageName = dataArray[indexPath.row]
        let image = UIImage(named: imageName)
        cell.imageView.image = image
        cell.imageView.frame = self.collectionView.frame
        print("cell.imageView.frame=\(cell.imageView.frame)")
        print("cell.imageView.image=\(cell.imageView.image!.size)")
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.orangeColor()
        }
        else {
            cell.backgroundColor = UIColor.yellowColor()
        }
        
        currentOffset = self.collectionView.contentOffset
        print("currentOffset=\(currentOffset)")
        // 스크롤 방향에 따라 x,y를 변경해야 한다.
        currentIndex = Int(currentOffset.y / self.collectionView.frame.size.height)
        print("currentIndex=\(currentIndex)")
        indexPathRow = indexPath.row

        return cell
    }
    
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        var reusableView : UICollectionReusableView? = nil
//        
//        // Create header
//        if (kind == UICollectionElementKindSectionHeader) {
//            // Create Header
//            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier, forIndexPath: indexPath) // as PackCollectionSectionView
//            
//            reusableView = headerView
//        }
//        return reusableView!
//    }
}

// MARK:UICollectionViewDelegateFlowLayout
extension MainViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        print("cell: self.collectionView.frame.size=\(self.collectionView.frame.size)")
        
        return self.collectionView.frame.size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}