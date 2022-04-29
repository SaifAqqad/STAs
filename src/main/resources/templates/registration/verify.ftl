<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />
<#import "../shared/account.ftl" as register/>
<#assign verification = verificationSuccess!false/>

<!DOCTYPE html>
<html lang="en">
<@default.head title="Verify your registration - STAs"/>
<body>
<@default.navbar />

<div class="container mt-3">
    <div class="d-flex align-items-center justify-content-center mt-5 mx-md-5">
        <#if verification>
            <div class="card card-light border-success mb-3 w-75">
                <div class="card-body">
                    <h6 class="mb-1">Verification successful</h6>
                    <br/>
                    <p class="card-text">
                        Your account has been verified and enabled. You can
                        <a class="link-primary text-decoration-none" href="<@spring.url "/login"/>">login</a> now!
                    </p>
                </div>
            </div>
        <#elseif RequestParameters.token??> <#-- there's a token but the verification failed -->
            <div class="card card-light border-danger mb-3 w-75">
                <div class="card-body">
                    <h6 class="mb-1">Verification failed</h6>
                    <br/>
                    <p class="card-text">
                        An error occurred while verifying your account. The verification code might have expired.
                        Click <a class="link-primary text-decoration-none" href="<@spring.url "/register/request-verification"/>">here</a> to request a new one.
                    </p>
                </div>
            </div>
        <#else >  <#-- there's no token -->
            <div class="card card-light mb-3 w-75">
                <div class="card-body">
                    <h6 class="mb-1">Verify your account</h6>
                    <br/>
                    <p class="card-text">
                        We've sent you an email with a verification link.
                        Please click on the link to verify and enable your account.
                    </p>
                    <p class="card-text">
                        If you haven't received the email, click <a class="link-primary text-decoration-none" href="<@spring.url "/register/request-verification"/>">here</a> to request a new one.
                    </p>
                </div>
            </div>
        </#if>
    </div>
</div>
<@default.scripts/>
</body>
</html>