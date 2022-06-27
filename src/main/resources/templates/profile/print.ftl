<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${profile.name} - STAs</title>
    <link rel="icon" type="image/svg+xml" href="<@spring.url "/images/favicon.svg"/>">

    <link rel="preload stylesheet" as="style" media="all" href="<@spring.url "/css/styles.css"/>">
    <link rel="preload stylesheet" as="style" media="all"
          href="<@spring.url "/webjars/bootswatch/dist/zephyr/bootstrap.min.css"/>"/>

    <script src="<@spring.url "/webjars/iconify__iconify/dist/iconify.min.js"/>"></script>

    <style>
        @media all {
            @page {
                margin: 0.5cm;
            }

            *:not(a) {
                print-color-adjust: exact !important;
                -webkit-print-color-adjust: exact !important;
            }

            .card {
                background-color: white !important;
                border: 1px solid #CED4DA !important;
                box-shadow: none !important;
            }

            .timeline {
                padding-left: 0;
            }

            .timeline .timeline-date {
                position: relative !important;
                display: block;
                left: 0 !important;
                margin-bottom: 0;
            }

            .link-grey {
                color: rgb(73, 80, 87) !important;
            }

            .link-grey:hover {
                color: rgb(108, 117, 125) !important;
            }
        }
    </style>
</head>

<body class="bg-white min-vh-100">
<div id="loadingSpinner" class="w-100 min-h-100 d-flex justify-content-center align-items-center">
    <div class="spinner-border text-muted me-2" role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
    Generating PDF...
</div>
<div id="profile" class="container-xl mb-3">
    <div class="w-100 d-flex flex-column justify-content-between ">

        <#-- Profile info -->
        <div class="card rounded-2 px-2 py-3 mb-3" style="border: none !important;">

            <div class="d-flex justify-content-center">

                <div class="d-flex justify-content-between align-items-center">
                    <#if profile.imageUri?has_content>
                        <div class="d-flex justify-content-center p-3 pt-1">
                            <div class="img-w-100 rounded-circle object-fit-cover">
                                <img class="img-w-100 rounded-circle object-fit-cover" src="${profile.imageUri}"
                                     alt="Profile picture"/>
                            </div>
                        </div>
                    </#if>

                    <div class="text-center mx-3">
                        <div class="fs-3" data-prop="name">${profile.name}</div>
                    </div>
                </div>

                <div class="vr mx-3"></div>

                <div>
                    <div class="px-3">
                        <@profileViewItem text=profile.major!"" name="major" icon="university"/>
                        <@profileViewItem text=profile.university!"" name="university" icon="university-alt"/>
                        <@profileViewItem text=profile.location!"" name="location" icon="location"/>
                        <@profileViewItem text=profile.contactEmail!"" name="contactEmail" icon="email" link="mailto:${profile.contactEmail}"/>
                        <@profileViewItem text=profile.contactPhone!"" name="contactPhone" icon="phone" link="tel:${profile.contactPhone}"/>
                        <div class="profile-view-links">
                            <#list profile.links as linkName, linkUrl>
                                <@profileViewItem text=linkUrl name="link_${linkName}" icon=linkName?lower_case link=linkUrl showLinkIcon=true includeUrl=true/>
                            </#list>
                        </div>
                    </div>
                </div>

            </div>

        </div>

        <#-- About card -->
        <#if profile.about?has_content>
            <div id="profileAbout" class="w-100 mb-3">
                <@profileCard>
                    <h5 class="card-title mb-2"><@default.icon name="personInfo" class="me-2"/>About me</h5>
                    <div class="md-content card-text" id="aboutContent">
                    </div>
                </@profileCard>
            </div>
        </#if>

        <#-- Experience card -->
        <#if profile.experiences?has_content>
            <div id="profileExperience" class="mb-3">
                <@profileCard>
                    <h5 class="card-title mb-2"><@default.icon name="work" class="me-2"/>Experience</h5>
                    <#list profile.experiences>
                        <ul class="ms-2 mb-0 list-unstyled timeline">
                            <#items as experience>
                                <li class="timeline-item"
                                    data-id="${experience.id}">
                                    <div class="pt-1 mb-1 card-title fs-115">${experience.jobTitle}</div>
                                    <p class="text-muted mb-1">${experience.companyName}</p>
                                    <span class="text-muted timeline-date">${experience.formattedStartDate} - ${(experience.formattedEndDate)!"Present"} · ${experience.duration}</span>
                                    <#if experience.description??>
                                        <p class="text-muted mt-2 preserve-lines">${experience.description}</p>
                                    </#if>
                                </li>
                            </#items>
                        </ul>
                    </#list>
                </@profileCard>
            </div>
        </#if>

        <#-- Skills card -->
        <#if profile.skills?has_content>
            <div id="skillsCard" class="mb-3">
                <@profileCard>
                    <h5 class="card-title mb-2"><@default.icon name="mdi:tools" class="me-2"/>Skills</h5>
                    <#list profile.skills as skill>
                        <div class="skill rounded-2 p-2 w-100">
                            <#-- Skill text -->
                            <div class="mb-1 d-flex justify-content-between text-muted">
                                <span>${skill.name}</span>
                                <span>${skill.level}%</span>
                            </div>
                            <#-- Skill level -->
                            <div class="progress" style="height: 10px;">
                                <div class="progress-bar bg-dark bg-opacity-75" role="progressbar"
                                     style="width: ${skill.level}%;"
                                     aria-valuenow="${skill.level}"
                                     aria-valuemin="0" aria-valuemax="100">
                                </div>
                            </div>
                        </div>
                    </#list>
                </@profileCard>
            </div>
        </#if>

        <#-- Courses card -->
        <#if profile.courses?has_content>
            <div id="profileCourses" class="mb-3">
                <@profileCard>
                    <h5 class="card-title mb-2"><@default.icon name="course" class="me-2"/>Courses</h5>
                    <div>
                        <#list profile.courses as course >
                            <#assign courseDescription = default.firstNonEmptyOrDefault("",course.studentComment,course.description) />
                            <@profileCard title=course.name text=courseDescription link=course.url limitLines=false preserveLines=true
                            class="w-100 rounded-0 ${course?is_first?then('rounded-top','')} ${course?is_last?then('rounded-bottom','border-bottom-0')}"/>
                        </#list>
                    </div>
                </@profileCard>
            </div>
        </#if>

        <#-- Projects card -->
        <#if profile.projects?has_content>
            <div id="profileProjects" class="mb-3">
                <@profileCard>
                    <h5 class="card-title mb-2"><@default.icon name="project" class="me-2"/>Projects</h5>
                    <div>
                        <#list profile.projects as project >
                            <@profileCard title=project.name text=project.description link=project.url limitLines=false preserveLines=true
                            class="w-100 rounded-0 ${project?is_first?then('rounded-top','')} ${project?is_last?then('rounded-bottom','border-bottom-0')}"/>
                        </#list>
                    </div>
                </@profileCard>
            </div>
        </#if>

        <#-- Activities card -->
        <#if profile.activities?has_content>
            <div id="profileActivities" class="mb-3">
                <@profileCard>
                    <h5 class="card-title mb-2"><@default.icon name="group" class="me-2"/>Activities</h5>
                    <div>
                        <#list profile.activities as activity >
                            <@profileCard title=activity.name text=activity.description link=activity.url limitLines=false preserveLines=true
                            class="w-100 rounded-0 ${activity?is_first?then('rounded-top','')} ${activity?is_last?then('rounded-bottom','border-bottom-0')}"/>
                        </#list>
                    </div>
                </@profileCard>
            </div>
        </#if>

    </div>
</div>
<#-- About card scripts -->
<#if profile.about?has_content>
    <script src="<@spring.url "/webjars/dompurify/dist/purify.min.js"/>"></script>
    <script src="<@spring.url "/webjars/marked/marked.min.js"/>"></script>
    <script>
        (() => {
            const contentContainer = document.querySelector("#aboutContent");
            const contentText = "${(profile.about!"")?js_string?no_esc}";
            contentContainer.innerHTML = DOMPurify.sanitize(marked.parse(contentText));
        })()
    </script>
</#if>
<script src="<@spring.url "/webjars/html2pdf.js/dist/html2pdf.bundle.min.js"/>"></script>
<script>
    window.addEventListener("load", () => {
        const loadingSpinner = document.querySelector("#loadingSpinner");
        const element = document.querySelector("#profile");
        const options = {
            margin: 5,
            filename: '${profile.name}.pdf',
            image: {type: 'png'},
            jsPDF: {compress: true, hotfixes: ["px_scaling"]},
            html2canvas: {
                width: 780,
                scale: 2,
                onclone: (element) => {
                    const svgElements = Array.from(element.querySelectorAll('svg'));
                    svgElements.forEach(s => {
                        const bBox = s.getBBox();
                        s.setAttribute("width", bBox.width + 20);
                        s.setAttribute("height", bBox.height + 20);
                    })
                }
            }
        };
        setTimeout(() =>
                html2pdf()
                    .set(options)
                    .from(element)
                    .to("pdf")
                    .save()
                    .then(() => loadingSpinner.classList.add("d-none"))
            , 500)
    });
</script>
</body>

</html>
<#macro profileCard title="" icon="" subtitle="" text="" link="" id="" class="" limitLines=true preserveLines=false>
    <#if link?has_content>
        <a href="${link}" target="_blank" class="link-grey text-hover-dark text-decoration-none">
    </#if>
    <div class="card card-border-grey w-100 h-100 user-select-none ${class?no_esc}"
         <#if id?has_content>data-id="${id}"</#if>>
        <div class="d-flex flex-column flex-sm-row align-content-between align-items-center w-100">
            <div class="card-body d-flex flex-column flex-grow-1 w-100">
                <#if title?has_content>
                    <h5 class="card-title user-select-none">
                        <#if icon?has_content><@default.icon name=icon class="me-2"/></#if>
                        ${title}<#if link?has_content><@default.externalLinkIcon/></#if>
                    </h5>
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
    <#if link?has_content>
        </a>
    </#if>
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
