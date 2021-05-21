Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1738F38D03D
	for <lists+io-uring@lfdr.de>; Fri, 21 May 2021 23:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbhEUVv6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 May 2021 17:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhEUVvv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 May 2021 17:51:51 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F1DC061574
        for <io-uring@vger.kernel.org>; Fri, 21 May 2021 14:50:27 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id v8so21349390qkv.1
        for <io-uring@vger.kernel.org>; Fri, 21 May 2021 14:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=w/wVrpbDddYGmYeIa/lLX6dIKPrH+Jy0d/XtOIIDKZ4=;
        b=eRM6JjYnEkTKlC5+Rcn1SAsvA+8BTinFm9H0FGGNLtE1SosLuwcraNaf4/GKtlm4fA
         eh+Q9g+w0J7nqnbedMg8bA90YJO962ZyK94UlBG+JvMTMnMJiAxeO1bRKSS8xIkRAnzJ
         emE02GOFRujDtOzaraq3j/B/mgKssR4tmH32edRJRcOJ2JOcbMtfgTcbs4nWyu7nDPnh
         zvZw/ZSAwpiUCJTFMdSl1vF5fRDXjJ5xZbDb6GWYibHT/Q61I5SctgJgJFFMmKGWkVnb
         3PPwSCtTJV8MMfqFdr8aCtSOvCq3Rt3evdTxTm1gatM2WayzgEbuj4J0QOybNJNOKbfL
         rHow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=w/wVrpbDddYGmYeIa/lLX6dIKPrH+Jy0d/XtOIIDKZ4=;
        b=Ie8ZmS7Cvjmn2s6XBsTinw3n+ujJbqNzuatBVIA1/hCSMzrlavjEVTXPZjwjRT+IgZ
         Fe3OlS1z30EAlgXyIN7rx+hCWOmtVdaH7EcqAVx95qbWedTY9cvOay+Y0Iw/fQIByIK2
         eYmKAyPMtnW+8nG7c4NcwbPbsGzDE0bwpOxVa/ruEEcfKkLwqtiSnS47gK3fgLI6X2Cs
         Ws/1Udy2moRbgpsG2AgRTdHP8NnwwoBLlyz/Au4Tfn0VzdFOptP4ONZTmsUW5mfSZduL
         0GMWGcDNsqyuKYO+uvXyxLE4RGgJ+OsofJhyjdhP8cW840RpVbcBKsFCh9i3G9QZPNwZ
         RasA==
X-Gm-Message-State: AOAM5319yr7y/ofrAuqAiuhYL9F/60kH6dkdlvCFLF8nsf0bk/ws10HO
        6bZAErS7xbqL50zxK5ljT3fO
X-Google-Smtp-Source: ABdhPJwWzC4oZBG5HfZ1Iz9QNRxVUdN7xK1qmDS/h0WKeKH6FTnP7rKaStU6OaFthZnDrlpJSMvAzw==
X-Received: by 2002:a05:620a:a4c:: with SMTP id j12mr12187144qka.33.1621633826362;
        Fri, 21 May 2021 14:50:26 -0700 (PDT)
Received: from localhost (pool-96-237-52-188.bstnma.fios.verizon.net. [96.237.52.188])
        by smtp.gmail.com with ESMTPSA id m67sm5909208qkd.108.2021.05.21.14.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 14:50:25 -0700 (PDT)
Subject: [RFC PATCH 7/9] lsm,io_uring: add LSM hooks to io_uring
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Date:   Fri, 21 May 2021 17:50:25 -0400
Message-ID: <162163382536.8379.3124023175473604584.stgit@sifl>
In-Reply-To: <162163367115.8379.8459012634106035341.stgit@sifl>
References: <162163367115.8379.8459012634106035341.stgit@sifl>
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
 fs/io_uring.c                 |   10 ++++++++++
 include/linux/lsm_hook_defs.h |    5 +++++
 include/linux/lsm_hooks.h     |   13 +++++++++++++
 include/linux/security.h      |   16 ++++++++++++++++
 security/security.c           |   12 ++++++++++++
 5 files changed, 56 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6ff769c9b7d3..d18a594c4c6e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -79,6 +79,7 @@
 #include <linux/pagemap.h>
 #include <linux/io_uring.h>
 #include <linux/audit.h>
+#include <linux/security.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -6537,6 +6538,11 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		if (!req->work.creds)
 			return -EINVAL;
 		get_cred(req->work.creds);
+		ret = security_uring_override_creds(req->work.creds);
+		if (ret) {
+			put_cred(req->work.creds);
+			return ret;
+		}
 	}
 	state = &ctx->submit_state;
 
@@ -7963,6 +7969,10 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
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
index 04c01794de83..88971b3da3c0 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -403,3 +403,8 @@ LSM_HOOK(void, LSM_RET_VOID, perf_event_free, struct perf_event *event)
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
index 06f7c50ce77f..263a744c839f 100644
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
index b38155b2de83..3d6b3a2cacf5 100644
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

