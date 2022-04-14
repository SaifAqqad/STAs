<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />

<#macro experiencePopup addPopup detailsPopup popupId formId uriBase>
    <@formPopup addPopup=addPopup detailsPopup=detailsPopup popupId=popupId formId=formId uriBase=uriBase>
        <input type="hidden" name="id" id="${formId}_id"/>
        <div class="form-floating">
            <input class="form-control" required type="text" name="companyName" id="${formId}_companyName"
                   placeholder="Company name">
            <label class="form-label text-muted" for="${formId}_companyName">Company name</label>
        </div>
        <div class="form-floating mt-3">
            <input class="form-control" required type="text" name="jobTitle" id="${formId}_jobTitle"
                   placeholder="Job title">
            <label class="form-label text-muted" for="${formId}_jobTitle">Job title</label>
        </div>
        <div class="form-floating mt-3 fix-floating-label">
            <textarea class="form-control" name="description" id="${formId}_description"
                      placeholder="Job description"></textarea>
            <label class="form-label text-muted" for="${formId}_description">Job description</label>
        </div>
        <div class="form-floating mt-3">
            <input class="form-control" required type="date" name="startDate" id="${formId}_startDate"
                   placeholder="Start date">
            <label class="form-label text-muted" for="${formId}_startDate">Start date</label>
        </div>
        <div class="form-floating mt-3">
            <input class="form-control" type="date" name="endDate" id="${formId}_endDate" placeholder="End date">
            <label class="form-label text-muted" for="${formId}_endDate">End date</label>
        </div>
    </@formPopup>
</#macro>

<#macro activityPopup addPopup detailsPopup popupId formId uriBase>
    <script>
        function _applyActivityToForm(formId, project) {
            _applyJsonToForm(formId, project)
            const imageElem = document.getElementById(formId + "_image")
            const imageUri = document.getElementById(formId + "_imageUri")
            imageElem.src = imageUri.value
        }
    </script>
    <@formPopup addPopup=addPopup detailsPopup=detailsPopup popupId=popupId formId=formId uriBase=uriBase isMultiPartForm=true applyMethod="_applyActivityToForm">
        <input type="hidden" name="id" id="${formId}_id"/>
        <div class="form-floating">
            <input class="form-control" required type="text" name="name" id="${formId}_name"
                   placeholder="Name">
            <label class="form-label text-muted" for="${formId}_name">Name</label>
        </div>
        <div class="form-floating mt-3 fix-floating-label">
            <textarea class="form-control" name="description" id="${formId}_description"
                      placeholder="Description"></textarea>
            <label class="form-label text-muted" for="${formId}_description">Description</label>
        </div>
        <div class="form-floating mt-3">
            <input class="form-control" required type="date" name="date" id="${formId}_date"
                   placeholder="Date">
            <label class="form-label text-muted" for="${formId}_date">Date</label>
        </div>
        <div class="mt-3">
            <label class="form-label text-muted" for="${formId}_imageUriData">Activity image</label>
            <div class="card w-100 mt-3">
                <img id="${formId}_image" class="card-img-top" alt="" src="">
                <div class="card-body">
                    <input type="hidden" name="imageUri" id="${formId}_imageUri"/>
                    <input class="form-control" type="file" name="imageUriData" id="${formId}_imageUriData"
                           placeholder="Activity image">
                </div>
            </div>
        </div>
    </@formPopup>
</#macro>

<#macro projectPopup addPopup detailsPopup popupId formId uriBase>
    <script>
        function _applyProjectToForm(formId, project) {
            _applyJsonToForm(formId, project)
            const imageElem = document.getElementById(formId + "_image")
            const imageUri = document.getElementById(formId + "_imageUri")
            imageElem.src = imageUri.value
        }
    </script>
    <@formPopup addPopup=addPopup detailsPopup=detailsPopup popupId=popupId formId=formId uriBase=uriBase isMultiPartForm=true applyMethod="_applyProjectToForm">
        <input type="hidden" name="id" id="${formId}_id"/>
        <div class="form-floating">
            <input class="form-control" required type="text" name="name" id="${formId}_name"
                   placeholder="Name">
            <label class="form-label text-muted" for="${formId}_name">Name</label>
        </div>
        <div class="form-floating mt-3">
            <input class="form-control" required type="text" name="category" id="${formId}_category"
                   placeholder="Category">
            <label class="form-label text-muted" for="${formId}_category">Category</label>
        </div>
        <div class="form-floating mt-3 fix-floating-label">
            <textarea class="form-control" name="description" id="${formId}_description"
                      placeholder="Description"></textarea>
            <label class="form-label text-muted" for="${formId}_description">Description</label>
        </div>
        <div class="form-floating mt-3">
            <input class="form-control" type="text" name="url" id="${formId}_url"
                   placeholder="Link">
            <label class="form-label text-muted" for="${formId}_url">Link</label>
        </div>
        <div class="form-floating mt-3">
            <input class="form-control" type="date" name="startDate" id="${formId}_startDate"
                   placeholder="Start date">
            <label class="form-label text-muted" for="${formId}_startDate">Start date</label>
        </div>
        <div class="form-floating mt-3">
            <input class="form-control" type="date" name="endDate" id="${formId}_endDate" placeholder="End date">
            <label class="form-label text-muted" for="${formId}_endDate">End date</label>
        </div>
        <div class="mt-3">
            <label class="form-label text-muted" for="${formId}_imageUriData">Project image</label>
            <div class="card w-100 mt-3">
                <img id="${formId}_image" class="card-img-top" alt="" src="">
                <div class="card-body">
                    <input type="hidden" name="imageUri" id="${formId}_imageUri"/>
                    <input class="form-control" type="file" name="imageUriData" id="${formId}_imageUriData"
                           placeholder="Project image">
                </div>
            </div>
        </div>

    </@formPopup>
</#macro>

<#macro coursePopup addPopup detailsPopup popupId formId uriBase>
    <script>
        function _applyCourseToForm(formId, project) {
            _applyJsonToForm(formId, project)
            const imageElem = document.getElementById(formId + "_image")
            const imageUri = document.getElementById(formId + "_imageUri")
            imageElem.src = imageUri.value
        }
    </script>
    <@formPopup addPopup=addPopup detailsPopup=detailsPopup popupId=popupId formId=formId uriBase=uriBase isMultiPartForm=true applyMethod="_applyCourseToForm">
        <input type="hidden" name="id" id="${formId}_id"/>
        <div class="form-floating">
            <input class="form-control" required type="text" name="name" id="${formId}_name"
                   placeholder="Name">
            <label class="form-label text-muted" for="${formId}_name">Name</label>
        </div>
        <div class="form-floating mt-3 fix-floating-label">
            <textarea class="form-control" name="description" id="${formId}_description"
                      placeholder="Description"></textarea>
            <label class="form-label text-muted" for="${formId}_description">Description</label>
        </div>
        <div class="form-floating mt-3 fix-floating-label">
            <textarea class="form-control" name="studentComment" id="${formId}_studentComment"
                      placeholder="Comment"></textarea>
            <label class="form-label text-muted" for="${formId}_studentComment">Comment</label>
        </div>
        <div class="form-floating mt-3">
            <input class="form-control" type="text" name="url" id="${formId}_url"
                   placeholder="Link">
            <label class="form-label text-muted" for="${formId}_url">Link</label>
        </div>
        <div class="mt-3">
            <label class="form-label text-muted" for="${formId}_imageUriData">Course image</label>
            <div class="card w-100 mt-3">
                <img id="${formId}_image" class="card-img-top" alt="" src="">
                <div class="card-body">
                    <input type="hidden" name="imageUri" id="${formId}_imageUri"/>
                    <input class="form-control" type="file" name="imageUriData" id="${formId}_imageUriData"
                           placeholder="Course image"/>
                </div>
            </div>
        </div>
    </@formPopup>
</#macro>

<#macro formPopup addPopup detailsPopup popupId formId uriBase isMultiPartForm=false applyMethod="_applyJsonToForm">
    <div class="modal fade" id="${popupId?no_esc}" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"></h5>
                </div>
                <div class="modal-body">
                    <form id="${formId}" action="" method="post"
                          <#if isMultiPartForm>enctype="multipart/form-data"</#if>>
                        <@default.csrfInput/>
                        <#nested/>
                    </form>
                </div>
                <div class="modal-footer justify-content-between">
                    <div>
                        <button id="${detailsPopup.deleteButtonId}" class="btn btn-outline-danger">Delete</button>
                    </div>
                    <div>
                        <button class="btn btn-outline-primary" data-bs-dismiss="modal">Cancel</button>
                        <input class="btn btn-primary" type="submit" value="Save" form="${formId}"/>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        (() => {
            const uriBase = "${uriBase}"
            const applyMethod = (${applyMethod});
            const formId = "${formId?no_esc}"
            const formElement = document.getElementById(formId)
            const modalElement = document.getElementById("${popupId?no_esc}")
            const modal = new bootstrap.Modal(modalElement)
            const detailsPopup = {
                elementSelector: "${detailsPopup.elementSelector?no_esc}",
                deleteButton: document.getElementById("${detailsPopup.deleteButtonId?no_esc}"),
                popupTitle: "${detailsPopup.popupTitle?no_esc}",
            }
            const addPopup = {
                addButton: document.getElementById("${addPopup.buttonId?no_esc}"),
                popupTitle: "${addPopup.popupTitle?no_esc}",
            }
            <#noparse>
            // set up details popup
            document.querySelectorAll(detailsPopup.elementSelector).forEach(element => {
                element.addEventListener("click", async () => {
                    // get the data id from the element
                    let elementId = element.getAttribute("data-id")
                    // fetch its info
                    let response = await fetch(`${uriBase}/${elementId}`)
                    if (!response.ok)
                        return
                    // apply it onto the form
                    applyMethod(formId, await response.json())
                    // set the popup title
                    modalElement.querySelector(".modal-title").textContent = detailsPopup.popupTitle
                    // show the delete button
                    detailsPopup.deleteButton.classList.remove("visually-hidden")
                    // set the form action
                    formElement.setAttribute("action", `${uriBase}/update`)
                    modal.show(element)
                })
            })
            // set up delete button
            detailsPopup.deleteButton.addEventListener("click", async () => {
                // get the data id from the input
                let currentId = document.getElementById(`${formId}_id`).value
                // execute DELETE request
                fetch(`${uriBase}/${currentId}`, {method: "DELETE"})
                    .then(async response => {
                        if (response.ok) {
                            // hide the popup
                            modal.hide()
                            // refresh the page
                            location.reload()
                        } else {
                            // display an error toast
                            let toastEl = document.getElementById('notification');
                            toastEl.querySelector(".toast-body").textContent = "An error has occurred"
                            toastEl.classList.add("bg-danger")
                            bootstrap.Toast.getOrCreateInstance(toastEl, {delay: 2000}).show();
                        }
                    });
            })
            // set up 'add new' popup
            addPopup.addButton.addEventListener("click", () => {
                // clear the form
                _clearForm(formElement)
                // set the popup title
                modalElement.querySelector(".modal-title").textContent = addPopup.popupTitle
                // hide the delete button
                detailsPopup.deleteButton.classList.add("visually-hidden")
                // set the form action
                formElement.setAttribute("action", `${uriBase}/add`)
                modal.show(null)
            })
            </#noparse>
        })();
    </script>

</#macro>