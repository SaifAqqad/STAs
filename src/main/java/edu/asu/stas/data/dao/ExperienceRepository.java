package edu.asu.stas.data.dao;

import edu.asu.stas.data.models.Experience;
import org.springframework.data.repository.CrudRepository;

public interface ExperienceRepository extends CrudRepository<Experience, Long> {
}