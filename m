Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10B138D029
	for <lists+io-uring@lfdr.de>; Fri, 21 May 2021 23:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhEUVvd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 May 2021 17:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhEUVvc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 May 2021 17:51:32 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61A0C0613ED
        for <io-uring@vger.kernel.org>; Fri, 21 May 2021 14:50:08 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id 124so8992491qkh.10
        for <io-uring@vger.kernel.org>; Fri, 21 May 2021 14:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=QUVDejUd0QVU/Z8Kg6BDyRzNOClvT48b9vJMJlEEAYU=;
        b=c0LniHduGCV7osELXKSi8Y7kTaA+YrOJgBGm3A54YFyvwbzfmoOyRmFNjLHukJqatK
         lJo5bv4R/B9k3KppXBKPyLFLP9nslxfiSW9ya3Ub6OyU2o+mcprcAQgB253Fjou1ncLD
         o5GshWgPxEDIqMIsadd6vw+RcYs0NbKjeTdhcsjIFh8Apts0c54EHtWybxaL+dFhslaw
         h2B00lTRKLZCX+2fJBVJvEMEikLt12LkNRg47b6Yuu4ZFp86MM4wBxFMHPtzFMfJn9TE
         RSCjekeXGuW13cZRfCmmWXRmba/Kk1V+m7LaIbAzBr1HOKr9R77LzFCZn2zNEcH0EPfv
         yAlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=QUVDejUd0QVU/Z8Kg6BDyRzNOClvT48b9vJMJlEEAYU=;
        b=KlklZtswv2yo7rVdJQm/gTl42OIeYRY9iThcq+v1rHQTHsd589d56DCIZAhWB9I677
         BobqJSdPufvzUbllPnMOnid2iXhDyTHLqy+8jhCUenW3MCvB3RUA4LGab76bC2Uovyag
         FsM1k/v1sCz0Y1RD7jfkDYrjdNVggGOye/CymtcvYbgYmxQHYpi/kSF8+gVec+ncXI2X
         PtJ/Usg40aHh+Nr5NbIt56GnFUq4FpTJWbfueUneoM1EeUJOQewFqmjMZJcqSFko5HsB
         yoJJ65tfQcPha2+IHFkl42mG42CPtfPSvhmq07FSaYG9B5qBgHGTO/SO0P+EQWmxCPsL
         Q2bQ==
X-Gm-Message-State: AOAM5318/7fkjcqFJK2rEzB1lyimW1vZP6SXv/LudaoCI1QrQICbyaQF
        ExOsJHigexXAHRDiW0fLVOtz
X-Google-Smtp-Source: ABdhPJxPTzsGFJkxhfKEg5HzgXuCEPzB3MK2hNWDMjSEOoq7brugPuxmQltgnePH6/vH3GsF3vbdYQ==
X-Received: by 2002:a05:620a:68e:: with SMTP id f14mr15645958qkh.306.1621633807902;
        Fri, 21 May 2021 14:50:07 -0700 (PDT)
Received: from localhost (pool-96-237-52-188.bstnma.fios.verizon.net. [96.237.52.188])
        by smtp.gmail.com with ESMTPSA id 7sm6228437qtu.38.2021.05.21.14.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 14:50:07 -0700 (PDT)
Subject: [RFC PATCH 4/9] audit: add filtering for io_uring records
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Date:   Fri, 21 May 2021 17:50:06 -0400
Message-ID: <162163380685.8379.17381053199011043757.stgit@sifl>
In-Reply-To: <162163367115.8379.8459012634106035341.stgit@sifl>
References: <162163367115.8379.8459012634106035341.stgit@sifl>
User-Agent: StGit/1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

WARNING - This is a work in progress and should not be merged
anywhere important.  It is almost surely not complete, and while it
probably compiles it likely hasn't been booted and will do terrible
things.  You have been warned.

This patch adds basic audit io_uring filtering, using as much of the
existing audit filtering infrastructure as possible.  In order to do
this we reuse the audit filter rule's syscall mask for the io_uring
operation and we create a new filter for io_uring operations as
AUDIT_FILTER_URING_EXIT/audit_filter_list[7].

<TODO - provide some additional guidance for the userspace tools>

Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 include/uapi/linux/audit.h |    3 +-
 kernel/auditfilter.c       |    4 ++-
 kernel/auditsc.c           |   65 ++++++++++++++++++++++++++++++++++----------
 3 files changed, 55 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index b26e0c435e8b..621eb3c1076e 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -167,8 +167,9 @@
 #define AUDIT_FILTER_EXCLUDE	0x05	/* Apply rule before record creation */
 #define AUDIT_FILTER_TYPE	AUDIT_FILTER_EXCLUDE /* obsolete misleading naming */
 #define AUDIT_FILTER_FS		0x06	/* Apply rule at __audit_inode_child */
+#define AUDIT_FILTER_URING_EXIT	0x07	/* Apply rule at io_uring op exit */
 
-#define AUDIT_NR_FILTERS	7
+#define AUDIT_NR_FILTERS	8
 
 #define AUDIT_FILTER_PREPEND	0x10	/* Prepend to front of list */
 
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index db2c6b59dfc3..c21119c00504 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -44,7 +44,8 @@ struct list_head audit_filter_list[AUDIT_NR_FILTERS] = {
 	LIST_HEAD_INIT(audit_filter_list[4]),
 	LIST_HEAD_INIT(audit_filter_list[5]),
 	LIST_HEAD_INIT(audit_filter_list[6]),
-#if AUDIT_NR_FILTERS != 7
+	LIST_HEAD_INIT(audit_filter_list[7]),
+#if AUDIT_NR_FILTERS != 8
 #error Fix audit_filter_list initialiser
 #endif
 };
@@ -56,6 +57,7 @@ static struct list_head audit_rules_list[AUDIT_NR_FILTERS] = {
 	LIST_HEAD_INIT(audit_rules_list[4]),
 	LIST_HEAD_INIT(audit_rules_list[5]),
 	LIST_HEAD_INIT(audit_rules_list[6]),
+	LIST_HEAD_INIT(audit_rules_list[7]),
 };
 
 DEFINE_MUTEX(audit_filter_mutex);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index d8aa2c690bf9..4f6ab34020fb 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -799,6 +799,35 @@ static int audit_in_mask(const struct audit_krule *rule, unsigned long val)
 	return rule->mask[word] & bit;
 }
 
+/**
+ * audit_filter_uring - apply filters to an io_uring operation
+ * @tsk: associated task
+ * @ctx: audit context
+ */
+static void audit_filter_uring(struct task_struct *tsk,
+			       struct audit_context *ctx)
+{
+	struct audit_entry *e;
+	enum audit_state state;
+
+	if (auditd_test_task(tsk))
+		return;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_URING_EXIT],
+				list) {
+		if (audit_in_mask(&e->rule, ctx->uring_op) &&
+		    audit_filter_rules(tsk, &e->rule, ctx, NULL, &state,
+				       false)) {
+			rcu_read_unlock();
+			ctx->current_state = state;
+			return;
+		}
+	}
+	rcu_read_unlock();
+	return;
+}
+
 /* At syscall exit time, this filter is called if the audit_state is
  * not low enough that auditing cannot take place, but is also not
  * high enough that we already know we have to write an audit record
@@ -1754,7 +1783,7 @@ static void audit_log_exit(void)
  * __audit_free - free a per-task audit context
  * @tsk: task whose audit context block to free
  *
- * Called from copy_process and do_exit
+ * Called from copy_process, do_exit, and the io_uring code
  */
 void __audit_free(struct task_struct *tsk)
 {
@@ -1772,15 +1801,21 @@ void __audit_free(struct task_struct *tsk)
 	 * random task_struct that doesn't doesn't have any meaningful data we
 	 * need to log via audit_log_exit().
 	 */
-	if (tsk == current && !context->dummy &&
-	    context->context == AUDIT_CTX_SYSCALL) {
+	if (tsk == current && !context->dummy) {
 		context->return_valid = AUDITSC_INVALID;
 		context->return_code = 0;
-
-		audit_filter_syscall(tsk, context);
-		audit_filter_inodes(tsk, context);
-		if (context->current_state == AUDIT_RECORD_CONTEXT)
-			audit_log_exit();
+		if (context->context == AUDIT_CTX_SYSCALL) {
+			audit_filter_syscall(tsk, context);
+			audit_filter_inodes(tsk, context);
+			if (context->current_state == AUDIT_RECORD_CONTEXT)
+				audit_log_exit();
+		} else if (context->context == AUDIT_CTX_URING) {
+			/* TODO: verify this case is real and valid */
+			audit_filter_uring(tsk, context);
+			audit_filter_inodes(tsk, context);
+			if (context->current_state == AUDIT_RECORD_CONTEXT)
+				audit_log_uring(context);
+		}
 	}
 
 	audit_set_context(tsk, NULL);
@@ -1861,12 +1896,6 @@ void __audit_uring_exit(int success, long code)
 {
 	struct audit_context *ctx = audit_context();
 
-	/*
-	 * TODO: At some point we will likely want to filter on io_uring ops
-	 *       and other things similar to what we do for syscalls, but that
-	 *       is something for another day; just record what we can here.
-	 */
-
 	if (!ctx || ctx->dummy)
 		goto out;
 	if (ctx->context == AUDIT_CTX_SYSCALL) {
@@ -1891,6 +1920,8 @@ void __audit_uring_exit(int success, long code)
 		 * the behavior here.
 		 */
 		audit_filter_syscall(current, ctx);
+		if (ctx->current_state != AUDIT_RECORD_CONTEXT)
+			audit_filter_uring(current, ctx);
 		audit_filter_inodes(current, ctx);
 		if (ctx->current_state != AUDIT_RECORD_CONTEXT)
 			return;
@@ -1899,7 +1930,9 @@ void __audit_uring_exit(int success, long code)
 		return;
 	}
 #if 1
-	/* XXX - temporary hack to force record generation */
+	/* XXX - temporary hack to force record generation, we are leaving this
+	 *       enabled, but if you want to actually test the filtering you
+	 *       need to disable this #if/#endif block */
 	ctx->current_state = AUDIT_RECORD_CONTEXT;
 #endif
 
@@ -1907,6 +1940,8 @@ void __audit_uring_exit(int success, long code)
 	if (!list_empty(&ctx->killed_trees))
 		audit_kill_trees(ctx);
 
+	/* run through both filters to ensure we set the filterkey properly */
+	audit_filter_uring(current, ctx);
 	audit_filter_inodes(current, ctx);
 	if (ctx->current_state != AUDIT_RECORD_CONTEXT)
 		goto out;

