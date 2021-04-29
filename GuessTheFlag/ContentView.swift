//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by FARIT GATIATULLIN on 22.03.2021.
//

import SwiftUI

struct ContentView: View {
   @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
   @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var alertText = ""
    @State private var userScore = 0
    
    @State private var correctAnimationAmount = 0.0
    @State private var incorrectOpacityAmount = 1.0
    @State private var incorrectAnimationAmount = 0.0
    @State private var incorrectRotatingNumber:Int? = nil
    
    @State private var toggleAnimation = false
    @State var attempts: Int = 0

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            if attempts <= 10 {
            VStack(spacing: 30) {
                VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.white)
                        Text(countries[correctAnswer])
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                }
                ForEach(0 ..< 3) { number in
                    Button(action: {
 
                        self.flagTapped(number)
                        
//                            if number == correctAnswer {
//                                withAnimation() {
//                        self.animationAmount += 360
//                                }
//                            }
//                            else {
//                                withAnimation() {
//                        self.incorrectAnimationAmount += 360
//                                }
//                            }
                            
                    }) {
//                        Image(self.countries[number])
//                            .renderingMode(.original)
//                            .clipShape(Capsule())
//                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
//                            .shadow(color: .black, radius: 2)
//                        FlagImage(flag: self.countries[number], number: number, correctAnswer: correctAnswer)
                        if number == correctAnswer {
                            FlagImage(flag: self.countries[number], number: number, correctAnswer: correctAnswer)
                                
                                .rotation3DEffect(.degrees(correctAnimationAmount), axis: (x: 0, y: toggleAnimation ? 1 : 0, z: 0))
                                //.animation(.easeInOut)
                                .animation(.interpolatingSpring(stiffness: 350, damping: 50, initialVelocity: 10))

                        } else {
                            FlagImage(flag: self.countries[number], number: number, correctAnswer: correctAnswer)
                                
                                .rotation3DEffect(.degrees(incorrectAnimationAmount), axis: (x: incorrectRotatingNumber == number && toggleAnimation ? 1 : 0, y: 0, z: incorrectRotatingNumber == number && toggleAnimation ? 1 : 0 ))
                                

                                
                                .opacity(incorrectOpacityAmount)
                                //.animation(.easeInOut)
                                                            .animation(.interpolatingSpring(stiffness: 350, damping: 50, initialVelocity: 10))
                                
                        }
                            
                    }
                }
                VStack {
                    Text ("Your current score is")
                        .foregroundColor(.white)
//                    Text("\(userScore)")
//                        .font(.largeTitle)
//                        .fontWeight(.black)
//                        .foregroundColor(.white)
                    if userScore > 0 {
                        Text("\(userScore)")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.green)
                    } else if userScore == 0 {
                        Text("\(userScore)")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                    } else {
                        Text("\(userScore)")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.red)
                    }
                }
                Spacer()
            }
            .alert(isPresented: $showingScore) {
                Alert(title: Text(scoreTitle), message:
                        Text(alertText), dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                })
            }
            } else {
                VStack {
                    Text("Game Over")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text("Your total score is")
                        .font(.title)
                        .foregroundColor(.white)
                    Text("\(userScore)")
                        .font(.largeTitle)
                        .foregroundColor(userScore > 0 ? .green : .red)
                    Button("Restart") {
                        self.askQuestion()
                        attempts = 0
                    }
                    .font(.largeTitle)
                    
                }.alert(isPresented: $showingScore) {
                    Alert(title: Text(scoreTitle), message:
                            Text(alertText), dismissButton: .default(Text("Continue")) {
                        self.askQuestion()
                    })
                }
                
            }
            
            
        }
    }
    
    func flagTapped(_ number: Int) {
        attempts += 1
        toggleAnimation = true
        print("toggle animation true")
        self.incorrectOpacityAmount = 0.5
        if number == correctAnswer {
            withAnimation() {
    self.correctAnimationAmount += 360
            }
            userScore += 1
            scoreTitle = "Correct"
            alertText = """
Your score is \(userScore)
"""
            
        } else {
            incorrectRotatingNumber = number
            withAnimation() {
    self.incorrectAnimationAmount += 180
            }
//            withAnimation(Animation.easeInOut(duration: 10.0)) {
//                self.incorrectAnimationAmount += 360
//            }
            
            userScore -= 1
            scoreTitle = "Wrong"
            alertText = """
That is a flag of \(countries[number])
Your score is \(userScore)
"""
            
        }

        showingScore = true
    }
    
    func askQuestion() {
        self.toggleAnimation = false
        print("toggle animation false")
        self.incorrectRotatingNumber = nil
        self.correctAnimationAmount = 0.0
        self.incorrectOpacityAmount = 1.0
        self.incorrectAnimationAmount = 0.0
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        
        
    }
}

struct FlagImage: View {
    let flag: String
    let number: Int
    let correctAnswer: Int
    //let content: (Int) -> Content

    var body: some View {
//            VStack {
//                ForEach(0..<rows, id: \.self) { row in
//                    HStack {
//                        ForEach(0..<self.columns, id: \.self) { column in
//                            self.content(row, column)
//                        }
//                    }
//                }
//            }
        Image(flag)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
        
        }
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
