<#import "../../../shared/default.ftl" as default/>
<#import "../shared.ftl" as shared/>

<#macro card>
    <div class="card rounded-3 user-select-none w-100">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
                <h6 class="card-title mb-1">Write a short bio</h6>
                <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" role="switch" id="aboutPreview">
                    <label class="form-check-label" for="aboutPreview">Preview</label>
                </div>
            </div>
            <div class="md-edit">
                <div class="form-floating mt-3 fix-floating-label">
                <textarea class="form-control" data-profile-prop="about" id="about"
                          maxlength="5000" placeholder="About me"></textarea>
                    <label class="form-label text-muted" for="about">About me</label>
                </div>
                <div class="clearfix">
                    <div class="float-start">
                        <@default.mdDisclaimer/>
                    </div>
                    <div class="float-end text-muted user-select-none" id="aboutCharCount">0/5000</div>
                </div>
            </div>
            <div class="card card-border-grey p-3 pb-1 mt-3 d-none md-content" style="min-height: 4rem"></div>
            <div class="mt-4 clearfix">
                <@shared.backBtn/>
                <@shared.nextBtn/>
            </div>
        </div>
    </div>
</#macro>

<#macro script>
    <script src="/webjars/dompurify/dist/purify.min.js"></script>
    <script src="/webjars/marked/marked.min.js"></script>
    <script>
        <#noparse>
        (() => {
            const aboutElem = document.querySelector("#about");
            const aboutCharCount = document.querySelector("#aboutCharCount");

            document.addEventListener("DOMContentLoaded", () => {
                _setupAutoTextArea(aboutElem);
                aboutElem.addEventListener("input", () => {
                    _updateAutoTextArea(aboutElem);
                    aboutCharCount.textContent = `${aboutElem.value.length}/5000`;
                });
            });
            document.querySelector("#aboutPreview").addEventListener("change", (e) => {
                const isChecked = e.target.checked;
                const mdEdit = document.querySelector(".md-edit");
                const mdContent = document.querySelector(".md-content");
                const aboutTextArea = mdEdit.querySelector("textarea[data-profile-prop='about']");
                if (isChecked) {
                    mdEdit.classList.add("d-none");
                    mdContent.innerHTML = DOMPurify.sanitize(marked.parse(aboutTextArea.value.trim()));
                    mdContent.classList.remove("d-none");
                } else {
                    mdEdit.classList.remove("d-none");
                    mdContent.classList.add("d-none");
                }
            });
        })()
        </#noparse>
    </script>
</#macro>