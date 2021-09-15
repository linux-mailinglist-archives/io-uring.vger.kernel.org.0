Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819BE40CB0A
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 18:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbhIOQuu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 12:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhIOQuq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 12:50:46 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C88C061764
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 09:49:27 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id y144so4131308qkb.6
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 09:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=8YWBwc8uGURi99B99vwd2XzI3RwHX+SBu+1nlNcEp0s=;
        b=gwpSc+sqmGFD+7Rsw5ir/MUYxl2xHh50iwfRpgeexsO2MC2QxDT85IvfP9I7UPNF9P
         /dPDmio5IkwlHcUX2Nd8XhiITJYVU9sYtQF/JYIBCKGCmrM0dBkCOvgAtVTnwfLYPY9/
         rprML4FUAOY06MTnGtzt0GkzQSoPV0HV78ZBO+XvRQ8iUV4VxM+lK++6CND6nZ5LZaHv
         giaTdEBZG7npY50Quf9r3MEmbgUO3DcSGfrwDH5Bq7bajJwq4jDFKVsl/cs79GgQFfhX
         LWlbez7P46Dh84dPzT4vgklljf9lyL92UowljwiAmDB6ZqtVLl0txw6zuHAiSLrtmo5m
         ZyNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8YWBwc8uGURi99B99vwd2XzI3RwHX+SBu+1nlNcEp0s=;
        b=V5HXK9iDz5ROTbhPSsVu1lBd51F5j1QF8ecA1CSJ2XF1cUuMRTR2XN1Maqc4B4GlSj
         bc6LF6tQTuM636cL4TRYSI1Khr/TvMel/RKVdCDyKLd0myf23d6+UKTDJkmnhPOjzNuG
         XYZBZQOGa/U5VylVQVDiTFJ+isWaoaUIXExv0/AD+Hix/z02Mgvh516pVKyKPLF8ohBV
         9zk9j/T7oVlinJFUr0KpGrJHuJ/Z6HN+AOHuHiQym1bqtS6pz/0V+B6lH3aqXdGbElnX
         M4FFej+P7yat9df1vv/EJffjeamif43VXipNgfkwrx4Gk1kXT2voszUEYATejDHy/UlN
         C8Ig==
X-Gm-Message-State: AOAM533U4ohqRAJLX0hC1aGbSddsfoy9iDeq3NJaECWTfEeRUL2kfHQX
        fk8wdOU32VBCKPuWGnfMaQ58qQDb/IC+
X-Google-Smtp-Source: ABdhPJw7Op73H/5ylV88OdiIwTFRD0SHdDT0xIZ6LtpwdhTY4Jdqissl4uJTOcqq3JZy2Tv2wPon3Q==
X-Received: by 2002:a05:620a:11a9:: with SMTP id c9mr61961qkk.89.1631724566417;
        Wed, 15 Sep 2021 09:49:26 -0700 (PDT)
Received: from localhost (pool-96-237-52-188.bstnma.fios.verizon.net. [96.237.52.188])
        by smtp.gmail.com with ESMTPSA id 9sm266579qtz.83.2021.09.15.09.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 09:49:25 -0700 (PDT)
Subject: [PATCH v4 1/8] audit: prepare audit_context for use in calling
 contexts beyond syscalls
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Wed, 15 Sep 2021 12:49:25 -0400
Message-ID: <163172456530.88001.13707423554814526028.stgit@olly>
In-Reply-To: <163172413301.88001.16054830862146685573.stgit@olly>
References: <163172413301.88001.16054830862146685573.stgit@olly>
User-Agent: StGit/1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch cleans up some of our audit_context handling by
abstracting out the reset and return code fixup handling to dedicated
functions.  Not only does this help make things easier to read and
inspect, it allows for easier reuse by future patches.  We also
convert the simple audit_context->in_syscall flag into an enum which
can be used to by future patches to indicate a calling context other
than the syscall context.

Thanks to Richard Guy Briggs for review and feedback.

Acked-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>

---
v4:
- fix some spelling errors in the comments
v3:
- removed work-in-progress warning from the description
v2:
- no change
v1:
- initial draft
---
 kernel/audit.h   |    5 +
 kernel/auditsc.c |  256 ++++++++++++++++++++++++++++++++++--------------------
 2 files changed, 167 insertions(+), 94 deletions(-)

diff --git a/kernel/audit.h b/kernel/audit.h
index d6a2c899a8db..13abc48de0bd 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -100,7 +100,10 @@ struct audit_proctitle {
 /* The per-task audit context. */
 struct audit_context {
 	int		    dummy;	/* must be the first element */
-	int		    in_syscall;	/* 1 if task is in a syscall */
+	enum {
+		AUDIT_CTX_UNUSED,	/* audit_context is currently unused */
+		AUDIT_CTX_SYSCALL,	/* in use by syscall */
+	} context;
 	enum audit_state    state, current_state;
 	unsigned int	    serial;     /* serial number for record */
 	int		    major;      /* syscall number */
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 8dd73a64f921..f3d309b05c2d 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -915,10 +915,80 @@ static inline void audit_free_aux(struct audit_context *context)
 		context->aux = aux->next;
 		kfree(aux);
 	}
+	context->aux = NULL;
 	while ((aux = context->aux_pids)) {
 		context->aux_pids = aux->next;
 		kfree(aux);
 	}
+	context->aux_pids = NULL;
+}
+
+/**
+ * audit_reset_context - reset a audit_context structure
+ * @ctx: the audit_context to reset
+ *
+ * All fields in the audit_context will be reset to an initial state, all
+ * references held by fields will be dropped, and private memory will be
+ * released.  When this function returns the audit_context will be suitable
+ * for reuse, so long as the passed context is not NULL or a dummy context.
+ */
+static void audit_reset_context(struct audit_context *ctx)
+{
+	if (!ctx)
+		return;
+
+	/* if ctx is non-null, reset the "ctx->state" regardless */
+	ctx->context = AUDIT_CTX_UNUSED;
+	if (ctx->dummy)
+		return;
+
+	/*
+	 * NOTE: It shouldn't matter in what order we release the fields, so
+	 *       release them in the order in which they appear in the struct;
+	 *       this gives us some hope of quickly making sure we are
+	 *       resetting the audit_context properly.
+	 *
+	 *       Other things worth mentioning:
+	 *       - we don't reset "dummy"
+	 *       - we don't reset "state", we do reset "current_state"
+	 *       - we preserve "filterkey" if "state" is AUDIT_STATE_RECORD
+	 *       - much of this is likely overkill, but play it safe for now
+	 *       - we really need to work on improving the audit_context struct
+	 */
+
+	ctx->current_state = ctx->state;
+	ctx->serial = 0;
+	ctx->major = 0;
+	ctx->ctime = (struct timespec64){ .tv_sec = 0, .tv_nsec = 0 };
+	memset(ctx->argv, 0, sizeof(ctx->argv));
+	ctx->return_code = 0;
+	ctx->prio = (ctx->state == AUDIT_STATE_RECORD ? ~0ULL : 0);
+	ctx->return_valid = AUDITSC_INVALID;
+	audit_free_names(ctx);
+	if (ctx->state != AUDIT_STATE_RECORD) {
+		kfree(ctx->filterkey);
+		ctx->filterkey = NULL;
+	}
+	audit_free_aux(ctx);
+	kfree(ctx->sockaddr);
+	ctx->sockaddr = NULL;
+	ctx->sockaddr_len = 0;
+	ctx->pid = ctx->ppid = 0;
+	ctx->uid = ctx->euid = ctx->suid = ctx->fsuid = KUIDT_INIT(0);
+	ctx->gid = ctx->egid = ctx->sgid = ctx->fsgid = KGIDT_INIT(0);
+	ctx->personality = 0;
+	ctx->arch = 0;
+	ctx->target_pid = 0;
+	ctx->target_auid = ctx->target_uid = KUIDT_INIT(0);
+	ctx->target_sessionid = 0;
+	ctx->target_sid = 0;
+	ctx->target_comm[0] = '\0';
+	unroll_tree_refs(ctx, NULL, 0);
+	WARN_ON(!list_empty(&ctx->killed_trees));
+	ctx->type = 0;
+	audit_free_module(ctx);
+	ctx->fds[0] = -1;
+	audit_proctitle_free(ctx);
 }
 
 static inline struct audit_context *audit_alloc_context(enum audit_state state)
@@ -928,6 +998,7 @@ static inline struct audit_context *audit_alloc_context(enum audit_state state)
 	context = kzalloc(sizeof(*context), GFP_KERNEL);
 	if (!context)
 		return NULL;
+	context->context = AUDIT_CTX_UNUSED;
 	context->state = state;
 	context->prio = state == AUDIT_STATE_RECORD ? ~0ULL : 0;
 	INIT_LIST_HEAD(&context->killed_trees);
@@ -953,7 +1024,7 @@ int audit_alloc(struct task_struct *tsk)
 	char *key = NULL;
 
 	if (likely(!audit_ever_enabled))
-		return 0; /* Return if not auditing. */
+		return 0;
 
 	state = audit_filter_task(tsk, &key);
 	if (state == AUDIT_STATE_DISABLED) {
@@ -975,14 +1046,10 @@ int audit_alloc(struct task_struct *tsk)
 
 static inline void audit_free_context(struct audit_context *context)
 {
-	audit_free_module(context);
-	audit_free_names(context);
-	unroll_tree_refs(context, NULL, 0);
+	/* resetting is extra work, but it is likely just noise */
+	audit_reset_context(context);
 	free_tree_refs(context);
-	audit_free_aux(context);
 	kfree(context->filterkey);
-	kfree(context->sockaddr);
-	audit_proctitle_free(context);
 	kfree(context);
 }
 
@@ -1489,29 +1556,35 @@ static void audit_log_exit(void)
 
 	context->personality = current->personality;
 
-	ab = audit_log_start(context, GFP_KERNEL, AUDIT_SYSCALL);
-	if (!ab)
-		return;		/* audit_panic has been called */
-	audit_log_format(ab, "arch=%x syscall=%d",
-			 context->arch, context->major);
-	if (context->personality != PER_LINUX)
-		audit_log_format(ab, " per=%lx", context->personality);
-	if (context->return_valid != AUDITSC_INVALID)
-		audit_log_format(ab, " success=%s exit=%ld",
-				 (context->return_valid==AUDITSC_SUCCESS)?"yes":"no",
-				 context->return_code);
-
-	audit_log_format(ab,
-			 " a0=%lx a1=%lx a2=%lx a3=%lx items=%d",
-			 context->argv[0],
-			 context->argv[1],
-			 context->argv[2],
-			 context->argv[3],
-			 context->name_count);
-
-	audit_log_task_info(ab);
-	audit_log_key(ab, context->filterkey);
-	audit_log_end(ab);
+	switch (context->context) {
+	case AUDIT_CTX_SYSCALL:
+		ab = audit_log_start(context, GFP_KERNEL, AUDIT_SYSCALL);
+		if (!ab)
+			return;
+		audit_log_format(ab, "arch=%x syscall=%d",
+				 context->arch, context->major);
+		if (context->personality != PER_LINUX)
+			audit_log_format(ab, " per=%lx", context->personality);
+		if (context->return_valid != AUDITSC_INVALID)
+			audit_log_format(ab, " success=%s exit=%ld",
+					 (context->return_valid == AUDITSC_SUCCESS ?
+					  "yes" : "no"),
+					 context->return_code);
+		audit_log_format(ab,
+				 " a0=%lx a1=%lx a2=%lx a3=%lx items=%d",
+				 context->argv[0],
+				 context->argv[1],
+				 context->argv[2],
+				 context->argv[3],
+				 context->name_count);
+		audit_log_task_info(ab);
+		audit_log_key(ab, context->filterkey);
+		audit_log_end(ab);
+		break;
+	default:
+		BUG();
+		break;
+	}
 
 	for (aux = context->aux; aux; aux = aux->next) {
 
@@ -1602,14 +1675,15 @@ static void audit_log_exit(void)
 		audit_log_name(context, n, NULL, i++, &call_panic);
 	}
 
-	audit_log_proctitle();
+	if (context->context == AUDIT_CTX_SYSCALL)
+		audit_log_proctitle();
 
 	/* Send end of event record to help user space know we are finished */
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
 	if (ab)
 		audit_log_end(ab);
 	if (call_panic)
-		audit_panic("error converting sid to string");
+		audit_panic("error in audit_log_exit()");
 }
 
 /**
@@ -1625,6 +1699,7 @@ void __audit_free(struct task_struct *tsk)
 	if (!context)
 		return;
 
+	/* this may generate CONFIG_CHANGE records */
 	if (!list_empty(&context->killed_trees))
 		audit_kill_trees(context);
 
@@ -1633,7 +1708,8 @@ void __audit_free(struct task_struct *tsk)
 	 * random task_struct that doesn't doesn't have any meaningful data we
 	 * need to log via audit_log_exit().
 	 */
-	if (tsk == current && !context->dummy && context->in_syscall) {
+	if (tsk == current && !context->dummy &&
+	    context->context == AUDIT_CTX_SYSCALL) {
 		context->return_valid = AUDITSC_INVALID;
 		context->return_code = 0;
 
@@ -1647,6 +1723,34 @@ void __audit_free(struct task_struct *tsk)
 	audit_free_context(context);
 }
 
+/**
+ * audit_return_fixup - fixup the return codes in the audit_context
+ * @ctx: the audit_context
+ * @success: true/false value to indicate if the operation succeeded or not
+ * @code: operation return code
+ *
+ * We need to fixup the return code in the audit logs if the actual return
+ * codes are later going to be fixed by the arch specific signal handlers.
+ */
+static void audit_return_fixup(struct audit_context *ctx,
+			       int success, long code)
+{
+	/*
+	 * This is actually a test for:
+	 * (rc == ERESTARTSYS ) || (rc == ERESTARTNOINTR) ||
+	 * (rc == ERESTARTNOHAND) || (rc == ERESTART_RESTARTBLOCK)
+	 *
+	 * but is faster than a bunch of ||
+	 */
+	if (unlikely(code <= -ERESTARTSYS) &&
+	    (code >= -ERESTART_RESTARTBLOCK) &&
+	    (code != -ENOIOCTLCMD))
+		ctx->return_code = -EINTR;
+	else
+		ctx->return_code  = code;
+	ctx->return_valid = (success ? AUDITSC_SUCCESS : AUDITSC_FAILURE);
+}
+
 /**
  * __audit_syscall_entry - fill in an audit record at syscall entry
  * @major: major syscall type (function)
@@ -1672,7 +1776,12 @@ void __audit_syscall_entry(int major, unsigned long a1, unsigned long a2,
 	if (!audit_enabled || !context)
 		return;
 
-	BUG_ON(context->in_syscall || context->name_count);
+	WARN_ON(context->context != AUDIT_CTX_UNUSED);
+	WARN_ON(context->name_count);
+	if (context->context != AUDIT_CTX_UNUSED || context->name_count) {
+		audit_panic("unrecoverable error in audit_syscall_entry()");
+		return;
+	}
 
 	state = context->state;
 	if (state == AUDIT_STATE_DISABLED)
@@ -1691,10 +1800,8 @@ void __audit_syscall_entry(int major, unsigned long a1, unsigned long a2,
 	context->argv[1]    = a2;
 	context->argv[2]    = a3;
 	context->argv[3]    = a4;
-	context->serial     = 0;
-	context->in_syscall = 1;
+	context->context = AUDIT_CTX_SYSCALL;
 	context->current_state  = state;
-	context->ppid       = 0;
 	ktime_get_coarse_real_ts64(&context->ctime);
 }
 
@@ -1711,63 +1818,27 @@ void __audit_syscall_entry(int major, unsigned long a1, unsigned long a2,
  */
 void __audit_syscall_exit(int success, long return_code)
 {
-	struct audit_context *context;
+	struct audit_context *context = audit_context();
 
-	context = audit_context();
-	if (!context)
-		return;
+	if (!context || context->dummy ||
+	    context->context != AUDIT_CTX_SYSCALL)
+		goto out;
 
+	/* this may generate CONFIG_CHANGE records */
 	if (!list_empty(&context->killed_trees))
 		audit_kill_trees(context);
 
-	if (!context->dummy && context->in_syscall) {
-		if (success)
-			context->return_valid = AUDITSC_SUCCESS;
-		else
-			context->return_valid = AUDITSC_FAILURE;
-
-		/*
-		 * we need to fix up the return code in the audit logs if the
-		 * actual return codes are later going to be fixed up by the
-		 * arch specific signal handlers
-		 *
-		 * This is actually a test for:
-		 * (rc == ERESTARTSYS ) || (rc == ERESTARTNOINTR) ||
-		 * (rc == ERESTARTNOHAND) || (rc == ERESTART_RESTARTBLOCK)
-		 *
-		 * but is faster than a bunch of ||
-		 */
-		if (unlikely(return_code <= -ERESTARTSYS) &&
-		    (return_code >= -ERESTART_RESTARTBLOCK) &&
-		    (return_code != -ENOIOCTLCMD))
-			context->return_code = -EINTR;
-		else
-			context->return_code  = return_code;
-
-		audit_filter_syscall(current, context);
-		audit_filter_inodes(current, context);
-		if (context->current_state == AUDIT_STATE_RECORD)
-			audit_log_exit();
-	}
+	/* run through both filters to ensure we set the filterkey properly */
+	audit_filter_syscall(current, context);
+	audit_filter_inodes(current, context);
+	if (context->current_state < AUDIT_STATE_RECORD)
+		goto out;
 
-	context->in_syscall = 0;
-	context->prio = context->state == AUDIT_STATE_RECORD ? ~0ULL : 0;
+	audit_return_fixup(context, success, return_code);
+	audit_log_exit();
 
-	audit_free_module(context);
-	audit_free_names(context);
-	unroll_tree_refs(context, NULL, 0);
-	audit_free_aux(context);
-	context->aux = NULL;
-	context->aux_pids = NULL;
-	context->target_pid = 0;
-	context->target_sid = 0;
-	context->sockaddr_len = 0;
-	context->type = 0;
-	context->fds[0] = -1;
-	if (context->state != AUDIT_STATE_RECORD) {
-		kfree(context->filterkey);
-		context->filterkey = NULL;
-	}
+out:
+	audit_reset_context(context);
 }
 
 static inline void handle_one(const struct inode *inode)
@@ -1919,7 +1990,7 @@ void __audit_getname(struct filename *name)
 	struct audit_context *context = audit_context();
 	struct audit_names *n;
 
-	if (!context->in_syscall)
+	if (context->context == AUDIT_CTX_UNUSED)
 		return;
 
 	n = audit_alloc_name(context, AUDIT_TYPE_UNKNOWN);
@@ -1991,7 +2062,7 @@ void __audit_inode(struct filename *name, const struct dentry *dentry,
 	struct list_head *list = &audit_filter_list[AUDIT_FILTER_FS];
 	int i;
 
-	if (!context->in_syscall)
+	if (context->context == AUDIT_CTX_UNUSED)
 		return;
 
 	rcu_read_lock();
@@ -2109,7 +2180,7 @@ void __audit_inode_child(struct inode *parent,
 	struct list_head *list = &audit_filter_list[AUDIT_FILTER_FS];
 	int i;
 
-	if (!context->in_syscall)
+	if (context->context == AUDIT_CTX_UNUSED)
 		return;
 
 	rcu_read_lock();
@@ -2208,7 +2279,7 @@ EXPORT_SYMBOL_GPL(__audit_inode_child);
 int auditsc_get_stamp(struct audit_context *ctx,
 		       struct timespec64 *t, unsigned int *serial)
 {
-	if (!ctx->in_syscall)
+	if (ctx->context == AUDIT_CTX_UNUSED)
 		return 0;
 	if (!ctx->serial)
 		ctx->serial = audit_serial();
@@ -2706,8 +2777,7 @@ void audit_seccomp_actions_logged(const char *names, const char *old_names,
 struct list_head *audit_killed_trees(void)
 {
 	struct audit_context *ctx = audit_context();
-
-	if (likely(!ctx || !ctx->in_syscall))
+	if (likely(!ctx || ctx->context == AUDIT_CTX_UNUSED))
 		return NULL;
 	return &ctx->killed_trees;
 }

