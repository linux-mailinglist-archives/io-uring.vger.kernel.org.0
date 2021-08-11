Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052243E9A00
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 22:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbhHKUt4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 16:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbhHKUtj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 16:49:39 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C01FC0617BD
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 13:49:10 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id c6so3222649qtv.5
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 13:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=fjm5E8jlur4ZmhZQt8sIor5EdCTxd31hgJPvTT515QA=;
        b=WcS9qkWmdAOR30pHBAqpZASMI8pexAv4ZejPT9DVJiSLOdCpb6K46er2oFtZiWlWtZ
         tq4bSWMOL5wUt4qPVCQbF2pZmx4yGyzNLDQsnNno6BVCdeRutOVJ1sDICvxDuB08M/V8
         yRfB0Gn7rgH9g0ZPGNVudaTXUlLLLyGv7HaeyLlC4gpjCbVfTSjOjGehTAPhz4DPwr40
         RSjZmj7KleWkJj0WpLExiFfUouIIq4bQ8n1bimK6Fy+Ur9hGJOFdGOPKA4BgedtLR/Cy
         2guxpNsjCQPbhpry68M4H+/rZiaVdjDsgTMf69KagspAyOExEVg/CRgpAWdGHGM8JucC
         JlSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=fjm5E8jlur4ZmhZQt8sIor5EdCTxd31hgJPvTT515QA=;
        b=RqJddmZ8T6IwrktJkWV4veTxYr/r4OMCeZYWvdFNOYixluPZrAnV50WDd1iMubz+e4
         JvEIC9nv6MKi7UQUevCw50MSvKNcvVDUQ8qVV5j0FP0JyyLmCg99gMTvXD7gIEc6CvKf
         EhdhOJTn2gIsYr9BPaHUSw+uEC1Ts4KElXQO3bICKwbsR2u2fVwWeljQWeSDmJYX4D02
         ++XOZQA7LJzcNTVe65mXvl3HUfO/ugHiSR+ei6C/ji/PR1O67jvsgbFO4BorV4wO5a2w
         KyeVrNvLGQcrYx6okPfEbf8bU1Sk3SlX4CGLjiLsCOSY7UysNU+09GWj5B2L/456zArz
         7P3Q==
X-Gm-Message-State: AOAM530eLo3gWn0c7g/5fHNO3IK7GOJSrejFpBdq39ieZFfVsnEOW4Gu
        YH+U7QKudjQQ/44c8GFF2OAB
X-Google-Smtp-Source: ABdhPJxvrwP5BSOOajTVuXk7Z63HlSzq+KFtGBCu4Il3OS/cOqfAvjfLAuqSVvNcYQqCWND161FvaA==
X-Received: by 2002:ac8:7770:: with SMTP id h16mr613425qtu.144.1628714949098;
        Wed, 11 Aug 2021 13:49:09 -0700 (PDT)
Received: from localhost (pool-96-237-52-188.bstnma.fios.verizon.net. [96.237.52.188])
        by smtp.gmail.com with ESMTPSA id a24sm190568qtj.43.2021.08.11.13.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 13:49:08 -0700 (PDT)
Subject: [RFC PATCH v2 9/9] Smack: Brutalist io_uring support with debug
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Date:   Wed, 11 Aug 2021 16:49:07 -0400
Message-ID: <162871494794.63873.18299137802334845525.stgit@olly>
In-Reply-To: <162871480969.63873.9434591871437326374.stgit@olly>
References: <162871480969.63873.9434591871437326374.stgit@olly>
User-Agent: StGit/1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

Add Smack privilege checks for io_uring. Use CAP_MAC_OVERRIDE
for the override_creds case and CAP_MAC_ADMIN for creating a
polling thread. These choices are based on conjecture regarding
the intent of the surrounding code.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
[PM: make the smack_uring_* funcs static]
Signed-off-by: Paul Moore <paul@paul-moore.com>

---
v2:
- made the smack_uring_* funcs static
v1:
- initial draft
---
 security/smack/smack_lsm.c |   64 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 223a6da0e6dc..7fb094098f38 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4691,6 +4691,66 @@ static int smack_dentry_create_files_as(struct dentry *dentry, int mode,
 	return 0;
 }
 
+#ifdef CONFIG_IO_URING
+/**
+ * smack_uring_override_creds - Is io_uring cred override allowed?
+ * @new: the target creds
+ *
+ * Check to see if the current task is allowed to override it's credentials
+ * to service an io_uring operation.
+ */
+static int smack_uring_override_creds(const struct cred *new)
+{
+	struct task_smack *tsp = smack_cred(current_cred());
+	struct task_smack *nsp = smack_cred(new);
+
+#if 1
+	if (tsp->smk_task == nsp->smk_task)
+		pr_info("%s: Smack matches %s\n", __func__,
+			tsp->smk_task->smk_known);
+	else
+		pr_info("%s: Smack override check %s to %s\n", __func__,
+			tsp->smk_task->smk_known, nsp->smk_task->smk_known);
+#endif
+	/*
+	 * Allow the degenerate case where the new Smack value is
+	 * the same as the current Smack value.
+	 */
+	if (tsp->smk_task == nsp->smk_task)
+		return 0;
+
+#if 1
+	pr_info("%s: Smack sqpoll %s\n", __func__,
+		smack_privileged_cred(CAP_MAC_OVERRIDE, current_cred()) ?
+		"ok by Smack" : "disallowed (No CAP_MAC_OVERRIDE)");
+#endif
+	if (smack_privileged_cred(CAP_MAC_OVERRIDE, current_cred()))
+		return 0;
+
+	return -EPERM;
+}
+
+/**
+ * smack_uring_sqpoll - check if a io_uring polling thread can be created
+ *
+ * Check to see if the current task is allowed to create a new io_uring
+ * kernel polling thread.
+ */
+static int smack_uring_sqpoll(void)
+{
+#if 1
+	pr_info("%s: Smack new ring %s\n", __func__,
+		smack_privileged_cred(CAP_MAC_ADMIN, current_cred()) ?
+		"ok by Smack" : "disallowed (No CAP_MAC_ADMIN)");
+#endif
+	if (smack_privileged_cred(CAP_MAC_ADMIN, current_cred()))
+		return 0;
+
+	return -EPERM;
+}
+
+#endif /* CONFIG_IO_URING */
+
 struct lsm_blob_sizes smack_blob_sizes __lsm_ro_after_init = {
 	.lbs_cred = sizeof(struct task_smack),
 	.lbs_file = sizeof(struct smack_known *),
@@ -4843,6 +4903,10 @@ static struct security_hook_list smack_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(inode_copy_up, smack_inode_copy_up),
 	LSM_HOOK_INIT(inode_copy_up_xattr, smack_inode_copy_up_xattr),
 	LSM_HOOK_INIT(dentry_create_files_as, smack_dentry_create_files_as),
+#ifdef CONFIG_IO_URING
+	LSM_HOOK_INIT(uring_override_creds, smack_uring_override_creds),
+	LSM_HOOK_INIT(uring_sqpoll, smack_uring_sqpoll),
+#endif
 };
 
 

