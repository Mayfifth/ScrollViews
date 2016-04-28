//
//  ScrollViewContainer.swift
//  ScrollViews
//
//  Created by KIMYOUNG SIK on 2016. 2. 22..
//  Copyright © 2016년 KIMYOUNG SIK. All rights reserved.
//

import UIKit

class ScrollViewContainer: UIView {

    //페이지 바깥을 눌러도 페이지가 변하도록 넓은 scrollView를 만들고
    @IBOutlet var scrollView: UIScrollView!
    //스크롤뷰 컨테이너 바운드 안을 누르기만 하면 스크롤뷰를 리턴 함!
    override func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView? {
        let view = super.hitTest(point, withEvent: event)
        if let theView = view {
            if theView == self {
                return scrollView
            }
        }
        
        return view
    }

}
