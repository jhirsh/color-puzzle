//
//  StatusPage.swift
//  puzzle
//
//  Created by Jonas Hirshland on 7/6/20.
//  Copyright © 2020 Jonas Hirshland. All rights reserved.
//

import Foundation
import ReactiveSwift
import UIKit


class StatusCircle: UIButton {
	var puzzle: PuzzleModel
	
	static let radius: CGFloat = 125
	static let widthHeight: CGFloat = StatusCircle.radius * 2
	
	init(puzzle: PuzzleModel) {
		self.puzzle = puzzle
		super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		
		translatesAutoresizingMaskIntoConstraints = false
		layer.cornerRadius = StatusCircle.radius
		
		titleLabel!.lineBreakMode = .byWordWrapping
		titleLabel!.textAlignment = .center
		titleLabel!.textColor = .white
		
		self.addTarget(self, action: #selector(restartModel), for: .touchUpInside)
		
		setupObservation()
	}
	
	required init?(coder: NSCoder) { fatalError("never") }
	
	/// observe signal coming from validating property
	func setupObservation() {
		puzzle.completed.producer.startWithSignal { signal, _ in
			signal.observeValues { _ in
				switch self.puzzle.completed.result.value {
				case .valid:
					self.setTitle("Tap to restart", for: .normal)
					self.backgroundColor = .green
					
				case .invalid(_, let error):
					switch error {
					case .insufficientMatches:
						self.setTitle("Match all four to win", for: .normal)
						self.backgroundColor = .orange
						
					case .noMatches:
						self.setTitle("Tap and match same\ncolored corner buttons on\nthe other page", for: .normal)
						self.backgroundColor = .gray
						
					}
				default:
					()
				}
			}
		}
	}
	
	/// check for a complete puzzle before restarting
	@objc func restartModel() {
		if !puzzle.completed.result.value.isInvalid {
			print("Restarting Puzzle...")
			puzzle.restart()
		}
	}
}
