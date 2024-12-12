//
//  JobPosts.swift
//  Jobify
//
//  Created by Fatima Ali on 11/12/2024.
//
import UIKit

class JobPost {
    var image: UIImage?
    var time: String
    var title: String
    var date: String
    var level: String
    var enrollmentType: String
    var category: String
    var location: String
    var description: String
    var jobDescription: String
    
    init(image: UIImage?, time: String, title: String, date: String, level: String, enrollmentType: String, category: String, location: String, description: String, jobDescription: String) {
        self.image = image
        self.time = time
        self.title = title
        self.date = date
        self.level = level
        self.enrollmentType = enrollmentType
        self.category = category
        self.location = location
        self.description = description
        self.jobDescription = jobDescription
    }
}

// Declare the jobPosts array and initialize it with job posts
var jobs: [JobPost] = [
    JobPost(
        image: UIImage(named: "Batelco Logo"),
        time: "12:15, 25-10-2024",
        title: "Software Developer",
        date: "25-10-2024",
        level: "Executive",
        enrollmentType: "Full-time",
        category: "Information Technology",
        location: "Bahrain",
        description: "Description",
        jobDescription: "As a Software Developer, you will work with various technologies..."
    ),
    JobPost(
        image: UIImage(named: "GDN logo"),
        time: "09:30, 01-11-2024",
        title: "UX Designer",
        date: "01-11-2024",
        level: "Senior",
        enrollmentType: "Part-time",
        category: "Design",
        location: "Dubai",
        description: "Description",
        jobDescription: "We are looking for a talented UX Designer to join our team."
    ),
    JobPost(
        image: UIImage(named: "Gulf Digital Group Logo"),
        time: "14:45, 05-12-2024",
        title: "Data Scientist",
        date: "05-12-2024",
        level: "Junior",
        enrollmentType: "Contract",
        category: "Data Science",
        location: "Remote",
        description: "Description",
        jobDescription: "As a Data Scientist, you will analyze large datasets to uncover insights and build predictive models."
    )
]
