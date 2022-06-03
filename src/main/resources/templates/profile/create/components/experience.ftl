<#import "../../../shared/default.ftl" as default/>
<#import "../shared.ftl" as shared/>

<#macro card>
    <div id="experienceCard" class="card rounded-3 user-select-none w-100">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
                <h6 class="card-title mb-2">
                    Do you have any professional experience?
                </h6>
                <button class="btn btn-outline-primary mb-2" id="addExperienceButton">Add experience</button>
            </div>
            <div class="card border-0 shadow-none bg-white w-100 mt-3 p-3 py-0">
                <ul id="experiencesContainer" class="list-unstyled timeline d-none">
                </ul>
                <@shared.emptyContainer/>
            </div>
            <div class="mt-3 clearfix">
                <@shared.backBtn/>
                <@shared.nextBtn/>
            </div>
        </div>
    </div>
</#macro>

<#macro timelineItem>
    <li class="timeline-item cursor-pointer bg-hover text-hover-dark smooth">
        <span class="timeline-date"></span>
        <div class="timeline-title pt-1 mb-1 card-title fs-115"></div>
        <p class="timeline-subtitle text-muted"></p>
        <p class="timeline-text text-muted mt-2 limit-lines-4 preserve-lines"></p>
    </li>
</#macro>

<#macro popup>
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

<#macro script>
    <@popup/>
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
<#-- Tabs script -->
    <script>
        (() => {
            const tabsContainer = document.querySelector('.tabs');
            const card = document.querySelector('#experienceCard');
            const currentTab = card.parentElement;

            // add timeline items for existing experiences
            document.addEventListener("profile-loaded", () => {
                timeline.update();
            });

            document.addEventListener("tab-changing", () => {
                if (!currentTab.classList.contains("tab-active"))
                    return;
                Profile.saveProfile();
            });
        })()
    </script>

</#macro>