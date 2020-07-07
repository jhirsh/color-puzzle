//
//  Puzzle.swift
//  puzzle
//
//  Created by Jonas Hirshland on 7/6/20.
//  Copyright © 2020 Jonas Hirshland. All rights reserved.
//

import Foundation
import ReactiveSwift
import UIKit

class PuzzleModel {
	enum IncompleteError: Error {
		case noMatches
		case insufficientMatches
	}
	
	/// keep track of how many matches
	var numberOfMatches = MutableProperty<Int>(0)
	var completed: ValidatingProperty<Int, IncompleteError>
	
	static let possibleColors: [UIColor] = [.red, .green, .blue, .yellow]

	static let buttonsPerPage = 4
	static let numberOfPages = 2
	static let totalNumberOfButtons = PuzzleModel.buttonsPerPage * PuzzleModel.numberOfPages
	
	/// each button is represented as a mutable property which UI will subscribe to
	var buttons: [MutableProperty<Button>] = []
	
	
	init() {
		/// matching is finished once you have matched each button
		completed = ValidatingProperty(numberOfMatches) { matchesCount in
			switch matchesCount {
			case 0:
				return .invalid(.noMatches)
			case 4:
				return .valid
			default:
				return .invalid(.insufficientMatches)
			}
		}
		
		assignAndCreateButtons()
	}
	
	func assignAndCreateButtons() {
		/// groups of random-ordered possible colors
		/// 	access: colorFor[page][button]
		let shuffledColors: [[UIColor]] = [PuzzleModel.possibleColors.shuffled(), PuzzleModel.possibleColors.shuffled()]

		/// append to buttons array
		for index in 0..<PuzzleModel.totalNumberOfButtons {
			let currentPage = index/PuzzleModel.buttonsPerPage
			let currentButton = index%PuzzleModel.buttonsPerPage
			
			/// initialize new button with assigned color
			let newButton = Button(color: shuffledColors[currentPage][currentButton])
			
			buttons.append(MutableProperty<Button>(newButton))
		}
	}
	
	// MARK: - View-Model Interactions
	
	func chooseButton(index: Int) {
		/// return function if index is out of range
		if index > 0 && index >= PuzzleModel.totalNumberOfButtons { return }
		
		var chosenButton: MutableProperty<Button> { buttons[index] }
		
		/// if another button is currently chosen, check if there is a match
		if let visibleIndex = buttons.firstIndex(where: { candidate in candidate.value.visible == true }) {
			/// do nothing when button picked on same page
			if (index < 4 && visibleIndex < 4) || (index >= 4 && visibleIndex >= 4) { return }
			
			let visibleButton = buttons[visibleIndex]
			
			chosenButton.value.visible = true
			if chosenButton.value.color == visibleButton.value.color {
				print("Match! (\(index), \(visibleIndex))")
				numberOfMatches.value += 1
				
				chosenButton.value.matched = true
				visibleButton.value.matched = true
				
				/// reset visible values so visible also marks the currently checking
				chosenButton.value.visible = false
				visibleButton.value.visible = false
				
			} else {
				// TODO: mark as in progress to disallow other taps
				
				/// reset visible values of a failure after one second
				DispatchQueue.global().async {
					usleep(500000)
					chosenButton.value.visible = false
					visibleButton.value.visible = false
				}
				
			}
		} else {
			/// mark button as chosen
			chosenButton.value.visible = true
		}
	}
	
	func restart() {
		let shuffledColors: [[UIColor]] = [PuzzleModel.possibleColors.shuffled(), PuzzleModel.possibleColors.shuffled()]

		/// append to buttons array
		for index in 0..<PuzzleModel.totalNumberOfButtons {
			let currentPage = index/PuzzleModel.buttonsPerPage
			let currentButton = index%PuzzleModel.buttonsPerPage
			
			/// initialize new button with assigned color
			buttons[index].value.color = shuffledColors[currentPage][currentButton]
			buttons[index].value.matched = false
		}
		
		numberOfMatches.value = 0
	}
}

extension PuzzleModel {
	struct Button {
		var color: UIColor!
		var visible: Bool = false
		var matched: Bool = false
	}
}
