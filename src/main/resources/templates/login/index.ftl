<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />

<!DOCTYPE html>
<html lang="en">

<@default.head title="Login - STAs">
</@default.head>

<body class="min-vh-100">
<@default.navbar login="active"/>
<#assign loginError = authError?? && RequestParameters.error??/>

<div class="container animate__animated animate__fadeIn animate__faster">
    <div class="d-flex align-items-center justify-content-center mt-5 mx-md-5-5 mx-lg-6">
        <div class="card card-light text-dark  mb-3 w-100 <#if loginError>border-danger</#if>">
            <div class="card-body">
                <h6 class="mb-1">Log in with your account</h6>
                <br/>
                <#if loginError>
                    <div class="alert alert-danger" role="alert">
                        <#switch errorType!0>
                            <#case 1>
                                Your account is unverified, click the link in the email we sent to verify your account, or click <a class="link-danger" href="<@spring.url "/register/request-verification"/>">here</a> to request a new link.
                                <#break>
                            <#default >
                            An error occurred while logging in, please check your credentials and try again.
                        </#switch>
                    </div>
                </#if>
                <#-- Login form -->
                <#-- TODO: Add "sign in with __" buttons -->
                <form action="<@spring.url"/login/do"/>" class="w-100" method="post">
                    <@default.csrfInput/>
                    <div class="form-floating mb-3">
                        <input class="form-control" type="email" name="email" id="email" placeholder="Email Address"
                               required/>
                        <label class="form-label text-muted" for="email">Email address</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input class="form-control" type="password" name="password" id="password" placeholder="Password"
                               required/>
                        <label class="form-label text-muted" for="password">Password</label>
                    </div>
                    <div class="d-flex justify-content-end mb-2">
                        <div class="">
                            <a class=" link-info text-decoration-none" href="<@spring.url "/reset-password"/>">Forgot
                                password?</a>
                        </div>
                    </div>
                    <input class="btn btn-primary w-100" type="submit" value="Log in">
                    <div class="w-100">
                        <a class="btn btn-outline-light w-100 mt-3" href="<@spring.url "/login/oauth/google"/>">
                            <span class="align-bottom iconify-inline" data-icon="flat-color-icons:google" data-width="24"></span>
                            <span class="align-text-bottom">Log in with Google</span>
                        </a>
                        <a class="btn btn-dark w-100 mt-2" href="<@spring.url "/login/oauth/github"/>">
                            <span class="align-bottom iconify-inline" data-icon="mdi:github" data-width="24"></span>
                            <span class="align-text-bottom">Log in with GitHub</span>
                        </a>
                        <a class="btn btn-linkedin w-100 mt-2" href="<@spring.url "/login/oauth/linkedin"/>">
                            <span class="align-bottom iconify-inline" data-icon="ion:logo-linkedin"
                                  data-width="24"></span>
                            <span class="align-text-bottom">Log in with LinkedIn</span>
                        </a>
                    </div>
                    <hr/>
                    <#-- Registration button -->
                    <div class="d-flex justify-content-center w-100">
                        <a class="btn btn-success w-75" href="<@spring.url "/register"/>">Create a new account</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<@default.scripts/>
</body>
</html>
