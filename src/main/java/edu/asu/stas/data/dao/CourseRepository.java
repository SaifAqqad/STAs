package edu.asu.stas.data.dao;

import edu.asu.stas.data.models.Course;
import org.springframework.data.repository.CrudRepository;

public interface CourseRepository extends CrudRepository<Course, Long> {
}