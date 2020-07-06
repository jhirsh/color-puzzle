//
//  Puzzle.swift
//  puzzle
//
//  Created by Jonas Hirshland on 7/6/20.
//  Copyright © 2020 Jonas Hirshland. All rights reserved.
//

import Foundation
import ReactiveSwift

class PuzzleModel {
	let button1: Property<Bool>
	
	init() {
		button1 = Property<Bool>(value: false)
	}
}
