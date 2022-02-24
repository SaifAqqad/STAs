<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />
<#import "../shared/account.ftl" as register/>

<!DOCTYPE html>
<html lang="en">
<@default.head title="Register - STAs"/>
<body>
<@default.navbar register="active"/>

<div class="container-fluid mt-3">
    <h4>Register a new account</h4>
    <form method="post">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

    </form>
</div>

<@default.scripts/>
</body>
</html>