package edu.asu.stas;

import edu.asu.stas.studentprofile.StudentProfile;
import edu.asu.stas.studentprofile.StudentProfileRepository;
import edu.asu.stas.studentprofile.activity.Activity;
import edu.asu.stas.studentprofile.activity.ActivityRepository;
import edu.asu.stas.studentprofile.course.Course;
import edu.asu.stas.studentprofile.course.CourseRepository;
import edu.asu.stas.studentprofile.experience.Experience;
import edu.asu.stas.studentprofile.experience.ExperienceRepository;
import edu.asu.stas.studentprofile.project.Project;
import edu.asu.stas.studentprofile.project.ProjectRepository;
import edu.asu.stas.studentprofile.skill.Skill;
import edu.asu.stas.studentprofile.skill.SkillRepository;
import edu.asu.stas.user.User;
import edu.asu.stas.user.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.dao.DataAccessException;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDate;

@SpringBootApplication
public class STAsApplication {

    public static void main(String[] args) {
        SpringApplication.run(STAsApplication.class, args);
    }

    @Bean
    @Autowired
    public ApplicationRunner seedDataLoader(
            UserRepository userRepository,
            PasswordEncoder passwordEncoder,
            StudentProfileRepository studentProfileRepository,
            CourseRepository courseRepository,
            ActivityRepository activityRepository,
            ProjectRepository projectRepository,
            SkillRepository skillRepository,
            ExperienceRepository experienceRepository
    ) {
        return args -> {
            if (args.containsOption("addSeedData")) {

                try {
                    User user1 = new User();
                    user1.setFirstName("Saif");
                    user1.setLastName("Aqqad");
                    user1.setEmail("saif@gmail.com");
                    user1.setPassword(passwordEncoder.encode("s1a2i3f4"));
                    user1.setDateOfBirth(LocalDate.of(1999, 10, 14));
                    user1.setRole(User.Roles.ADMIN);
                    user1.setEnabled(true);
                    user1 = userRepository.save(user1);

                    StudentProfile profile = new StudentProfile();
                    profile.setName("Saif Alaqqad");
                    profile.setUniversity("Applied Science University");
                    profile.setMajor("Computer Science");
                    profile.setAbout("""
                            ## Lorem ipsum

                            dolor sit amet, nibh suavitate qualisque ut nam. Ad harum primis electram duo, porro principes ei has Lorem ipsum dolor sit amet, nibh suavitate qualisque ut nam. Ad harum primis electram duo, porro principes ei has.
                            _____
                            * Ad harum primis electram duo, porro principes ei has.
                            * Ad harum primis electram duo, porro principes ei has.
                            * Ad harum primis electram duo, porro principes ei has.
                            """);
                    profile.setContactEmail("saif.w.alaqqad@gmail.com");
                    profile.setContactPhone("+962799545922");
                    profile.setLocation("Amman, Jordan");
                    profile.getLinks().put("GitHub", "https://github.com/SaifAqqad/");
                    profile.setUser(user1);
                    profile = studentProfileRepository.save(profile);

                    Skill skill1 = new Skill();
                    skill1.setName("Java");
                    skill1.setLevel(80);
                    skill1.setProfile(profile);
                    skillRepository.save(skill1);
                    Skill skill2 = new Skill();
                    skill2.setName("Spring");
                    skill2.setLevel(65);
                    skill2.setProfile(profile);
                    skillRepository.save(skill2);

                    Course course = new Course();
                    course.setName("The Java workshop");
                    course.setDescription("The Workshop starts by showing you how to use classes, methods, and the built-in Collections API to manipulate data structures effortlessly. You'll dive right into learning about object-oriented programming by creating classes and interfaces and making use of inheritance and polymorphism. After learning how to handle exceptions, you'll study the modules, packages, and libraries that help you organize your code. As you progress, you'll discover how to connect to external databases and web servers, work with regular expressions, and write unit tests to validate your code. You'll also be introduced to functional programming and see how to implement it using lambda functions.");
                    course.setStudentComment("This book helped me learn Java in-depth, it covers a lot of great topics like IO, encryption and functional programming");
                    course.setImageUri("https://static.packt-cdn.com/products/9781838986698/cover/smaller");
                    course.setUrl("https://www.packtpub.com/product/the-java-workshop/9781838986698");
                    course.setPublisher("Packt");
                    course.setProfile(profile);
                    courseRepository.save(course);

                    Activity activity = new Activity();
                    activity.setName("Hash Code 2021");
                    activity.setDescription("Team programming competition, organized by Google, for students and professionals around the world. You pick your team and programming language and we pick an engineering problem for you to solve.");
                    activity.setDate(LocalDate.of(2021, 2, 25));
                    activity.setImageUri("https://geeksgod.com/wp-content/uploads/2021/02/Google-Hash-Code.jpg");
                    activity.setProfile(profile);
                    activityRepository.save(activity);

                    Project project = new Project();
                    project.setName("AHK_MicMute");
                    project.setDescription("open-source program that allows you to mute your microphone with a pre-defined hotkey. It supports custom mute sounds, profiles, push-to-talk, AFK timeout, and more.");
                    project.setUrl("https://github.com/SaifAqqad/AHK_MicMute");
                    project.setImageUri("https://github.com/SaifAqqad/AHK_MicMute/raw/master/screenshots/configwindow_1.png");
                    project.setStartDate(LocalDate.of(2020, 5, 9));
                    project.setProfile(profile);
                    projectRepository.save(project);

                    Experience experience = new Experience();
                    experience.setCompanyName("Amazon");
                    experience.setJobTitle("Software Development Engineer");
                    experience.setDescription("""
                            - Implement, deploy highly available and highly scalable reverse proxy keeping security, performance and robustness in mind.
                            - Work in a multi-regional team and maintain clear communication across different time-zones using agile principles.
                            - Collaborate with a variety of other services, teams and APIs.\s
                            - Design and create scalable API’s for internal and public consumption.
                            - Conduct interviews with stakeholders for setting expectations.
                            """);
                    experience.setStartDate(LocalDate.of(2020, 5, 19));
                    experience.setProfile(profile);
                    experienceRepository.save(experience);

                    Experience experience2 = new Experience();
                    experience2.setCompanyName("Google");
                    experience2.setJobTitle("Software Engineering Intern");
                    experience2.setStartDate(LocalDate.of(2019, 11, 20));
                    experience2.setEndDate(LocalDate.of(2020, 2, 13));
                    experience2.setProfile(profile);
                    experienceRepository.save(experience2);
                } catch (DataAccessException ignored) {
                    // do nothing
                }
            }
        };
    }

}
