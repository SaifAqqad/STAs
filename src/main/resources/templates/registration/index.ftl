<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default />
<#import "../shared/account.ftl" as register/>

<!DOCTYPE html>
<html lang="en">
<@default.head title="Create a new account - STAs"/>
<body>
<@default.navbar/>

<div class="container mt-3">
    <div class="card card-light text-dark mb-3 w-100">
        <div class="card-body">
            <h6 class="mb-1">Create a new account</h6>
            <br/>
            <form class="needs-validation" method="post">
                <@default.csrfInput/>
                <div class="row">
                    <div class="col">
                        <div class="form-floating mt-3">
                            <@register.formElement path="registrationForm.firstName" label="First name" placeholder="First name" attrb="required"/>
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-floating mt-3">
                            <@register.formElement path="registrationForm.lastName" label="Last name" placeholder="Last name" attrb="required"/>
                        </div>
                    </div>
                </div>
                <div class="form-floating mt-3">
                    <@register.formElement path="registrationForm.email" type="email" label="Email" placeholder="Email" attrb="required"/>
                </div>
                <div class="form-floating mt-3">
                    <@register.formElement path="registrationForm.password" bindValue=false type="password" label="Password" placeholder="Password" attrb="required"/>
                </div>
                <div class="form-floating mt-3">
                    <input class="form-control" name="confirmPassword" id="confirmPassword" required
                           placeholder="Confirm password" type="password"/>
                    <label class="form-label text-muted" for="confirmPassword">Confirm password</label>
                    <span class="invalid-feedback" id="confirmPasswordFeedback"></span>
                </div>
                <div class="form-floating mt-3">
                    <@register.formElement path="registrationForm.dateOfBirth" type="date" label="Date of birth" placeholder="Date of birth" attrb="required"/>
                </div>
                <div class="mt-3">
                    <input class="btn btn-primary" type="submit" value="Create account"/>
                </div>
            </form>
        </div>
    </div>
</div>

<@default.scripts/>
<@register.confirmPasswordScript passwordId="password" confirmPasswordId="confirmPassword" confirmPasswordFeedbackId="confirmPasswordFeedback"/>
</body>
</html>