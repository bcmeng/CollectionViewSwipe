//
//  ViewController.swift
//  CollectionViewSwipe
//
//  Created by Alex on 3/18/15.
//  Copyright (c) 2015 WebFuture. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, SMSegmentViewDelegate {
    
    // MARK: - Local data
    
    let images = ["img1", "img2", "img3", "img4", "img5", "img6", "img7"]
    var colors = ["black", "coconut", "flamingo pink", "tropical orange", "kalua nude", "pacific blue", "colibri green"]
    
    var segmentView: SMSegmentView!
    var margin: CGFloat = 30.0
    
    let mediumGray = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
    
    var colorSelectionImageView = UIImageView()
    


    
    
    // MARK: - Outlets & Actions
    
    @IBOutlet weak var swipeCV: UICollectionView!
    
    @IBOutlet weak var colorSelectionCV: UICollectionView!
    
    
    @IBAction func goToNextImage(sender: AnyObject) {
        
        var indexPathArray = swipeCV.indexPathsForVisibleItems()
        var currentIndexPath = indexPathArray.first as NSIndexPath
        var nextIndexPath = NSIndexPath(forItem: currentIndexPath.item + 1, inSection: 0)

        // protecting against crash
        
        if nextIndexPath.item < images.count {
            
            self.swipeCV.scrollToItemAtIndexPath(nextIndexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
            pageControl.currentPage = nextIndexPath.item
        }
    }
    
    @IBAction func goBackToImage(sender: AnyObject) {
        
        var indexPathArray = swipeCV.indexPathsForVisibleItems()
        var currentIndexPath = indexPathArray.first as NSIndexPath
        var previousIndexPath = NSIndexPath(forItem: currentIndexPath.item - 1, inSection: 0)
        
        // protecting against crash
        
        if previousIndexPath.item >= 0 {
            
            self.swipeCV.scrollToItemAtIndexPath(previousIndexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
            pageControl.currentPage = previousIndexPath.item
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var pageScoll: UIScrollView!
    
    @IBOutlet weak var psvLabel: UILabel!
    
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var colorLabel: UILabel!
    

    
    // MARK: - UICollectionView data source & delegate
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
     
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1 {
            
            return images.count
        }

        if collectionView.tag == 2 {
        
            return colors.count
        }
            
        return 0
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = colorSelectionCV.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as ColorSelectionCollectionViewCell
        
        if collectionView.tag == 1 {
            
            let swipeCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as MyCollectionViewCell
            
            // Configure the cell
            
            // Image aspect fill & hidden horizontal scroll indicator set in storyboard
            
            var imageName = images[indexPath.row] as String
            swipeCell.slideImage.image = UIImage(named: imageName)
            
            return swipeCell
            
        } else if collectionView.tag == 2 {
        
            let colorCell = colorSelectionCV.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as ColorSelectionCollectionViewCell
            
            // Configure the cell
            
            var colorName = colors[indexPath.row] as String
            colorCell.colorSelectionImageView.image = UIImage(named: "\(colorName).jpeg")
            
            return colorCell

        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
        // Update color label
        
        colorLabel.text = "Selected color: \(colors[indexPath.item])"
        
        // Draw custom circle around selected cell item
        
        colorSelectionImageView.image = nil
        colorSelectionImageView.removeFromSuperview()
        
        let rectX: CGFloat = self.colorSelectionCV.cellForItemAtIndexPath(indexPath)!.frame.origin.x
        let rectY: CGFloat = self.colorSelectionCV.cellForItemAtIndexPath(indexPath)!.frame.origin.y
        
        let cellWidth = self.colorSelectionCV.cellForItemAtIndexPath(indexPath)!.bounds.width
        let cellHeight = self.colorSelectionCV.cellForItemAtIndexPath(indexPath)!.bounds.height
        
        let imageSize = CGSize(width: 40, height: 40)
        
        colorSelectionImageView = UIImageView(frame: CGRect(origin: CGPoint(x: rectX - (imageSize.width - cellWidth)/2 , y: rectY - (imageSize.height - cellHeight)/2), size: imageSize))
        let image = drawCustomCircle(imageSize)
        
        self.colorSelectionCV.addSubview(colorSelectionImageView)
        colorSelectionImageView.image = image
        
        
    }
    
    func drawCustomCircle(size: CGSize) -> UIImage {
        
        let lineWidth: CGFloat = 2.0
        
        // Setup our context
        // prevent stroke croping
        let bounds = CGRect(origin: CGPointMake(lineWidth/2, lineWidth/2), size: CGSize(width: size.width - lineWidth, height: size.height - lineWidth))
        let opaque = false
        let scale: CGFloat = 0
        
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        
        // Setup complete, do drawing here
        CGContextSetStrokeColorWithColor(context, mediumGray.CGColor)
        CGContextSetLineWidth(context, lineWidth)
        CGContextStrokeEllipseInRect(context, bounds)
        
        // Drawing complete, retrieve the finished image and cleanup
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    

    
    
    // MARK: - UIScrollViewDelegate
    
    // updating page control's current page when scroll stops
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        var indexPathArray = swipeCV.indexPathsForVisibleItems()
        var currentIndexPath = indexPathArray.first as NSIndexPath
        
        pageControl.currentPage = currentIndexPath.item
    }
    
    
    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Settig page scroll
        
        pageScoll.delegate = self
        
        pageScoll.contentSize.width = UIScreen.mainScreen().bounds.width
        pageScoll.contentSize.height = 1036
        
        
        // Create a custom SM segmented view
        
            let segmentViewProperties : Dictionary<String, AnyObject> = [   keySegmentTitleFont: UIFont.systemFontOfSize(14),
                                                                            keySegmentOnSelectionColour: mediumGray,
                                                                            keySegmentOffSelectionColour: UIColor.whiteColor(),
                                                                            keyContentVerticalMargin: 10.0]
            
            segmentView = SMSegmentView(frame: CGRect(x: margin, y: 532, width: self.view.frame.size.width - margin*2, height: 30),
                separatorColour: mediumGray, separatorWidth: 0.5, segmentProperties: segmentViewProperties)
            
            segmentView.delegate = self
            
            segmentView.addSegmentWithTitle("34", onSelectionImage: nil, offSelectionImage: nil)
            segmentView.addSegmentWithTitle("36", onSelectionImage: nil, offSelectionImage: nil)
            segmentView.addSegmentWithTitle("38", onSelectionImage: nil, offSelectionImage: nil)
            segmentView.addSegmentWithTitle("40", onSelectionImage: nil, offSelectionImage: nil)
            segmentView.addSegmentWithTitle("42", onSelectionImage: nil, offSelectionImage: nil)
            segmentView.addSegmentWithTitle("44", onSelectionImage: nil, offSelectionImage: nil)
            segmentView.addSegmentWithTitle("LSM", onSelectionImage: nil, offSelectionImage: nil)
            
            // You can programmatically select/deselect a segment by calling selectSegmentAtIndex(index: Int)
            segmentView.selectSegmentAtIndex(0)
            
            self.pageScoll.addSubview(self.segmentView)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        
        psvLabel.hidden = true
        

        
    }
    
    // MARK: - SMSegment delegate
    
    func didSelectSegmentAtIndex(segmentIndex: Int) {
        
        // Replace the following line to implement what you want the app to do after the segment gets tapped.
        
        println("Select segment at index: \(segmentIndex)")
        
        switch segmentIndex {
            
        case 0: sizeLabel.text = "Selected size: 34"
        case 1: sizeLabel.text = "Selected size: 36"
        case 2: sizeLabel.text = "Selected size: 38"
        case 3: sizeLabel.text = "Selected size: 40"
        case 4: sizeLabel.text = "Selected size: 42"
        case 5: sizeLabel.text = "Selected size: 44"
        case 6: sizeLabel.text = "Selected size: luxury-sur-mesure"
            
        default: sizeLabel.text = "Selected size: 34"
        
        }
        
    }
    

}

