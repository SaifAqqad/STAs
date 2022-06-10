package edu.asu.stas.studentprofile.skill;

import edu.asu.stas.studentprofile.StudentProfile;
import edu.asu.stas.studentprofile.endorsement.Endorsement;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import net.minidev.json.annotate.JsonIgnore;
import org.hibernate.validator.constraints.Range;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Setter
@Getter
@NoArgsConstructor
public class Skill {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @Range(min = 0, max = 100)
    private int level;

    @ManyToOne(optional = false)
    @JsonIgnore
    private StudentProfile profile;

    @OneToMany(mappedBy = "skill", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private final List<Endorsement> endorsements = new ArrayList<>();
}
