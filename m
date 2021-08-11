Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160023E99FC
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 22:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhHKUtu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 16:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhHKUtg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 16:49:36 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0211C0617A2
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 13:48:57 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id a19so3941839qkg.2
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 13:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=LG+JDhuVRM/bBjl1U6QRkbk0MzYARXdx78XozLV6E/I=;
        b=IDjmV6gU84hRTKs8LZRecfmuw/xBF2xpn7YPzYgkKZqhmfgvm2dGpPUZZka0Kxiyrn
         vmJAm14Kn7mG8NaZCLHhzLCoZ7wnhdtKVAOukABX/0nvNjnIRdnSQSaim3N5v5edO3/c
         JxMWq2W8ifQA9VcZmAjybfd8zWaaAxD+WX4fuaUadvAc8syja1Ll/P7cTJSaaSlucScm
         TEdC/0PmUXEJjrHf9uYZeYj74Xb02SEW49rxYUZX2QIwYl1nDanwzlGqND6QXsqVI73p
         83SjS0TAWTGK04InlMwQhSp70Yp1As4xRCMaPY+ncfY20BhgZADOKHfqe2gvk3iSFEsE
         ac1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=LG+JDhuVRM/bBjl1U6QRkbk0MzYARXdx78XozLV6E/I=;
        b=JxBe0sClbkxRJT4HmpkORObTdgeytYlCSBcWre7Op/KHrP8+n8YmJeJs2UlA6bjnrS
         HDPg0cjifyDDkQhdkGjguB5bCHUi4ZtBsKStdekJWwMti3a3nyUWZZk484zF6GLf5yrH
         o/8I1O4bLqMP93I1kmN/XUYgB7xQhWc/t0EJ0XkftHmoEM4DcZFI9EUw+vSI3GppL43R
         hNjltIaKi+BjMHPyLCrj7yUvtQSi8uoYt7xNpzuegDbDUmYelqJvOvz4iq4+5yNKum5g
         kyZqDNau3iQQ8JFWSgDA7w3WqX9VMggeBGbu0QFRYB+pHh4E12hCQNllR8CI9F1eXatI
         Frxw==
X-Gm-Message-State: AOAM533h5lD542j5VE2o3whdf1y9iQMJ4etSJX+LeJky4EuY1oeencvr
        S3faD+ryOYshl7bEifjl4QBl
X-Google-Smtp-Source: ABdhPJyckSiCbWmaowJ2yBB4oYQ8V93A3pDzqw4XYjPiQnmgq/mx9emZEEwYrVL5iTCdTLdEzNEmHw==
X-Received: by 2002:a37:5ac7:: with SMTP id o190mr1005459qkb.152.1628714936659;
        Wed, 11 Aug 2021 13:48:56 -0700 (PDT)
Received: from localhost (pool-96-237-52-188.bstnma.fios.verizon.net. [96.237.52.188])
        by smtp.gmail.com with ESMTPSA id o63sm193942qkf.4.2021.08.11.13.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 13:48:56 -0700 (PDT)
Subject: [RFC PATCH v2 7/9] lsm,io_uring: add LSM hooks to io_uring
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Date:   Wed, 11 Aug 2021 16:48:55 -0400
Message-ID: <162871493537.63873.8470369457688012936.stgit@olly>
In-Reply-To: <162871480969.63873.9434591871437326374.stgit@olly>
References: <162871480969.63873.9434591871437326374.stgit@olly>
User-Agent: StGit/1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

WARNING - This is a work in progress, this patch, including the
description, may be incomplete or even incorrect.  You have been
warned.

A full expalantion of io_uring is beyond the scope of this commit
description, but in summary it is an asynchronous I/O mechanism
which allows for I/O requests and the resulting data to be queued
in memory mapped "rings" which are shared between the kernel and
userspace.  Optionally, io_uring offers the ability for applications
to spawn kernel threads to dequeue I/O requests from the ring and
submit the requests in the kernel, helping to minimize the syscall
overhead.  Rings are accessed in userspace by memory mapping a file
descriptor provided by the io_uring_setup(2), and can be shared
between applications as one might do with any open file descriptor.
Finally, process credentials can be registered with a given ring
and any process with access to that ring can submit I/O requests
using any of the registered credentials.

While the io_uring functionality is widely recognized as offering a
vastly improved, and high performing asynchronous I/O mechanism, its
ability to allow processes to submit I/O requests with credentials
other than its own presents a challenge to LSMs.  When a process
creates a new io_uring ring the ring's credentials are inhertied
from the calling process; if this ring is shared with another
process operating with different credentials there is the potential
to bypass the LSMs security policy.  Similarly, registering
credentials with a given ring allows any process with access to that
ring to submit I/O requests with those credentials.

In an effort to allow LSMs to apply security policy to io_uring I/O
operations, this patch adds two new LSM hooks.  These hooks, in
conjunction with the LSM anonymous inode support previously
submitted, allow an LSM to apply access control policy to the
sharing of io_uring rings as well as any io_uring credential changes
requested by a process.

The new LSM hooks are described below:

 * int security_uring_override_creds(cred)
   Controls if the current task, executing an io_uring operation,
   is allowed to override it's credentials with @cred.  In cases
   where the current task is a user application, the current
   credentials will be those of the user application.  In cases
   where the current task is a kernel thread servicing io_uring
   requests the current credentials will be those of the io_uring
   ring (inherited from the process that created the ring).

 * int security_uring_sqpoll(void)
   Controls if the current task is allowed to create an io_uring
   polling thread (IORING_SETUP_SQPOLL).  Without a SQPOLL thread
   in the kernel processes must submit I/O requests via
   io_uring_enter(2) which allows us to compare any requested
   credential changes against the application making the request.
   With a SQPOLL thread, we can no longer compare requested
   credential changes against the application making the request,
   the comparison is made against the ring's credentials.

Signed-off-by: Paul Moore <paul@paul-moore.com>

---
v2:
- no change
v1:
- initial draft
---
 fs/io_uring.c                 |   10 ++++++++++
 include/linux/lsm_hook_defs.h |    5 +++++
 include/linux/lsm_hooks.h     |   13 +++++++++++++
 include/linux/security.h      |   16 ++++++++++++++++
 security/security.c           |   12 ++++++++++++
 5 files changed, 56 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ea396f5fe735..78df778d329b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -79,6 +79,7 @@
 #include <linux/pagemap.h>
 #include <linux/io_uring.h>
 #include <linux/audit.h>
+#include <linux/security.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -6617,6 +6618,11 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		if (!req->creds)
 			return -EINVAL;
 		get_cred(req->creds);
+		ret = security_uring_override_creds(req->creds);
+		if (ret) {
+			put_cred(req->creds);
+			return ret;
+		}
 		req->flags |= REQ_F_CREDS;
 	}
 	state = &ctx->submit_state;
@@ -8080,6 +8086,10 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		struct io_sq_data *sqd;
 		bool attached;
 
+		ret = security_uring_sqpoll();
+		if (ret)
+			return ret;
+
 		sqd = io_get_sq_data(p, &attached);
 		if (IS_ERR(sqd)) {
 			ret = PTR_ERR(sqd);
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 2adeea44c0d5..b3c525353769 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -402,3 +402,8 @@ LSM_HOOK(void, LSM_RET_VOID, perf_event_free, struct perf_event *event)
 LSM_HOOK(int, 0, perf_event_read, struct perf_event *event)
 LSM_HOOK(int, 0, perf_event_write, struct perf_event *event)
 #endif /* CONFIG_PERF_EVENTS */
+
+#ifdef CONFIG_IO_URING
+LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
+LSM_HOOK(int, 0, uring_sqpoll, void)
+#endif /* CONFIG_IO_URING */
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 5c4c5c0602cb..0eb0ae95c4c4 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1557,6 +1557,19 @@
  * 	Read perf_event security info if allowed.
  * @perf_event_write:
  * 	Write perf_event security info if allowed.
+ *
+ * Security hooks for io_uring
+ *
+ * @uring_override_creds:
+ *      Check if the current task, executing an io_uring operation, is allowed
+ *      to override it's credentials with @new.
+ *
+ *      @new: the new creds to use
+ *
+ * @uring_sqpoll:
+ *      Check whether the current task is allowed to spawn a io_uring polling
+ *      thread (IORING_SETUP_SQPOLL).
+ *
  */
 union security_list_options {
 	#define LSM_HOOK(RET, DEFAULT, NAME, ...) RET (*NAME)(__VA_ARGS__);
diff --git a/include/linux/security.h b/include/linux/security.h
index 24eda04221e9..3928d80b6f76 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2037,4 +2037,20 @@ static inline int security_perf_event_write(struct perf_event *event)
 #endif /* CONFIG_SECURITY */
 #endif /* CONFIG_PERF_EVENTS */
 
+#ifdef CONFIG_IO_URING
+#ifdef CONFIG_SECURITY
+extern int security_uring_override_creds(const struct cred *new);
+extern int security_uring_sqpoll(void);
+#else
+static inline int security_uring_override_creds(const struct cred *new)
+{
+	return 0;
+}
+static inline int security_uring_sqpoll(void)
+{
+	return 0;
+}
+#endif /* CONFIG_SECURITY */
+#endif /* CONFIG_IO_URING */
+
 #endif /* ! __LINUX_SECURITY_H */
diff --git a/security/security.c b/security/security.c
index 09533cbb7221..a54544e61bd1 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2624,3 +2624,15 @@ int security_perf_event_write(struct perf_event *event)
 	return call_int_hook(perf_event_write, 0, event);
 }
 #endif /* CONFIG_PERF_EVENTS */
+
+#ifdef CONFIG_IO_URING
+int security_uring_override_creds(const struct cred *new)
+{
+	return call_int_hook(uring_override_creds, 0, new);
+}
+
+int security_uring_sqpoll(void)
+{
+	return call_int_hook(uring_sqpoll, 0);
+}
+#endif /* CONFIG_IO_URING */

