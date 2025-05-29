//
//  CoursesTableElement.swift
//  ITExams
//
//  Created by Андрей Чернышев on 26.04.2022.
//

final class CoursesTableCourseElement {
    let course: Course
    var isCurrent: Bool
    var isSelected: Bool
    
    init(course: Course, isCurrent: Bool, isSelected: Bool) {
        self.course = course
        self.isCurrent = isCurrent
        self.isSelected = isSelected
    }
}
