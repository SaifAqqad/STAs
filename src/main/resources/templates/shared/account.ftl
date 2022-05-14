<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "./default.ftl" as default />

<#macro sidebar accountDetails="" accountSecurity="" accountConnections="">
    <div class="mb-2 user-select-none">
        <span class="fs-4"><@default.icon name="mdi:account-outline"/>
            My Account</span>
        <hr/>
        <div class="list-group mx-2 mx-md-0">
            <a class="text-decoration-none list-group-item list-group-item-action d-flex align-items-center ${accountDetails}"
               href="<@spring.url "/account"/>"><@default.icon name="accountEdit" width="24" class="me-2"/>
                Account information
            </a>
            <a class="text-decoration-none list-group-item list-group-item-action d-flex align-items-center ${accountSecurity}"
               href="<@spring.url "/account/security"/>"><@default.icon name="security" width="24" class="me-2"/>
                Account security
            </a>
            <a class="text-decoration-none list-group-item list-group-item-action d-flex align-items-center ${accountConnections}"
               href="<@spring.url "/account/connections"/>"><@default.icon name="connection" width="24" class="me-2"/>
                Connections
            </a>
        </div>
    </div>
</#macro>

<#macro formElement path label bindValue=true type="text" attrb="" placeholder="">
    <@spring.bind path="${path}"/>
    <input class="form-control <#if spring.status.error>is-invalid</#if>" type="${type}"
           name="${spring.status.expression}" id="${spring.status.expression}" ${attrb?no_esc}
           placeholder="${placeholder}" value="${bindValue?then(spring.status.value!"","")}">
    <label class="form-label text-muted" for="${spring.status.expression}">${label}</label>
    <span class="invalid-feedback">
        <#list (spring.status.errorMessage)?split("-") as error>
            ${error}<#sep><br/></#sep>
        </#list>
    </span>
</#macro>

<#macro hiddenFormElement path>
    <@spring.bind path="${path}"/>
    <input type="hidden" name="${(spring.status.expression)!path}" value="${spring.status.value}"/>
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