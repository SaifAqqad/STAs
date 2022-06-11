<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />
<#import "./popup.ftl" as popups/>

<!DOCTYPE html>
<html lang="en">

<@default.head title="${profile.name} - STAs">
    <style>
        <#--noinspection CssUnusedSymbol-->
        .card-body .card-body {
            padding-left: 0.5rem;
            padding-right: 0.5rem;
        }
    </style>
</@default.head>

<body class="min-vh-100">
<@default.navbar profile=(isPublicView!false)?then("","active") marginBreak="xl"/>

<div class="container-fluid container-xl my-3 animate__animated animate__fadeIn animate__faster">
    <div id="profile">
        <div class="row">
            <#-- Left column -->
            <div class="col-md-4 col-lg-3">

                <#-- Profile settings -->
                <@ownOnly>
                    <div class="mb-3">
                        <div class="card card-border-grey w-100">
                            <div class="card-body p-1 m-2">
                                <div class="d-flex justify-content-evenly align-items-center">
                                    <div>
                                        <button class="btn btn-sm btn-outline-primary" id="profileSettings">Settings
                                        </button>
                                    </div>
                                    <div class="vr"></div>
                                    <div class="form-check form-switch me-2 user-select-none">
                                        <input class="form-check-input" type="checkbox" role="switch"
                                               id="profileEditSwitch" <@editOnly>checked</@editOnly>>
                                        <label class="form-check-label" for="profileEditSwitch">Editing</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </@ownOnly>

                <#-- Profile info -->
                <div id="profileInfo">
                    <div class="card card-border-grey rounded-2 p-2 mb-3">
                        <div class="text-center mx-3">
                            <#-- profile picture -->
                            <div class="d-flex justify-content-center p-3 user-select-none">
                                <div class="position-relative">
                                    <div class="img-w-100 rounded-circle object-fit-cover">
                                        <img class="img-w-100 rounded-circle object-fit-cover" id="profilePicture"
                                             src="${profile.imageUri!""}"
                                             onerror="_setPlaceholder(this)"
                                             data-placeholder="/images/generic_profile.jpeg"
                                             alt="Profile picture"/>
                                    </div>
                                    <@editOnly>
                                        <div class="image-mask img-w-100 rounded-circle clickable"
                                             id="profilePictureEditButton">
                                            <@default.icon name="editImage" width="32"/>
                                        </div>
                                    </@editOnly>
                                </div>
                            </div>
                            <#-- name and major -->
                            <div class="profile-view-items">
                                <div class="fs-4 profile-view-item" data-prop="name">${profile.name}</div>
                                <div class="fs-6 text-muted profile-view-item"
                                     data-prop="major">${profile.major!""}</div>
                            </div>
                            <@editOnly>
                                <div class="profile-edit-items text-start d-none">
                                    <div>
                                        <label class="form-label text-muted mb-0" for="edit_name">Name</label>
                                        <input class="form-control form-control-sm profile-edit-item" type="text"
                                               data-prop="name" id="edit_name" value="${profile.name}">
                                    </div>
                                    <div class="mt-2">
                                        <label class="form-label text-muted mb-0" for="edit_major">Major</label>
                                        <input class="form-control form-control-sm profile-edit-item" type="text"
                                               data-prop="major" id="edit_major" value="${profile.major!""}">
                                    </div>
                                </div>
                            </@editOnly>
                        </div>
                        <hr class="mx-4"/>
                        <#-- profile info -->
                        <div class="px-3 profile-view-items">
                            <@profileViewItem text=profile.location!"" name="location" icon="location"/>
                            <@profileViewItem text=profile.university!"" name="university" icon="university"/>
                            <@profileViewItem text=profile.contactEmail!"" name="contactEmail" icon="email" link="mailto:${profile.contactEmail}"/>
                            <@profileViewItem text=profile.contactPhone!"" name="contactPhone" icon="phone" link="tel:${profile.contactPhone}"/>
                            <div class="profile-view-links">
                                <#list profile.links as linkName, linkUrl>
                                    <@profileViewItem text=linkName name="link_${linkName}" icon=linkName?lower_case link=linkUrl showLinkIcon=true includeUrl=true/>
                                </#list>
                            </div>
                        </div>
                        <@editOnly>
                            <div class="mx-3 mt-3 profile-view-items ">
                                <button class="btn btn-sm btn-outline-primary w-100" id="editInfoBtn">Edit information
                                </button>
                            </div>

                            <div class="px-3 mb-1 profile-edit-items d-none">
                                <form action="<@spring.url "/profile/info"/>" method="post"
                                      enctype="multipart/form-data">
                                    <@default.csrfInput/>
                                    <input class="hidden-profile-edit-item" type="hidden" name="name"
                                           value="${profile.name!""}">
                                    <input class="hidden-profile-edit-item" type="hidden" name="major"
                                           value="${profile.major!""}">
                                    <@profileEditItem icon="location" name="location" label="Location" value=profile.location!""/>
                                    <@profileEditItem icon="university" name="university" label="University" value=profile.university!""/>
                                    <@profileEditItem icon="email" name="contactEmail" label="Contact email" value=profile.contactEmail!""/>
                                    <@profileEditItem icon="phone" name="contactPhone" label="Contact phone" value=profile.contactPhone!""/>
                                    <#list profile.links >
                                        <div class="d-flex justify-content-evenly align-items-center user-select-none mt-1">
                                            <div class="text-muted fs-6 me-1">Links</div>
                                            <hr class="w-100"/>
                                        </div>
                                        <#items as linkName, linkUrl>
                                            <@profileEditItem icon=linkName?lower_case name="link_${linkName}" label=linkName value=linkUrl showLabel=true/>
                                        </#items>
                                    </#list>
                                    <div class="mx-1 mt-2 d-flex justify-content-end">
                                        <button type="button" class="btn btn-sm btn-outline-primary" id="addLinkButton">
                                            Add
                                            link
                                        </button>
                                    </div>
                                </form>
                            </div>

                            <div class="mx-3 mt-3 d-flex justify-content-end profile-edit-items d-none">
                                <button class="btn btn-sm btn-primary me-1" id="saveInfoBtn">Save</button>
                                <button class="btn btn-sm btn-outline-primary" id="cancelInfoBtn">Cancel</button>
                            </div>
                        </@editOnly>
                    </div>
                </div>

                <#-- Skills card -->
                <@editOnly or=profile.skills?has_content>
                    <div id="skillsCard" class="mb-3">
                        <@profileCard>
                        <#-- Title -->
                            <div class="d-flex justify-content-between align-items-center">
                                <h5 class="card-title mb-2"><@default.icon name="mdi:tools" class="me-2"/>
                                    Skills
                                </h5>
                                <@editOnly>
                                    <button class="btn btn-outline-primary mb-2" id="addSkillButton">Add</button>
                                </@editOnly>
                            </div>
                        <#-- Content -->
                            <div id="profileSkills">
                                <#list profile.skills as skill>
                                    <div class="skill rounded-2 p-2 w-100 <@editOnly>cursor-pointer bg-hover</@editOnly>"
                                         data-id="${skill.id}">

                                        <#-- Skill text -->
                                        <div class="mb-1 d-flex justify-content-between text-muted">
                                            <span>${skill.name}</span>
                                            <span>${skill.level}%</span>
                                        </div>

                                        <#-- Skill level -->
                                        <div class="progress" style="height: 10px;">
                                            <div class="progress-bar" role="progressbar"
                                                 style="width: ${skill.level}%;"
                                                 aria-valuenow="${skill.level}"
                                                 aria-valuemin="0" aria-valuemax="100">
                                            </div>
                                        </div>

                                        <@viewOnly>
                                            <div class="mt-2 clearfix">

                                                <#-- Endorsements count -->
                                                <#if skill.endorsements?has_content>
                                                    <#assign count = skill.endorsements?size/>
                                                    <a class="float-start cursor-pointer text-decoration-none text-muted text-hover-dark view-endorsement-button"
                                                       data-id="${skill.id}">
                                                        <@default.icon name="mdi:account-multiple" class="me-1"/>
                                                        <span>${count} endorsement${(count > 1)?then("s","")}</span>
                                                    </a>
                                                </#if>

                                                <#-- Endorse Button -->
                                                <@publicViewOnly>

                                                    <#assign isEndorsed = false/>
                                                    <#if authenticatedUser??>
                                                    <#-- check if the authed user has already endorsed this skill -->
                                                        <#list skill.endorsements as endorsement>
                                                            <#if (endorsement.user.userId == authenticatedUser.userId)>
                                                                <#assign isEndorsed = true/>
                                                            </#if>
                                                        </#list>
                                                    </#if>

                                                    <#if !isEndorsed>
                                                        <form class="float-end" method="post"
                                                              action="<@spring.url springMacroRequestContext.requestUri + "/skills/${skill.id}/endorsements"/>">
                                                            <@default.csrfInput/>
                                                            <button class="btn btn-sm btn-outline-primary">Endorse
                                                            </button>
                                                        </form>
                                                    </#if>

                                                </@publicViewOnly>

                                            </div>
                                        </@viewOnly>

                                    </div>
                                <#else>
                                    <div class="w-100 min-h-100 d-flex justify-content-center align-items-center">
                                        <span class="fs-6 text-muted user-select-none">You haven't added anything yet</span>
                                    </div>
                                </#list>
                            </div>

                        </@profileCard>
                    </div>
                </@editOnly>
            </div>

            <#-- Right column -->
            <div id="profileContent" class="col-md-8 col-lg-9">
                <@editOnly or=profile.about?has_content>
                    <div id="profileAbout" class="mb-3">
                        <@profileCard class="view-card">
                        <#-- Title -->
                            <div class="d-flex justify-content-between align-items-center <@viewOnly>mb-2</@viewOnly>">
                                <h5 class="card-title mb-2"><@default.icon name="personInfo" class="me-2"/>
                                    About me
                                </h5>
                                <@editOnly>
                                    <button class="btn btn-outline-primary mb-2" id="editAboutButton">Edit</button>
                                </@editOnly>
                            </div>
                        <#-- Content -->
                            <div class="md-content card-text" id="aboutContent"></div>
                        </@profileCard>
                        <@editOnly>
                            <@profileCard class="edit-card d-none">
                            <#-- Title -->
                                <div class="d-flex justify-content-between align-items-center <@viewOnly>mb-2</@viewOnly>">
                                    <h5 class="card-title user-select-none mb-2"><@default.icon name="personInfo" class="me-2"/>
                                        About me
                                    </h5>
                                    <div class="mb-2">
                                        <button class="btn btn-primary save-btn">Save</button>
                                        <button class="btn btn-outline-primary cancel-btn">Cancel</button>
                                    </div>
                                </div>
                            <#-- Content -->
                                <form action="<@spring.url "/profile/about"/>" method="post"
                                      enctype="multipart/form-data">
                                    <@default.csrfInput/>
                                    <div class="mt-2">
                                <textarea aria-label="About me" class="form-control" name="about"
                                          maxlength="5000"></textarea>
                                    </div>
                                </form>
                                <div class="clearfix">
                                    <div class="float-start">
                                        <@default.mdDisclaimer/>
                                    </div>
                                    <div class="float-end text-muted user-select-none" id="aboutCharCount">0/5000</div>
                                </div>
                            </@profileCard>
                        </@editOnly>
                    </div>
                </@editOnly>

                <@editOnly or=profile.experiences?has_content>

                    <div id="profileExperience" class="mb-3">
                        <@profileCard>
                        <#-- Title -->
                            <div class="d-flex justify-content-between align-items-center <@viewOnly>mb-2</@viewOnly>">
                                <h5 class="card-title mb-2"><@default.icon name="work" class="me-2"/>
                                    Experience
                                </h5>
                                <@editOnly>
                                    <button class="btn btn-outline-primary mb-2" id="addExperienceButton">Add</button>
                                </@editOnly>
                            </div>
                        <#-- Content -->
                            <#list profile.experiences>
                                <ul class="list-unstyled timeline">
                                    <#items as experience>
                                        <li class="timeline-item cursor-pointer bg-hover text-hover-dark smooth"
                                            data-id="${experience.id}">
                                            <span class="timeline-date">${experience.startDate.year?c} - ${(experience.endDate.year?c)!"Present"}</span>
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
                                    <span class="fs-6 text-muted user-select-none">You haven't added anything yet</span>
                                </div>
                            </#list>
                        </@profileCard>
                    </div>
                </@editOnly>

                <@editOnly or=profile.activities?has_content>
                    <div id="profileActivity" class="mb-3">
                        <@profileCard>
                        <#-- Title -->
                            <div class="d-flex justify-content-between align-items-center <@viewOnly>mb-2</@viewOnly>">
                                <h5 class="card-title mb-2"><@default.icon name="group" class="me-2"/>
                                    Activities
                                </h5>
                                <@editOnly>
                                    <button class="btn btn-outline-primary mb-2" id="addActivityButton">Add</button>
                                </@editOnly>
                            </div>
                        <#-- Content -->
                            <div class="scrollable-box">
                                <#list profile.activities as activity>
                                    <@profileCard title=activity.name subtitle=activity.getFormattedDate() text=activity.description img=activity.imageUri img_alt=activity.name id=activity.id?c
                                    limitLines=false preserveLines=true class="btn w-100 ${isEditing?then('bg-hover','pe-none')} rounded-0 ${activity?is_first?then('rounded-top','')} ${activity?is_last?then('rounded-bottom','border-bottom-0')}"/>
                                <#else>
                                    <div class="w-100 min-h-100 d-flex justify-content-center align-items-center">
                                        <span class="fs-6 text-muted user-select-none">You haven't added anything yet</span>
                                    </div>
                                </#list>
                            </div>
                        </@profileCard>
                    </div>
                </@editOnly>

                <@editOnly or=profile.projects?has_content>
                    <div id="profileProjects" class="mb-3">
                        <@profileCard>
                        <#-- Title -->
                            <div class="d-flex justify-content-between align-items-center <@viewOnly>mb-2</@viewOnly>">
                                <h5 class="card-title mb-2"><@default.icon name="project" class="me-2"/>
                                    Projects
                                </h5>
                                <@editOnly>
                                    <button class="btn btn-outline-primary mb-2" id="addProjectButton">Add</button>
                                </@editOnly>
                            </div>
                        <#-- Content -->
                            <div class="row row-cols-1 row-cols-lg-2">
                                <#list profile.projects as project>
                                    <div class="col mb-3">
                                        <@profileCard title=project.name text=project.description img=project.imageUri id=project.id?c class="btn bg-hover" preserveLines=true/>
                                    </div>
                                <#else>
                                    <div class="w-100 min-h-100 d-flex justify-content-center align-items-center">
                                        <span class="fs-6 text-muted user-select-none">You haven't added anything yet</span>
                                    </div>
                                </#list>
                            </div>
                        </@profileCard>
                    </div>
                </@editOnly>

                <@editOnly or=profile.courses?has_content>
                    <div id="profileCourses" class="mb-3">
                        <@profileCard>
                        <#-- Title -->
                            <div class="d-flex justify-content-between align-items-center <@viewOnly>mb-2</@viewOnly>">
                                <h5 class="card-title mb-2"><@default.icon name="course" class="me-2"/>
                                    Courses
                                </h5>
                                <@editOnly>
                                    <button class="btn btn-outline-primary mb-2" id="addCourseButton">Add</button>
                                </@editOnly>
                            </div>
                        <#-- Content -->
                            <div class="row row-cols-1 row-cols-lg-2">
                                <#list profile.courses as course >
                                    <div class="col mb-3">
                                        <@profileCard title=course.name text=(course.studentComment?has_content)?then(course.studentComment,course.description) img=course.imageUri id=course.id?c class="btn bg-hover" preserveLines=true/>
                                    </div>
                                <#else>
                                    <div class="w-100 min-h-100 d-flex justify-content-center align-items-center">
                                        <span class="fs-6 text-muted user-select-none">You haven't added anything yet</span>
                                    </div>
                                </#list>
                            </div>
                        </@profileCard>
                    </div>
                </@editOnly>

            </div>
        </div>
    </div>
</div>


<@default.scripts>
    <script src="<@spring.url "/webjars/dompurify/dist/purify.min.js"/>"></script>
    <script src="<@spring.url "/webjars/marked/marked.min.js"/>"></script>
</@default.scripts>
<@default.toast/>
<@ownOnly>
    <script>
        <#-- profile settings script -->
        (() => {
            const uri = "/profile?edit="
            const editSwitch = document.getElementById('profileEditSwitch');
            editSwitch.addEventListener("change", () => {
                window.location.href = uri + (editSwitch.checked ? "true" : "false");
            });
        })()
    </script>
</@ownOnly>
<@editOnly or=profile.about?has_content>
    <script>
        <#-- About card script -->
        (() => {
            const view = {card: document.querySelector("#profileAbout div.card.view-card")}
            view.textElement = view.card.querySelector("#aboutContent")
            view.content = "${(profile.about!"")?js_string?no_esc}";
            // set initial content
            view.textElement.innerHTML = DOMPurify.sanitize(marked.parse(view.content));

            <@editOnly>
            const edit = {card: document.querySelector("#profileAbout div.card.edit-card")}
            edit.textArea = edit.card.querySelector("textarea[name='about']")
            edit.form = edit.card.querySelector("form")
            edit.charCount = edit.card.querySelector("#aboutCharCount")
            edit.charLimit = 5000

            // set initial textarea height
            edit.textArea.setAttribute("style", "height:" + (edit.textArea.scrollHeight) + "px;overflow-y:hidden;")

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
            </@editOnly>
        })()
    </script>
</@editOnly>

<@editOnly>
<#-- Profile info script -->
    <script>
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
                    const propValue = document.querySelector(`.profile-view-item[data-prop=${propName}]`)
                    item.value = propValue.getAttribute("data-url") || propValue.textContent.trim();
                })
            });
            edit.saveButton.addEventListener("click", () => {
                // copy edit values onto hidden form inputs
                edit.form.querySelectorAll("input.hidden-profile-edit-item").forEach(hiddenInput => {
                    let name = hiddenInput.getAttribute("name")
                    hiddenInput.value = document.querySelector(`.profile-edit-item[data-prop=${name}]`).value
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
</@editOnly>
<#-- Skills popover script -->
<@viewOnly>
    <script>
        (() => {
            const baseUri = "${springMacroRequestContext.requestUri}";
            const skillButtons = document.querySelectorAll(".view-endorsement-button");
            const getEndorsementsList = async (skillId) => {
                const response = await fetch(baseUri + "/skills/" + skillId + "/endorsements");
                if (!response.ok)
                    return null;
                const {endorsements} = (await response.json());
                if (!endorsements || endorsements.length === 0)
                    return null;
                const list = document.createElement("ul");
                list.classList.add("list-group", "list-group-flush", "shadow-none");
                for (let i = 0; i < endorsements.length; i++) {
                    const endorsement = endorsements[i];

                    const listItem = document.createElement("li");
                    listItem.classList.add("list-group-item", "p-0", "border-0");

                    const name = document.createElement("div");
                    name.classList.add("fw-bold");
                    name.textContent = endorsement["endorserName"];
                    listItem.appendChild(name);

                    const email = document.createElement("div");
                    email.classList.add("text-muted");
                    email.textContent = endorsement["endorserEmail"];
                    listItem.appendChild(email);

                    list.appendChild(listItem);

                    // add divider if not last item
                    if (i !== endorsements.length - 1) {
                        const divider = document.createElement("hr")
                        divider.classList.add("my-1");
                        list.appendChild(divider);
                    }
                }
                return list;
            };

            skillButtons.forEach(async skillButton => {
                let endorsementList = await getEndorsementsList(skillButton.getAttribute("data-id"));
                let options = {
                    html: true,
                    placement: 'right',
                    trigger: 'hover',
                    content: endorsementList,
                }
                if (endorsementList)
                    new bootstrap.Popover(skillButton, options)
            });
        })()
    </script>
</@viewOnly>
<#-- edit/overview popups -->
<@popups.script/>
<@popups.experiencePopup popupId="experiencePopup" formId="experienceForm" uriBase=springMacroRequestContext.requestUri+"/experiences"
detailsPopup={
"popupTitle" : "Experience details",
"deleteButtonId" : "experienceDelete",
"elementSelector" : "#profileExperience li"
}
addPopup={
"popupTitle" : "Add a new experience",
"buttonId" : "addExperienceButton"
}
overviewPopupDetails={
"enabled": !isEditing,
"elementSelector" : "#profileExperience li"
}
/>
<@popups.projectPopup popupId="projectPopup" formId="projectForm" uriBase=springMacroRequestContext.requestUri+"/projects"
detailsPopup={
"popupTitle" : "Project details",
"deleteButtonId" : "projectDelete",
"elementSelector" : "#profileProjects .card.btn"
}
addPopup={
"popupTitle" : "Add a new project",
"buttonId" : "addProjectButton"
}
overviewPopupDetails={
"enabled": !isEditing,
"elementSelector" : "#profileProjects .card.btn"
}
/>
<@popups.coursePopup popupId="coursePopup" formId="courseForm" uriBase=springMacroRequestContext.requestUri+"/courses"
detailsPopup={
"popupTitle" : "Course details",
"deleteButtonId" : "courseDelete",
"elementSelector" : "#profileCourses .card.btn"
}
addPopup={
"popupTitle" : "Add a new course",
"buttonId" : "addCourseButton"
}
overviewPopupDetails={
"enabled": !isEditing,
"elementSelector" : "#profileCourses .card.btn"
}
/>
<@editOnly>
    <@popups.activityPopup popupId="activityPopup" formId="activityForm" uriBase=springMacroRequestContext.requestUri+"/activities"
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
    <@popups.linkPopup popupId="linkPopup" formId="linkForm" uriBase="/profile/info/links"
    addPopup={
    "popupTitle" : "Add a new link",
    "buttonId" : "addLinkButton"
    }
    />
    <@popups.picturePopup popupId="profilePicturePopup" formId="profilePictureForm" uriBase="/profile/picture" defaultValue={"imageUri": profile.imageUri!""}
    detailsPopup={
    "popupTitle" : "Profile picture",
    "deleteButtonId" : "profilePictureDeleteButton",
    "elementSelector" : "#profilePictureEditButton"
    }
    />
    <@popups.skillPopup popupId="skillPopup" formId="skillForm" uriBase=springMacroRequestContext.requestUri+"/skills"
    detailsPopup={
    "popupTitle" : "Skill details",
    "deleteButtonId" : "skillDelete",
    "elementSelector" : "#profileSkills > .skill"
    }
    addPopup={
    "popupTitle" : "Add a new skill",
    "buttonId" : "addSkillButton"
    }
    />
</@editOnly>
<@ownOnly>
    <@popups.settingsPopup options={
    "elementSelector" : "#profileSettings"
    }
    />
</@ownOnly>
</body>
</html>

<#macro profileCard title="" icon="" subtitle="" text="" id="" img="" img_alt="" class="" limitLines=true preserveLines=false>
    <div class="card card-border-grey w-100 h-100 user-select-none ${class?no_esc}"
         <#if id?has_content>data-id="${id}"</#if>>
        <div class="d-flex flex-column flex-sm-row align-content-between align-items-center w-100">
            <#if img?has_content>
                <div class="h-100 w-50 p-2 d-flex align-items-center">
                    <img src="${img}" class="w-100 rounded-3 shadow-lg aspect-ratio-1 object-fit-cover"
                         alt="${img_alt}">
                </div>
            </#if>
            <div class="card-body d-flex flex-column flex-grow-1 w-100">
                <#if title?has_content>
                    <h5 class="card-title user-select-none"><#if icon?has_content><@default.icon name=icon class="me-2"/></#if>${title}</h5>
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

<#macro profileViewItem text="" name="" icon="" link="" showLinkIcon=false includeUrl=false>
    <#if text?has_content>
        <div class="text-muted fs-6 text-truncate">
            <#if link?has_content>
                <a href="${link?no_esc}" target="_blank" class="text-decoration-none text-muted text-hover-dark">
                    <@default.icon name=icon fallback="web" class="mx-1"/>
                    <span data-prop="${name}" <#if includeUrl>data-url="${link}"</#if>
                      class="profile-view-item">${text}<#if showLinkIcon><@default.externalLinkIcon/></#if></span>
                </a>
            <#else>
                <@default.icon name=icon fallback="web" class="mx-1"/>
                <span data-prop="${name}" class="profile-view-item">${text}</span>
            </#if>
        </div>
    </#if>
</#macro>

<#macro profileEditItem icon name label value showLabel=false>
    <div class="mt-1 mx-1 d-flex align-items-center text-muted">
        <#if showLabel>
            <span class="me-2 user-select-none">${label}</span>
        <#else>
            <@default.icon name=icon fallback="web" class="me-2" width="20"/>
        </#if>
        <input class="form-control form-control-sm flex-grow-1 rounded-3 profile-edit-item" type="text" name="${name}"
               data-prop="${name}" placeholder="${label}" value="${value}" aria-label="${label}">
    </div>
</#macro>

<#macro editOnly or=false>
    <#if isEditing || or>
        <#nested/>
    </#if>
</#macro>

<#macro viewOnly>
    <#if !isEditing>
        <#nested />
    </#if>
</#macro>

<#macro ownOnly>
    <#if !(isPublicView!false)>
        <#nested/>
    </#if>
</#macro>

<#macro publicViewOnly>
    <#if isPublicView!false>
        <#nested/>
    </#if>
</#macro>