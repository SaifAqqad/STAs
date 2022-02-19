<#import "/spring.ftl" as spring />
<#import "../shared/template.ftlh" as default />

<!DOCTYPE html>
<html lang="en">

<@default.head title="STAs - Login">
</@default.head>

<body>
<@default.navbar login="active"/>

<div class="container">
    <h4 class="mt-5">Please log in</h4>
    <hr>
    <div class="d-flex align-items-center justify-content-center mt-5 mx-md-6">
        <form class="w-100" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <div class="mb-3">
                <label class="form-label" for="email">Email address</label>
                <input class="form-control" type="email" name="email" id="email" required autofocus/>
            </div>
            <div class="mb-3">
                <label class="form-label" for="password">Password</label>
                <input class="form-control" type="password" name="password" id="password" required/>
            </div>
            <div class="mb-3">
                <input class="form-check-inline" type="checkbox" id="remember-me" name="remember-me"/>
                <label class="form-check-label" for="remember-me">Remember Me</label>
            </div>
            <input class="btn btn-primary w-100" type="submit" value="Log in">
        </form>
    </div>
</div>

<@default.scripts/>
</body>
</html>
