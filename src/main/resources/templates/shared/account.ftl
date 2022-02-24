<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />

<#macro sidebar accountDetails="" accountSecurity="">
    <div class="mb-2">
        <span class="fs-4">My Account</span>
        <hr/>
        <div class="list-group ">
            <a class="text-decoration-none list-group-item list-group-item-action ${accountDetails}"
               href="<@spring.url "/account"/>">
                Account information
            </a>
            <a class="text-decoration-none list-group-item list-group-item-action ${accountSecurity}"
               href="<@spring.url "/account/security"/>">
                Account security
            </a>
        </div>
    </div>
</#macro>

<#macro formElement path label type="text" attrb="" placeholder="">
    <@spring.bind path="${path}"/>
    <input class="form-control <#if spring.status.error>is-invalid</#if>" type="${type}"
           name="${spring.status.expression}" id="${spring.status.expression}"
           value="${spring.status.value}" placeholder="${placeholder}" ${attrb?no_esc}>
    <label class="form-label" for="${spring.status.expression}">${label}</label>
    <span class="invalid-feedback">${spring.status.errorMessage}</span>
</#macro>
