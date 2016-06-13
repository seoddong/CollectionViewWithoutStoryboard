//
//  MainCollectionViewCell.swift
//  CollectionViewWithoutStoryboard
//
//  Created by SeoDongHee on 2016. 6. 8..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    var storyLabel: UILabel!
    
    // 아래 init(frame)이 이상하게 두어 번 호출된다. 이유는 재사용할 셀을 준비하면서 알아서 몇 개의 셀 인스턴스를 (마치 pool처럼)만들어놓고 돌아가며 재사용하는 것 같다.
    override init(frame: CGRect) {
        super.init(frame: frame)

        debugPrint("cell.init(frame)=\(frame)")
        
        scrollView = UIScrollView()
        
        scrollView.backgroundColor = UIColor.blueColor()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self

        imageView = UIImageView()
        
        imageView.contentMode = .ScaleAspectFit
        //imageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        storyLabel = UILabel()
        storyLabel.text = "AVENGERS: Age of Ultron"
        storyLabel.backgroundColor = UIColor.lightGrayColor()
        //label.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        storyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(scrollView)
        self.contentView.addSubview(storyLabel)
        scrollView.addSubview(imageView)
        
        
        let viewDictionary = ["scrollView": scrollView, "storyLabel": storyLabel, "imageView": imageView]
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[scrollView]-|", options: .AlignAllBaseline, metrics: nil, views: viewDictionary))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[scrollView]-[storyLabel]-|", options: .AlignAllCenterX, metrics: nil, views: viewDictionary))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[imageView]|", options: .AlignAllBaseline, metrics: nil, views: viewDictionary))
        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]|", options: .AlignAllCenterX, metrics: nil, views: viewDictionary))
        debugPrint("cell.imageView.frame=\(imageView.frame)")
    }
    
    func updateCellFrame(frame: CGRect) {
        var frame = frame
        // 미리 cell을 만드는 경우 init이 다시 호출되는 경우가 있는데 이 때의 frame 정보가 실제 화면과 안 맞는 경우가 있어서 강제로 변경한다.
        frame.origin.y = 0
        
        let labelHeight: CGFloat = 60
        let imageViewHeight: CGFloat = frame.height - labelHeight
        var imageViewFrame: CGRect!
        let labelFrame = CGRectMake(frame.origin.x, frame.origin.y + imageViewHeight, frame.width, labelHeight)
        if (frame.size.width >= frame.size.height) {
            imageViewFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.width, imageViewHeight)
            imageView.frame.size = imageViewFrame.size
        }
        else {
            imageViewFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.width*2, imageViewHeight)
            imageView.frame.size = imageViewFrame.size
        }
        debugPrint("imageView.frame=\(imageView.frame)")
        //scrollView.contentSize = scrollView.frame.size
//        imageView.frame = imageViewFrame
//        storyLabel.frame = labelFrame
//        debugPrint("imageViewFrame=\(imageViewFrame)")
//        debugPrint("labelFrame=\(labelFrame)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension MainCollectionViewCell: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        debugPrint("viewForZoomingInScrollView: scrollView.contentSize=\(scrollView.contentSize)")
        debugPrint("viewForZoomingInScrollView: imageView.frame=\(imageView.frame)")
        return imageView
    }
}
