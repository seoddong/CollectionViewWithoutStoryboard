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
        imageView.translatesAutoresizingMaskIntoConstraints = true
        
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
//        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[imageView]|", options: .AlignAllBaseline, metrics: nil, views: viewDictionary))
//        scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]|", options: .AlignAllCenterX, metrics: nil, views: viewDictionary))
        layoutIfNeeded()
        debugPrint("cell.scrollView.frame=\(scrollView.frame)")
        setZoomScale(scrollView)
    }
    
    func setZoomScale(scrollView: UIScrollView) {
        scrollView.maximumZoomScale = 1.0
        scrollView.minimumZoomScale = 0.1
        // 아래 zoomScale을 적용할 경우 imageView.bounds가 두 배가 되는 현상이 생겨서 사용하지 않기로 함
//        scrollView.zoomScale = 0.5
    }
    
    func updateCellFrame(frame: CGRect) {
        var frame = frame
        // 미리 cell을 만드는 경우 init이 다시 호출되는 경우가 있는데 이 때의 frame 정보가 실제 화면과 안 맞는 경우가 있어서 강제로 변경한다.
        frame.origin.y = 0
        
        // 만약 이미 scrollView.zoomScale이 이상하게 맞춰져 있다면 imageView.bounds.size는 image.size의 zoomScale의 영향을 받는다.
        let imageSize = (imageView.image?.size)!
        imageView.bounds.size = imageSize
        scrollView.contentSize = imageView.bounds.size
        debugPrint("updateCellFrame; imageView.bounds=\(imageView.bounds)")

        var imageViewFrame: CGRect!
        if (frame.size.width >= frame.size.height) {
            // 가로모드일 경우 image.size.width를 scrollView.width의 크기와 동일하게 맞춘다.
            let scrollViewWidth = scrollView.frame.width
            imageViewFrame = CGRectMake(imageView.bounds.origin.x, imageView.bounds.origin.y, scrollViewWidth, round(imageSize.height * (scrollViewWidth / imageSize.width)))
        }
        else {
            // 세로모드일 경우 image.size.height를 scrollView.height의 크기와 동일하게 맞춘다.
            let scrollViewHeight = scrollView.frame.height
            imageViewFrame = CGRectMake(imageView.bounds.origin.x, imageView.bounds.origin.y, round(imageSize.width * (scrollViewHeight / imageSize.height)), scrollViewHeight)
        }
        imageView.frame = imageViewFrame
        debugPrint("updateCellFrame: scrollView.frame=\(scrollView.frame)")
        debugPrint("updateCellFrame: imageView.frame=\(imageViewFrame)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.scrollToCenter()
    }
    
    // 스크롤의 요체는 스크롤뷰의 bounds가 이동하는 것이다
    func scrollToCenter() {
        // 전제사항 1: imageView.bounds = imageView.frame
        // 전제사항 2: scrollView.contentSize = imageView.bounds.size
        
        guard let imageView = imageView else { return }
        
        // 1. scrollView의 bounds를 image.frame의 센터로 옮긴다.
        // 1.1. image.frame의 중심 좌표를 구한다.
        let centerOrigin = CGPointMake(imageView.frame.origin.x + round(imageView.frame.width / 2), imageView.frame.origin.y + round(imageView.frame.height / 2))
        // 1.2. scrollView의 origin을 계산한다.
        let scrollOrigin = CGPointMake(centerOrigin.x - round(scrollView.bounds.width / 2), centerOrigin.y - round(scrollView.bounds.height / 2))
        scrollView.bounds.origin = scrollOrigin
    }

    
}

extension MainCollectionViewCell: UIScrollViewDelegate {

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        debugPrint("viewForZoomingInScrollView: imageView.bounds=\(imageView.bounds)")
        debugPrint("viewForZoomingInScrollView: imageView.frame=\(imageView.frame)")
        return imageView
    }
}
