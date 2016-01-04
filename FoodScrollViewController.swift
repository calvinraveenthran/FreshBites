//
//  FoodScrollViewController.swift
//  fb2.0
//
//  Created by Calvin Raveenthran on 2016-01-02.
//  Copyright © 2016 Calvin Raveenthran. All rights reserved.
//

import Foundation

class FoodScrollViewController: UIViewController, UIScrollViewDelegate{
    @IBOutlet var scrollView: UIScrollView!

    
    
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.midnightBlueColor()
        self.scrollView.frame = CGRect(x:0, y:0, width: self.view.frame.width, height:self.view.frame.height)
        let scrollViewHeight = self.scrollView.frame.height
        let scrollviewWidth = self.scrollView.frame.width
        
        
        // 1
        pageImages = [UIImage(named: "photo_item1@2x.png")!,
            UIImage(named: "photo2.png")!,
            UIImage(named: "photo3.png")!,
            UIImage(named: "photo_item4@2x.png")!,
            UIImage(named: "photo3.png")!]
        
        let pageCount = pageImages.count
        
    
            
                let ImageView = UIImageView(frame: CGRectMake(0,0, scrollviewWidth, scrollViewHeight))
                    ImageView.image  = pageImages[0];
                    ImageView.contentMode = .ScaleAspectFit
            
                self.scrollView.addSubview(ImageView)
        
                let ImageView2 = UIImageView(frame: CGRectMake(scrollviewWidth, -195, scrollviewWidth, scrollViewHeight))
                ImageView2.image  = pageImages[1];
                ImageView2.contentMode = .ScaleAspectFit
        
                self.scrollView.addSubview(ImageView2)
        
                let ImageView3 = UIImageView(frame: CGRectMake(scrollviewWidth*2, -195, scrollviewWidth, scrollViewHeight))
                ImageView3.image  = pageImages[2];
                ImageView3.contentMode = .ScaleAspectFit
        
                self.scrollView.addSubview(ImageView3)
        
                let ImageView4 = UIImageView(frame: CGRectMake(scrollviewWidth*3, -195, scrollviewWidth, scrollViewHeight))
                ImageView4.image  = pageImages[3];
                ImageView4.contentMode = .ScaleAspectFit
        
                self.scrollView.addSubview(ImageView4)
        
                print(scrollViewHeight)
                print(scrollviewWidth)
    
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width*4, self.scrollView.frame.height)
        
    }

    
    
}
