<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />

<#macro settingsPopup options>
    <div class="modal fade" id="settingsPopup" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered user-select-none">
            <div class="modal-content">
                <div class="pb-3 modal-header">
                    <span>Settings</span>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="pt-0 card-body">
                    <div class="mb-1">Privacy settings</div>
                    <form class="w-100 pt-0 card-body" action="<@spring.url "/profile/privacy"/>" id="privacyForm">
                        <div class="d-inline-flex justify-content-center align-items-center">
                            <@default.csrfInput/>
                            <input type="hidden" name="uuid" id="privacyForm_uuid">
                            <div class="w-50 w-sm-auto form-check form-switch me-3 user-select-none">
                                <input class="form-check-input form-submitter" type="checkbox" role="switch"
                                       name="public" id="privacyForm_isPublic">
                                <label class="form-check-label text-muted w-mxc" for="privacyForm_isPublic">Public
                                    profile</label>
                            </div>
                            <div class="w-auto input-group">
                                <input class="form-control form-control-sm" readonly
                                       id="privacyForm_publicUri" aria-label="Public URL"
                                       placeholder="Public URL">
                                <button type="button" id="privacyForm_publicUriCopyBtn"
                                        class="btn btn-primary copy-button">
                                    <@default.icon name="mdi:clipboard-text-outline"/>
                                </button>
                            </div>
                        </div>
                        <div class="mt-2 d-inline-flex align-items-center">
                            <div class="w-100 form-check form-switch me-3 user-select-none">
                                <input class="form-check-input form-submitter" type="checkbox" role="switch"
                                       name="includeInSearch" id="privacyForm_includeInSearch">
                                <label class="form-check-label text-muted" for="privacyForm_includeInSearch">Include in
                                    search</label>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <script>
        (() => {
            const options = {
                formId: "privacyForm",
                modalElement: document.getElementById("settingsPopup"),
                elementSelector: "${options.elementSelector?no_esc}",
                uuidInput: document.getElementById("privacyForm_uuid"),
                publicUrlInput: document.getElementById("privacyForm_publicUri"),
                publicUrlCopyBtn: document.getElementById("privacyForm_publicUriCopyBtn"),
                isPublicCheckbox: document.getElementById("privacyForm_isPublic"),
                includeInSearchCheckbox: document.getElementById("privacyForm_includeInSearch"),
            }
            options.modal = new bootstrap.Modal(options.modalElement)

            <#noparse>

            const formFetchSubmit = async function (formId, applyMethod, post = true) {
                const formElem = document.getElementById(formId),
                    formAction = formElem.action;
                if (post) {
                    // Enable disabled inputs
                    formElem.querySelectorAll("input[disabled]").forEach(elem => {
                        elem.removeAttribute("disabled");
                    })
                }
                const formData = new FormData(formElem);
                let response = await fetch(formAction, post ? {body: formData, method: "post"} : {})
                if (!response.ok)
                    return
                applyMethod(await response.json());
            };

            const privacyFormApply = (json) => {
                options.uuidInput.value = json["uuid"];
                options.isPublicCheckbox.checked = !!json["public"];
                options.includeInSearchCheckbox.checked = !!json["includeInSearch"];
                // set up public url input and copy button
                if (json["uuid"]) {
                    const url = window.location;
                    options.publicUrlInput.value = `${url.protocol}//${url.hostname}/profile/${json["uuid"]}`;
                    options.publicUrlCopyBtn.removeAttribute("disabled")
                    options.includeInSearchCheckbox.removeAttribute("disabled")
                } else {
                    options.publicUrlInput.value = "";
                    options.publicUrlCopyBtn.setAttribute("disabled", "true")
                    options.includeInSearchCheckbox.setAttribute("disabled", "true")
                }
            };

            document.querySelectorAll(options.elementSelector).forEach(element => {
                element.addEventListener("click", async () => {
                    await formFetchSubmit("privacyForm", privacyFormApply, false)
                    options.modal.show(element)
                })
            })

            options.modalElement.querySelectorAll("#privacyForm .form-submitter").forEach(elem => {
                elem.addEventListener("change", async () => {
                    await formFetchSubmit("privacyForm", privacyFormApply)
                })
            })

            options.modalElement.querySelectorAll(".input-group .copy-button").forEach(copyBtn => {
                const inputElem = copyBtn.parentElement.querySelector("input")
                copyBtn.addEventListener("click", async () => {
                    await navigator.clipboard.writeText(inputElem.value)
                    copyBtn.classList.add("btn-success")
                    copyBtn.blur()
                    await _sleep(600)
                    copyBtn.classList.remove("btn-success")
                })
            })
            </#noparse>
        })()
    </script>

</#macro>

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

<#macro experiencePopup addPopup detailsPopup popupId formId uriBase overviewPopupDetails>
    <#if overviewPopupDetails.enabled>
        <script>
            function _applyExperienceToModal(json) {
                const tooltips = [];
                _applyJsonToModal("${popupId}", json)
                document.querySelector("#${popupId} [data-prop='formattedEndDate']").textContent = json["formattedEndDate"] || "Present";
                // set startDate tooltip value
                document.querySelector("#${popupId} [data-prop-manual='startDate']").setAttribute("title", json["startDate"])
                const endDateElem = document.querySelector("#${popupId} [data-prop-manual='endDate']")
                // set endDate tooltip value
                if (json["endDate"])
                    endDateElem.setAttribute("title", json["endDate"])
                else
                    endDateElem.removeAttribute("title")
                // create a tooltip for elements with [data-bs-toggle='tooltip'][title]
                document.querySelectorAll("#${popupId} [data-bs-toggle='tooltip'][title]").forEach(element => tooltips.push(new bootstrap.Tooltip(element)))
                // destroy tooltips when hiding the popup
                document.querySelector("#${popupId}").addEventListener('hide.bs.modal', () => tooltips.forEach(tooltip => tooltip.dispose()), {once: true})
            }
        </script>
        <@overviewPopup popupId=popupId uriBase=uriBase overviewPopup=overviewPopupDetails applyMethod="_applyExperienceToModal">
            <div class="pt-0 card-body">
                <h5 data-prop="jobTitle"></h5>
                <h6 data-prop="companyName"></h6>
                <div class="text-muted">
                    <span data-prop="formattedStartDate" data-bs-toggle="tooltip" data-bs-placement="top"
                          title="" data-prop-manual="startDate"></span> -
                    <span data-prop="formattedEndDate" data-bs-toggle="tooltip" data-bs-placement="top"
                          title="" data-prop-manual="endDate"></span> ·
                    <span data-prop="duration"></span>
                </div>
                <p class="mt-2 preserve-lines" data-prop="description"></p>
            </div>
        </@overviewPopup>
    <#else >
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
    </#if>
</#macro>

<#macro activityPopup addPopup detailsPopup popupId formId uriBase>
    <script>
        function _applyActivityToForm(formId, activity) {
            _applyJsonToForm(formId, activity)
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

<#macro projectPopup addPopup detailsPopup popupId formId uriBase overviewPopupDetails>
    <#if overviewPopupDetails.enabled>
        <script>
            function _applyProjectToModal(json) {
                const tooltips = [];
                _applyJsonToModal("${popupId}", json)
                document.querySelector("#${popupId} [data-prop='formattedEndDate']").textContent = json["formattedEndDate"] || "Present"
                document.querySelector("#${popupId} [data-prop-manual='imageUri']").src = json["imageUri"]
                document.querySelector("#${popupId} [data-prop-manual='url']").href = json["url"]
                // set startDate tooltip value
                document.querySelector("#${popupId} [data-prop-manual='startDate']").setAttribute("title", json["startDate"])
                const endDateElem = document.querySelector("#${popupId} [data-prop-manual='endDate']")
                // set endDate tooltip value
                if (json["endDate"])
                    endDateElem.setAttribute("title", json["endDate"])
                else
                    endDateElem.removeAttribute("title")
                // create a tooltip for elements with [data-bs-toggle='tooltip'][title]
                document.querySelectorAll("#${popupId} [data-bs-toggle='tooltip'][title]").forEach(element => tooltips.push(new bootstrap.Tooltip(element)))
                // destroy tooltips when hiding the popup
                document.querySelector("#${popupId}").addEventListener('hide.bs.modal', () => tooltips.forEach(tooltip => tooltip.dispose()), {once: true})
            }
        </script>
        <@overviewPopup popupId=popupId uriBase=uriBase overviewPopup=overviewPopupDetails applyMethod="_applyProjectToModal">
            <div class="pt-0 card-body">
                <div class="d-flex justify-content-around align-items-center flex-column flex-lg-row">
                    <div class="card w-100 me-0 mb-3 w-lg-50 me-lg-3 mb-lg-0">
                        <img class="card-img-top" data-prop-manual="imageUri" src="" alt="Project image">
                    </div>
                    <div class="w-100 w-lg-50">
                        <h5>
                            <a class="text-decoration-none link-dark" data-prop-manual="url" target="_blank" href="">
                                <span data-prop="name"></span><@default.externalLinkIcon/>
                            </a>
                        </h5>
                        <h6 class="text-muted" data-prop="category"></h6>
                        <div class="text-muted">
                            <span data-prop="formattedStartDate" data-bs-toggle="tooltip" data-bs-placement="top"
                                  title="" data-prop-manual="startDate"></span> -
                            <span data-prop="formattedEndDate" data-bs-toggle="tooltip" data-bs-placement="top" title=""
                                  data-prop-manual="endDate"></span> ·
                            <span data-prop="duration"></span>
                        </div>
                        <p class="mt-2" data-prop="description"></p>
                    </div>
                </div>
            </div>
        </@overviewPopup>
    <#else >
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
    </#if>
</#macro>

<#macro coursePopup addPopup detailsPopup popupId formId uriBase overviewPopupDetails>
    <#if overviewPopupDetails.enabled>
        <script>
            function _applyCourseToModal(json) {
                _assignDefaultValue({publisher: "Link"}, json)
                _applyJsonToModal("${popupId}", json)
                document.querySelector("#${popupId} [data-prop-manual='imageUri']").src = json["imageUri"]
                document.querySelector("#${popupId} [data-prop-manual='url']").href = json["url"]
            }
        </script>
        <@overviewPopup popupId=popupId uriBase=uriBase overviewPopup=overviewPopupDetails applyMethod="_applyCourseToModal">
            <div class="pt-0 card-body">
                <div class="d-flex justify-content-around align-items-center flex-column flex-lg-row">
                    <#-- below lg: width(100) me(0) mb(3) -->
                    <#-- lg and above: width(50) me(3) mb(0) -->
                    <div class="card w-100 me-0 mb-3 w-lg-50 me-lg-3 mb-lg-0">
                        <img class="card-img-top" data-prop-manual="imageUri" src="" alt="Course image">
                    </div>
                    <div class="w-100 w-lg-50">
                        <h5>
                            <span data-prop="name"></span>
                        </h5>
                        <h6 class="">
                            <a class="text-decoration-none link-dark" data-prop-manual="url" target="_blank" href="">
                                <span data-prop="publisher"></span><@default.externalLinkIcon/>
                            </a>
                        </h6>
                        <div data-group="description">
                            <div class="text-black">Course description</div>
                            <p class="mt-0 limit-lines-8" data-prop="description"></p>
                        </div>
                        <div data-group="studentComment">
                            <div class="text-black">Course reflection</div>
                            <p class="mt-0" data-prop="studentComment"></p>
                        </div>
                    </div>
                </div>
            </div>
        </@overviewPopup>
    <#else >
        <script>
            function _applyCourseToForm(formId, course) {
                _applyJsonToForm(formId, course)
                const imageElem = document.getElementById(formId + "_image")
                const imageUri = document.getElementById(formId + "_imageUri")
                imageElem.src = imageUri.value
            }
        </script>
        <@formPopup addPopup=addPopup detailsPopup=detailsPopup popupId=popupId formId=formId uriBase=uriBase isMultiPartForm=true imageInputId=["${formId}_imageUri", "${formId}_imageUriData"] applyMethod="_applyCourseToForm">
            <div id="courseParser" class="add-only">
                <div class="mx-2">
                    <div class="card-text mb-2">Autofill using the course's link</div>
                    <div class="input-group flex-nowrap">
                        <div class="flex-grow-1 form-floating">
                            <input class="form-control rounded-0 rounded-start" type="url"
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
            <div class="mx-2">
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
                    <label class="form-label text-muted" for="${formId}_studentComment">Reflection</label>
                </div>
                <div class="form-floating mt-3">
                    <input class="form-control" type="text" name="publisher" id="${formId}_publisher"
                           placeholder="Publisher">
                    <label class="form-label text-muted" for="${formId}_publisher">Publisher</label>
                </div>
                <div class="form-floating mt-3">
                    <input class="form-control" type="url" name="url" id="${formId}_url"
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
            </div>
        </@formPopup>
        <script src="/js/CourseParser.js"></script>
        <script>
            <#-- courseParser setup -->
            new CourseParser("courseParser", _applyCourseToForm.bind(null, "${formId}"));
        </script>
    </#if>
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

<#macro overviewPopup popupId uriBase applyMethod overviewPopup>
    <div class="modal fade" id="${popupId?no_esc}" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered user-select-none">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <#nested />
            </div>
        </div>
    </div>
    <script>
        (() => {
            const options = {
                uriBase: "${uriBase}",
                applyMethod: (${applyMethod}),
                modalElement: document.getElementById("${popupId?no_esc}"),
                overviewPopup: {
                    elementSelector: "${overviewPopup.elementSelector?no_esc}",
                }
            }
            options.modal = new bootstrap.Modal(options.modalElement)
            try {
                _setupPopup(options)
            } catch (e) {
                console.error(e)
            }
        })()

    </script>
</#macro>

<#macro formPopup popupId formId uriBase detailsPopup={} addPopup={} isMultiPartForm=false imageInputId=[] applyMethod="_applyJsonToForm" defaultValue={}>
    <div class="modal fade" id="${popupId?no_esc}" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="${formId}" action="" method="post"
                          <#if isMultiPartForm>enctype="multipart/form-data"</#if>>
                        <@default.csrfInput/>
                        <#nested/>
                    </form>
                </div>
                <div class="modal-footer <#if detailsPopup?has_content>justify-content-between</#if>">
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
            options.textAreas = document.querySelectorAll(`#${formId} textarea`)
            try {
                _setupPopup(options)
            } catch (e) {
                console.error(e)
            }
        })()
    </script>
</#macro>

<#macro script>
    <script>
        function _applyJsonToModal(modalId, json) {
            <#noparse>
            document.querySelectorAll(`#${modalId} [data-prop]`).forEach(element => {
                const propName = element.getAttribute("data-prop")
                element.textContent = json[propName] || "";
                let elementGroup = document.querySelector(`#${modalId} [data-group='${propName}']`)
                if (elementGroup)
                    elementGroup.classList[json[propName] ? "remove" : "add"]("d-none")
            })
            </#noparse>
        }

        function _setupPopup(options) {
            <#noparse>
            if (options.textAreas) {
                // set up auto expanding text areas
                options.textAreas.forEach(textArea => _setupAutoTextArea(textArea))
                // when the modal is fully shown
                options.modalElement.addEventListener("shown.bs.modal", () => options.textAreas.forEach(async textArea => {
                    // add height transition
                    textArea.classList.add("height-transition")
                    // update text area height
                    _updateAutoTextArea(textArea)
                    // wait for transition to end
                    await _sleep(200)
                    // remove height transition
                    textArea.classList.remove("height-transition")
                }))
                // when the modal is fully hidden -> reset the text area's height
                options.modalElement.addEventListener("hidden.bs.modal", () => options.textAreas.forEach(textArea => textArea.style.height = '3.5rem'))
            }
            // set up details popup
            if (options.detailsPopup) {
                document.querySelectorAll(options.detailsPopup.elementSelector).forEach(element => {
                    element.addEventListener("click", async () => {
                        // hide add-only elements
                        options.formElement.querySelectorAll(".add-only").forEach(e => e.classList.add("d-none"));
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
                    // show add-only elements
                    options.formElement.querySelectorAll(".add-only").forEach(e => e.classList.remove("d-none"));
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
            // setup form's image previews
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
            if (options.formElement) {
                // setup form validation event listeners
                options.formElement.querySelectorAll("input,select,textarea").forEach(elem => {
                    elem.addEventListener("invalid", () => {
                        elem.classList.add("is-invalid");
                        _animateCSS(elem, "headShake");
                        elem.addEventListener("input", () => elem.classList.remove("is-invalid"), {once: true});
                    })
                });
                options.modalElement.addEventListener('hide.bs.modal', () => {
                    options.formElement.querySelectorAll("input,select,textarea").forEach(elem => elem.classList.remove("is-invalid"))
                });
            }
            // setup overview popup
            if (options.overviewPopup) {
                document.querySelectorAll(options.overviewPopup.elementSelector).forEach(element => {
                    element.addEventListener("click", async () => {
                        // get the data id from the element
                        let elementId = element.getAttribute("data-id")
                        // fetch its info
                        let response = await fetch(`${options.uriBase}/${elementId}`)
                        if (!response.ok)
                            return
                        options.applyMethod(await response.json())
                        options.modal.show(element)
                    })
                })
            }
            </#noparse>
        }
    </script>
</#macro>