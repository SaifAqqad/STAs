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

<div class="container-fluid container-xl my-3">
    <div id="profile">
        <div class="row">
            <#-- Left column -->
            <div class="col-md-4 col-lg-3">
                <#-- Profile info -->
                <div id="profileInfo">
                    <div class="card card-border-grey rounded-2 p-2 mb-3">
                        <div class="text-center ms-3">
                            <#-- profile picture -->
                            <div class="p-2">
                                <img class="figure-img img-w-100 rounded-circle" src="${profile.imagerUri}"
                                     alt="profile picture"/>
                            </div>
                            <#-- name and major -->
                            <div class="profile-view-items">
                                <div class="fs-4 profile-view-item" data-prop="name">${profile.name}</div>
                                <div class="fs-6 text-muted profile-view-item" data-prop="major">${profile.major}</div>
                            </div>
                            <div class="profile-edit-items text-start d-none">
                                <div>
                                    <label class="form-label text-muted mb-0" for="edit_name">Name</label>
                                    <input class="form-control form-control-sm profile-edit-item" type="text"
                                           data-prop="name" id="edit_name" value="${profile.name}">
                                </div>
                                <div class="mt-2">
                                    <label class="form-label text-muted mb-0" for="edit_major">Major</label>
                                    <input class="form-control form-control-sm profile-edit-item" type="text"
                                           data-prop="major" id="edit_major" value="${profile.major}">
                                </div>
                            </div>
                        </div>
                        <hr class="mx-4"/>
                        <#-- profile info -->
                        <div class="ps-3 profile-view-items">
                            <@profileViewItem text=profile.location name="location" icon="location"/>
                            <@profileViewItem text=profile.university name="university" icon="university"/>
                            <@profileViewItem text=profile.contactEmail name="contactEmail" icon="email" link="mailto:${profile.contactEmail}"/>
                            <@profileViewItem text=profile.contactPhone name="contactPhone" icon="phone" link="tel:${profile.contactPhone}"/>
                            <#list profile.links as linkName, linkUrl>
                                <@profileViewItem text=linkName name="link_${linkName}" icon=linkName?lower_case link=linkUrl showLinkIcon=true/>
                            </#list>
                        </div>
                        <div class="mx-3 mt-3 profile-view-items ">
                            <button class="btn btn-sm btn-outline-primary w-100" id="editInfoBtn">Edit information
                            </button>
                        </div>

                        <div class="ps-3 profile-edit-items d-none ">
                            <form action="<@spring.url "/profile/info"/>" method="post">
                                <@default.csrfInput/>
                                <input class="hidden-profile-edit-item" type="hidden" name="name"
                                       value="${profile.name}">
                                <input class="hidden-profile-edit-item" type="hidden" name="major"
                                       value="${profile.major}">
                                <@profileEditItem icon="location" name="location" label="Location" value=profile.location/>
                                <@profileEditItem icon="university" name="university" label="University" value=profile.university/>
                                <@profileEditItem icon="email" name="contactEmail" label="Contact email" value=profile.contactEmail/>
                                <@profileEditItem icon="phone" name="contactPhone" label="Contact phone" value=profile.contactPhone/>
                            </form>
                        </div>
                        <div class="mx-3 mt-3 d-flex justify-content-end profile-edit-items d-none">
                            <button class="btn btn-sm btn-primary me-1" id="saveInfoBtn">Save</button>
                            <button class="btn btn-sm btn-outline-primary" id="cancelInfoBtn">Cancel</button>
                        </div>
                    </div>
                </div>

                <#-- TODO: Add skills card -->
            </div>

            <#-- Right column -->
            <div id="profileContent" class="col-md-8 col-lg-9">

                <div id="profileAbout" class="mb-3">
                    <@profileCard class="view-card">
                    <#-- Title -->
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="card-title"><@default.icon name="personInfo" class="me-2"/>About me</h5>
                            <button class="btn btn-outline-primary mb-2" id="editAboutButton">Edit</button>
                        </div>
                    <#-- Content -->
                        <div class="card-text" id="aboutContent"></div>
                    </@profileCard>
                    <@profileCard class="edit-card d-none">
                    <#-- Title -->
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="card-title"><@default.icon name="personInfo" class="me-2"/>About me</h5>
                            <div class="mb-2">
                                <button class="btn btn-primary save-btn">Save</button>
                                <button class="btn btn-outline-primary cancel-btn">Cancel</button>
                            </div>
                        </div>
                    <#-- Content -->
                        <form action="<@spring.url "/profile/about"/>" method="post" enctype="multipart/form-data">
                            <@default.csrfInput/>
                            <div class="mt-2">
                                <textarea aria-label="About me" class="form-control" name="about"
                                          maxlength="5000"></textarea>
                            </div>
                        </form>
                        <div class="clearfix">
                            <div class="float-end text-muted" id="aboutCharCount">0/5000</div>
                        </div>
                    </@profileCard>
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
<script>
    <#-- About card script -->
    (() => {
        const view = {card: document.querySelector("#profileAbout div.card.view-card")}
        view.textElement = view.card.querySelector("#aboutContent")
        view.content = "${profile.about?js_string}"
        const edit = {card: document.querySelector("#profileAbout div.card.edit-card")}
        edit.textArea = edit.card.querySelector("textarea[name='about']")
        edit.form = edit.card.querySelector("form")
        edit.charCount = edit.card.querySelector("#aboutCharCount")
        edit.charLimit = 5000

        // set initial textarea height
        edit.textArea.setAttribute("style", "height:" + (edit.textArea.scrollHeight) + "px;overflow-y:hidden;")
        // set initial content
        view.textElement.innerHTML = marked.parse(view.content, {sanitizer: DOMPurify.sanitizeFn})

        // view card edit button
        view.card.querySelector("#editAboutButton").addEventListener("click", () => {
            // hide view card
            _showElems([view.card], false)
            // show edit card
            _showElems([edit.card], true)
            // set text area content
            edit.textArea.value = view.content.trim()
            // set text area char count
            edit.charCount.textContent = edit.textArea.value.length + "/" + edit.charLimit
            // set text area initial height
            edit.textArea.style.height = 'auto';
            edit.textArea.style.height = edit.textArea.scrollHeight + 'px';
        })

        // edit card cancel button
        edit.card.querySelector("button.cancel-btn").addEventListener("click", () => {
            // hide edit card
            _showElems([edit.card], false)
            // show view card
            _showElems([view.card], true)
        })

        // edit card save button
        edit.card.querySelector("button.save-btn").addEventListener("click", () => {
            edit.form.submit()
        })

        // textarea onChange
        edit.textArea.addEventListener("input", () => {
            edit.textArea.style.height = 'auto';
            edit.textArea.style.height = edit.textArea.scrollHeight + 'px';
            edit.charCount.textContent = edit.textArea.value.length + "/" + edit.charLimit
        })
    })()
</script>
<script>
    <#-- Profile info script -->
    (() => {
        const view = {
            items: document.querySelectorAll(".profile-view-item"),
            groups: document.querySelectorAll(".profile-view-items"),
            editButton: document.querySelector("#editInfoBtn"),
        }
        const edit = {
            items: document.querySelectorAll(".profile-edit-item"),
            groups: document.querySelectorAll(".profile-edit-items"),
            form: document.querySelector(".profile-edit-items > form"),
            saveButton: document.querySelector("#saveInfoBtn"),
            cancelButton: document.querySelector("#cancelInfoBtn"),
        }

        <#noparse>
        view.editButton.addEventListener("click", () => {
            // hide view items
            _showElems([...view.items, ...view.groups], false);
            // show edit items
            _showElems([...edit.items, ...edit.groups], true);
            // copy view values onto edit inputs
            edit.items.forEach(item => {
                const propName = item.getAttribute("data-prop")
                const propViewValue = document.querySelector(`.profile-view-item[data-prop=${propName}]`).textContent
                item.value = propViewValue.trim()
            })
        });
        edit.saveButton.addEventListener("click", () => {
            // copy edit values onto hidden form inputs
            edit.form.querySelectorAll("input.hidden-profile-edit-item").forEach(hiddenInput => {
                let name = hiddenInput.getAttribute("name")
                hiddenInput.value = document.querySelector(`.profile-edit-item[data-prop=${name}]`)
            });
            edit.form.submit();
            // hide edit items
            _showElems([...edit.items, ...edit.groups], false);
            // show view items
            _showElems([...view.items, ...view.groups], true);
        });
        edit.cancelButton.addEventListener("click", () => {
            // hide edit items
            _showElems([...edit.items, ...edit.groups], false);
            // show view items
            _showElems([...view.items, ...view.groups], true);
        });
        </#noparse>
    })()
</script>

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
        <div class="d-flex flex-column flex-sm-row align-content-between align-items-center w-100">
            <#if img?has_content>
                <div class="h-75">
                    <img src="${img}" class="w-100 h-100 rounded-1 img-w-limit object-fit" alt="${img_alt}">
                </div>
            </#if>
            <div class="card-body d-flex flex-column flex-grow-1 w-100">
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

<#macro profileViewItem text name icon="" link="" showLinkIcon=false>
    <div class="text-muted fs-6 text-truncate">
        <#if link?has_content>
            <a href="${link?no_esc}" target="_blank" class="text-decoration-none text-muted text-hover-dark">
                <@default.icon name=icon fallback="web" class="mx-1"/>
                <span data-prop="${name}"
                      class="profile-view-item">${text}<#if showLinkIcon><@default.externalLinkIcon/></#if></span>
            </a>
        <#else>
            <@default.icon name=icon fallback="web" class="mx-1"/>
            <span data-prop="${name}" class="profile-view-item">${text}</span>
        </#if>
    </div>
</#macro>

<#macro profileEditItem icon name label value>
    <div class="mt-1 mx-1 d-flex align-items-center text-muted">
        <@default.icon name=icon fallback="web" class="me-2" width="20"/>
        <input class="form-control form-control-sm flex-grow-1 rounded-3 profile-edit-item" type="text" name="${name}"
               data-prop="${name}" placeholder="${label}" value="${value}" aria-label="${label}">
    </div>
</#macro>