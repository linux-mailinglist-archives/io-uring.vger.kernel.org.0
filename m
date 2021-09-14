Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F79540A47E
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 05:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239019AbhINDe3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Sep 2021 23:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239115AbhINDeW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Sep 2021 23:34:22 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A7DC061760
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 20:33:06 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id c19so10146859qte.7
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 20:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=t9g7lwcAT63OmJcbTuIhhVl7/18uJfot7JKc7VxpTLM=;
        b=KAJ/YiLVYK1UchGEfENOfAoFfe5k1FTqpclI+V9RBs4YAU3DZNQJPjjzfHvJMHqUqd
         rHvi5zv3ykmPrkXtQ9a4G4ByeROkvDQ7NXhD+M03E53oKkLpTh42o3LbeU43VYWUFNmm
         3tIu8eqQsdgxZk8LImpLudWgzpGK2ahpsryY8Kaand24D/igoiWwdt+MkI1O219yJGrH
         +tPD1CR3rak2NdzxF8ZFlIpgTv1lU6xdo6kwNt1dFeacmtBxqGFMGsEm7cIx6m5BB8Fr
         hk45M58hPj8ASgnaQPrecYMvX1yAfQ7i4oj0A6lXtabqImmT2W9tKcilg9wbHUIXMhie
         cldQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=t9g7lwcAT63OmJcbTuIhhVl7/18uJfot7JKc7VxpTLM=;
        b=dno37QV+WxmSro3iVFPmBLajPcHjzKcNSsHReT+zMtOjPpPBS3vj0wNDu5SMv5Ukup
         IKo4HAj0W/78SS+039S1s5G6rEACadli2rEfijxFxsycgOT1/JBLH98BKzGjJho/pF1w
         1Qie4Q2ILIcZ6yoaKMu324iuG50D7k9jY00a0IZtenI0qZ2nhfKm/JItzuEJu6DA73YX
         kpVH0ae9iNEKbAFI/ry5HzqUI7C5t53d0DBrqfR3p8rzFIoPlEwduPjiV2Vb6Ne29sP3
         nPjp/HWLSAyYo1tXPjYCfzOnYeovNgFUXG5U1Ee3uiYqnkmp2FZvK0aJD0bv2kdyoyss
         8lFw==
X-Gm-Message-State: AOAM530Y67F5ZgN5jZlTv2elyjO7tvd0rZA8ColZV4fKbLquPq85D/tH
        dfn1SV02tbF7+8dYguI2j4Tz
X-Google-Smtp-Source: ABdhPJzzsbE4Yvg5HMBfV3FFXU2yOIOCzWZ5ia1i6/cyAB3o9i8facu5oS19BIJnK9BaM++hUKiw4g==
X-Received: by 2002:ac8:7c44:: with SMTP id o4mr2796915qtv.82.1631590385154;
        Mon, 13 Sep 2021 20:33:05 -0700 (PDT)
Received: from localhost (pool-96-237-52-188.bstnma.fios.verizon.net. [96.237.52.188])
        by smtp.gmail.com with ESMTPSA id t188sm6860143qkf.22.2021.09.13.20.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 20:33:04 -0700 (PDT)
Subject: [PATCH v3 2/8] audit,io_uring,io-wq: add some basic audit support to
 io_uring
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Mon, 13 Sep 2021 23:33:04 -0400
Message-ID: <163159038402.470089.1406703360189547052.stgit@olly>
In-Reply-To: <163159032713.470089.11728103630366176255.stgit@olly>
References: <163159032713.470089.11728103630366176255.stgit@olly>
User-Agent: StGit/1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch adds basic auditing to io_uring operations, regardless of
their context.  This is accomplished by allocating audit_context
structures for the io-wq worker and io_uring SQPOLL kernel threads
as well as explicitly auditing the io_uring operations in
io_issue_sqe().  Individual io_uring operations can bypass auditing
through the "audit_skip" field in the struct io_op_def definition for
the operation; although great care must be taken so that security
relevant io_uring operations do not bypass auditing; please contact
the audit mailing list (see the MAINTAINERS file) with any questions.

The io_uring operations are audited using a new AUDIT_URINGOP record,
an example is shown below:

  type=UNKNOWN[1336] msg=audit(1630523381.288:260):
    uring_op=19 success=yes exit=0 items=0 ppid=853 pid=1204
    auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0
    subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
    key=(null)
    AUID="root" UID="root" GID="root" EUID="root" SUID="root"
    FSUID="root" EGID="root" SGID="root" FSGID="root"

Thanks to Richard Guy Briggs for review and feedback.

Signed-off-by: Paul Moore <paul@paul-moore.com>

---
v3:
- removed work-in-progress warning from the description
v2:
- added dummy funcs for audit_uring_{entry,exit}()
- replaced opcode checks in io_issue_sqe() with audit_skip checks
- moved fastpath checks into audit_uring_{entry,exit}()
- audit_log_uring() uses GFP_ATOMIC
- don't record the arch in __audit_uring_entry()
v1:
- initial draft
---
 fs/io-wq.c                 |    4 +
 fs/io_uring.c              |   55 ++++++++++++--
 include/linux/audit.h      |   26 +++++++
 include/uapi/linux/audit.h |    1 
 kernel/audit.h             |    2 +
 kernel/auditsc.c           |  174 ++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 256 insertions(+), 6 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 6c55362c1f99..dac5c5961c9d 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -14,6 +14,7 @@
 #include <linux/rculist_nulls.h>
 #include <linux/cpu.h>
 #include <linux/tracehook.h>
+#include <linux/audit.h>
 
 #include "io-wq.h"
 
@@ -562,6 +563,8 @@ static int io_wqe_worker(void *data)
 	snprintf(buf, sizeof(buf), "iou-wrk-%d", wq->task->pid);
 	set_task_comm(current, buf);
 
+	audit_alloc_kernel(current);
+
 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
 		long ret;
 
@@ -601,6 +604,7 @@ static int io_wqe_worker(void *data)
 		io_worker_handle_work(worker);
 	}
 
+	audit_free(current);
 	io_worker_exit(worker);
 	return 0;
 }
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 16fb7436043c..388754b24785 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -79,6 +79,7 @@
 #include <linux/pagemap.h>
 #include <linux/io_uring.h>
 #include <linux/tracehook.h>
+#include <linux/audit.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -917,6 +918,8 @@ struct io_op_def {
 	unsigned		needs_async_setup : 1;
 	/* should block plug */
 	unsigned		plug : 1;
+	/* skip auditing */
+	unsigned		audit_skip : 1;
 	/* size of async data needed, if any */
 	unsigned short		async_size;
 };
@@ -930,6 +933,7 @@ static const struct io_op_def io_op_defs[] = {
 		.buffer_select		= 1,
 		.needs_async_setup	= 1,
 		.plug			= 1,
+		.audit_skip		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 	},
 	[IORING_OP_WRITEV] = {
@@ -939,16 +943,19 @@ static const struct io_op_def io_op_defs[] = {
 		.pollout		= 1,
 		.needs_async_setup	= 1,
 		.plug			= 1,
+		.audit_skip		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 	},
 	[IORING_OP_FSYNC] = {
 		.needs_file		= 1,
+		.audit_skip		= 1,
 	},
 	[IORING_OP_READ_FIXED] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.plug			= 1,
+		.audit_skip		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 	},
 	[IORING_OP_WRITE_FIXED] = {
@@ -957,15 +964,20 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.plug			= 1,
+		.audit_skip		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 	},
 	[IORING_OP_POLL_ADD] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.audit_skip		= 1,
+	},
+	[IORING_OP_POLL_REMOVE] = {
+		.audit_skip		= 1,
 	},
-	[IORING_OP_POLL_REMOVE] = {},
 	[IORING_OP_SYNC_FILE_RANGE] = {
 		.needs_file		= 1,
+		.audit_skip		= 1,
 	},
 	[IORING_OP_SENDMSG] = {
 		.needs_file		= 1,
@@ -983,18 +995,23 @@ static const struct io_op_def io_op_defs[] = {
 		.async_size		= sizeof(struct io_async_msghdr),
 	},
 	[IORING_OP_TIMEOUT] = {
+		.audit_skip		= 1,
 		.async_size		= sizeof(struct io_timeout_data),
 	},
 	[IORING_OP_TIMEOUT_REMOVE] = {
 		/* used by timeout updates' prep() */
+		.audit_skip		= 1,
 	},
 	[IORING_OP_ACCEPT] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 	},
-	[IORING_OP_ASYNC_CANCEL] = {},
+	[IORING_OP_ASYNC_CANCEL] = {
+		.audit_skip		= 1,
+	},
 	[IORING_OP_LINK_TIMEOUT] = {
+		.audit_skip		= 1,
 		.async_size		= sizeof(struct io_timeout_data),
 	},
 	[IORING_OP_CONNECT] = {
@@ -1009,14 +1026,19 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_OPENAT] = {},
 	[IORING_OP_CLOSE] = {},
-	[IORING_OP_FILES_UPDATE] = {},
-	[IORING_OP_STATX] = {},
+	[IORING_OP_FILES_UPDATE] = {
+		.audit_skip		= 1,
+	},
+	[IORING_OP_STATX] = {
+		.audit_skip		= 1,
+	},
 	[IORING_OP_READ] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.buffer_select		= 1,
 		.plug			= 1,
+		.audit_skip		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 	},
 	[IORING_OP_WRITE] = {
@@ -1025,39 +1047,50 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.plug			= 1,
+		.audit_skip		= 1,
 		.async_size		= sizeof(struct io_async_rw),
 	},
 	[IORING_OP_FADVISE] = {
 		.needs_file		= 1,
+		.audit_skip		= 1,
 	},
 	[IORING_OP_MADVISE] = {},
 	[IORING_OP_SEND] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
+		.audit_skip		= 1,
 	},
 	[IORING_OP_RECV] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.buffer_select		= 1,
+		.audit_skip		= 1,
 	},
 	[IORING_OP_OPENAT2] = {
 	},
 	[IORING_OP_EPOLL_CTL] = {
 		.unbound_nonreg_file	= 1,
+		.audit_skip		= 1,
 	},
 	[IORING_OP_SPLICE] = {
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.audit_skip		= 1,
+	},
+	[IORING_OP_PROVIDE_BUFFERS] = {
+		.audit_skip		= 1,
+	},
+	[IORING_OP_REMOVE_BUFFERS] = {
+		.audit_skip		= 1,
 	},
-	[IORING_OP_PROVIDE_BUFFERS] = {},
-	[IORING_OP_REMOVE_BUFFERS] = {},
 	[IORING_OP_TEE] = {
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.audit_skip		= 1,
 	},
 	[IORING_OP_SHUTDOWN] = {
 		.needs_file		= 1,
@@ -6591,6 +6624,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	if ((req->flags & REQ_F_CREDS) && req->creds != current_cred())
 		creds = override_creds(req->creds);
 
+	if (!io_op_defs[req->opcode].audit_skip)
+		audit_uring_entry(req->opcode);
+
 	switch (req->opcode) {
 	case IORING_OP_NOP:
 		ret = io_nop(req, issue_flags);
@@ -6706,6 +6742,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		break;
 	}
 
+	if (!io_op_defs[req->opcode].audit_skip)
+		audit_uring_exit(!ret, ret);
+
 	if (creds)
 		revert_creds(creds);
 	if (ret)
@@ -7360,6 +7399,8 @@ static int io_sq_thread(void *data)
 		set_cpus_allowed_ptr(current, cpu_online_mask);
 	current->flags |= PF_NO_SETAFFINITY;
 
+	audit_alloc_kernel(current);
+
 	mutex_lock(&sqd->lock);
 	while (1) {
 		bool cap_entries, sqt_spin = false;
@@ -7425,6 +7466,8 @@ static int io_sq_thread(void *data)
 	io_run_task_work();
 	mutex_unlock(&sqd->lock);
 
+	audit_free(current);
+
 	complete(&sqd->exited);
 	do_exit(0);
 }
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 82b7c1116a85..d656a06dd909 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -286,7 +286,10 @@ static inline int audit_signal_info(int sig, struct task_struct *t)
 /* These are defined in auditsc.c */
 				/* Public API */
 extern int  audit_alloc(struct task_struct *task);
+extern int  audit_alloc_kernel(struct task_struct *task);
 extern void __audit_free(struct task_struct *task);
+extern void __audit_uring_entry(u8 op);
+extern void __audit_uring_exit(int success, long code);
 extern void __audit_syscall_entry(int major, unsigned long a0, unsigned long a1,
 				  unsigned long a2, unsigned long a3);
 extern void __audit_syscall_exit(int ret_success, long ret_value);
@@ -323,6 +326,21 @@ static inline void audit_free(struct task_struct *task)
 	if (unlikely(task->audit_context))
 		__audit_free(task);
 }
+static inline void audit_uring_entry(u8 op)
+{
+	/*
+	 * We intentionally check audit_context() before audit_enabled as most
+	 * Linux systems (as of ~2021) rely on systemd which forces audit to
+	 * be enabled regardless of the user's audit configuration.
+	 */
+	if (unlikely(audit_context() && audit_enabled))
+		__audit_uring_entry(op);
+}
+static inline void audit_uring_exit(int success, long code)
+{
+	if (unlikely(!audit_dummy_context()))
+		__audit_uring_exit(success, code);
+}
 static inline void audit_syscall_entry(int major, unsigned long a0,
 				       unsigned long a1, unsigned long a2,
 				       unsigned long a3)
@@ -554,8 +572,16 @@ static inline int audit_alloc(struct task_struct *task)
 {
 	return 0;
 }
+static inline int audit_alloc_kernel(struct task_struct *task)
+{
+	return 0;
+}
 static inline void audit_free(struct task_struct *task)
 { }
+static inline void audit_uring_entry(u8 op)
+{ }
+static inline void audit_uring_exit(int success, long code)
+{ }
 static inline void audit_syscall_entry(int major, unsigned long a0,
 				       unsigned long a1, unsigned long a2,
 				       unsigned long a3)
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index daa481729e9b..a1997697c8b1 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -118,6 +118,7 @@
 #define AUDIT_TIME_ADJNTPVAL	1333	/* NTP value adjustment */
 #define AUDIT_BPF		1334	/* BPF subsystem */
 #define AUDIT_EVENT_LISTENER	1335	/* Task joined multicast read socket */
+#define AUDIT_URINGOP		1336	/* io_uring operation */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
diff --git a/kernel/audit.h b/kernel/audit.h
index 13abc48de0bd..d1161e3b83e2 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -103,10 +103,12 @@ struct audit_context {
 	enum {
 		AUDIT_CTX_UNUSED,	/* audit_context is currently unused */
 		AUDIT_CTX_SYSCALL,	/* in use by syscall */
+		AUDIT_CTX_URING,	/* in use by io_uring */
 	} context;
 	enum audit_state    state, current_state;
 	unsigned int	    serial;     /* serial number for record */
 	int		    major;      /* syscall number */
+	int		    uring_op;   /* uring operation */
 	struct timespec64   ctime;      /* time of syscall entry */
 	unsigned long	    argv[4];    /* syscall arguments */
 	long		    return_code;/* syscall return code */
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index c0383d554e61..62fb502da3fc 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -959,6 +959,7 @@ static void audit_reset_context(struct audit_context *ctx)
 	ctx->current_state = ctx->state;
 	ctx->serial = 0;
 	ctx->major = 0;
+	ctx->uring_op = 0;
 	ctx->ctime = (struct timespec64){ .tv_sec = 0, .tv_nsec = 0 };
 	memset(ctx->argv, 0, sizeof(ctx->argv));
 	ctx->return_code = 0;
@@ -1044,6 +1045,31 @@ int audit_alloc(struct task_struct *tsk)
 	return 0;
 }
 
+/**
+ * audit_alloc_kernel - allocate an audit_context for a kernel task
+ * @tsk: the kernel task
+ *
+ * Similar to the audit_alloc() function, but intended for kernel private
+ * threads.  Returns zero on success, negative values on failure.
+ */
+int audit_alloc_kernel(struct task_struct *tsk)
+{
+	/*
+	 * At the moment we are just going to call into audit_alloc() to
+	 * simplify the code, but there two things to keep in mind with this
+	 * approach:
+	 *
+	 * 1. Filtering internal kernel tasks is a bit laughable in almost all
+	 * cases, but there is at least one case where there is a benefit:
+	 * the '-a task,never' case allows the admin to effectively disable
+	 * task auditing at runtime.
+	 *
+	 * 2. The {set,clear}_task_syscall_work() ops likely have zero effect
+	 * on these internal kernel tasks, but they probably don't hurt either.
+	 */
+	return audit_alloc(tsk);
+}
+
 static inline void audit_free_context(struct audit_context *context)
 {
 	/* resetting is extra work, but it is likely just noise */
@@ -1546,6 +1572,52 @@ static void audit_log_proctitle(void)
 	audit_log_end(ab);
 }
 
+/**
+ * audit_log_uring - generate a AUDIT_URINGOP record
+ * @ctx: the audit context
+ */
+static void audit_log_uring(struct audit_context *ctx)
+{
+	struct audit_buffer *ab;
+	const struct cred *cred;
+
+	/*
+	 * TODO: What do we log here?  I'm tossing in a few things to start the
+	 *       conversation, but additional thought needs to go into this.
+	 */
+
+	ab = audit_log_start(ctx, GFP_ATOMIC, AUDIT_URINGOP);
+	if (!ab)
+		return;
+	cred = current_cred();
+	audit_log_format(ab, "uring_op=%d", ctx->uring_op);
+	if (ctx->return_valid != AUDITSC_INVALID)
+		audit_log_format(ab, " success=%s exit=%ld",
+				 (ctx->return_valid == AUDITSC_SUCCESS ?
+				  "yes" : "no"),
+				 ctx->return_code);
+	audit_log_format(ab,
+			 " items=%d"
+			 " ppid=%d pid=%d auid=%u uid=%u gid=%u"
+			 " euid=%u suid=%u fsuid=%u"
+			 " egid=%u sgid=%u fsgid=%u",
+			 ctx->name_count,
+			 task_ppid_nr(current),
+			 task_tgid_nr(current),
+			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
+			 from_kuid(&init_user_ns, cred->uid),
+			 from_kgid(&init_user_ns, cred->gid),
+			 from_kuid(&init_user_ns, cred->euid),
+			 from_kuid(&init_user_ns, cred->suid),
+			 from_kuid(&init_user_ns, cred->fsuid),
+			 from_kgid(&init_user_ns, cred->egid),
+			 from_kgid(&init_user_ns, cred->sgid),
+			 from_kgid(&init_user_ns, cred->fsgid));
+	audit_log_task_context(ab);
+	audit_log_key(ab, ctx->filterkey);
+	audit_log_end(ab);
+}
+
 static void audit_log_exit(void)
 {
 	int i, call_panic = 0;
@@ -1581,6 +1653,9 @@ static void audit_log_exit(void)
 		audit_log_key(ab, context->filterkey);
 		audit_log_end(ab);
 		break;
+	case AUDIT_CTX_URING:
+		audit_log_uring(context);
+		break;
 	default:
 		BUG();
 		break;
@@ -1751,6 +1826,105 @@ static void audit_return_fixup(struct audit_context *ctx,
 	ctx->return_valid = (success ? AUDITSC_SUCCESS : AUDITSC_FAILURE);
 }
 
+/**
+ * __audit_uring_entry - prepare the kernel task's audit context for io_uring
+ * @op: the io_uring opcode
+ *
+ * This is similar to audit_syscall_entry() but is intended for use by io_uring
+ * operations.  This function should only ever be called from
+ * audit_uring_entry() as we rely on the audit context checking present in that
+ * function.
+ */
+void __audit_uring_entry(u8 op)
+{
+	struct audit_context *ctx = audit_context();
+
+	if (ctx->state == AUDIT_STATE_DISABLED)
+		return;
+
+	/*
+	 * NOTE: It's possible that we can be called from the process' context
+	 *       before it returns to userspace, and before audit_syscall_exit()
+	 *       is called.  In this case there is not much to do, just record
+	 *       the io_uring details and return.
+	 */
+	ctx->uring_op = op;
+	if (ctx->context == AUDIT_CTX_SYSCALL)
+		return;
+
+	ctx->dummy = !audit_n_rules;
+	if (!ctx->dummy && ctx->state == AUDIT_STATE_BUILD)
+		ctx->prio = 0;
+
+	ctx->context = AUDIT_CTX_URING;
+	ctx->current_state = ctx->state;
+	ktime_get_coarse_real_ts64(&ctx->ctime);
+}
+
+/**
+ * __audit_uring_exit - wrap up the kernel task's audit context after io_uring
+ * @success: true/false value to indicate if the operation succeeded or not
+ * @code: operation return code
+ *
+ * This is similar to audit_syscall_exit() but is intended for use by io_uring
+ * operations.  This function should only ever be called from
+ * audit_uring_exit() as we rely on the audit context checking present in that
+ * function.
+ */
+void __audit_uring_exit(int success, long code)
+{
+	struct audit_context *ctx = audit_context();
+
+	/*
+	 * TODO: At some point we will likely want to filter on io_uring ops
+	 *       and other things similar to what we do for syscalls, but that
+	 *       is something for another day; just record what we can here.
+	 */
+
+	if (ctx->context == AUDIT_CTX_SYSCALL) {
+		/*
+		 * NOTE: See the note in __audit_uring_entry() about the case
+		 *       where we may be called from process context before we
+		 *       return to userspace via audit_syscall_exit().  In this
+		 *       case we simply emit a URINGOP record and bail, the
+		 *       normal syscall exit handling will take care of
+		 *       everything else.
+		 *       It is also worth mentioning that when we are called,
+		 *       the current process creds may differ from the creds
+		 *       used during the normal syscall processing; keep that
+		 *       in mind if/when we move the record generation code.
+		 */
+
+		/*
+		 * We need to filter on the syscall info here to decide if we
+		 * should emit a URINGOP record.  I know it seems odd but this
+		 * solves the problem where users have a filter to block *all*
+		 * syscall records in the "exit" filter; we want to preserve
+		 * the behavior here.
+		 */
+		audit_filter_syscall(current, ctx);
+		audit_filter_inodes(current, ctx);
+		if (ctx->current_state != AUDIT_STATE_RECORD)
+			return;
+
+		audit_log_uring(ctx);
+		return;
+	}
+
+	/* this may generate CONFIG_CHANGE records */
+	if (!list_empty(&ctx->killed_trees))
+		audit_kill_trees(ctx);
+
+	audit_filter_inodes(current, ctx);
+	if (ctx->current_state != AUDIT_STATE_RECORD)
+		goto out;
+	audit_return_fixup(ctx, success, code);
+	audit_log_exit();
+
+out:
+	audit_reset_context(ctx);
+}
+
 /**
  * __audit_syscall_entry - fill in an audit record at syscall entry
  * @major: major syscall type (function)

