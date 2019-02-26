//
//  CalendarCell.swift
//  SimpleCalendar
//
//  Created by Ilia Kolomeitsev on 26/02/2019.
//  Copyright © 2019 Ilia Kolomeitsev. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCell: JTAppleCell {

	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var selectionView: UIView!
	@IBOutlet weak var preSelectedView: UIView!
}
