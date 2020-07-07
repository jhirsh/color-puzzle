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
	var buttons: [MutableProperty<Button>] = []
	
	static let buttonsPerPage = 4
	static let numberOfPages = 2
	static let numberOfButtons = PuzzleModel.buttonsPerPage * PuzzleModel.numberOfPages
	
	static let possibleColors: [UIColor] = [.red, .green, .blue, .yellow]
	
	init() {
		/// groups of random-ordered possible colors
		/// 	access: colorFor[page][button]
		let shuffledColors: [[UIColor]] = [PuzzleModel.possibleColors.shuffled(), PuzzleModel.possibleColors.shuffled()]

		/// append to buttons array
		for index in 0..<PuzzleModel.numberOfButtons {
			let currentPage = index/PuzzleModel.buttonsPerPage
			let currentButton = index%PuzzleModel.buttonsPerPage
			
			/// initialize new button with assigned color
			let newButton = Button(color: shuffledColors[currentPage][currentButton])
			
			buttons.append(MutableProperty<Button>(newButton))
		}
	}
	
	func chooseButton(index: Int) {
		/// return function if index is out of range
		if index > 0 && index >= PuzzleModel.numberOfButtons { return }
		
		var chosenButton: MutableProperty<Button> { buttons[index] }
		
		/// if another button is currently chosen, check if there is a match
		if let visibleIndex = buttons.firstIndex(where: { candidate in candidate.value.visible == true }) {
			/// do nothing when button picked on same page
			if (index < 4 && visibleIndex < 4) || (index >= 4 && visibleIndex >= 4) { return }
			
			let visibleButton = buttons[visibleIndex]
			
			chosenButton.value.visible = true
			if chosenButton.value.color == visibleButton.value.color {
				print("Match! (\(index), \(visibleIndex))")
				
				chosenButton.value.matched = true
				visibleButton.value.matched = true
				
				/// reset visible values so visible also marks the currently checking
				chosenButton.value.visible = false
				visibleButton.value.visible = false
			} else {
				/// reset visible values of a failure after one second
				DispatchQueue.global().async {
					usleep(1000000)
					chosenButton.value.visible = false
					visibleButton.value.visible = false
				}
			}
		} else {
			chosenButton.value.visible = true
		}
	}
	
	struct Button {
		var color: UIColor!
		var visible: Bool = false
		var matched: Bool = false
	}
}
