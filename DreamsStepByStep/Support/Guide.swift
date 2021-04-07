//
//  Guide.swift
//  DreamsStepByStep
//
//  Created by Jamal on 4/7/21.
//

import Foundation
import SwiftUI

enum TextStyleType{
    case body
    case highlighted
}

class TextStyle: Identifiable{
    var text = ""
    var type = TextStyleType.body
    
    init(text: String){
        self.text = text
    }
}

class HighlightedText: TextStyle{
    override init(text: String){
        super.init(text: text)
        type = TextStyleType.highlighted
        
    }
}

class Guide: Identifiable {
    var title: String = ""
    var content: [TextStyle] = []
    
    
    init(){
        
    }
    
    
    private static var guide1: Guide = {
        let guide = Guide()
        guide.title = "JUST GET STARTED"
        
        guide.content.append(TextStyle(text: "We all have a lot of goals, dreams, desires in our life and we want to achieve them This app will guide you step-by-step through how to reach your dreams and get to know yourself and your abilities and capabilities and worthiness.\n This app Guide you to get to know yourself better and helps you step by step to know next actions and act on your dreams."))
        
        
        
        return guide
    }()
    
    
    
    private static var guide2: Guide = {
        let guide = Guide()
        guide.title = "How Dreams come true?"
          guide.content.append(TextStyle(text: "The speed of reaching dreams is determined by our thoughts and feelings When we have a strong feeling about a purpose or a dream, we are very likely to achieve it."))
        return guide
    }()
    
    private static var guide3: Guide = {
        let guide = Guide()
        guide.title = "So to achieve your dreams and goals:"
        guide.content.append(TextStyle(text: "1- Specify your goals and dreams, something like learning new skills, fitness, changing financial conditions, or discovery and … \n\n2- Identify and specify the reasons that why you want to reach this specific goal or dream and specify when you attain that what good things will happen in your life, how you will be in that position? explain it deeply and exaggerate the good results of this goal for yourself to have good feeling about it.\n\n 3- Identify and specify the what will happen if you don’t reach this specific goal or dream in your life, how you will be in that position? explain it deeply and exaggerate the bad results.\n\n 4- Review Frequently the reasons that you specified in step 2 and 3 To have strong feeling about your dreams.step 2 and 3 is the Leverage suffering and pleasure.\n\n 5- Just start acting and take steps on the way to your goals do everything that came to your mind to achieve your dream just take steps no matter how big or small your steps are, your first step may be just a simple phone call or relocation.\n\n6- Measure how you feel about each step you take try to have feel good about every step you take. the better you feel, the closer you are to the goal. maybe in the next step you will reach to your dream. \n\n 7- Take note of the things that you understood and learned in every step and actions in the way of your dream or goal."))
        return guide
    }()
    
    private static var guide4: Guide = {
        let guide = Guide()
        guide.title = ""
          guide.content.append(TextStyle(text: "* This app has all these features to help and guide you to achieve your dreams"))
        return guide
    }()
    
    private static var guide5: Guide = {
        let guide = Guide()
        guide.title = "Consider: "
          guide.content.append(TextStyle(text: "1- If you have strong and good Feeling you are closer to your dreams \n\n2- To achieve your dreams, time doesn't matter Don't make it hard by measuring the time \n\n3- Don’t spend time for planing and scheduling take steps, When you have a lot of planning and scheduling, you make your mind confused and complex and it can’t think creatively. Instead take Steps. \n\n4- Don’t make it complicated JUST Start to take Steps with good feeling toward your dreams, make it as simple as possible by dividing it into smaller parts and steps.\n\n 5- It doesn’t matter your actions and steps are big or small, Every step has its importance and try to do the steps as accurately as possible, the smallest step can lead us to great success \n\n6- If you could read Darren Hardy's compound effect book, It tells us how the compound effect of our actions leads us to our dreams. \n\n7- Always try to strengthen your intellectual and emotional connection with your dreams and goals it makes us powerful. \n\n8- Again and Again Don't make it hard don’t try hard always make things very easy and simple Do not struggle look for easy and simplicity. There is always a simpler, easier, shortcut way.\n\n 9- The amount of money and fund, literacy and education, your place and time and what you have or not good or bad, they all do not matter and again, Not all of them are important. \n\n10- You will achieve the things you need to achieve On the way to the goals And things you don't like will be removed from your path Just think about your goals don’t think about the problems you will find your way. \n\n 11- No matter how much information and experience you have about your dreams, you will understand and learn the most important things throughout the path step by step. \n\n12- And Again Get Started From Where You Are No matter where in the world you are and what your name and business are and everything else is, you reach your dreams and goals when you start thinking and feeling more and more about your dreams and goals."))
        return guide
    }()
    
//    private static var guide4: Guide = {
//        let guide = Guide()
//        guide.title = ""
//          guide.content.append(TextStyle(text: ""))
//        return guide
//    }()
//
    
    static var guides: [Guide] = [
        guide1,
        guide2,
        guide3,
        guide4,
        guide5,
        
        
    ]
}
