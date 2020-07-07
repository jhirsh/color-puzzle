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


class StatusPage: UIViewController, ViewControllerPage {
	var pageId: Int!
	var puzzle: PuzzleModel

	// TODO: create status page that shows you how much the puzzle is done
	let statusView = StatusCircle(puzzle: PuzzleModel())
	
	init(pageId: Int, model: PuzzleModel) {
		puzzle = model
		self.pageId = pageId
		
		super.init(nibName: nil, bundle: nil)
		
		self.view.backgroundColor = .black
	}
	
	required init?(coder: NSCoder) { fatalError("never") }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addSubview(statusView)
		
		NSLayoutConstraint.activate([
			statusView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			statusView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			statusView.widthAnchor.constraint(equalToConstant: StatusCircle.widthHeight),
			statusView.heightAnchor.constraint(equalToConstant: StatusCircle.widthHeight)
		])
	}
	
	class StatusCircle: UIView {
		var puzzle: PuzzleModel
		
		static let radius: CGFloat = 80
		static let widthHeight: CGFloat = StatusCircle.radius * 2
		
		init(puzzle: PuzzleModel) {
			self.puzzle = puzzle
			super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
			
			translatesAutoresizingMaskIntoConstraints = false
			layer.cornerRadius = StatusCircle.radius
			
			backgroundColor = .gray
			
		}
	
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
}
