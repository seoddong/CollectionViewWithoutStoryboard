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


        print("cell.init(frame)=\(frame)")
        imageView = UIImageView(frame: frame)
        
        imageView.contentMode = .ScaleAspectFit
        imageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        label = UILabel(frame: frame)
        label.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        self.contentView.addSubview(imageView)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
