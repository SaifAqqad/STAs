<#ftl output_format="HTML">
<#import "/spring.ftl" as spring />
<#import "../shared/default.ftl" as default/>
<#import "../shared/account.ftl" as account/>

<!DOCTYPE html>
<html lang="en">
<@default.head title="Reset your password - STAs"/>
<body>
<@default.navbar />

<div class="container mt-3">
    <div class="d-flex align-items-center justify-content-center mt-5 mx-md-5">
        <#if resetSuccess??>
        <#-- show success message -->
            <@infoCard border="success" title="Reset your password">
                <p class="card-text">
                    Your password has been successfully changed. Click <a class="link-primary text-decoration-none"
                                                                        href="<@spring.url "/login"/>">here</a> to login
                </p>
            </@infoCard>
        <#elseif requestSuccess??>
        <#-- show request success message -->
            <@infoCard border="1" title="Reset your password">
                <p class="card-text">
                    Check your email for a link to reset your password. If it doesn't appear within a few minutes, check
                    your spam folder.
                </p>
            </@infoCard>
        <#else>
            <#if showResetForm??>
            <#-- show reset password form -->
                <@infoCard title="Reset your password" border="1" style="text-dark bg-light">
                    <form action="<@spring.url "/reset-password/do"/>" method="post">
                        <@default.csrfInput/>
                        <@account.hiddenFormElement path="resetPasswordForm.resetToken"/>
                        <div class="form-floating mt-3">
                            <@account.formElement path="resetPasswordForm.newPassword" bindValue=false type="password" label="Password" placeholder="Password" attrb="required"/>
                        </div>
                        <div class="form-floating mt-3">
                            <input class="form-control" name="confirmPassword" id="confirmPassword" required
                                   placeholder="Confirm password" type="password"/>
                            <label class="form-label text-muted" for="confirmPassword">Confirm password</label>
                            <span class="invalid-feedback" id="confirmPasswordFeedback"></span>
                        </div>
                        <div class="mt-3">
                            <input class="btn btn-primary" type="submit" value="Change password"/>
                        </div>
                    </form>
                </@infoCard>
            <#else>
            <#-- show request reset password form -->
                <@infoCard title="Reset your password" border="1" style="text-dark bg-light">
                    <p class="card-text">
                        Enter your account's verified email address, and we will send you a password reset link.
                    </p>
                    <form action="<@spring.url "/reset-password/request-email"/>" method="post">
                        <@default.csrfInput/>
                        <div class="form-floating mt-3">
                            <input class="form-control " type="email" name="email" id="email" placeholder="Email"
                                   required>
                            <label class="form-label text-muted" for="email">Email</label>
                        </div>
                        <div class="mt-3">
                            <input class="btn btn-outline-primary" value="Send password reset email" type="submit"/>
                        </div>
                    </form>
                </@infoCard>
            </#if>
        </#if>
    </div>
</div>
</body>
<@default.scripts/>
<#if showResetForm??>
    <@account.confirmPasswordScript passwordId="newPassword" confirmPasswordId="confirmPassword" confirmPasswordFeedbackId="confirmPasswordFeedback"/>
</#if>
</html>
<#macro infoCard border title style="" >
    <div class="card border-${border} ${style} mb-3 w-75">
        <div class="card-header">${title}</div>
        <div class="card-body">
            <#nested/>
        </div>
    </div>
</#macro>