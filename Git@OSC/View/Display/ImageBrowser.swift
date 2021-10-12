//
//  ImageBrowser.swift
//  Git@OSC
//
//  Created by strayRed on 2018/12/21.
//  Copyright © 2018 Git@OSC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: ImageBrowser {
    var singleTap: ControlEvent<()> {
        return ControlEvent(events: base.singleTap.rx.event.map{ _ in () })
    }
    var longPress: ControlEvent<()> {
        return ControlEvent(events: base.longPress.rx.event.map{ _ in () })
    }
    var scale: ControlEvent<CGFloat> {
        return ControlEvent(events: base.scale.asObservable())
    }
 }


class ImageBrowser: UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    private let scrollView = UIScrollView()
    
    private let imageView = UIImageView()
    
    private var beganFrame = CGRect.zero
    
    private var beganTouch = CGPoint.zero
    
    private let image: UIImage
    
    var imageMaximumZoomScale: CGFloat = 2.0
    
    private let disposeBag = DisposeBag()
    
    
    let scale = PublishSubject<CGFloat>()
    
    let singleTap = UITapGestureRecognizer()
    let longPress = UILongPressGestureRecognizer()
    
    /// 计算图片复位坐标
    private var resettingCenter: CGPoint {
        let deltaWidth = bounds.width - scrollView.contentSize.width
        let offsetX = deltaWidth > 0 ? deltaWidth * 0.5 : 0
        let deltaHeight = bounds.height - scrollView.contentSize.height
        let offsetY = deltaHeight > 0 ? deltaHeight * 0.5 : 0
        return CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX,
                       y: scrollView.contentSize.height * 0.5 + offsetY - 32)
    }
    
    
    /// 复位ImageView
    private func resetImageView() {
        // 如果图片当前显示的size小于原size，则重置为原size
        let size = imageSize
        let needResetSize = imageView.bounds.size.width < size.width
            || imageView.bounds.size.height < size.height
        UIView.animate(withDuration: 0.25) {
            self.imageView.center = self.resettingCenter
            if needResetSize {
                self.imageView.bounds.size = size
            }
        }
    }
    
    private var imageSize: CGSize {
        //设置比例
        let ratio = min(CGFloat.screenWidth/image.size.width, CGFloat.screenHeight/image.size.height)
        if ratio < 1 {
            return CGSize(width: ratio * image.size.width, height: ratio * image.size.height)
        }
        else {
            return image.size
        }
    }
    
    private var imageViewFrame: CGRect {
        let size = imageSize
        let x = self.bounds.width > size.width ? (self.bounds.width - size.width) * 0.5 : 0
        let y = self.bounds.height > size.height ? (self.bounds.height - size.height) * 0.5 : 0
        return CGRect.init(origin: CGPoint(x: x, y: y - 32), size: size)
    }
    
    
    private func setupSubViews() {
        self.backgroundColor = .black
        addSubview(scrollView)
        scrollView.frame = bounds
        scrollView.delegate = self
        scrollView.maximumZoomScale = imageMaximumZoomScale
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(imageView)
        imageView.frame = imageViewFrame
        imageView.image = image
        scrollView.addSubview(imageView)
        scrollView.maximumZoomScale = imageMaximumZoomScale
        //拖动手势
        let pan = UIPanGestureRecognizer()
        pan.delegate = self
        scrollView.addGestureRecognizer(pan)
        pan.rx.event.bind { [weak self] (pan) in
            guard let self = self else { return }
            switch pan.state {
            case .began:
                self.beganFrame = self.imageView.frame
                self.beganTouch = pan.location(in: self.scrollView)
            case .changed:
                let result = self.panResult(pan)
                self.imageView.frame = result.0
            case .ended, .cancelled:
                let result = self.panResult(pan)
                self.imageView.frame = result.0
                self.scale.onNext(result.1)
                if pan.velocity(in: self).y > 0 {
                    self.resetImageView()
                }
            default:
                self.resetImageView()
            }
            }.disposed(by: disposeBag)
        
        
        //双击手势
        let doubleTap = UITapGestureRecognizer()
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
        doubleTap.rx.event.bind { [weak self] (doubleTap) in
            //双击的操作
            guard let self = self else { return }
            // 如果当前没有任何缩放，则放大到目标比例，否则重置到原比例
            if self.scrollView.zoomScale == 1.0 {
                // 以点击的位置为中心，放大
                let pointInView = doubleTap.location(in: self.imageView)
                let width = self.scrollView.bounds.size.width / self.scrollView.maximumZoomScale
                let height = self.scrollView.bounds.size.height / self.scrollView.maximumZoomScale
                let x = pointInView.x - (width / 2.0)
                let y = pointInView.y - (height / 2.0)
                self.scrollView.zoom(to: CGRect(x: x, y: y, width: width, height: height), animated: true)
            } else {
                self.scrollView.setZoomScale(1.0, animated: true)
            }
            
            }.disposed(by: disposeBag)
        
        //单击手势
        singleTap.require(toFail: doubleTap)
        addGestureRecognizer(singleTap)
        
        //长按手势
        addGestureRecognizer(longPress)
    }
    
    /// 计算拖动时图片应调整的frame和scale值
    private func panResult(_ pan: UIPanGestureRecognizer) -> (CGRect, CGFloat) {
        // 拖动偏移量
        let translation = pan.translation(in: scrollView)
        let currentTouch = pan.location(in: scrollView)
        
        // 由下拉的偏移值决定缩放比例，越往下偏移，缩得越小。scale值区间[0.3, 1.0]
        let scale = min(1.0, max(0.3, 1 - translation.y / bounds.height))
        
        let width = beganFrame.size.width * scale
        let height = beganFrame.size.height * scale
        
        // 计算x和y。保持手指在图片上的相对位置不变。
        // 即如果手势开始时，手指在图片X轴三分之一处，那么在移动图片时，保持手指始终位于图片X轴的三分之一处
        let xRate = (beganTouch.x - beganFrame.origin.x) / beganFrame.size.width
        let currentTouchDeltaX = xRate * width
        let x = currentTouch.x - currentTouchDeltaX
        
        let yRate = (beganTouch.y - beganFrame.origin.y) / beganFrame.size.height
        let currentTouchDeltaY = yRate * height
        let y = currentTouch.y - currentTouchDeltaY
        
        return (CGRect(x: x.isNaN ? 0 : x, y: y.isNaN ? 0 : y, width: width, height: height), scale)
    }
    
    
    init(image: UIImage, frame: CGRect) {
        self.image = image
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageView.center = resettingCenter
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 只响应pan手势
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        let velocity = pan.velocity(in: self)
        // 向上或向下滑动时，不响应手势
        if velocity.y < 0 {
            return false
        }
        // 横向滑动时，不响应pan手势
        if abs(Int(velocity.x)) > Int(velocity.y) {
            return false
        }
        // 向下滑动，如果图片顶部超出可视区域，不响应手势
        if scrollView.contentOffset.y > 0 {
            return false
        }
        // 响应允许范围内的下滑手势
        return true
        
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
