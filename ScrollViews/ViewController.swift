//
//  ViewController.swift
//  ScrollViews
//
//  Created by KIMYOUNG SIK on 2016. 2. 21..
//  Copyright © 2016년 KIMYOUNG SIK. All rights reserved.
//

//UIScrollView 는 UITableView 기반의 매우 유용한 view contol로써
//특히 싱글 스크린보다 큰 화면을 표현하는데 좋다.
//1. 매우 큰 이미지 표현
//2. 줌하는 경우 화면 중앙에 위치시키기
//3. complex view hiearchy 내장시키기
//4. UIPageControl과 연동해서 여러 페이지 뷰 표현하기
//5. 현재 페이지 뿐만아니라 앞뒤 페이지 맛보기 peeking 표현 등

//이 튜토리얼은 TableView menu를 통해서 4가지 view를 보여준다.
//1.Image Scroll, 2.Custom View Scroll, 3. Paged, 4. Paged with Peeking

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    
    //이미지 뷰 변수 선언
    var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // 1. photo1.png로 부터 이미지뷰를 생성(파일이 없으면 crash!)
        //    이미지 프레임(크기,위치) 설정한 후 scrollView의 subview로 추가함.
        let image = UIImage(named: "photo1.png")!
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size:image.size)
        scrollView.addSubview(imageView)
        
        // 2. 수직 수평으로 스크롤하는 컨텐트 크기를 이미지 크기로 설정
        scrollView.contentSize = image.size
        
        // 3. 줌인 하기위해  double tap recognizer 설정
        var doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)
        
        // 4. 최대 줌아웃 했을 때 전체 이미지를 한 화면에 보기 위한 minimumZoomScale 설정
        //    width, height에 대해서 스크롤프레임크기/이미지 크기 를 구하고 최소값으로 설정
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight);
        scrollView.minimumZoomScale = minScale;
        
        // 5.maximumZoomScale을 1 이상으로 설정하면 해상도보다 확대하므로 화질 저하됨
        //   초기 zoomScale은 minScale로 설정해서 한 화면에 이미지 전체를 볼 수 있도록 함.
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = minScale;
        
        // 6. 스크롤뷰 안에 이미지를 가운데 오도록 하는 helper method호출
        centerScrollViewContents()
    }
    // 이미지가 항상 스크롤 뷰 바운드의 가운데 오도록 설정
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        // 이미지 크기가 화면크기보다 작으면 이미지 origin(top,left) 위치를 약간 가운데로 옮김
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else { //이미지가 화면보다 크면 무조건 (0,0) 에서 시작
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
    }
    
    //더블 탭으로 줌인하는 메소드
    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        // 1. 줌인하는 위치는 이미지 안에 탭한 위치로 설정
        let pointInView = recognizer.locationInView(imageView)
        
        // 2. 150% 줌인하는 데 최대 maximumZoomScale 까지만 줌인
        var newZoomScale = scrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        
        // 3. 시작 위치와 줌인한 width, height에 의해서 CGRect 생성
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        // 4. 줌인!!
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
 
    //스크롤뷰 콘트롤러를 위한 메소드
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    //줌한 후에 다시 가운데로 오도록
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

