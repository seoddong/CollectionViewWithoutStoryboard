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
    let layout = UICollectionViewFlowLayout()
    
    // 화면 로테이션 시 제대로 화면을 뿌려주기 위한 변수
    var currentIndex: Int = 0
    var cellSize: CGSize?

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
        

        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(MainCollectionViewCell.self, forCellWithReuseIdentifier: reuseCellIdentifier)
//        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)  // UICollectionReusableView
        collectionView.pagingEnabled = true
        collectionView.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(collectionView)
        
        loadImages()
        
        cellSize = collectionView.frame.size
        
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
        debugPrint("dataArray=\(dataArray)")

        
        
    }
    
    // Detect device's rotation 1
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        // Where is the best location of super? Top of this method or bottom?
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        // size는 New Size이며 old size는 self.view.bounds.size, self.collectionView.frame로 확인 가능하다.
        
        //let width = layout.sectionInset.left + layout.sectionInset.right + layout.content
        cellSize = size
        
        let oldBounds = self.collectionView.bounds
        debugPrint("4 oldBounds=\(oldBounds)")
//        debugPrint("4 size=\(size)")
        let index = round(oldBounds.origin.y / oldBounds.height)
        
        // rotation 후 보던 셀이 보이게 위치를 정확히 세팅해준다.
        currentIndex = Int(index)
        let offset = CGFloat(currentIndex) * size.height
        debugPrint("offset=\(currentIndex) * \(size.height) = \(offset)")
        self.collectionView.setContentOffset(CGPointMake(0, offset), animated: true)
//        debugPrint("self.collectionView.contentOffset=\(self.collectionView.contentOffset)")
        
        // Suppress the layout errors by invalidating the layout
        self.collectionView.collectionViewLayout.invalidateLayout();
        
        // 위에서 invalidateLayout로 layout을 업데이트했음에도 불구하고 아래 로그는 이전 사이즈가 출력된다. 그래서 "이상하지만" 강제로 self.collectionView.frame.size = size를 해 주었다.
        // 또 하나 재미있는 것은 self.collectionView.frame.size = size를 위 invalidateLayout 위에 위치시키면 warning이 발생한다.
        // debugPrint("self.collectionView.frame=\(self.collectionView.frame), self.collectionView.bounds=\(self.collectionView.bounds)")
        self.collectionView.frame.size = size
        

    }
    
    func adjustInterfaceForSize(size: CGSize) {
        if size.width > size.height {
            
        }
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
        
        // 이 메소드는 cell을 표현하기 위한 메소드이다. 그러므로 다른 용도로 사용하게 되면 원하는 결과를 얻지 못 할 수 있으므로 그런 용도로 사용하지 않는 것이 좋다.
        // 예컨대 디바이스의 상황에 따라서 이 메소드가 한 번에 여러 번 호출될 수 있기 때문에 cell 표현 이외의 용도로 사용하게 되면 엉뚱한 값을 갖게 된다. 다시 말해서 이 메소드가 마지막으로 호출된 결과와 내가 현재 디바이스에서 보고 있는 화면의 결과가 다를 수 있다는 것이다.
        

//        debugPrint("self.collectionView.bounds=\(self.collectionView.bounds)")
//        debugPrint("self.collectionView.frame=\(self.collectionView.frame)")
        
        //print("indexPath=\(indexPath.row)")
        let frame = self.collectionView.frame

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseCellIdentifier, forIndexPath: indexPath) as! MainCollectionViewCell

        let imageName = dataArray[indexPath.row]
        let image = UIImage(named: imageName)
        cell.imageView.image = image
        if (frame.size.width >= frame.size.height) {
            // 가로모드
            cell.imageView.frame = frame
        }
        else {
            // 세로모드: 이미지가 너무 작게 나오니 프레임을 키워준다.
            cell.imageView.frame = CGRectMake(0, 0, frame.width*2, frame.height)
        }
//        debugPrint("cell.imageView.frame=\(frame)")
//        debugPrint("cell.imageView.image=\(cell.imageView.image!.size)")
        
        
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.orangeColor()
        }
        else {
            cell.backgroundColor = UIColor.yellowColor()
        }
        
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
    
    
    // 아래 4개 메소드는 셀 표현 시 애니메이션 효과를 주기 위한 메소드이다.
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        animateCell(cell)
    }
    func animateCell(cell: UICollectionViewCell) {
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.fromValue = 200
        cell.layer.cornerRadius = 0
        animation.toValue = 0
        animation.duration = 1
        cell.layer.addAnimation(animation, forKey: animation.keyPath)
    }
    func animateCellAtIndexPath(indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) else { return }
        animateCell(cell)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        animateCellAtIndexPath(indexPath)
    }
    
    
    
}



// MARK:UICollectionViewDelegateFlowLayout
extension MainViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return cellSize!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero //UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}


