<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />
<#import "./popup.ftl" as popups/>

<!DOCTYPE html>
<html lang="en">

<@default.head title="Profile - STAs">
    <style>
        .scrollable-box {
            max-height: 600px;
            overflow: auto;
        }
    </style>
</@default.head>

<body>
<@default.navbar profile="active"/>

<div class="container-fluid my-3">
    <div id="profile">
        <div class="row">
            <#-- Left column -->
            <div class="col-md-4 col-lg-3">
                <div id="profileInfo" class="card-border-grey rounded-2 p-2 mb-3">
                    <div class="text-center ms-3">
                        <div class="p-2">
                            <img class="figure-img img-w-100 rounded-circle" src="${profile.imagerUri}"
                                 alt="profile picture"/>
                        </div>
                        <div class="fs-4" id="profileName">${profile.name}</div>
                        <div class="fs-6 text-muted">${profile.major}</div>
                    </div>
                    <hr class="mx-4"/>
                    <div class="ps-3">
                        <@profileItem text=profile.location icon="location"/>
                        <@profileItem text=profile.university icon="university"/>
                        <@profileItem text=profile.contactEmail icon="email" link="mailto:${profile.contactEmail}"/>
                        <@profileItem text=profile.contactPhone icon="phone" link="tel:${profile.contactPhone}"/>
                        <@profileItem text="GitHub" icon="github" link="https://github.com/SaifAqqad" showLinkIcon=true/>
                        <@profileItem text="LinkedIn" icon="linkedin" link="https://github.com/SaifAqqad" showLinkIcon=true/>
                    </div>
                </div>
                <#-- TODO: Add skills card -->
            </div>

            <#-- Right column -->
            <div id="profileContent" class="col-md-8 col-lg-9">

                <div id="profileAbout" class="mb-3">
                    <@profileCard title="About me" icon="personInfo" text="${profile.about}"/>
                </div>

                <div id="profileExperience" class="mb-3">
                    <@profileCard>
                    <#-- Title -->
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="card-title"><@default.icon name="work" class="me-2"/>Experience</h5>
                            <button class="btn btn-outline-primary mb-2" id="addExperienceButton">Add</button>
                        </div>
                    <#-- Content -->
                        <#list profile.experiences>
                            <ul class="list-unstyled timeline-sm">
                                <#items as experience>
                                    <li class="timeline-sm-item cursor-pointer bg-hover text-hover-dark smooth"
                                        data-id="${experience.id}">
                                        <span class="timeline-sm-date">${experience.startDate.year?c} - ${(experience.endDate.year?c)!"Present"}</span>
                                        <div class="pt-1 mb-1 card-title fs-115">${experience.jobTitle}</div>
                                        <p class="text-muted">${experience.companyName}</p>
                                        <#if experience.description??>
                                            <p class="text-muted mt-2 limit-lines-4 preserve-lines">${experience.description}</p>
                                        </#if>
                                    </li>
                                </#items>
                            </ul>
                        <#else>
                            <div class="w-100 min-h-100 d-flex justify-content-center align-items-center">
                                <span class="fs-6 text-muted">You haven't added anything yet</span>
                            </div>
                        </#list>
                    </@profileCard>
                </div>

                <div id="profileActivity" class="mb-3">
                    <@profileCard>
                    <#-- Title -->
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="card-title"><@default.icon name="group" class="me-2"/>Activities</h5>
                            <button class="btn btn-outline-primary mb-2" id="addActivityButton">Add</button>
                        </div>
                    <#-- Content -->
                        <div class="scrollable-box">
                            <#list profile.activities as activity>
                                <@profileCard title=activity.name subtitle=activity.getFormattedDate() text=activity.description img=activity.imageUri img_alt=activity.name id=activity.id?c
                                limitLines=false class="btn w-100 bg-hover rounded-0 ${activity?is_first?then('rounded-top','')} ${activity?is_last?then('rounded-bottom','border-bottom-0')}"/>
                            <#else>
                                <div class="w-100 min-h-100 d-flex justify-content-center align-items-center">
                                    <span class="fs-6 text-muted">You haven't added anything yet</span>
                                </div>
                            </#list>
                        </div>
                    </@profileCard>
                </div>

                <div id="profileProjects" class="mb-3">
                    <@profileCard>
                    <#-- Title -->
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="card-title"><@default.icon name="project" class="me-2"/>Projects</h5>
                            <button class="btn btn-outline-primary mb-2" id="addProjectButton">Add</button>
                        </div>
                    <#-- Content -->
                        <div class="row row-cols-1 row-cols-lg-2">
                            <#list profile.projects as project>
                                <div class="col mb-3">
                                    <@profileCard title=project.name subtitle=project.category text=project.description img=project.imageUri id=project.id?c class="btn bg-hover"/>
                                </div>
                            <#else>
                                <div class="w-100 min-h-100 d-flex justify-content-center align-items-center">
                                    <span class="fs-6 text-muted">You haven't added anything yet</span>
                                </div>
                            </#list>
                        </div>
                    </@profileCard>
                </div>

                <div id="profileCourses" class="mb-3">
                    <@profileCard>
                    <#-- Title -->
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="card-title"><@default.icon name="course" class="me-2"/>Courses</h5>
                            <button class="btn btn-outline-primary mb-2" id="addCourseButton">Add</button>
                        </div>
                    <#-- Content -->
                        <div class="row row-cols-1 row-cols-lg-2">
                            <#list profile.courses as course >
                                <div class="col mb-3">
                                    <@profileCard title=course.name text=course.studentComment img=course.imageUri id=course.id?c class="btn bg-hover"/>
                                </div>
                            <#else>
                                <div class="w-100 min-h-100 d-flex justify-content-center align-items-center">
                                    <span class="fs-6 text-muted">You haven't added anything yet</span>
                                </div>
                            </#list>
                        </div>
                    </@profileCard>
                </div>

            </div>
        </div>
    </div>
</div>


<@default.scripts/>
<@default.toast/>

<@popups.experiencePopup popupId="experiencePopup" formId="experienceForm" uriBase="/profile/experiences"
    detailsPopup={
        "popupTitle" : "Experience details",
        "deleteButtonId" : "experienceDelete",
        "elementSelector" : "#profileExperience li"
    }
    addPopup={
        "popupTitle" : "Add a new experience",
        "buttonId" : "addExperienceButton"
    }
/>
<@popups.activityPopup popupId="activityPopup" formId="activityForm" uriBase="/profile/activities"
    detailsPopup={
        "popupTitle" : "Activity details",
        "deleteButtonId" : "activityDelete",
        "elementSelector" : "#profileActivity .card.btn"
    }
    addPopup={
        "popupTitle" : "Add a new activity",
        "buttonId" : "addActivityButton"
    }
/>
<@popups.projectPopup popupId="projectPopup" formId="projectForm" uriBase="/profile/projects"
    detailsPopup={
        "popupTitle" : "Project details",
        "deleteButtonId" : "projectDelete",
        "elementSelector" : "#profileProjects .card.btn"
    }
    addPopup={
        "popupTitle" : "Add a new project",
        "buttonId" : "addProjectButton"
    }
/>
<@popups.coursePopup popupId="coursePopup" formId="courseForm" uriBase="/profile/courses"
    detailsPopup={
        "popupTitle" : "Course details",
        "deleteButtonId" : "courseDelete",
        "elementSelector" : "#profileCourses .card.btn"
    }
    addPopup={
        "popupTitle" : "Add a new course",
        "buttonId" : "addCourseButton"
    }
/>
</body>
</html>

<#macro profileCard title="" icon="" subtitle="" text="" id="" img="" img_alt="" class="" limitLines=true preserveLines=false>
    <div class="card card-border-grey w-100 h-100 ${class?no_esc}" <#if id?has_content>data-id="${id}"</#if>>
        <div class="d-flex align-content-between align-items-center w-100">
            <#if img?has_content>
                <div class="h-75">
                    <img src="${img}" class="w-100 h-100 rounded-1 img-w-limit object-fit" alt="${img_alt}">
                </div>
            </#if>
            <div class="card-body d-flex flex-column flex-grow-1">
                <#if title?has_content>
                    <h5 class="card-title"><#if icon?has_content><@default.icon name=icon class="me-2"/></#if>${title}</h5>
                </#if>
                <#if subtitle?has_content>
                    <h6 class="card-subtitle mb-2 text-muted">${subtitle}</h6>
                </#if>
                <#if text?has_content>
                    <p class="card-text <#if limitLines>limit-lines-4</#if> <#if preserveLines>preserve-lines</#if>">${text}</p>
                </#if>
                <#nested />
            </div>
        </div>
    </div>
</#macro>

<#macro profileItem text icon="" link="" showLinkIcon=false>
    <div class="text-muted fs-6 text-truncate">
        <#if link?has_content>
            <a href="${link?no_esc}" class="text-decoration-none text-muted text-hover-dark">
                <@default.icon name=icon fallback="web" class="mx-1"/>
                <span>${text}<#if showLinkIcon><@default.externalLinkIcon/></#if></span>
            </a>
        <#else>
            <@default.icon name=icon fallback="web" class="mx-1"/>
            <span>${text}<#if showLinkIcon><@default.externalLinkIcon/></#if></span>
        </#if>
    </div>
</#macro>
