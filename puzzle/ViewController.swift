//
//  ViewController.swift
//  puzzle
//
//  Created by Jonas Hirshland on 7/6/20.
//  Copyright © 2020 Jonas Hirshland. All rights reserved.
//

import UIKit
import ReactiveSwift

protocol ViewControllerPage {
	var pageId: Int! { get set }
}

class ViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
	var puzzle: PuzzleModel!
	
	var pages: [UIViewController]
		
	override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
		puzzle = PuzzleModel()
		
		pages = [
			PuzzlePage(pageId: 0, model: puzzle),
			StatusPage(pageId: 1, model: puzzle),
			PuzzlePage(pageId: 2, model: puzzle)
		]
		
		super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.delegate = self
		self.dataSource = self
		setViewControllers([pages[1]], direction: .reverse, animated: false, completion: nil)
		definesPresentationContext = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		let nextIndex = (viewController as! ViewControllerPage).pageId - 1
		if nextIndex < 0 {
			return nil // pages[pages.count - 1]
		}
		
		return pages[nextIndex]
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		let nextIndex = (viewController as! ViewControllerPage).pageId + 1
		
		if nextIndex == pages.count {
			return nil // pages[0]
		}
		return pages[nextIndex]
	}

	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return pages.count
	}

	func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		return 1
	}
}

