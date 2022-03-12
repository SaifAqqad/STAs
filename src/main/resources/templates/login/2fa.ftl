<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />

<!DOCTYPE html>
<html lang="en">

<@default.head title="2-Factor authentication - STAs">
</@default.head>

<body>
<@default.navbar login="active"/>

<div class="container">
    <div class="d-flex align-items-center justify-content-center mt-5 mx-md-5-5 mx-lg-6">
        <div class="card text-dark bg-light mb-3 w-100 <#if auth2FAError??>border-danger</#if>">
            <div class="card-header">Two-factor authentication</div>
            <div class="card-body">
                <div class="card-text">
                    Open the two-factor authenticator (TOTP) app on your mobile device to view your authentication code.
                </div>
                <form action="<@spring.url "/login/2fa/do"/>" class="w-100" method="post">
                    <@default.csrfInput/>
                    <div class="form-floating my-3">
                        <input class="form-control <#if auth2FAError??>is-invalid</#if>" type="text" name="code" id="code" placeholder="Authentication code"
                               required/>
                        <label class="form-label" for="code">Authentication code</label>
                        <#if auth2FAError??>
                            <span class="invalid-feedback">
                                Invalid code
                            </span>
                        </#if>
                    </div>
                    <input class="btn btn-primary w-100" type="submit" value="Verify">
                </form>
            </div>
        </div>
    </div>
</div>

<@default.scripts/>
</body>
</html>
