<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#global roles = {"student" : "ROLE_STUDENT", "admin": "ROLE_ADMIN"}/>

<#macro head title>
    <head>
        <meta charset="UTF-8">
        <title>${title}</title>

        <link rel="icon" type="image/svg+xml" href="<@spring.url "/images/favicon.svg"/>">
        <link rel="icon" type="image/png" href="<@spring.url "/images/favicon.png"/>">
        <link rel="manifest" href="<@spring.url "/js/site.webmanifest"/>">

        <link rel="stylesheet" href="<@spring.url "/webjars/bootswatch/dist/zephyr/bootstrap.min.css"/>"/>
        <link rel="stylesheet" href="<@spring.url "/css/styles.css"/>"/>
        <#nested/>
    </head>
</#macro>

<#macro scripts>
    <script src="<@spring.url "/webjars/bootstrap/js/bootstrap.bundle.min.js"/>"></script>
    <#nested >
</#macro>

<#macro logo width height color>
    <svg style="width:${width};height:${height};color: ${color};" viewBox="0 0 24 24">
        <path fill="currentColor"
              d="M12,3L1,9L12,15L21,10.09V17H23V9M5,13.18V17.18L12,21L19,17.18V13.18L12,17L5,13.18Z"/>
    </svg>
</#macro>

<#macro navbar home="" about="" login="" profile="" dashboard="" account="">
    <nav class="navbar navbar-expand-md navbar-light bg-light">
        <div class="container-fluid">
            <a class="navbar-brand" href="<@spring.url relativeUrl="/"/>">
                <@logo width="30px" height="30px" color="#393939"/>
                STAs
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                    data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                    aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <#-- General links -->
                    <li class="nav-item">
                        <a class="nav-link ${home}" href="<@spring.url relativeUrl="/"/>">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${about}" href="<@spring.url relativeUrl="/about"/>">About</a>
                    </li>
                    <#-- STUDENT-only links -->
                    <@requiredRole roles.student>
                        <li class="nav-item">
                            <a class="nav-link ${profile}" href="<@spring.url relativeUrl="/profile"/>">Profile</a>
                        </li>
                    </@requiredRole>
                    <#-- ADMIN-only links -->
                    <@requiredRole roles.admin>
                        <li class="nav-item">
                            <a class="nav-link ${dashboard}"
                               href="<@spring.url relativeUrl="/dashboard"/>">Dashboard</a>
                        </li>
                    </@requiredRole>
                </ul>
                <#-- Login/Logout links -->
                <div class="d-flex">
                    <ul class="navbar-nav me-2 mb-2 mb-lg-0 w-100">
                        <#-- if the user is authenticated -->
                        <#if SPRING_SECURITY_CONTEXT??>
                            <li class="nav-item"> <#-- user's fName lName -->
                                <#local user = SPRING_SECURITY_CONTEXT.authentication.getPrincipal()/>
                                <a class="nav-link ${account}" href="<@spring.url relativeUrl="/account"/>">
                                    ${user.getFirstName()} ${user.getLastName()}
                                </a>
                            </li>
                            <li class="nav-item"> <#-- logout button -->
                                <form action="/logout" method="post" class="d-inline">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <input type="submit" class="btn btn-link nav-link border-0" value="Logout">
                                </form>
                            </li>
                        <#else>
                            <li class="nav-item">
                                <a class="nav-link ${login}" href="<@spring.url relativeUrl="/login"/>">Login</a>
                            </li>
                        </#if>
                    </ul>
                </div>
            </div>
        </div>
    </nav>
</#macro>

<#macro toast>
    <div class="toast align-items-center text-white bg-primary border-0 position-absolute top-0 end-0 mt-5 me-4"
         id="notification" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body">
                ${(.data_model.toast)!""}
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"
                    aria-label="Close"></button>
        </div>
    </div>
    <script>
        let state = ${(.data_model.toast??)?then("true", "false")};
        if (state) {
            document.addEventListener("DOMContentLoaded", function () {
                let toastEl = document.getElementById('notification');
                new bootstrap.Toast(toastEl, {delay: 1500}).show();
            });
        }
    </script>
</#macro>

<#macro requiredRole Role>
    <#assign authorized = false>
    <#if SPRING_SECURITY_CONTEXT??>
        <#list SPRING_SECURITY_CONTEXT.authentication.authorities as authority>
            <#if authority == Role>
                <#assign authorized = true>
            </#if>
        </#list>
    </#if>
    <#if authorized>
        <#nested>
    </#if>
</#macro>

<#macro requiresAnyRole Roles>
    <#assign authorized = false>
    <#if SPRING_SECURITY_CONTEXT??>
        <#list SPRING_SECURITY_CONTEXT.authentication.authorities as authority>
            <#list Roles as role>
                <#if authority == role>
                    <#assign authorized = true>
                    <#break/>
                </#if>
            </#list>
        </#list>
    </#if>
    <#if authorized>
        <#nested>
    </#if>
</#macro>

