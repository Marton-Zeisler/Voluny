//
//  Review.swift
//  Voluny
//


import Foundation

class Review{
    private var _reviewerName: String
    private var _rating: Double
    private var _date: String
    private var _reviewDescription: String
    
    var reviewerName: String{
        return _reviewerName
    }
    
    var rating: Double{
        return _rating
    }
    
    var date: String{
        return _date
    }
    
    var reviewDescription: String{
        return _reviewDescription
    }
    
    init(reviewerName: String, rating: Double, date: String, reviewDescription: String){
        self._reviewerName = reviewerName
        self._rating = rating
        self._date = date
        self._reviewDescription = reviewDescription
    }
    
}
