Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D4940CB24
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 18:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbhIOQvR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 12:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhIOQvR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 12:51:17 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272FCC061575
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 09:49:58 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id b14so2959824qtb.0
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 09:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=ICAM6mKHGGedHsxpsbavLoCbX1CIysyavsIH2Q+N0Do=;
        b=KKF14JOkrMrQgNum+nBeUR/4lPbLyAGCyUz8uvN64BHpfDHhpdKb75itIdh7iz0u5W
         yy0vBoP38CXT8ebj9sARJYQcTaG2aHHvlfDtCFgzZnYAWNIb+7Q108a7ebdBZDFmR5wm
         DWfHYRW/s1dz7O2P99j5kYeG/F/QvtVB1M2OQb4DEHbVcMmAeh5gAIjKXBrSqQfm8baq
         gUxfW2T7TeKDhBeQPUyhGLpcdUt5nXSPhqrj4rMRFmim1QF+1Hl2EKGj51B0Gro94V3G
         +RSL60y6hTMdpg59rqvhAL5XU0I93HiUe/LxGaNivNfbCqrPorEnZZsvUK2M4R22Pav5
         6Wsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ICAM6mKHGGedHsxpsbavLoCbX1CIysyavsIH2Q+N0Do=;
        b=0tBwGWoBohkjN32rezphFSRF6sBldn4QA+JsvZzxMo5rKsaFhD59VIz7UwWcJUT0aW
         bT4+r69qeV/WrHm1MyCNCAfy9jFNOaifuQAxa2SWJv3jocsoAbTTZz7GFm1IZ0d/K/8M
         VxZFwjCvD5w2prN1VpmXWE0GlYrCaucCnRCFl8X573e3UUClJAMWUU9tiPb5MNtF4Tjm
         yIiAO35Eu84SV92qeK6a6Bay9xp2rlq/klazlxlo/QKtf6QWwf4360VnjIj4dRcsJs2p
         n/SI4wV5CkWbfETx/0PVRiPdW37I3vfCTFbB1lzKpVlX6hzKkrCdUbOAliZW9I4Cvos+
         FZKQ==
X-Gm-Message-State: AOAM533C/vQJQNYP+ePgYqp5hkwb2KqOp+X90R/vjlYmLH5yBm/2wyZI
        1CwBk3D3tyfF/vUSU39XzzK2
X-Google-Smtp-Source: ABdhPJyhq6uYSCuyukRnCV8KXX6viIqp20hFzF32qPgkImdooiMPdvSk1VaBXD5ejImpgMFtWIgfYA==
X-Received: by 2002:ac8:5c95:: with SMTP id r21mr788423qta.57.1631724597210;
        Wed, 15 Sep 2021 09:49:57 -0700 (PDT)
Received: from localhost (pool-96-237-52-188.bstnma.fios.verizon.net. [96.237.52.188])
        by smtp.gmail.com with ESMTPSA id x21sm365217qkf.76.2021.09.15.09.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 09:49:56 -0700 (PDT)
Subject: [PATCH v4 6/8] lsm,io_uring: add LSM hooks to io_uring
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Wed, 15 Sep 2021 12:49:56 -0400
Message-ID: <163172459614.88001.11338111737517016751.stgit@olly>
In-Reply-To: <163172413301.88001.16054830862146685573.stgit@olly>
References: <163172413301.88001.16054830862146685573.stgit@olly>
User-Agent: StGit/1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

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
v4:
- no change
v3:
- removed work-in-progress warning from the description
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
index 56cc9aba0d01..f89d00af3a67 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -80,6 +80,7 @@
 #include <linux/io_uring.h>
 #include <linux/tracehook.h>
 #include <linux/audit.h>
+#include <linux/security.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -7070,6 +7071,11 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
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
@@ -8566,6 +8572,10 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
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
index 5b7288521300..7979b9629a42 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2038,4 +2038,20 @@ static inline int security_perf_event_write(struct perf_event *event)
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
index 9ffa9e9c5c55..c49a2c0cc1c1 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2625,3 +2625,15 @@ int security_perf_event_write(struct perf_event *event)
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

