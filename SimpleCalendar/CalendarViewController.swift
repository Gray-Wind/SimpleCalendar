//
//  ViewController.swift
//  SimpleCalendar
//
//  Created by Ilia Kolomeitsev on 26/02/2019.
//  Copyright © 2019 Ilia Kolomeitsev. All rights reserved.
//

import UIKit
import JTAppleCalendar

enum PreSelectedDateType {
	case left, right, middle, full, none
}


public struct DateRange {
	var startDate: Date
	var endDate: Date
	fileprivate func contains(date: Date) -> Bool {
		return (startDate ... endDate).contains(date)
	}
}


class CalendarViewController: UIViewController {

	private let formatter = DateFormatter()
	@IBOutlet weak var calendarView: JTAppleCalendarView!

	var preSelectedDateRange: [DateRange] {
		return [DateRange(startDate: Date(), endDate: Date().addingTimeInterval(60 * 60 * 24 * 4))]
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupCalendarView()
	}

	func setupCalendarView() {
		calendarView.allowsDateCellStretching = false
		calendarView.allowsMultipleSelection = true
		calendarView.isRangeSelectionUsed = true

		calendarView.minimumLineSpacing = 0
		calendarView.minimumInteritemSpacing = 0
		calendarView.scrollToHeaderForDate(Date())
	}
}

extension CalendarViewController {

	private func configureCell(cell: JTAppleCell?, cellState: CellState, date: Date) {
		guard let validCell = cell as? CalendarCell else {
			return
		}

		updateSelectionViews(for: cell, cellState: cellState, date: date)

		validCell.isHidden = cellState.dateBelongsTo != .thisMonth
	}

	private func updateSelectionViews(for cell: JTAppleCell?, cellState: CellState, date: Date) {
		guard let validCell = cell as? CalendarCell else {
			return
		}

		validCell.selectionView.isHidden = false
		let height = validCell.preSelectedView.bounds.height / 2

		switch cellState.selectedPosition() {
		case .left:
			validCell.selectionView.layer.cornerRadius = height
			validCell.selectionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
		case .middle:
			validCell.selectionView.layer.cornerRadius = 0
			validCell.selectionView.layer.maskedCorners = []
		case .right:
			validCell.selectionView.layer.cornerRadius = height
			validCell.selectionView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
		case .full:
			validCell.selectionView.layer.cornerRadius = height
			validCell.selectionView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
		default:
			validCell.selectionView.isHidden = true
		}

		let size = validCell.contentView.bounds.width / 10
		print(size)

		let patternColor = UIColor(patternImage: drawCustomImage(size: CGSize(width: size, height: size)))
		validCell.preSelectedView.backgroundColor = patternColor
		validCell.preSelectedView.isHidden = false

		switch preSelectedType(for: date) {
		case .left:
			validCell.preSelectedView.layer.cornerRadius = height
			validCell.preSelectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
		case .middle:
			validCell.preSelectedView.layer.cornerRadius = 0
			validCell.preSelectedView.layer.maskedCorners = []
		case .right:
			validCell.preSelectedView.layer.cornerRadius = height
			validCell.preSelectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
		case .full:
			validCell.preSelectedView.layer.cornerRadius = height
			validCell.preSelectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
		default:
			validCell.preSelectedView.isHidden = true
		}
	}

	func preSelectedType(for date: Date) -> PreSelectedDateType {
		guard let range = preSelectedDateRange.first(where: { $0.contains(date: date) }) else {
			return .none
		}

		if range.contains(date: date.addingTimeInterval(60 * 60 * 24)) {
			if range.contains(date: date.addingTimeInterval(-60 * 60 * 24)) {
				return .middle
			}
			return .left
		}
		if range.contains(date: date.addingTimeInterval(-60 * 60 * 24)) {
			return .right
		}
		return .full
	}
}

extension CalendarViewController: JTAppleCalendarViewDelegate {

	public func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
		configureCell(cell: cell, cellState: cellState, date: date)
	}

	public func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
		let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
		cell.dateLabel.text = cellState.text
		configureCell(cell: cell, cellState: cellState, date: date)
		return cell
	}

	public func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
		let header  = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "CalendarHeader", for: indexPath) as! CalendarHeader

		formatter.dateFormat = "MMMM"
		header.monthTitle.text = formatter.string(from: range.start)

		formatter.dateFormat = "yyyy"
		header.yearTitle.text = formatter.string(from: range.start)

		return header
	}

	public func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
		updateSelectionViews(for: cell, cellState: cellState, date: date)
	}

	public func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
		updateSelectionViews(for: cell, cellState: cellState, date: date)
	}

	public func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
		return MonthSize(defaultSize: 50)
	}
}

extension CalendarViewController: JTAppleCalendarViewDataSource {

	public func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
		let parameters = ConfigurationParameters(startDate: Date().addingTimeInterval(-60 * 60 * 24 * 32),
			endDate: Date().addingTimeInterval(60 * 60 * 24 * 63),
			numberOfRows: 6,
			calendar: Calendar.current,
			generateInDates: .forAllMonths,
			generateOutDates: .off,
			firstDayOfWeek: DaysOfWeek(rawValue: Calendar.current.firstWeekday) ?? .monday,
			hasStrictBoundaries: true)

		return parameters
	}
}
