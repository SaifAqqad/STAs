<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />
<#import "../shared/account.ftl" as account />

<!DOCTYPE html>
<html lang="en">

<@default.head title="Account connection - STAs"/>
<#assign isOAuthError = ((toastColor!"") = "danger") && RequestParameters.error??/>
<body class="min-vh-100">
<@default.navbar/>
<div class="d-flex justify-content-center mt-5 mx-md-5 animate__animated animate__fadeIn animate__faster">
    <#if isOAuthError??>
        <@infoCard title="An error has occured" border="danger" style="text-dark bg-white">
            <#if toast??>
                <p class="card-text">${toast}</p>
            </#if>
            <p class="card-text">You can close this window now.</p>
        </@infoCard>
    <#else>
        <@infoCard title="Account connection" border="success" style="text-dark bg-white">
            <#if toast??>
                <p class="card-text">${toast}</p>
            </#if>
            <p class="card-text">You can close this window now.</p>
        </@infoCard>
    </#if>
</div>

<@default.scripts/>
<script>
    (() => {
        const isOAuthError = ${isOAuthError?c};
        const parentWindow = window.opener;
        if (parentWindow) {
            const OAuthEvent = new CustomEvent('oauth-callback', {
                detail: {
                    oauthError: isOAuthError,
                }
            });
            parentWindow.document.dispatchEvent(OAuthEvent);
            if (!isOAuthError) {
                setTimeout(() => {
                    window.close();
                }, 1000);
            }
        }
    })()
</script>
</body>
</html>

<#macro infoCard border title style="">
    <div class="card text-dark border-${border} ${style} mb-3 w-75">
        <div class="card-body">
            <h6 class="mb-3">${title}</h6>
            <#nested/>
        </div>
    </div>
</#macro>