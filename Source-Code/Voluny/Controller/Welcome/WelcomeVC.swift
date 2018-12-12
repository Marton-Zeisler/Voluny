//
//  WelcomeVC.swift
//  Voluny
//


import UIKit

class WelcomeVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var page1ImageView: UIImageView!
    @IBOutlet weak var page2ImageView: UIImageView!
    @IBOutlet weak var page3ImageView: UIImageView!
    @IBOutlet weak var page4ImageView: UIImageView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    let filledImage = UIImage(named: "welcomeFilled")
    let unFilledImage = UIImage(named: "welcomeUnfilled")
    
    @IBOutlet weak var startButton: UIButton!
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        let slides = createSlides()
        setupScrollView(slides)
    }
    
    
    func createSlides() ->[SlideView]{
        let slide1 = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! SlideView
        slide1.headerLabel.text = ""
        slide1.welcomeImage.image = UIImage(named: "welcome1")
        slide1.underImageLabel.text = "Looking to volunteer and help others in your area?"
        slide1.descriptionLabel.text = "We make volunteering quick and simple. Just select your location and browse our categories."
        slide1.otherAspectConstraints.isActive = true
        slide1.thirdAspectConstraint.isActive = false
        
        let slide2 = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! SlideView
        slide2.headerLabel.text = ""
        slide2.welcomeImage.image = UIImage(named: "welcome2")
        slide2.underImageLabel.text = "Found a volunteer experience that works for you?"
        slide2.descriptionLabel.text = "It will only take a few minutes to apply. Wait a bit and someone will get back to you!"
        slide2.otherAspectConstraints.isActive = true
        slide2.thirdAspectConstraint.isActive = false
        
        let slide3 = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! SlideView
        slide3.headerLabel.text = ""
        slide3.welcomeImage.image = UIImage(named: "welcome3")
        slide3.underImageLabel.text = "Seeking for Volunteers for your Organization?"
        slide3.descriptionLabel.text = "Are you a recruiter? We got you! Post and manage listings to find the perfect candidates in 1..2..3"
        slide3.otherAspectConstraints.isActive = false
        slide3.thirdAspectConstraint.isActive = true
        
        let slide4 = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! SlideView
        slide4.headerLabel.text = ""
        slide4.welcomeImage.image = UIImage(named: "welcome4")
        slide4.underImageLabel.text = "We love our community …and so do you!"
        slide4.descriptionLabel.text = "That’s why you are here! Why wait?"
        slide4.otherAspectConstraints.isActive = true
        slide4.thirdAspectConstraint.isActive = false
        
        return [slide1, slide2, slide3, slide4]
    }
    
    func setupScrollView(_ slides: [SlideView]){
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scrollView.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: 1.0)
        scrollView.isPagingEnabled = true
        
        for each in 0..<slides.count{
            slides[each].frame = CGRect(x: view.frame.width * CGFloat(each), y: 0, width: view.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(slides[each])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/scrollView.frame.width)
        if pageIndex == 0{
            backButton.isHidden = true
        }else{
            backButton.isHidden = false
        }
        
        if pageIndex == 3{
            nextButton.isHidden = true
            startButton.isHidden = false
        }else{
            nextButton.isHidden = false
            startButton.isHidden = true
        }
        
        if pageIndex == 0{
            selectedIndex = 0
            page1ImageView.image = filledImage
            
            page2ImageView.image = unFilledImage
            page3ImageView.image = unFilledImage
            page4ImageView.image = unFilledImage
        }else if pageIndex == 1{
            selectedIndex = 1
            page2ImageView.image = filledImage
            
            page1ImageView.image = unFilledImage
            page3ImageView.image = unFilledImage
            page4ImageView.image = unFilledImage
        }else if pageIndex == 2{
            selectedIndex = 2
            page3ImageView.image = filledImage
            
            page1ImageView.image = unFilledImage
            page2ImageView.image = unFilledImage
            page4ImageView.image = unFilledImage
        }else if pageIndex == 3{
            selectedIndex = 3
            page4ImageView.image = filledImage
            
            page1ImageView.image = unFilledImage
            page2ImageView.image = unFilledImage
            page3ImageView.image = unFilledImage
        }
    }
    
    @IBAction func nextTapped(_ sender: UIButton){
        if selectedIndex == 0{
            scrollView.scrollRectToVisible(CGRect(x: view.frame.width, y: 0, width: view.frame.width, height: scrollView.frame.height), animated: true)
        }else if selectedIndex == 1{
            scrollView.scrollRectToVisible(CGRect(x: view.frame.width*2, y: 0, width: view.frame.width, height: scrollView.frame.height), animated: true)
        }else if selectedIndex == 2{
            scrollView.scrollRectToVisible(CGRect(x: view.frame.width*3, y: 0, width: view.frame.width, height: scrollView.frame.height), animated: true)
        }
    }
    
    @IBAction func backTapped(_ sender: UIButton){
        if selectedIndex == 1{
            scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: view.frame.width, height: scrollView.frame.height), animated: true)
        }else if selectedIndex == 2{
            scrollView.scrollRectToVisible(CGRect(x: view.frame.width, y: 0, width: view.frame.width, height: scrollView.frame.height), animated: true)
        }else if selectedIndex == 3{
            scrollView.scrollRectToVisible(CGRect(x: view.frame.width*2, y: 0, width: view.frame.width, height: scrollView.frame.height), animated: true)
        }
    }
    
    @IBAction func startTapped(_ sender: UIButton){
        
    }
    
}
