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

<#macro formElement path label bindValue=true type="text" attrb="" placeholder="">
    <@spring.bind path="${path}"/>
    <input class="form-control <#if spring.status.error>is-invalid</#if>" type="${type}"
           name="${spring.status.expression}" id="${spring.status.expression}" ${attrb?no_esc}
           placeholder="${placeholder}" value="${bindValue?then(spring.status.value,"")}">
    <label class="form-label" for="${spring.status.expression}">${label}</label>
    <span class="invalid-feedback">
        <#list (spring.status.errorMessage)?split("-") as error>
            ${error}<#sep><br/></#sep>
        </#list>
    </span>
</#macro>

<#macro confirmPasswordScript passwordId confirmPasswordId confirmPasswordFeedbackId>
    <script>
        const passwordElem = document.getElementById("${passwordId}"),
            confirmPasswordElem = document.getElementById("${confirmPasswordId}"),
            confirmPasswordFeedbackElem = document.getElementById("${confirmPasswordFeedbackId}");
        confirmPasswordElem.addEventListener('input', validatePassword);

        function validatePassword() {

            if (passwordElem.value !== confirmPasswordElem.value) {
                confirmPasswordElem.setCustomValidity("Passwords don't match");
                confirmPasswordFeedbackElem.innerText = "Passwords don't match";
                confirmPasswordElem.classList.add("is-invalid");
                return false;
            } else {
                confirmPasswordElem.setCustomValidity("");
                confirmPasswordFeedbackElem.innerText = "";
                confirmPasswordElem.classList.remove("is-invalid");
                return true;
            }
        }
    </script>
</#macro>