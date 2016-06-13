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

        // collectionView.contentInset: 말 그대로 collectionView의 내부 공간이다. 그러므로 이 값이 가장 바깥 공간이 될 것이다. 문제는 이 놈을 설정할 경우 collectionView.pagingEnabled에 영향을 준다. collectionView.pagingEnabled는 collectionView의 bounds를 계산하여 paging처리를 하는데 contentInset이 bounds를 변경하기 때문이다. 이 놈은 사용하면 안 되는 놈으로 생각된다.
        // layout.sectionInset: 말 그대로 섹션에 대한 내부 공간이다. 섹션이 하나인 경우는 제일 위와 제일 아래에 설정된 공간을 확보한다.
        // layout.minimumInteritemSpacing: 셀 간의 간격이기 때문에 이 예제에서는 효과가 없다. 만약 셀 스크롤 방향이 가로라면 이걸 써야 할 것.
        // layout.minimumLineSpacing: 행 사이에 공간을 부여한다. 이 예제에서는 결국 셀 사이에 공간을 부여한다. 만약 셀 스크롤 방향이 세로라면 효과가 없을 것이다.
        
        // If the delegate object does not implement the collectionView:layout:insetForSectionAtIndex: method, the flow layout uses the value in this property to set the margins for each section.
        layout.sectionInset = UIEdgeInsetsZero //UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
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
        
        // 코드로 뷰, constraints를 추가하는 경우에는 아래와 같이 자동 리사이징을 꺼야 한다고 한다.
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.contentInset = UIEdgeInsetsZero //UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView.backgroundColor = UIColor.greenColor()
        
        self.view.addSubview(collectionView)
        
        loadImages()
        
        cellSize = getCellSize() //collectionView.frame.size

        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func getCellSize() -> CGSize {
        var vSpacing: CGFloat = 0, hSpacing: CGFloat = 0
        if layout.scrollDirection == .Vertical {
            vSpacing = layout.minimumLineSpacing
        }
        else {
            hSpacing = layout.minimumLineSpacing
        }
        let width = collectionView.frame.width - layout.sectionInset.left - layout.sectionInset.right - collectionView.contentInset.left - collectionView.contentInset.right - hSpacing
        let height = collectionView.frame.height - layout.sectionInset.top - layout.sectionInset.bottom - collectionView.contentInset.top - collectionView.contentInset.bottom - vSpacing
        //debugPrint("width=\(width), height=\(height)")
        return CGSizeMake(width, height)
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
        cellSize = getCellSize()

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
        

//        debugPrint("5 self.collectionView.bounds=\(self.collectionView.bounds)")
//        debugPrint("5 self.collectionView.frame=\(self.collectionView.frame)")
        
        //print("indexPath=\(indexPath.row)")
        let frame = self.collectionView.frame

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseCellIdentifier, forIndexPath: indexPath) as! MainCollectionViewCell

        let imageName = dataArray[indexPath.row]
        let image = UIImage(named: imageName)
        cell.imageView.image = image

        cell.updateCellFrame(frame)
//        debugPrint("5 cell.imageView.bounds=\(cell.imageView.bounds)")
//        debugPrint("5 cell.imageView.frame=\(cell.imageView.frame)")

        
        
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
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        return UIEdgeInsetsZero //UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
}


