<#ftl output_format="HTML">
<#import "template.ftl" as default />
<@default.template
title="STAs - Verify your account"
msg1="Hi, ${user.firstName}!"
msg2="Please click the link below to verify and enable your account"
buttonName="Verify"
url="${url}"
/>