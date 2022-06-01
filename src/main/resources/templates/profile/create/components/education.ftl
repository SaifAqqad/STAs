<#import "../../../shared/default.ftl" as default/>
<#import "../shared.ftl" as shared/>
<#import "../../popup.ftl" as popups />

<#macro card>
    <div id="educationCard" class="card rounded-3 user-select-none w-100">
        <div class="card-body">
            <h6 class="card-title mb-1">What about your education?</h6>
            <div class="form-floating mt-3">
                <input class="form-control" required type="text" data-profile-prop="major" id="major"
                       placeholder="Major">
                <label class="form-label text-muted" for="major">Major</label>
            </div>
            <div class="form-floating mt-3">
                <input class="form-control" required type="text" data-profile-prop="university"
                       id="university"
                       placeholder="University">
                <label class="form-label text-muted" for="university">University</label>
            </div>
            <div class="card card-border-grey w-100 mt-3 p-3 pt-2 ">
                <div class="d-flex justify-content-between align-items-center">
                    <h6 class="card-title mb-2">
                        Have you taken any courses?
                    </h6>
                    <button class="btn btn-outline-primary mb-2" id="addCourseButton">Add course</button>
                </div>
                <div class="row row-cols-1" id="coursesContainer">
                    <@shared.emptyContainer/>
                </div>
            </div>
            <div class="mt-4 clearfix">
                <@shared.backBtn/>
                <@shared.nextBtn/>
            </div>
        </div>
    </div>
</#macro>

<#macro popup>
    <div class="modal fade user-select-none" id="coursePopup" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header pb-1">
                    <h5 class="modal-title"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="courseParser">
                        <div class="mx-2">
                            <div class="card-text mb-2">Autofill using the course's link</div>
                            <div class="input-group flex-nowrap">
                                <div class="flex-grow-1 form-floating">
                                    <input class="form-control rounded-0 rounded-start" required type="url"
                                           id="courseParserInput"
                                           placeholder="Link">
                                    <label for="courseParserInput">Link</label>
                                </div>
                                <button type="button" class="btn btn-primary" id="courseParserButton">
                                    <span class="btn-spinner spinner-border spinner-border-sm d-none" role="status"
                                          aria-hidden="true"></span>
                                    <span class="btn-text">Fetch</span>
                                </button>
                            </div>
                            <sub class="text-danger fw-bold" id="courseParserFeedback"></sub>
                        </div>
                        <hr>
                        <div class="card-text mb-2 mx-2">Or manually enter the course's information</div>
                    </div>
                    <form class="mx-2" id="courseForm" method="post">
                        <@default.csrfInput/>
                        <input type="hidden" data-course-prop="id" id=""/>
                        <div class="form-floating">
                            <input class="form-control" required type="text" data-course-prop="name" id="courseName"
                                   placeholder="Name">
                            <label class="form-label text-muted" for="courseName">Name</label>
                        </div>
                        <div class="form-floating mt-3 fix-floating-label">
                            <textarea class="form-control" data-course-prop="description" id="courseDescription"
                                      placeholder="Description"></textarea>
                            <label class="form-label text-muted" for="courseDescription">Description</label>
                        </div>
                        <div class="form-floating mt-3 fix-floating-label">
                            <textarea class="form-control" data-course-prop="studentComment" id="courseStudentComment"
                                      placeholder="Comment"></textarea>
                            <label class="form-label text-muted" for="courseStudentComment">Reflection</label>
                        </div>
                        <div class="form-floating mt-3">
                            <input class="form-control" type="text" data-course-prop="publisher" id="coursePublisher"
                                   placeholder="Publisher">
                            <label class="form-label text-muted" for="coursePublisher">Publisher</label>
                        </div>
                        <div class="form-floating mt-3">
                            <input class="form-control" type="url" data-course-prop="url" id="courseUrl"
                                   placeholder="Link">
                            <label class="form-label text-muted" for="courseUrl">Link</label>
                        </div>
                        <div class="mt-3">
                            <label class="form-label text-muted" for="courseImageFile">Course image</label>
                            <div class="card w-100 mt-3">
                                <img id="courseImagePreview" class="card-img-top" alt="" src="">
                                <div class="card-body">
                                    <input type="hidden" data-course-prop="imageUri" id=""/>
                                    <div class="input-group">
                                        <input class="form-control" type="file" accept="image/png, image/jpeg"
                                               id="courseImageFile" placeholder="Course image"/>
                                        <button id="courseImageClearButton" type="button" class="btn btn-style-group">
                                            Clear
                                        </button>
                                    </div>
                                    <sub class="text-danger fw-bold text-center" id="courseImageFileFeedback"></sub>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="d-block modal-footer clearfix">
                    <div class="float-start">
                        <button id="courseDeleteButton" class="btn btn-outline-danger d-none">Delete</button>
                    </div>
                    <div class="float-end">
                        <button id="courseSaveButton" class="btn btn-primary">Save</button>
                        <button class="btn btn-outline-primary" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</#macro>

<#macro script>
    <@popup/>
    <script src="/js/CourseParser.js"></script>
    <script>
        // courses data functions
        const courses = {
            add: null,
            update: null,
            remove: null,
        };
        document.addEventListener("profile-loaded", () => {
            const coursesArray = Profile.getItem("courses");
            courses.add = (courseObj) => {
                courseObj.id = coursesArray.length;
                coursesArray.push(new Profile.Course(courseObj));
                Profile.saveProfile();
                return coursesArray[coursesArray.length - 1];
            };
            courses.update = (courseObj) => {
                const course = coursesArray.find(course => course.id === courseObj.id);
                Object.assign(course, courseObj);
                Profile.saveProfile();
                return course;
            };
            courses.remove = (courseId) => {
                coursesArray.splice(courseId, 1);
                for (let i = 0; i < coursesArray.length; i++) {
                    coursesArray[i].id = i;
                }
                Profile.saveProfile();
            };
        });

        const courseCards = new itemCardFactory("coursesContainer", "course", <@default.jsStr><@shared.itemCard cardType="course"/></@default.jsStr>);

        // courses popup functions
        const coursePopup = {
            show: null,
            hide: null,
        };
        (() => {
            const popup = new function () {
                    this.element = document.getElementById("coursePopup");
                    this.title = this.element.querySelector(".modal-title");
                    this.object = new bootstrap.Modal(this.element);
                },
                form = new function () {
                    this.element = document.getElementById("courseForm");
                    this.image = {
                        fileElem: this.element.querySelector("#courseImageFile"),
                        fileFeedback: this.element.querySelector("#courseImageFileFeedback"),
                        previewElem: this.element.querySelector("#courseImagePreview"),
                        clearButton: this.element.querySelector("#courseImageClearButton"),
                        uriElem: this.element.querySelector("[data-course-prop='imageUri']"),
                    }
                    this.name = this.element.querySelector("[data-course-prop='name']");
                    this.description = this.element.querySelector("[data-course-prop='description']");
                    this.studentComment = this.element.querySelector("[data-course-prop='studentComment']");
                    this.publisher = this.element.querySelector("[data-course-prop='publisher']");
                    this.url = this.element.querySelector("[data-course-prop='url']");
                },
                addBtn = document.getElementById("addCourseButton"),
                saveBtn = document.getElementById("courseSaveButton"),
                deleteBtn = document.getElementById("courseDeleteButton"),
                applyCourseToForm = (courseObj) => {
                    form.name.value = courseObj.name || "";
                    form.description.value = courseObj.description || "";
                    form.studentComment.value = courseObj.studentComment || "";
                    form.publisher.value = courseObj.publisher || "";
                    form.url.value = courseObj.url || "";
                    form.image.uriElem.value = courseObj.imageUri || "";
                    form.image.previewElem.src = courseObj.imageUri || "";
                    form.image.fileElem.value = "";
                    _updateAutoTextArea(form.description);
                    _updateAutoTextArea(form.studentComment);
                },
                applyFormToCourse = (courseObj) => {
                    courseObj.name = form.name.value.trim();
                    courseObj.description = form.description.value.trim();
                    courseObj.studentComment = form.studentComment.value.trim();
                    courseObj.publisher = form.publisher.value.trim();
                    courseObj.url = form.url.value.trim();
                    courseObj.imageUri = form.image.uriElem.value;
                },
                courseParser = new CourseParser("courseParser", applyCourseToForm);

            coursePopup.show = (courseObj = null, courseCard = null) => {
                let saveBtnListener = null;
                let deleteBtnListener = null;
                _clearForm(form.element)
                if (courseObj && courseCard) { // we're editing an existing course
                    popup.title.textContent = "Edit course";
                    // hide course parser group
                    courseParser.group.classList.add("d-none");
                    applyCourseToForm(courseObj);
                    // set delete event listener
                    deleteBtnListener = () => {
                        courseCards.remove(courseCard);
                        courses.remove(courseObj.id);
                        popup.object.hide();
                    };
                    // show delete button and register event listener
                    deleteBtn.classList.remove("d-none");
                    deleteBtn.addEventListener("click", deleteBtnListener);
                    // set save event listener
                    saveBtnListener = () => {
                        if (form.element.reportValidity()) {
                            applyFormToCourse(courseObj);
                            courseObj = courses.update(courseObj);
                            courseCards.remove(courseCard);
                            courseCard = courseCards.add({
                                title: courseObj.name,
                                subtitle: courseObj.publisher,
                                text: courseObj.studentComment || courseObj.description,
                                imageUri: courseObj.imageUri,
                            });
                            courseCard.addEventListener("click", () => {
                                coursePopup.show(courseObj, courseCard);
                            });
                            popup.object.hide();
                        }
                    };
                } else { // we're adding a new course
                    popup.title.textContent = "Add a new course";
                    // show course parser group
                    courseParser.group.classList.remove("d-none");
                    // hide delete button
                    deleteBtn.classList.add("d-none");
                    // set save event listener
                    saveBtnListener = () => {
                        if (form.element.reportValidity()) {
                            courseObj = new Profile.Course();
                            applyFormToCourse(courseObj);
                            courseObj = courses.add(courseObj);
                            const card = courseCards.add({
                                title: courseObj.name,
                                subtitle: courseObj.publisher,
                                text: courseObj.studentComment || courseObj.description,
                                imageUri: courseObj.imageUri,
                            });
                            card.addEventListener("click", () => {
                                coursePopup.show(courseObj, card);
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
                popup.object.show(courseCard);

            };

            coursePopup.hide = () => {
                popup.object.hide();
            };

            <@shared.popupHandlers/>

            // when hiding the popup, reset courseParser
            popup.element.addEventListener("hidden.bs.modal", () => {
                courseParser.setValidity(true);
                courseParser.setLoading(false);
            });

            addBtn.addEventListener("click", () => coursePopup.show());
        })()
    </script>

<#-- Tabs script  -->
    <script>
        (() => {
            const tabsContainer = document.querySelector('.tabs');
            const card = document.querySelector('#educationCard');
            const currentTab = card.parentElement;

            // handle tab changing event
            tabsContainer.addEventListener("tab-changing", () => {
                if (!currentTab.classList.contains("tab-active"))
                    return;
                // update profile data
                card.querySelectorAll("[data-profile-prop]").forEach(element => {
                    Profile.setItem(element.getAttribute("data-profile-prop"), element.value)
                });
                Profile.saveProfile();
            });

            // handle existing profile data
            document.addEventListener("profile-loaded", () => {
                // update form inputs
                card.querySelectorAll("[data-profile-prop]").forEach(element => {
                    element.value = Profile.getItem(element.getAttribute("data-profile-prop"))
                });
                // create a course card for each existing course
                const coursesArray = Profile.getItem("courses");
                coursesArray.forEach(course => {
                    const courseCard = courseCards.add({
                        title: course.name,
                        subtitle: course.publisher,
                        text: course.studentComment || course.description,
                        imageUri: course.imageUri,
                    });
                    courseCard.addEventListener("click", () => coursePopup.show(course, courseCard));
                });
            })
        })()
    </script>
</#macro>