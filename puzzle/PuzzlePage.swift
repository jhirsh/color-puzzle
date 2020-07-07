//
//  PuzzlePage.swift
//  puzzle
//
//  Created by Jonas Hirshland on 7/6/20.
//  Copyright © 2020 Jonas Hirshland. All rights reserved.
//

import Foundation
import ReactiveSwift
import UIKit

class PuzzlePage: UIViewController, ViewControllerPage {
	var pageId: Int!
	var puzzle: PuzzleModel
	
	var puzzleButtons: [PuzzleButton]
	
	init(pageId: Int, model: PuzzleModel) {
		self.pageId = pageId
		self.puzzle = model
		
		puzzleButtons = [PuzzleButton]()
		for id in 0..<PuzzleModel.buttonsPerPage { puzzleButtons.append(PuzzleButton(id: pageId * PuzzleModel.buttonsPerPage + id, puzzle: puzzle)) }

		super.init(nibName: nil, bundle: nil)
		
		view.backgroundColor = .black
	}
	
	required init?(coder: NSCoder) { fatalError("never") }
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		
		let safeArea = view.safeAreaLayoutGuide
		
		for puzzleButton in puzzleButtons.enumerated() {
			let button = puzzleButton.element
			
			view.addSubview(button)
			
			NSLayoutConstraint.activate([
				button.xPlacementConstraint(safeArea: safeArea),
				button.yPlacementConstraint(safeArea: safeArea),
				button.widthAnchor.constraint(equalToConstant: PuzzleButton.widthHeight),
				button.heightAnchor.constraint(equalToConstant: PuzzleButton.widthHeight)
			])
		}
	}
	
}

class PuzzleButton: UIButton {
	var id: Int
	
	var puzzle: PuzzleModel
	
	static let radius: CGFloat = 25
	static let widthHeight: CGFloat = PuzzleButton.radius * 2
	
	static let padding: CGFloat = 25
	
	public init(id: Int, puzzle: PuzzleModel) {
		self.id = id
		self.puzzle = puzzle
		
		super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
		translatesAutoresizingMaskIntoConstraints = false
		
		layer.cornerRadius = PuzzleButton.radius
		
		setupObservation()
		
		self.addTarget(self, action: #selector(chooseCard), for: .touchUpInside)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func xPlacementConstraint(safeArea: UILayoutGuide) -> NSLayoutConstraint {
		// x coords alternate left and right side of screen
		if id % 2 == 0 {
			return self.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: PuzzleButton.padding)
		} else {
			return self.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -PuzzleButton.padding)
		}
	}
	
	func yPlacementConstraint(safeArea: UILayoutGuide) -> NSLayoutConstraint {
		// first buttons are on top row
		if id / 2 % 2 == 0 {
			return self.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: PuzzleButton.padding)
		} else {
			return self.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -PuzzleButton.padding)
		}
	}
	
	func setupObservation() {
		self.puzzle.buttons[id].producer.startWithSignal({ signal, _ in
			signal.observeValues({ button in
				DispatchQueue.main.async {
					if button.matched || button.visible {
						self.backgroundColor = button.color
					} else {
						self.backgroundColor = .gray
					}
				}
			})
		})
	}
	
	@objc func chooseCard() {
		puzzle.chooseButton(index: id)
	}
}
