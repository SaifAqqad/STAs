<#import "../../../shared/default.ftl" as default/>
<#import "../shared.ftl" as shared/>

<#macro card>
    <div id="experienceCard" class="card rounded-3 user-select-none w-100">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
                <h6 class="card-title mb-2">
                    Do you have any professional experience?
                </h6>
                <button class="flex-shrink-0 btn btn-outline-primary mb-2" id="addExperienceButton">Add experience
                </button>
            </div>
            <div class="card border-0 shadow-none bg-white w-100 mt-3 p-3 py-0">
                <ul id="experiencesContainer" class="list-unstyled timeline d-none">
                </ul>
                <@shared.emptyContainer/>
            </div>
            <hr>
            <div class="d-flex justify-content-between align-items-center">
                <h6 class="card-title mb-2">
                    Do you have any skills?
                </h6>
                <button class="btn btn-outline-primary mb-2" id="addSkillButton">Add skill</button>
            </div>
            <div class="card border-0 shadow-none bg-white w-100 mt-3 p-3 py-0">
                <div class="row row-cols-1" id="skillsContainer">
                    <@shared.emptyContainer/>
                </div>
            </div>
            <div class="mt-3 clearfix">
                <@shared.backBtn/>
                <@shared.nextBtn/>
            </div>
        </div>
    </div>
</#macro>
<#macro script>
    <@experiencePopup/>
    <@experienceScript/>
    <@skillPopup/>
    <@skillScript/>
<#-- Tabs script -->
    <script>
        (() => {
            const tabsContainer = document.querySelector('.tabs');
            const card = document.querySelector('#experienceCard');
            const currentTab = card.parentElement;

            // add timeline items for existing experiences
            document.addEventListener("profile-loaded", () => {
                timeline.update();
                const skills = Profile.getItem("skills");
                skills.forEach(skill => {
                    const element = skillElements.add(skill);
                    element.addEventListener("click", () => {
                        skillPopup.show(skill, element);
                    });
                });
            });

            document.addEventListener("tab-changing", () => {
                if (!currentTab.classList.contains("tab-active"))
                    return;
                Profile.saveProfile();
            });
        })()
    </script>
</#macro>

<#macro timelineItem>
    <li class="timeline-item cursor-pointer bg-hover text-hover-dark smooth">
        <span class="timeline-date"></span>
        <div class="timeline-title pt-1 mb-1 card-title fs-115"></div>
        <p class="timeline-subtitle text-muted"></p>
        <p class="timeline-text text-muted mt-2 limit-lines-4 preserve-lines"></p>
    </li>
</#macro>

<#macro experiencePopup>
    <div class="modal fade user-select-none" id="experiencePopup" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header pb-1">
                    <h5 class="modal-title"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form class="mx-2" id="experienceForm" method="post">
                        <@default.csrfInput/>
                        <input type="hidden" data-experience-prop="id" id=""/>
                        <div class="form-floating">
                            <input class="form-control" required type="text" data-experience-prop="companyName"
                                   id="experienceCompanyName"
                                   placeholder="Company name">
                            <label class="form-label text-muted" for="experienceCompanyName">Company name</label>
                        </div>
                        <div class="form-floating mt-3">
                            <input class="form-control" required type="text" data-experience-prop="jobTitle"
                                   id="experienceJobTitle"
                                   placeholder="Job title">
                            <label class="form-label text-muted" for="experienceJobTitle">Job title</label>
                        </div>
                        <div class="form-floating mt-3 fix-floating-label">
                            <textarea class="form-control" data-experience-prop="description" id="experienceDescription"
                                      placeholder="Job description"></textarea>
                            <label class="form-label text-muted" for="experienceDescription">Job description</label>
                        </div>
                        <div class="form-floating mt-3">
                            <input class="form-control" type="date" data-experience-prop="startDate"
                                   id="experienceStartDate" required placeholder="Start date">
                            <label class="form-label text-muted" for="experienceStartDate">Start date</label>
                        </div>
                        <div class="form-floating mt-3">
                            <input class="form-control" type="date" data-experience-prop="endDate"
                                   id="experienceEndDate"
                                   placeholder="End date">
                            <label class="form-label text-muted" for="experienceEndDate">End date</label>
                        </div>
                    </form>
                </div>
                <div class="d-block modal-footer clearfix">
                    <div class="float-start">
                        <button id="experienceDeleteButton" class="btn btn-outline-danger d-none">Delete</button>
                    </div>
                    <div class="float-end">
                        <button id="experienceSaveButton" class="btn btn-primary">Save</button>
                        <button class="btn btn-outline-primary" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</#macro>

<#macro experienceScript>
    <script>
        // experience data functions
        const experiences = {
            add: null,
            update: null,
            remove: null,
        }
        // experience popup functions
        const experiencePopup = {
            show: null,
            hide: null,
        };
        const timeline = {
            update: null,
        };

        document.addEventListener("profile-loaded", () => {
            const experiencesArray = Profile.getItem("experiences");
            const sortExperiences = (a, b) => {
                const aDate = new Date(a.startDate);
                const bDate = new Date(b.startDate);
                return bDate - aDate;
            };
            experiences.add = (experienceObj) => {
                experienceObj.id = _getRandomInt(0, 1000000);
                experiencesArray.push(new Profile.Experience(experienceObj));
                Profile.saveProfile();
                return experiencesArray.at(-1);
            };
            experiences.update = (experienceObj) => {
                const experience = experiencesArray.find(experience => experience.id === experienceObj.id);
                Object.assign(experience, experienceObj);
                Profile.saveProfile();
                return experience;
            };
            experiences.remove = (experienceId) => {
                const index = experiencesArray.findIndex(experience => experience.id === experienceId);
                experiencesArray.splice(index, 1);
                Profile.saveProfile();
            };
            (() => {
                const timelineTemplate = <@default.jsStr><@timelineItem/></@default.jsStr>;
                const experiencesContainer = document.getElementById('experiencesContainer');
                const emptyContainer = document.querySelector("#experienceCard .empty-container");
                const createTimelineItem = (obj) => {
                    // create timeline item
                    const template = document.createElement('template');
                    template.innerHTML = timelineTemplate;
                    let item = template.content.firstElementChild;
                    item.querySelector(".timeline-title").innerText = obj["title"] || "";
                    item.querySelector(".timeline-subtitle").innerText = obj["subtitle"] || "";
                    item.querySelector(".timeline-text").innerText = obj["text"] || "";
                    item.querySelector(".timeline-date").innerText = obj["date"] || "";

                    return item;
                };
                timeline.update = () => {
                    experiencesContainer.replaceChildren();
                    if (experiencesArray.length > 0) {
                        // hide empty container
                        emptyContainer.classList.add('d-none');
                        experiencesContainer.classList.remove('d-none');
                        experiencesArray.sort(sortExperiences);
                        experiencesArray.forEach(experienceObj => {
                            let item = createTimelineItem({
                                title: experienceObj.jobTitle,
                                subtitle: experienceObj.companyName,
                                text: experienceObj.description,
                                date: (new Date(experienceObj.startDate).getFullYear()) + " - "
                                    + (experienceObj.endDate ? (new Date(experienceObj.endDate).getFullYear()) : "Present"),
                            });

                            // append to container
                            item = experiencesContainer.appendChild(item);
                            item.addEventListener("click", () => experiencePopup.show(experienceObj, item));
                        });
                    } else {
                        emptyContainer.classList.remove('d-none');
                        experiencesContainer.classList.add('d-none');
                    }
                    updateTabsHeight();
                };
            })();
        });

        (() => {
            const popup = new function () {
                    this.element = document.getElementById("experiencePopup");
                    this.title = this.element.querySelector(".modal-title");
                    this.object = new bootstrap.Modal(this.element);
                },
                form = new function () {
                    this.element = document.getElementById("experienceForm");
                    this.companyName = this.element.querySelector("[data-experience-prop='companyName']");
                    this.jobTitle = this.element.querySelector("[data-experience-prop='jobTitle']");
                    this.description = this.element.querySelector("[data-experience-prop='description']");
                    this.startDate = this.element.querySelector("[data-experience-prop='startDate']");
                    this.endDate = this.element.querySelector("[data-experience-prop='endDate']");
                },
                addBtn = document.getElementById("addExperienceButton"),
                saveBtn = document.getElementById("experienceSaveButton"),
                deleteBtn = document.getElementById("experienceDeleteButton"),
                applyExperienceToForm = (experienceObj) => {
                    form.companyName.value = experienceObj.companyName || "";
                    form.jobTitle.value = experienceObj.jobTitle || "";
                    form.description.value = experienceObj.description || "";
                    form.startDate.value = experienceObj.startDate || "";
                    form.endDate.value = experienceObj.endDate || "";
                    _updateAutoTextArea(form.description);
                },
                applyFormToExperience = (experienceObj) => {
                    experienceObj.companyName = form.companyName.value.trim();
                    experienceObj.jobTitle = form.jobTitle.value.trim();
                    experienceObj.description = form.description.value.trim();
                    experienceObj.startDate = form.startDate.value;
                    experienceObj.endDate = form.endDate.value;
                };

            experiencePopup.show = (experienceObj = null, experienceItem = null) => {
                let saveBtnListener = null;
                let deleteBtnListener = null;
                _clearForm(form.element)
                if (experienceObj && experienceItem) { // we're editing an existing experience
                    popup.title.textContent = "Edit experience";
                    applyExperienceToForm(experienceObj);
                    // set delete event listener
                    deleteBtnListener = () => {
                        experiences.remove(experienceObj.id);
                        timeline.update();
                        popup.object.hide();
                    };
                    // show delete button and register event listener
                    deleteBtn.classList.remove("d-none");
                    deleteBtn.addEventListener("click", deleteBtnListener);
                    // set save event listener
                    saveBtnListener = () => {
                        if (form.element.reportValidity()) {
                            applyFormToExperience(experienceObj);
                            experiences.update(experienceObj);
                            timeline.update();
                            popup.object.hide();
                        }
                    };
                } else { // we're adding a new experience
                    popup.title.textContent = "Add a new experience";
                    // hide delete button
                    deleteBtn.classList.add("d-none");
                    // set save event listener
                    saveBtnListener = () => {
                        if (form.element.reportValidity()) {
                            experienceObj = new Profile.Experience();
                            applyFormToExperience(experienceObj);
                            experiences.add(experienceObj);
                            timeline.update();
                            popup.object.hide();
                        }
                    };
                }
                // register save button event listener
                saveBtn.addEventListener("click", saveBtnListener);
                // remove buttons event listeners when hiding popup
                popup.element.addEventListener("hidden.bs.modal", () => {
                    if (saveBtnListener)
                        saveBtn.removeEventListener("click", saveBtnListener);
                    if (deleteBtnListener)
                        deleteBtn.removeEventListener("click", deleteBtnListener);

                }, {once: true});
                popup.object.show(experienceItem);

            };
            experiencePopup.hide = () => {
                popup.object.hide();
            };

            <@shared.popupHandlers/>

            addBtn.addEventListener("click", () => experiencePopup.show());
        })();

    </script>
</#macro>

<#macro skill>
    <div class="skill rounded-2 p-2 w-100 cursor-pointer bg-hover">
        <div class="mb-1 d-flex justify-content-between text-muted">
            <span data-prop="name"></span>
            <span data-prop="level"></span>
        </div>
        <div class="progress" style="height: 10px;">
            <div class="progress-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100"></div>
        </div>
    </div>
</#macro>

<#macro skillPopup>
    <div class="modal fade user-select-none" id="skillPopup" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header pb-1">
                    <h5 class="modal-title"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form class="mx-2" id="skillForm" method="post">
                        <@default.csrfInput/>
                        <input type="hidden" data-skill-prop="id" id=""/>
                        <div class="form-floating">
                            <input class="form-control" required type="text" data-skill-prop="name"
                                   id="skillName" placeholder="Skill">
                            <label class="form-label text-muted" for="skillName">Skill</label>
                        </div>
                        <div class="form-floating mt-3">
                            <input class="form-control" required max="100" min="0" type="number" data-skill-prop="level"
                                   id="skillLevel" placeholder="Level">
                            <label class="form-label text-muted" for="skillLevel">Level</label>
                        </div>
                    </form>
                </div>
                <div class="d-block modal-footer clearfix">
                    <div class="float-start">
                        <button id="skillDeleteButton" class="btn btn-outline-danger d-none">Delete</button>
                    </div>
                    <div class="float-end">
                        <button id="skillSaveButton" class="btn btn-primary">Save</button>
                        <button class="btn btn-outline-primary" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</#macro>

<#macro skillScript>
    <script>
        // skills data functions
        const skills = {
            add: null,
            update: null,
            remove: null,
        };
        document.addEventListener("profile-loaded", () => {
            const skillsArray = Profile.getItem("skills");
            skills.add = (skillObj) => {
                skillObj.id = skillsArray.length;
                skillsArray.push(new Profile.Skill(skillObj));
                Profile.saveProfile();
                return skillsArray[skillsArray.length - 1];
            };
            skills.update = (skillObj) => {
                const skill = skillsArray.find(skill => skill.id === skillObj.id);
                Object.assign(skill, skillObj);
                Profile.saveProfile();
                return skill;
            };
            skills.remove = (skillId) => {
                skillsArray.splice(skillId, 1);
                for (let i = 0; i < skillsArray.length; i++) {
                    skillsArray[i].id = i;
                }
                Profile.saveProfile();
            };
        });
        // skills cards functions
        const skillElements = {
            add: null,
            remove: null,
        };
        (() => {
            const skillsContainer = document.getElementById("skillsContainer");
            const skillTemplate = <@default.jsStr><@skill/></@default.jsStr>;
            const emptyContainerTemplate = <@default.jsStr><@shared.emptyContainer/></@default.jsStr>;

            <#noparse>
            // creates and adds a skill card to the skillsContainer
            // returns the added card
            skillElements.add = (skillObj) => {
                // remove empty container
                if (skillsContainer.querySelector(".empty-container"))
                    skillsContainer.replaceChildren();

                // create card element and apply skillObj data
                const template = document.createElement("template");
                template.innerHTML = skillTemplate;
                const skill = template.content.firstElementChild;
                skill.querySelector("[data-prop='name']").innerText = skillObj.name;
                skill.querySelector("[data-prop='level']").innerText = skillObj.level + "%";
                skill.querySelector(".progress-bar").style.width = skillObj.level + "%";

                // create the card's column and add it to the skillsContainer
                const col = document.createElement("div");
                col.classList.add("col", "mb-1");
                col.appendChild(skill);
                skillsContainer.appendChild(col);
                updateTabsHeight();
                return skillsContainer.lastElementChild.firstElementChild;
            };

            // removes a skill card from the skillsContainer
            skillElements.remove = (card) => {
                // remove the card's column
                const col = card.parentElement;
                col.remove();
                // insert empty container if there are no elements
                if (skillsContainer.querySelectorAll(".col").length === 0) {
                    const template = document.createElement("template");
                    template.innerHTML = emptyContainerTemplate;
                    const emptyContainer = template.content.firstElementChild;
                    skillsContainer.appendChild(emptyContainer);
                }
                updateTabsHeight();
            };
            </#noparse>
        })()

        // skills popup functions
        const skillPopup = {
            show: null,
            hide: null,
        };
        (() => {
            const popup = new function () {
                    this.element = document.getElementById("skillPopup");
                    this.title = this.element.querySelector(".modal-title");
                    this.object = new bootstrap.Modal(this.element);
                },
                form = new function () {
                    this.element = document.getElementById("skillForm");
                    this.name = this.element.querySelector("[data-skill-prop='name']");
                    this.level = this.element.querySelector("[data-skill-prop='level']");
                },
                addBtn = document.getElementById("addSkillButton"),
                saveBtn = document.getElementById("skillSaveButton"),
                deleteBtn = document.getElementById("skillDeleteButton"),
                applySkillToForm = (skillObj) => {
                    form.name.value = skillObj.name || "";
                    form.level.value = skillObj.level || "";
                },
                applyFormToSkill = (skillObj) => {
                    skillObj.name = form.name.value.trim();
                    skillObj.level = form.level.value;
                };

            skillPopup.show = (skillObj = null, skillElem = null) => {
                let saveBtnListener = null;
                let deleteBtnListener = null;
                _clearForm(form.element)
                if (skillObj && skillElem) { // we're editing an existing skill
                    popup.title.textContent = "Edit skill";
                    // hide skill parser group
                    applySkillToForm(skillObj);
                    // set delete event listener
                    deleteBtnListener = () => {
                        skillElements.remove(skillElem);
                        skills.remove(skillObj.id);
                        popup.object.hide();
                    };
                    // show delete button and register event listener
                    deleteBtn.classList.remove("d-none");
                    deleteBtn.addEventListener("click", deleteBtnListener);
                    // set save event listener
                    saveBtnListener = () => {
                        if (form.element.reportValidity()) {
                            applyFormToSkill(skillObj);
                            skillObj = skills.update(skillObj);
                            skillElements.remove(skillElem);
                            skillElem = skillElements.add(skillObj);
                            skillElem.addEventListener("click", () => {
                                skillPopup.show(skillObj, skillElem);
                            });
                            popup.object.hide();
                        }
                    };
                } else { // we're adding a new skill
                    popup.title.textContent = "Add a new skill";
                    // show skill parser group
                    // hide delete button
                    deleteBtn.classList.add("d-none");
                    // set save event listener
                    saveBtnListener = () => {
                        if (form.element.reportValidity()) {
                            skillObj = new Profile.Skill();
                            applyFormToSkill(skillObj);
                            skillObj = skills.add(skillObj);
                            const card = skillElements.add(skillObj);
                            card.addEventListener("click", () => {
                                skillPopup.show(skillObj, card);
                            });
                            popup.object.hide();
                        }
                    };
                }
                // register save button event listener
                saveBtn.addEventListener("click", saveBtnListener);
                // remove buttons event listeners when hiding popup
                popup.element.addEventListener("hidden.bs.modal", () => {
                    if (saveBtnListener)
                        saveBtn.removeEventListener("click", saveBtnListener);
                    if (deleteBtnListener)
                        deleteBtn.removeEventListener("click", deleteBtnListener);

                }, {once: true});
                popup.object.show(skillElem);

            };

            skillPopup.hide = () => {
                popup.object.hide();
            };

            <@shared.popupHandlers/>

            addBtn.addEventListener("click", () => skillPopup.show());
        })()

    </script>
</#macro>