<#import "../../../shared/default.ftl" as default/>
<#import "../shared.ftl" as shared/>
<#import "../../popup.ftl" as popups />

<#macro card>
    <div id="projectCard" class="card rounded-3 user-select-none w-100">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
                <h6 class="card-title mb-2">
                    Have you worked on any projects?
                </h6>
                <button class="btn btn-outline-primary mb-2" id="addProjectButton">Add project</button>
            </div>
            <div class="card border-0 shadow-none bg-white w-100 mt-3 p-3 py-0">
                <div class="row row-cols-1" id="projectsContainer">
                    <@shared.emptyContainer/>
                </div>
            </div>
            <hr>
            <div class=" d-flex justify-content-between align-items-center">
                <h6 class="card-title mb-2">
                    Do you want to add an activity?
                </h6>
                <button class="btn btn-outline-primary mb-2" id="addActivityButton">Add activity</button>
            </div>
            <div class="card border-0 shadow-none bg-white w-100 mt-3 p-3 py-0">
                <div class="row row-cols-1" id="activitiesContainer">
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

<#macro popup>
    <div class="modal fade user-select-none" id="projectPopup" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header pb-1">
                    <h5 class="modal-title"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="githubImporter">
                        <div class="mx-2">
                            <div class="card-text mb-2">Import a project from a GitHub repository</div>
                            <div class="gi-pre-login d-flex justify-content-center">
                                <button type="button" class="gi-login-btn btn btn-dark w-75 mt-2">
                                    <@default.icon name="github" width="24" class="align-bottom"/>
                                    <span class="align-text-bottom">Log in with GitHub</span>
                                </button>
                            </div>
                            <div class="gi-post-login">
                                <div class="dropdown w-100 d-flex justify-content-center">
                                    <button class="btn btn-dark w-75 dropdown-toggle" type="button" id="giDropDown"
                                            data-bs-toggle="dropdown" aria-expanded="false">
                                        <@default.icon name="github" width="24" class="align-bottom"/>
                                        <span class="gi-username">GitHub</span>'s
                                        repositories
                                    </button>
                                    <ul class="dropdown-menu overflow-auto w-75 gi-repos" aria-labelledby="giDropDown"
                                        style="max-height: 200px;"></ul>
                                </div>
                            </div>
                            <sub class="text-danger fw-bold gi-feedback"></sub>
                        </div>
                        <hr>
                        <div class="card-text mb-2 mx-2">Or manually enter the project's information</div>
                    </div>
                    <form class="mx-2" id="projectForm" method="post">
                        <@default.csrfInput/>
                        <input type="hidden" data-project-prop="id"/>
                        <div class="form-floating">
                            <input class="form-control" required type="text" data-project-prop="name"
                                   id="projectName"
                                   placeholder="Name">
                            <label class="form-label text-muted" for="projectName">Name</label>
                        </div>
                        <div class="form-floating mt-3 fix-floating-label">
                            <textarea class="form-control" data-project-prop="description" id="projectDescription"
                                      placeholder="Description"></textarea>
                            <label class="form-label text-muted" for="projectDescription">Description</label>
                        </div>
                        <div class="form-floating mt-3">
                            <input class="form-control" type="text" data-project-prop="url" id="projectUrl"
                                   placeholder="Link">
                            <label class="form-label text-muted" for="projectUrl">Link</label>
                        </div>
                        <div class="form-floating mt-3">
                            <input class="form-control" type="date" data-project-prop="startDate"
                                   required id="projectStartDate"
                                   placeholder="Start date">
                            <label class="form-label text-muted" for="projectStartDate">Start date</label>
                        </div>
                        <div class="form-floating mt-3">
                            <input class="form-control" type="date" data-project-prop="endDate" id="projectEndDate"
                                   placeholder="End date">
                            <label class="form-label text-muted" for="projectEndDate">End date</label>
                        </div>
                        <div class="mt-3">
                            <label class="form-label text-muted" for="projectImageUriData">Project image</label>
                            <div class="card w-100 mt-3">
                                <img id="projectImagePreview" class="card-img-top" alt="" src="">
                                <div class="card-body">
                                    <input type="hidden" data-project-prop="imageUri"/>
                                    <div class="input-group">
                                        <input class="form-control" type="file" accept="image/png, image/jpeg"
                                               id="projectImageFile" placeholder="Project image"/>
                                        <button id="projectImageClearButton" type="button" class="btn btn-style-group">
                                            Clear
                                        </button>
                                    </div>
                                    <sub class="text-danger fw-bold text-center" id="projectImageFileFeedback"></sub>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="d-block modal-footer clearfix">
                    <div class="float-start">
                        <button id="projectDeleteButton" class="btn btn-outline-danger d-none">Delete</button>
                    </div>
                    <div class="float-end">
                        <button id="projectSaveButton" class="btn btn-primary">Save</button>
                        <button class="btn btn-outline-primary" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade user-select-none" id="activityPopup" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header pb-1">
                    <h5 class="modal-title"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form class="mx-2" id="activityForm" method="post">
                        <@default.csrfInput/>
                        <input type="hidden" data-activity-prop="id"/>
                        <div class="form-floating">
                            <input class="form-control" required type="text" data-activity-prop="name"
                                   id="activityName"
                                   placeholder="Name">
                            <label class="form-label text-muted" for="activityName">Name</label>
                        </div>
                        <div class="form-floating mt-3 fix-floating-label">
                            <textarea class="form-control" data-activity-prop="description" id="activityDescription"
                                      placeholder="Description"></textarea>
                            <label class="form-label text-muted" for="activityDescription">Description</label>
                        </div>
                        <div class="form-floating mt-3">
                            <input class="form-control" required type="date" data-activity-prop="date"
                                   id="activityDate"
                                   placeholder="Date">
                            <label class="form-label text-muted" for="activityDate">Date</label>
                        </div>
                        <div class="mt-3">
                            <label class="form-label text-muted" for="activityImageUriData">Activity image</label>
                            <div class="card w-100 mt-3">
                                <img id="activityImagePreview" class="card-img-top" alt="" src="">
                                <div class="card-body">
                                    <input type="hidden" data-activity-prop="imageUri"/>
                                    <div class="input-group">
                                        <input class="form-control" type="file" accept="image/png, image/jpeg"
                                               id="activityImageFile" placeholder="Activity image"/>
                                        <button id="activityImageClearButton" type="button" class="btn btn-style-group">
                                            Clear
                                        </button>
                                    </div>
                                    <sub class="text-danger fw-bold text-center" id="activityImageFileFeedback"></sub>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="d-block modal-footer clearfix">
                    <div class="float-start">
                        <button id="activityDeleteButton" class="btn btn-outline-danger d-none">Delete</button>
                    </div>
                    <div class="float-end">
                        <button id="activitySaveButton" class="btn btn-primary">Save</button>
                        <button class="btn btn-outline-primary" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</#macro>

<#macro script>
    <@popup/>
    <script src="<@spring.url "/js/GithubImporter.js"/>"></script>
    <script>
        // projects data functions
        const projects = {
            add: null,
            update: null,
            remove: null,
        };
        document.addEventListener("profile-loaded", () => {
            const projectsArray = Profile.getItem("projects");
            projects.add = (projectObj) => {
                projectObj.id = projectsArray.length;
                projectsArray.push(new Profile.Project(projectObj));
                Profile.saveProfile();
                return projectsArray[projectsArray.length - 1]
            };
            projects.update = (projectObj) => {
                const project = projectsArray.find(project => project.id === projectObj.id);
                Object.assign(project, projectObj);
                Profile.saveProfile();
                return project;
            };
            projects.remove = (projectId) => {
                projectsArray.splice(projectId, 1);
                for (let i = 0; i < projectsArray.length; i++) {
                    projectsArray[i].id = i;
                }
                Profile.saveProfile();
            };
        });

        // projects cards functions
        const projectCards = new itemCardFactory("projectsContainer", "project", <@default.jsStr><@shared.itemCard cardType="project"/></@default.jsStr>);

        const projectPopup = {
            show: null,
            hide: null,
        };
        (() => {
            const popup = new function () {
                    this.element = document.getElementById("projectPopup");
                    this.title = this.element.querySelector(".modal-title");
                    this.object = new bootstrap.Modal(this.element);
                },
                form = new function () {
                    this.element = document.getElementById("projectForm");
                    this.image = {
                        fileElem: this.element.querySelector("#projectImageFile"),
                        fileFeedback: this.element.querySelector("#projectImageFileFeedback"),
                        previewElem: this.element.querySelector("#projectImagePreview"),
                        clearButton: this.element.querySelector("#projectImageClearButton"),
                        uriElem: this.element.querySelector("[data-project-prop='imageUri']"),
                    }
                    this.name = this.element.querySelector("[data-project-prop='name']");
                    this.description = this.element.querySelector("[data-project-prop='description']");
                    this.url = this.element.querySelector("[data-project-prop='url']");
                    this.startDate = this.element.querySelector("[data-project-prop='startDate']");
                    this.endDate = this.element.querySelector("[data-project-prop='endDate']");
                },
                addBtn = document.getElementById("addProjectButton"),
                saveBtn = document.getElementById("projectSaveButton"),
                deleteBtn = document.getElementById("projectDeleteButton"),
                applyProjectToForm = (projectObj) => {
                    form.name.value = projectObj.name || "";
                    form.description.value = projectObj.description || "";
                    form.url.value = projectObj.url || "";
                    form.startDate.value = projectObj.startDate || "";
                    form.endDate.value = projectObj.endDate || "";
                    form.image.uriElem.value = projectObj.imageUri || "";
                    form.image.previewElem.src = projectObj.imageUri || "";
                    form.image.fileElem.value = "";
                    _updateAutoTextArea(form.description);
                },
                applyFormToProject = (projectObj) => {
                    projectObj.name = form.name.value.trim();
                    projectObj.description = form.description.value.trim();
                    projectObj.startDate = form.startDate.value;
                    projectObj.endDate = form.endDate.value;
                    projectObj.url = form.url.value.trim();
                    projectObj.imageUri = form.image.uriElem.value;
                };
            let githubImporter = new GithubImporter("githubImporter", applyProjectToForm);
            githubImporter.init();

            projectPopup.show = (projectObj = null, projectCard = null) => {
                let saveBtnListener = null;
                let deleteBtnListener = null;
                _clearForm(form.element)
                if (projectObj && projectCard) { // we're editing an existing project
                    popup.title.textContent = "Edit project";
                    applyProjectToForm(projectObj);
                    // hide GitHub importer
                    _showElems([githubImporter.group], false);
                    // set delete event listener
                    deleteBtnListener = () => {
                        projectCards.remove(projectCard);
                        projects.remove(projectObj.id);
                        popup.object.hide();
                    };
                    // show delete button and register event listener
                    deleteBtn.classList.remove("d-none");
                    deleteBtn.addEventListener("click", deleteBtnListener);
                    // set save event listener
                    saveBtnListener = () => {
                        if (form.element.reportValidity()) {
                            applyFormToProject(projectObj);
                            projectObj = projects.update(projectObj);
                            projectCards.remove(projectCard);
                            projectCard = projectCards.add({
                                title: projectObj.name,
                                text: projectObj.description,
                                imageUri: projectObj.imageUri,
                            });
                            projectCard.addEventListener("click", () => {
                                projectPopup.show(projectObj, projectCard);
                            });
                            popup.object.hide();
                        }
                    };
                } else { // we're adding a new project
                    popup.title.textContent = "Add a new project";
                    // hide delete button
                    deleteBtn.classList.add("d-none");
                    // show GitHub importer
                    _showElems([githubImporter.group], true);
                    // set save event listener
                    saveBtnListener = () => {
                        if (form.element.reportValidity()) {
                            projectObj = new Profile.Project();
                            applyFormToProject(projectObj);
                            projectObj = projects.add(projectObj);
                            const card = projectCards.add({
                                title: projectObj.name,
                                text: projectObj.description,
                                imageUri: projectObj.imageUri,
                            });
                            card.addEventListener("click", () => {
                                projectPopup.show(projectObj, card);
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
                popup.object.show(projectCard);


            };
            projectPopup.hide = () => {
                popup.object.hide();
            };

            <@shared.popupHandlers/>
            popup.element.addEventListener("hidden.bs.modal", () => {
                githubImporter.feedbackElem.textContent = "";
            });

            addBtn.addEventListener("click", () => projectPopup.show());
        })()
    </script>
    <script>
        // activities data functions
        const activities = {
            add: null,
            update: null,
            remove: null,
        };
        document.addEventListener("profile-loaded", () => {
            const activitiesArray = Profile.getItem("activities");
            activities.add = (activityObj) => {
                activityObj.id = activitiesArray.length;
                activitiesArray.push(new Profile.Activity(activityObj));
                Profile.saveProfile();
                return activitiesArray[activitiesArray.length - 1]
            };
            activities.update = (activityObj) => {
                const activity = activitiesArray.find(activity => activity.id === activityObj.id);
                Object.assign(activity, activityObj);
                Profile.saveProfile();
                return activity;
            };
            activities.remove = (activityId) => {
                activitiesArray.splice(activityId, 1);
                for (let i = 0; i < activitiesArray.length; i++) {
                    activitiesArray[i].id = i;
                }
                Profile.saveProfile();
            };
        });

        // activities cards functions
        const activityCards = new itemCardFactory("activitiesContainer", "activity", <@default.jsStr><@shared.itemCard cardType="activity"/></@default.jsStr>);

        const activityPopup = {
            show: null,
            hide: null,
        };
        (() => {
            const popup = new function () {
                    this.element = document.getElementById("activityPopup");
                    this.title = this.element.querySelector(".modal-title");
                    this.object = new bootstrap.Modal(this.element);
                },
                form = new function () {
                    this.element = document.getElementById("activityForm");
                    this.image = {
                        fileElem: this.element.querySelector("#activityImageFile"),
                        fileFeedback: this.element.querySelector("#activityImageFileFeedback"),
                        previewElem: this.element.querySelector("#activityImagePreview"),
                        clearButton: this.element.querySelector("#activityImageClearButton"),
                        uriElem: this.element.querySelector("[data-activity-prop='imageUri']"),
                    }
                    this.name = this.element.querySelector("[data-activity-prop='name']");
                    this.description = this.element.querySelector("[data-activity-prop='description']");
                    this.date = this.element.querySelector("[data-activity-prop='date']");
                },
                addBtn = document.getElementById("addActivityButton"),
                saveBtn = document.getElementById("activitySaveButton"),
                deleteBtn = document.getElementById("activityDeleteButton"),
                applyActivityToForm = (activityObj) => {
                    form.name.value = activityObj.name || "";
                    form.description.value = activityObj.description || "";
                    form.date.value = activityObj.date || "";
                    form.image.uriElem.value = activityObj.imageUri || "";
                    form.image.previewElem.src = activityObj.imageUri || "";
                    form.image.fileElem.value = "";
                    _updateAutoTextArea(form.description);
                },
                applyFormToActivity = (activityObj) => {
                    activityObj.name = form.name.value.trim();
                    activityObj.description = form.description.value.trim();
                    activityObj.date = form.date.value;
                    activityObj.imageUri = form.image.uriElem.value;
                };

            activityPopup.show = (activityObj = null, activityCard = null) => {
                let saveBtnListener = null;
                let deleteBtnListener = null;
                _clearForm(form.element)
                if (activityObj && activityCard) { // we're editing an existing activity
                    popup.title.textContent = "Edit activity";
                    applyActivityToForm(activityObj);
                    // set delete event listener
                    deleteBtnListener = () => {
                        activityCards.remove(activityCard);
                        activities.remove(activityObj.id);
                        popup.object.hide();
                    };
                    // show delete button and register event listener
                    deleteBtn.classList.remove("d-none");
                    deleteBtn.addEventListener("click", deleteBtnListener);
                    // set save event listener
                    saveBtnListener = () => {
                        if (form.element.reportValidity()) {
                            applyFormToActivity(activityObj);
                            activityObj = activities.update(activityObj);
                            activityCards.remove(activityCard);
                            activityCard = activityCards.add({
                                title: activityObj.name,
                                text: activityObj.description,
                                imageUri: activityObj.imageUri,
                            });
                            activityCard.addEventListener("click", () => {
                                activityPopup.show(activityObj, activityCard);
                            });
                            popup.object.hide();
                        }
                    };
                } else { // we're adding a new activity
                    popup.title.textContent = "Add a new activity";
                    // hide delete button
                    deleteBtn.classList.add("d-none");
                    // set save event listener
                    saveBtnListener = () => {
                        if (form.element.reportValidity()) {
                            activityObj = new Profile.Activity();
                            applyFormToActivity(activityObj);
                            activityObj = activities.add(activityObj);
                            const card = activityCards.add({
                                title: activityObj.name,
                                text: activityObj.description,
                                imageUri: activityObj.imageUri,
                            });
                            card.addEventListener("click", () => {
                                activityPopup.show(activityObj, card);
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
                popup.object.show(activityCard);


            };
            activityPopup.hide = () => {
                popup.object.hide();
            };

            <@shared.popupHandlers/>

            addBtn.addEventListener("click", () => activityPopup.show());
        })()
    </script>
<#-- Tabs script -->
    <script>
        (() => {
            const tabsContainer = document.querySelector('.tabs');
            const card = document.querySelector('#projectCard');
            const currentTab = card.parentElement;

            // add cards for existing projects
            document.addEventListener("profile-loaded", () => {
                const projectArray = Profile.getItem("projects");
                const activityArray = Profile.getItem("activities");
                projectArray.forEach(projectObj => {
                    const projectCard = projectCards.add({
                        title: projectObj.name,
                        text: projectObj.description,
                        imageUri: projectObj.imageUri,
                    });
                    projectCard.addEventListener("click", () => {
                        projectPopup.show(projectObj, projectCard)
                    });
                });
                activityArray.forEach(activityObj => {
                    const activityCard = activityCards.add({
                        title: activityObj.name,
                        text: activityObj.description,
                        imageUri: activityObj.imageUri,
                    });
                    activityCard.addEventListener("click", () => {
                        activityPopup.show(activityObj, activityCard)
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