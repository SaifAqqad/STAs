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
                <div class="row row-cols-1 row-cols-lg-2">
                    <div class="w-100 min-h-100 d-flex justify-content-center align-items-center">
                        <span class="fs-6 text-muted user-select-none">You haven't added anything yet</span>
                    </div>
                </div>
            </div>
            <div class="mt-4 clearfix">
                <@shared.backBtn/>
                <@shared.nextBtn/>
            </div>
        </div>
    </div>
</#macro>

<#macro script>
    <div class="modal fade" id="coursePopup" tabindex="-1" >
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="courseForm" method="post">
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
                            <label class="form-label text-muted" for="">Course image</label>
                            <div class="card w-100 mt-3">
                                <img id="" class="card-img-top" alt="" src="">
                                <div class="card-body">
                                    <input type="hidden" data-course-prop="imageUri" id=""/>
                                    <input class="form-control" type="file" accept="image/*" name="imageUriData" id=""
                                           placeholder="Course image"/>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer clearfix">
                    <div class="float-start">
                        <button id="courseDeleteButton" class="btn btn-danger d-none">Delete</button>
                    </div>
                    <div class="float-end">
                        <button id="courseSaveButton" class="btn btn-primary">Save</button>
                        <button class="btn btn-outline-primary" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
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
            };
            courses.update = (courseObj) => {
                const course = coursesArray.find(course => course.id === courseObj.id);
                Object.assign(course, courseObj);
                Profile.saveProfile();
            };
            courses.remove = (courseId) => {
                coursesArray.splice(courseId, 1);
                for (let i = 0; i < coursesArray.length; i++) {
                    coursesArray[i].id = i;
                }
                Profile.saveProfile();
            };
        });


        // courses popup functions
        const coursePopup = {
            show: null,
            hide: null,
        };
        (() => {
            const popupElem = document.getElementById("coursePopup");
            const popupTitleElem = popupElem.querySelector(".modal-title");
            const popup = new bootstrap.Modal(popupElem);
            const form = document.getElementById("courseForm");
            const addBtn = document.getElementById("addCourseButton");
            const saveBtn = document.getElementById("courseSaveButton");
            const deleteBtn = document.getElementById("courseDeleteButton");
            const applyCourseToForm = (courseObj) => {
                form.querySelector("[data-course-prop='id']").value = courseObj.id;
                form.querySelector("[data-course-prop='name']").value = courseObj.name;
                form.querySelector("[data-course-prop='description']").value = courseObj.description;
                form.querySelector("[data-course-prop='studentComment']").value = courseObj.studentComment;
                form.querySelector("[data-course-prop='publisher']").value = courseObj.publisher;
                form.querySelector("[data-course-prop='url']").value = courseObj.url;
                form.querySelector("[data-course-prop='imageUri']").value = courseObj.imageUri;
            }
            const applyFormToCourse = (courseObj) => {
                courseObj.name = form.querySelector("[data-course-prop='name']").value;
                courseObj.description = form.querySelector("[data-course-prop='description']").value;
                courseObj.studentComment = form.querySelector("[data-course-prop='studentComment']").value;
                courseObj.publisher = form.querySelector("[data-course-prop='publisher']").value;
                courseObj.url = form.querySelector("[data-course-prop='url']").value;
                courseObj.imageUri = form.querySelector("[data-course-prop='imageUri']").value;
                courseObj.imageData = form.querySelector("[name='imageUriData']").files[0];
            };

            // scope abuse incoming :D
            coursePopup.show = (courseObj = null) => {
                let saveBtnListener = null;
                let deleteBtnListener = null;
                _clearForm(form)
                if (courseObj) { // we're editing an existing course
                    popupTitleElem.textContent = "Edit course";
                    applyCourseToForm(courseObj);
                    // set delete event listener
                    deleteBtnListener = () => {
                        courses.remove(courseObj.id);
                        // TODO: remove card
                        popup.hide();
                    };
                    // show delete button and register event listener
                    deleteBtn.classList.remove("d-none");
                    deleteBtn.addEventListener("click", deleteBtnListener);
                    // set save event listener
                    saveBtnListener = () => {
                        applyFormToCourse(courseObj);
                        courses.update(courseObj);
                        // TODO: update card
                        popup.hide();
                    };
                } else { // we're adding a new course
                    popupTitleElem.textContent = "Add a new course";
                    // hide delete button
                    deleteBtn.classList.add("d-none");
                    // set save event listener
                    saveBtnListener = () => {
                        if (form.reportValidity()) {
                            courseObj = new Profile.Course();
                            applyFormToCourse(courseObj);
                            courses.add(courseObj);
                            // TODO: add card
                            popup.hide();
                        }
                    };
                }
                // register save button event listener
                saveBtn.addEventListener("click", saveBtnListener);
                // remove buttons event listeners when hiding popup
                popupElem.addEventListener("hidden.bs.modal", () => {
                    if (saveBtnListener) {
                        saveBtn.removeEventListener("click", saveBtnListener);
                    }
                    if (deleteBtnListener) {
                        deleteBtn.removeEventListener("click", deleteBtnListener);
                    }
                }, {once: true});
                popup.show(null);
            };

            coursePopup.hide = () => {
                popup.hide();
            };

            addBtn.addEventListener("click", () => coursePopup.show());

        })()
    </script>

<#-- Tabs script  -->
    <script>
        (() => {
            const tabsContainer = document.querySelector('.tabs');
            const card = document.querySelector('#educationCard');
            const currentTab = card.parentElement;

            tabsContainer.addEventListener("tab-changing", () => {
                if (!currentTab.classList.contains("tab-active"))
                    return;
                card.querySelectorAll("[data-profile-prop]").forEach(element => {
                    Profile.setItem(element.getAttribute("data-profile-prop"), element.value)
                });
                Profile.saveProfile();
            });

            document.addEventListener("profile-loaded", () => {
                card.querySelectorAll("[data-profile-prop]").forEach(element => {
                    element.value = Profile.getItem(element.getAttribute("data-profile-prop"))
                });
                // TODO: add a new card for each course in the data
            })

        })()
    </script>
</#macro>

