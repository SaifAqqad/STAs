<#ftl output_format="HTML">
<#import "template.ftl" as default />
<@default.template
title="STAs - Reset your password"
msg1="Hi, ${user.firstName}!"
msg2="A password reset was requested for your account, you can click the link below to reset your password.<br/>The link expires in 3 hours."
buttonName="Reset password"
url="${url}"
/>