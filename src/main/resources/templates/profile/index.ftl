<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />

<!DOCTYPE html>
<html lang="en">

<@default.head title="Profile - STAs">
    <style>
        .scrollable-box {
            max-height: 600px;
            overflow: auto;
        }
    </style>
</@default.head>

<body>
<@default.navbar profile="active"/>

<div class="container-fluid my-3">
    <div id="profile">
        <div class="row">
            <#-- Left column -->
            <div class="col-md-4 col-lg-3">
                <div id="profileInfo" class="card-border-grey rounded-2 p-2 mb-3">
                    <div class="text-center ms-3">
                        <div class="p-2">
                            <img class="figure-img img-w-100 rounded-circle" src="${profile.imagerUri}"
                                 alt="profile picture"/>
                        </div>
                        <div class="fs-4" id="profileName">${profile.name}</div>
                        <div class="fs-6 text-muted">${profile.major}</div>
                    </div>
                    <hr class="mx-4"/>
                    <div class="ps-3">
                        <@profileItem text=profile.location icon="mdi:map-marker"/>
                        <@profileItem text=profile.university icon="mdi:school"/>
                        <@profileItem text=profile.contactEmail icon="mdi:email" link="mailto:${profile.contactEmail}"/>
                        <@profileItem text=profile.contactPhone icon="mdi:phone" link="tel:${profile.contactPhone}"/>
                        <@profileItem text="SaifAqqad" icon="mdi:github" link="https://github.com/SaifAqqad" showLinkIcon=true/>
                        <@profileItem text="Saif Aqqad" icon="mdi:linkedin" link="https://github.com/SaifAqqad" showLinkIcon=true/>
                    </div>
                </div>
                <#-- TODO: Add skills card -->
            </div>

            <#-- Right column -->
            <div id="profileContent" class="col-md-8 col-lg-9">

                <div id="profileAbout" class="mb-3">
                    <@profileCard title="About me" text="${profile.about}"/>
                </div>

                <div id="profileCourses" class="mb-3">
                    <@profileCard>
                    <#-- Title -->
                        <div class="d-flex justify-content-between">
                            <h5 class="card-title">Courses</h5>
                            <button class="btn btn-outline-primary mb-2">Add</button>
                        </div>
                    <#-- Content -->
                        <div class="row row-cols-1 row-cols-lg-2">
                            <#list profile.courses as course >
                                <div class="col mb-3">
                                    <@profileCard title=course.name text=course.studentComment img=course.imageUri class="btn bg-hover"/>
                                </div>
                            <#else>
                                <div class="w-100 min-h-100 d-flex justify-content-center align-items-center">
                                    <span class="fs-6 text-muted">You haven't added any courses yet</span>
                                </div>
                            </#list>
                        </div>
                    </@profileCard>
                </div>

                <div id="profileProjects" class="mb-3">
                    <@profileCard>
                    <#-- Title -->
                        <div class="d-flex justify-content-between">
                            <h5 class="card-title">Projects</h5>
                            <button class="btn btn-outline-primary mb-2">Add</button>
                        </div>
                    <#-- Content -->
                        <div class="row row-cols-1 row-cols-lg-2">
                            <#list profile.projects as project>
                                <div class="col mb-3">
                                    <@profileCard title=project.name subtitle=project.category text=project.description img=project.imageUri class="btn bg-hover"/>
                                </div>
                            <#else>
                                <div class="w-100 min-h-100 d-flex justify-content-center align-items-center">
                                    <span class="fs-6 text-muted">You haven't added any projects yet</span>
                                </div>
                            </#list>
                        </div>
                    </@profileCard>
                </div>

                <div id="profileActivity" class="mb-3">
                    <@profileCard>
                    <#-- Title -->
                        <div class="d-flex justify-content-between">
                            <h5 class="card-title">Activities</h5>
                            <button class="btn btn-outline-primary mb-2">Add</button>
                        </div>
                    <#-- Content -->
                        <div class="scrollable-box">
                            <#list profile.activities as activity>
                                <@profileCard title=activity.name subtitle=activity.getFormattedDate() text=activity.description img=activity.imageUri img_alt=activity.name limitLines=false class="btn w-100 bg-hover"/>
                            <#else>
                                <div class="w-100 min-h-100 d-flex justify-content-center align-items-center">
                                    <span class="fs-6 text-muted">You haven't added any activities yet</span>
                                </div>
                            </#list>
                        </div>
                    </@profileCard>
                </div>
            </div>
        </div>
    </div>
</div>

<#macro profileCard title="" subtitle="" text="" img="" img_alt="" class="" limitLines=true >
    <div class="card card-border-grey w-100 h-100 ${class?no_esc}">
        <div class="d-flex align-content-between align-items-center w-100">
            <#if img?has_content>
                <div class="h-75">
                    <img src="${img}" class="w-100 h-100 rounded-1 img-w-limit object-fit" alt="${img_alt}">
                </div>
            </#if>
            <div class="card-body d-flex flex-column flex-grow-1">
                <#if title?has_content>
                    <h5 class="card-title">${title}</h5>
                </#if>
                <#if subtitle?has_content>
                    <h6 class="card-subtitle mb-2 text-muted">${subtitle}</h6>
                </#if>
                <#if text?has_content>
                    <p class="card-text <#if limitLines>limit-lines-4</#if>">${text}</p>
                </#if>
                <#nested />
            </div>
        </div>
    </div>
</#macro>

<#macro profileItem text icon="" link="" showLinkIcon=false>
    <div class="text-muted fs-6 text-truncate">
        <#if link?has_content>
            <a href="${link?no_esc}" class="text-decoration-none text-muted text-hover-dark">
                <span class="iconify-inline mx-1" data-icon="${icon}"></span>
                <span>${text}<#if showLinkIcon><@default.externalLinkIcon/></#if></span>
            </a>
        <#else>
            <span class="iconify-inline mx-1" data-icon="${icon}"></span>
            <span>${text}<#if showLinkIcon><@default.externalLinkIcon/></#if></span>
        </#if>
    </div>
</#macro>

<@default.scripts/>
</body>
</html>