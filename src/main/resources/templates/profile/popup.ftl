<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />

<#macro linkPopup addPopup popupId formId uriBase>
    <@formPopup addPopup=addPopup popupId=popupId formId=formId uriBase=uriBase>
        <div class="form-floating">
            <input class="form-control" required type="text" name="linkName" id="${formId}_linkName"
                   placeholder="Name">
            <label class="form-label text-muted" for="${formId}_linkName">Name</label>
        </div>
        <div class="form-floating mt-3">
            <input class="form-control" required type="url" name="linkUrl" id="${formId}_linkUrl"
                   placeholder="Link">
            <label class="form-label text-muted" for="${formId}_linkUrl">Link</label>
        </div>
    </@formPopup>
</#macro>

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
    <@formPopup addPopup=addPopup detailsPopup=detailsPopup popupId=popupId formId=formId uriBase=uriBase isMultiPartForm=true imageInputId=["${formId}_imageUri", "${formId}_imageUriData"] applyMethod="_applyActivityToForm">
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
                    <input class="form-control" type="file" accept="image/*" name="imageUriData"
                           id="${formId}_imageUriData"
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
    <@formPopup addPopup=addPopup detailsPopup=detailsPopup popupId=popupId formId=formId uriBase=uriBase isMultiPartForm=true imageInputId=["${formId}_imageUri", "${formId}_imageUriData"] applyMethod="_applyProjectToForm">
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
                    <input class="form-control" type="file" accept="image/*" name="imageUriData"
                           id="${formId}_imageUriData"
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
    <@formPopup addPopup=addPopup detailsPopup=detailsPopup popupId=popupId formId=formId uriBase=uriBase isMultiPartForm=true imageInputId=["${formId}_imageUri", "${formId}_imageUriData"] applyMethod="_applyCourseToForm">
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
                    <input class="form-control" type="file" accept="image/*" name="imageUriData"
                           id="${formId}_imageUriData"
                           placeholder="Course image"/>
                </div>
            </div>
        </div>
    </@formPopup>
</#macro>

<#macro picturePopup detailsPopup popupId formId uriBase defaultValue>
    <script>
        function _applyPictureToForm(formId, project) {
            _applyJsonToForm(formId, project)
            const imageElem = document.getElementById(formId + "_image")
            const imageUri = document.getElementById(formId + "_imageUri")
            imageElem.src = imageUri.value
        }
    </script>
    <@formPopup detailsPopup=detailsPopup popupId=popupId formId=formId uriBase=uriBase isMultiPartForm=true imageInputId=["${formId}_imageUri", "${formId}_imageUriData"] applyMethod="_applyCourseToForm" defaultValue=defaultValue>
        <div class="mt-3">
            <div class="card w-100 mt-3">
                <img id="${formId}_image" class="card-img-top" alt="" src="">
                <div class="card-body">
                    <input type="hidden" name="imageUri" id="${formId}_imageUri"/>
                    <input class="form-control" type="file" accept="image/*" name="imageUriData"
                           id="${formId}_imageUriData" placeholder="Profile picture">
                </div>
            </div>
        </div>
    </@formPopup>
</#macro>

<#macro formPopup popupId formId uriBase detailsPopup={} addPopup={} isMultiPartForm=false imageInputId=[] applyMethod="_applyJsonToForm" defaultValue={}>
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
                    <#if detailsPopup?has_content>
                        <div>
                            <button id="${detailsPopup.deleteButtonId}" class="btn btn-outline-danger">Delete</button>
                        </div>
                    </#if>
                    <div>
                        <input class="btn btn-primary" type="submit" value="Save" form="${formId}"/>
                        <button class="btn btn-outline-primary" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        (() => {
            const options = {
                uriBase: "${uriBase}",
                applyMethod: (${applyMethod}),
                formId: "${formId?no_esc}",
                modalElement: document.getElementById("${popupId?no_esc}"),
                <#if detailsPopup?has_content>
                detailsPopup: {
                    elementSelector: "${detailsPopup.elementSelector?no_esc}",
                    deleteButton: document.getElementById("${detailsPopup.deleteButtonId?no_esc}"),
                    popupTitle: "${detailsPopup.popupTitle?no_esc}",
                },
                </#if>
                <#if addPopup?has_content>
                addPopup: {
                    addButton: document.getElementById("${addPopup.buttonId?no_esc}"),
                    popupTitle: "${addPopup.popupTitle?no_esc}",
                },
                </#if>
                <#list defaultValue >
                defaultValue: {
                    <#items as prop ,val>
                    "${prop}": "${val}",
                    </#items>
                },
                </#list>
                imageInputSelector: "<#list imageInputId as id>#${id}<#sep>,</#list>",
            }
            options.formElement = document.getElementById(options.formId)
            options.modal = new bootstrap.Modal(options.modalElement)
            _setupPopup(options)
        })()
    </script>
</#macro>

<#macro script>
    <script>
        function _setupPopup(options) {
            <#noparse>
            // set up details popup
            if (options.detailsPopup) {
                document.querySelectorAll(options.detailsPopup.elementSelector).forEach(element => {
                    element.addEventListener("click", async () => {
                        // clear the form
                        _clearForm(options.formElement)
                        // get the data id from the element
                        let elementId = element.getAttribute("data-id")
                        if (!options.defaultValue) {
                            // fetch its info
                            let response = await fetch(`${options.uriBase}/${elementId}`)
                            if (!response.ok)
                                return
                            // apply it onto the form
                            options.applyMethod(options.formId, await response.json())
                            // set the form action
                            options.formElement.setAttribute("action", `${options.uriBase}/${elementId}`)
                        } else {
                            options.applyMethod(options.formId, options.defaultValue)
                            options.formElement.setAttribute("action", options.uriBase)
                        }
                        // set the popup title
                        options.modalElement.querySelector(".modal-title").textContent = options.detailsPopup.popupTitle
                        // show the delete button
                        options.detailsPopup.deleteButton.classList.remove("visually-hidden")
                        options.modal.show(element)
                    })
                })
                // set up delete button
                options.detailsPopup.deleteButton.addEventListener("click", async () => {
                    // set the form action to './delete'
                    options.formElement.setAttribute("action", `${options.uriBase}/delete`)
                    // submit the form and hide the popup
                    options.formElement.submit()
                    options.modal.hide()
                })
            }
            // set up 'add new' popup
            if (options.addPopup) {
                options.addPopup.addButton.addEventListener("click", () => {
                    // clear the form
                    _clearForm(options.formElement)
                    // set the popup title
                    options.modalElement.querySelector(".modal-title").textContent = options.addPopup.popupTitle
                    // hide the delete button
                    options.detailsPopup?.deleteButton.classList.add("visually-hidden")
                    // set the form action
                    options.formElement.setAttribute("action", `${options.uriBase}`)
                    options.modal.show(null)
                })
            }
            if (options.imageInputSelector) {
                document.querySelectorAll(options.imageInputSelector).forEach(input => {
                    input.addEventListener("change", event => {
                        let imageElement = document.getElementById(options.formId + "_image")
                        if (event.target.files) {
                            let imageData = URL.createObjectURL(event.target.files[0])
                            imageElement.src = imageData
                            options.modalElement.addEventListener('hidden.bs.modal', () => URL.revokeObjectURL(imageData), {once: true})
                        } else {
                            imageElement.src = event.target.value
                        }
                    })
                })
            }
            </#noparse>
        }
    </script>
</#macro>