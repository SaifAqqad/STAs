package edu.asu.stas.data.dao;

import edu.asu.stas.data.models.Activity;
import org.springframework.data.repository.CrudRepository;

public interface ActivityRepository extends CrudRepository<Activity, Long> {
}