//
//  EngagementScorer.swift
//  BrandWatchClient
//
//  Created by Nabib El-RAHMAN on 10/20/14.
//  Copyright (c) 2014 BrandWatch. All rights reserved.
//

let SHARES_WEIGHT = 3
let FAVORITES_WEIGHT = 2
let LIKES_WEIGHT = 2
let COMMENTS_WEIGHT = 4
let VIEWS_WEIGHT = 1


class EngagementScorer: NSObject {
    
    class func calculateTotalScore(campaign: Campaign) -> Int {
        return Int(self.calculateScore(campaign, metrics: campaign.metrics_total!))
    }
    

    private class func calculateScore(campaign: Campaign, metrics: Metrics) -> Float {
        let sharesTarget = campaign.shares_target
        let favoritesTarget = campaign.favorites_target
        let likesTarget = campaign.likes_target
        let commentsTarget = campaign.comments_target
        let viewsTarget = campaign.views_target
        
        let maxShares = SHARES_WEIGHT * (sharesTarget!)
        let maxFavorites = FAVORITES_WEIGHT * (favoritesTarget!)
        let maxLikes = LIKES_WEIGHT * (likesTarget!)
        let maxComments = COMMENTS_WEIGHT * (commentsTarget!)
        let maxViews = VIEWS_WEIGHT * (viewsTarget!)
        
        //Now the maxScore
        let maxScore = maxShares + maxFavorites + maxLikes + maxComments + maxViews
        
        println("maxScore: \(maxScore)" )
        
        
        let shares = metrics.shares
        let favorites = metrics.favorites
        let likes = metrics.likes
        let comments = metrics.comments
        let views = metrics.views
        
        let sharesScore = calcuateWeightScore(SHARES_WEIGHT, achieved: shares!)
        
        let favoritesScore = calcuateWeightScore(FAVORITES_WEIGHT, achieved: favorites!)
        
        let likesScore = calcuateWeightScore(LIKES_WEIGHT, achieved: likes!)

        let commentsScore = calcuateWeightScore(LIKES_WEIGHT, achieved: comments!)
        
        let viewsScore = calcuateWeightScore(LIKES_WEIGHT, achieved: views!)
        
        //now acheivedScore
        let acheivedScore = sharesScore + favoritesScore + likesScore + commentsScore + viewsScore
        
        //not lets come up with a percentage
        let rawPercentage = Float(acheivedScore) / Float(maxScore)
        
        //normalize
        
        return rawPercentage * 100

    }
    
    private class func calcuateWeightScore(weight: Int, achieved: Int) -> Int {
        return achieved * weight
    }
}
