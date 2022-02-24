<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />

<!DOCTYPE html>
<html lang="en">

<@default.head title="Login - STAs">
</@default.head>

<body>
<@default.navbar login="active"/>
<#assign loginError = SPRING_SECURITY_LAST_EXCEPTION?? && RequestParameters.error??/>

<div class="container">
    <div class="d-flex align-items-center justify-content-center mt-5 mx-md-6">
        <div class="card text-dark bg-light mb-3 w-100 <#if loginError>border-danger</#if>">
            <div class="card-header">Log in with your account</div>
            <div class="card-body">
                <#-- Login form -->
                <#-- TODO: Add "sign in with __" buttons -->
                <form class="w-100" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <div class="form-floating mb-3">
                        <input class="form-control" type="email" name="email" id="email" placeholder="Email Address" required/>
                        <label class="form-label" for="email">Email address</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input class="form-control" type="password" name="password" id="password" placeholder="Password" required/>
                        <label class="form-label" for="password">Password</label>
                    </div>
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="checkbox" id="remember-me" name="remember-me"/>
                        <label class="form-check-label" for="remember-me">Remember Me</label>
                    </div>
                    <input class="btn btn-primary w-100" type="submit" value="Log in">
                </form>
            </div>
            <#-- TODO: Add "Register" button -->
            <#if loginError>
                <div class="card-footer text-white bg-danger border-danger">
                    An error occurred while logging in, please check your credentials and try again.
                </div>
            </#if>
        </div>
    </div>
</div>

<@default.scripts/>
</body>
</html>
