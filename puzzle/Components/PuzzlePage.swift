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
		
		let safeArea = view.safeAreaLayoutGuide
		
		/// add each button to view
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
		
		
		/// add status circle
		let status = StatusCircle(puzzle: puzzle)
		
		view.addSubview(status)
		
		NSLayoutConstraint.activate([
			status.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			status.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			status.widthAnchor.constraint(equalToConstant: StatusCircle.widthHeight),
			status.heightAnchor.constraint(equalToConstant: StatusCircle.widthHeight)
		])
	}
}

