# canvas_customize_passwords
Customize password requirements for Canvas LMS


## Installation

Clone this repo into `gems/plugins` and restart the server.

Login with the a site admin account and head over to `/plugins` in the browser.

Find the plugin `Canvas Customize Passwords` and click into it. Enable the plugin and configure as desired.

### Javascript patch

In order to get an error message for the complexity requirement, you must patch some Canvas javascript.

Find the file `ui/shared/pseudonyms/backbone/models/Pseudonym.coffee`.

There will be an `errorMap` function with a `password` section. Add `too_simple:   I18n.t("errors.too_simple", "Must contain a special, numerical, uppercase, and lowercase character")` to that `password` section.

Here is a diff:

```
diff --git a/ui/shared/pseudonyms/backbone/models/Pseudonym.coffee b/ui/shared/pseudonyms/backbone/models/Pseudonym.coffee
index 8126cc20bb..9b73c6a085 100644
--- a/ui/shared/pseudonyms/backbone/models/Pseudonym.coffee
+++ b/ui/shared/pseudonyms/backbone/models/Pseudonym.coffee
@@ -32,6 +32,7 @@ export default class Pseudonym extends Backbone.Model
       too_long:     I18n.t("errors.too_long", "Can't exceed %{max} characters", {max: 255})
       taken:        I18n.t("errors.sis_taken", "The SIS ID is already in use")
     password:
+      too_simple:   I18n.t("errors.too_simple", "Must contain a special, numerical, uppercase, and lowercase character")
       too_short:    I18n.t("errors.too_short", "Must be at least %{min} characters", {min: policy.min_length})
       sequence:     I18n.t("errors.sequence", "Can't incude a run of more than %{max} characters (e.g. abcdef)", {max: policy.max_sequence})
       common:       I18n.t("errors.common", "Can't use common passwords (e.g. \"password\")")
```
