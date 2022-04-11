package edu.asu.stas.data.dao;

import edu.asu.stas.data.models.Project;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProjectRepository extends JpaRepository<Project, Long> {
}