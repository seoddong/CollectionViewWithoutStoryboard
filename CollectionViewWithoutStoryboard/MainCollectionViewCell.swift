//
//  MainCollectionViewCell.swift
//  CollectionViewWithoutStoryboard
//
//  Created by SeoDongHee on 2016. 6. 8..
//  Copyright © 2016년 SeoDongHee. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var label: UILabel!
    
    // 아래 init(frame)이 이상하게 두 번 호출된다. 왜 그런지 알 수 없다. 두 번째 호출되었을 때 frame 정보가 좀 맞지 않아서 두 번째 호출을 무시하기 위한 플래그를 설정한다. 허나 아래의 코드는 소용이 없다. 왜냐하면 이 인스턴스 자체가 두 개 생기기 때문이다.
    // 또한 파라미터로 넘어오는 frame도 쓸만한 것이 아니다. 다른 용도의 frame인 것 같다.
    override init(frame: CGRect) {
        super.init(frame: frame)

        debugPrint("cell.init(frame)=\(frame)")

        imageView = UIImageView()
        
        imageView.contentMode = .ScaleAspectFit
        imageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        label = UILabel()
        label.text = "AVENGERS: Age of Ultron"
        label.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(label)
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
        }
        else {
            imageViewFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.width*2, imageViewHeight)
        }
        imageView.frame = imageViewFrame
        label.frame = labelFrame
//        debugPrint("imageViewFrame=\(imageViewFrame)")
//        debugPrint("labelFrame=\(labelFrame)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
