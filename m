Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36ECB61FFFC
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 21:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbiKGU6W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 15:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbiKGU6R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 15:58:17 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E3B2BB0C
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 12:58:16 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-36f8318e4d0so119639967b3.20
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 12:58:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=82Sk77X8oVXjFrSC3UdX1BgOsBdJ+Ee5YdnkpmQ5zx0=;
        b=cz0D6cQc+B6jbJ25lggM2jj1Ve8T+VuhMYi0uDgtW5HCcjLC14ZBS007EYxG+txfot
         XJMUh5Tm1r1HbdC9+H488e8aFXZpZQwXVRrRVuDwmO5PUHwC2UzNUjplJrnhYQhfn+fA
         ymjMXGP+1pFVOcLyk+1qYaf18AX9uYX6ctqtvGQ1SwoGbejKXwE+69ZxYPTjIfrsdhdu
         XHDHJEDaMoRAExQwLG+cwnwSQe3ypSdLgmlJHAu6AH8zzQU5X6a906gpKc1TOxA84TRL
         13A2Z9JCtReMXYwSvyLLH1Eb5nhN4ISpk3wBHPZKK9MEyZT02R40w1ZE1oGFubAFHXIc
         8eyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=82Sk77X8oVXjFrSC3UdX1BgOsBdJ+Ee5YdnkpmQ5zx0=;
        b=6Rfd/c4dH8eFA5rQLCkkOx6aApnpu2Fs8Z/MiIsEmWPXKRcJyOipdtmcMSHWDIyXDn
         d4LMTAD9I/SvwQyglNHhAF8wJKf/7eDcAI4UtBPOyDFxf3NX+M0bwUwgHDY+Xvhx38Y2
         +49olUEb3gfk2w4kgwd9Rn2xfQJOIztoSodkdKDDYeU6SbWoGNIInEnAM0Iy1YDvvdfz
         /jlrKJ5Sw9niFZIeCDLfYOhSeJnKRdWyQWrEq15QkAyBgUma5W1r40eAwIahjrxGXYlQ
         FLQusE7rfExQDHJNs7dQ+2ZgE1O56aheWXWDtkF8ncLqorZIjiiD2FQCgpZGORXfq+Tz
         s9bw==
X-Gm-Message-State: ACrzQf1Z5sRRH8r4WKv8bO2/vIbr4tAg96kEP0Wfblq+h6CbBjwE3NZh
        G8V+G0G9DnnG+evEFg4j7Hz3OLKhwA==
X-Google-Smtp-Source: AMsMyM4/w5POlTIghMGwE57Oz98TpTtgzV9HuAg5r2Yigzzk4vfAg9WYpj3Y1exwA2J0cwVR9T4NXW8haw==
X-Received: from cukie91.nyc.corp.google.com ([2620:0:1003:314:8113:36e9:8e90:5fb8])
 (user=cukie job=sendgmr) by 2002:a0d:e203:0:b0:36a:a52e:fe5b with SMTP id
 l3-20020a0de203000000b0036aa52efe5bmr47990349ywe.512.1667854695296; Mon, 07
 Nov 2022 12:58:15 -0800 (PST)
Date:   Mon,  7 Nov 2022 15:57:52 -0500
In-Reply-To: <20221107205754.2635439-1-cukie@google.com>
Mime-Version: 1.0
References: <20221107205754.2635439-1-cukie@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221107205754.2635439-2-cukie@google.com>
Subject: [PATCH v1 1/2] lsm,io_uring: add LSM hook for io_uring_setup
From:   Gil Cukierman <cukie@google.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Cc:     Gil Cukierman <cukie@google.com>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch allows LSMs to apply security policies that control
access to the io_uring_setup syscall. This is accomplished by
adding a new hook:

int security_uring_setup(void)
Check whether the current task is allowed to call io_uring_setup.

This hook, together with the existing hooks for sharing of file
descriptors and io_uring credentials, allow LSMs to expose
comprehensive controls on the usage of io_uring overall.

Signed-off-by: Gil Cukierman <cukie@google.com>
---
 include/linux/lsm_hook_defs.h | 1 +
 include/linux/lsm_hooks.h     | 3 +++
 include/linux/security.h      | 5 +++++
 io_uring/io_uring.c           | 5 +++++
 security/security.c           | 4 ++++
 5 files changed, 18 insertions(+)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index ec119da1d89b..ffbf29b32a48 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -409,4 +409,5 @@ LSM_HOOK(int, 0, perf_event_write, struct perf_event *event)
 LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
 LSM_HOOK(int, 0, uring_sqpoll, void)
 LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd)
+LSM_HOOK(int, 0, uring_setup, void)
 #endif /* CONFIG_IO_URING */
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 4ec80b96c22e..bc13a8e664c9 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1589,6 +1589,9 @@
  * @uring_cmd:
  *      Check whether the file_operations uring_cmd is allowed to run.
  *
+ * @uring_setup:
+ *      Check whether the current task is allowed to call io_uring_setup.
+ *
  */
 union security_list_options {
 	#define LSM_HOOK(RET, DEFAULT, NAME, ...) RET (*NAME)(__VA_ARGS__);
diff --git a/include/linux/security.h b/include/linux/security.h
index ca1b7109c0db..0bba7dd85691 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2069,6 +2069,7 @@ static inline int security_perf_event_write(struct perf_event *event)
 extern int security_uring_override_creds(const struct cred *new);
 extern int security_uring_sqpoll(void);
 extern int security_uring_cmd(struct io_uring_cmd *ioucmd);
+extern int security_uring_setup(void);
 #else
 static inline int security_uring_override_creds(const struct cred *new)
 {
@@ -2082,6 +2083,10 @@ static inline int security_uring_cmd(struct io_uring_cmd *ioucmd)
 {
 	return 0;
 }
+static inline int security_uring_setup(void)
+{
+	return 0;
+}
 #endif /* CONFIG_SECURITY */
 #endif /* CONFIG_IO_URING */
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6cc16e39b27f..1456c85648ed 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3574,6 +3574,11 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 {
 	struct io_uring_params p;
 	int i;
+	int ret;
+
+	ret = security_uring_setup();
+	if (ret)
+		return ret;
 
 	if (copy_from_user(&p, params, sizeof(p)))
 		return -EFAULT;
diff --git a/security/security.c b/security/security.c
index 79d82cb6e469..b1bc95df5a5d 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2671,4 +2671,8 @@ int security_uring_cmd(struct io_uring_cmd *ioucmd)
 {
 	return call_int_hook(uring_cmd, 0, ioucmd);
 }
+int security_uring_setup(void)
+{
+	return call_int_hook(uring_setup, 0);
+}
 #endif /* CONFIG_IO_URING */
-- 
2.38.0.135.g90850a2211-goog

