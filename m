Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43FD06E9BB2
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 20:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjDTScb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Apr 2023 14:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbjDTScJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Apr 2023 14:32:09 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CAD4ECF
        for <io-uring@vger.kernel.org>; Thu, 20 Apr 2023 11:31:40 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-760e332e1b3so7676039f.0
        for <io-uring@vger.kernel.org>; Thu, 20 Apr 2023 11:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682015499; x=1684607499;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CnGEhGdXV2Z1x5XhnHR3IqlvZK4t9CqIhqNFlRmuKGg=;
        b=JcLMZ9IDlCm5HL7H67/6MFp8Vgief9wRahLbJwXdphHZOvahhH+4Dy7gEe4ipeudFl
         UHxCW7z5IHeo1RejN2hg6515LooNaWlC7gOh2QN7mBTUwcIO8eE5uwNdlT/XwHi5WhEt
         pY9rD4AONeeg3jNNC2khmr/2WwcWu7CVPqpnzgwsIslCx/AOYekhxMwghI0WcAgcTP2q
         YKYse5h4/tSybXDkRIxNzFmHDWfKlyFVWFMtpa3DHcF+myvIQiygYB0gn39FanZrWNiC
         7szYvzzp/riWL0HXR+x2JkmD3F9KQ7cWyXkbh0vOggyAZ6BQxSo6ZcJafFaP21BJKLzK
         oyfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682015499; x=1684607499;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CnGEhGdXV2Z1x5XhnHR3IqlvZK4t9CqIhqNFlRmuKGg=;
        b=L8nluGth8LIZyZQTCy1ryVW6KfZ5HJhSTcVWmewcY0DlUzZc39mKwsYtBgzh1CooUu
         DWQOhLU8WeYlDAsOxpw+HyzyVFPqtxyvFx1k2BFyw+Q1prcP5b30aaczIo4UR/M0qPJC
         iEd8BveMTgktdFWQT3nP4llxdW5QwQXz4TYhslikBFCDfBO4cBcJdCr3aW6bffrSaoOr
         V9txr8RTADvQk0icnbqrHqpz2V0q7AGMt5nn7X7FPFfGvH2IY2KO/WBtgurXLOE4C9iu
         A/Ntaizj/Ah+CUS1m3m6p3oz1WMZjTx/dBqx/J30T1W+v3h6K/XhAwigU+FuuI7DOVr9
         /cPw==
X-Gm-Message-State: AAQBX9cK5MqMUDTjTLQRm6zvaxIM8etODSe3LmKkfg3j0CgSjOki2XbC
        +hGPXwTyPWv+/bsOeuAdMCytpOwmCogL6gvw1Pk=
X-Google-Smtp-Source: AKy350Z7xcr1ZBkSDdg8BVgOplRPS4FCJhcx3+LAUkS81sbhhFlhnVklbcoEwtIkdhqdeH9uMfIc+g==
X-Received: by 2002:a05:6e02:188d:b0:325:e639:76aa with SMTP id o13-20020a056e02188d00b00325e63976aamr1861129ilu.1.1682015498787;
        Thu, 20 Apr 2023 11:31:38 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id dl36-20020a05663827a400b003c4e02148e5sm659132jab.53.2023.04.20.11.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 11:31:38 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: add support for NO_OFFLOAD
Date:   Thu, 20 Apr 2023 12:31:32 -0600
Message-Id: <20230420183135.119618-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420183135.119618-1-axboe@kernel.dk>
References: <20230420183135.119618-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some applications don't necessarily care about io_uring not blocking for
request issue, they simply want to use io_uring for batched submission
of IO. However, io_uring will always do non-blocking issues, and for
some request types, there's simply no support for doing non-blocking
issue and hence they get punted to io-wq unconditionally. If the
application doesn't care about issue potentially blocking, this causes
a performance slowdown as thread offload is not nearly as efficient as
inline issue.

Add support for configuring the ring with IORING_SETUP_NO_OFFLOAD, and
add an IORING_ENTER_NO_OFFLOAD flag to io_uring_enter(2). If either one
of these is set, then io_uring will ignore the non-block issue attempt
for any file which we cannot poll for readiness. The simplified io_uring
issue model looks as follows:

1) Non-blocking issue is attempted for IO. If successful, we're done for
   now.

2) Case 1 failed. Now we have two options
  	a) We can poll the file. We arm poll, and we're done for now
	   until that triggers.
   	b) File cannot be polled, we punt to io-wq which then does a
	   blocking attempt.

If either of the NO_OFFLOAD flags are set, we should never hit case
2b. Instead, case 1 would issue the IO without the non-blocking flag
being set and perform an inline completion.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring.h      |  1 +
 include/uapi/linux/io_uring.h |  7 +++++
 io_uring/io_uring.c           | 52 +++++++++++++++++++++++++----------
 io_uring/io_uring.h           |  2 +-
 io_uring/sqpoll.c             |  6 ++--
 5 files changed, 50 insertions(+), 18 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 35b9328ca335..386d6b722481 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -13,6 +13,7 @@ enum io_uring_cmd_flags {
 	IO_URING_F_MULTISHOT		= 4,
 	/* executed by io-wq */
 	IO_URING_F_IOWQ			= 8,
+	IO_URING_F_NO_OFFLOAD		= 16,
 	/* int's last bit, sign checks are usually faster than a bit test */
 	IO_URING_F_NONBLOCK		= INT_MIN,
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 0716cb17e436..ea903a677ce9 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -173,6 +173,12 @@ enum {
  */
 #define IORING_SETUP_DEFER_TASKRUN	(1U << 13)
 
+/*
+ * Don't attempt non-blocking issue on file types that would otherwise
+ * punt to io-wq if they cannot be completed non-blocking.
+ */
+#define IORING_SETUP_NO_OFFLOAD		(1U << 14)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
@@ -443,6 +449,7 @@ struct io_cqring_offsets {
 #define IORING_ENTER_SQ_WAIT		(1U << 2)
 #define IORING_ENTER_EXT_ARG		(1U << 3)
 #define IORING_ENTER_REGISTERED_RING	(1U << 4)
+#define IORING_ENTER_NO_OFFLOAD		(1U << 5)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3d43df8f1e4e..fee3e461e149 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -147,7 +147,7 @@ static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 
 static void io_dismantle_req(struct io_kiocb *req);
 static void io_clean_op(struct io_kiocb *req);
-static void io_queue_sqe(struct io_kiocb *req);
+static void io_queue_sqe(struct io_kiocb *req, unsigned int issue_flags);
 static void io_move_task_work_from_local(struct io_ring_ctx *ctx);
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx);
 static __cold void io_fallback_tw(struct io_uring_task *tctx);
@@ -1471,7 +1471,7 @@ void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts)
 	else if (req->flags & REQ_F_FORCE_ASYNC)
 		io_queue_iowq(req, ts);
 	else
-		io_queue_sqe(req);
+		io_queue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
 }
 
 void io_req_task_queue_fail(struct io_kiocb *req, int ret)
@@ -1947,6 +1947,10 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!io_assign_file(req, def, issue_flags)))
 		return -EBADF;
 
+	if (issue_flags & IO_URING_F_NO_OFFLOAD &&
+	    (!req->file || !file_can_poll(req->file)))
+		issue_flags &= ~IO_URING_F_NONBLOCK;
+
 	if (unlikely((req->flags & REQ_F_CREDS) && req->creds != current_cred()))
 		creds = override_creds(req->creds);
 
@@ -2120,12 +2124,12 @@ static void io_queue_async(struct io_kiocb *req, int ret)
 		io_queue_linked_timeout(linked_timeout);
 }
 
-static inline void io_queue_sqe(struct io_kiocb *req)
+static inline void io_queue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	__must_hold(&req->ctx->uring_lock)
 {
 	int ret;
 
-	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
+	ret = io_issue_sqe(req, issue_flags);
 
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
@@ -2337,7 +2341,8 @@ static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
 }
 
 static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
-			 const struct io_uring_sqe *sqe)
+			 const struct io_uring_sqe *sqe,
+			 unsigned int aux_issue_flags)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_link *link = &ctx->submit_state.link;
@@ -2385,7 +2390,8 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		return 0;
 	}
 
-	io_queue_sqe(req);
+	io_queue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER|
+		     aux_issue_flags);
 	return 0;
 }
 
@@ -2466,7 +2472,8 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 	return false;
 }
 
-int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
+int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
+		   unsigned int aux_issue_flags)
 	__must_hold(&ctx->uring_lock)
 {
 	unsigned int entries = io_sqring_entries(ctx);
@@ -2495,7 +2502,7 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		 * Continue submitting even for sqe failure if the
 		 * ring was setup with IORING_SETUP_SUBMIT_ALL
 		 */
-		if (unlikely(io_submit_sqe(ctx, req, sqe)) &&
+		if (unlikely(io_submit_sqe(ctx, req, sqe, aux_issue_flags)) &&
 		    !(ctx->flags & IORING_SETUP_SUBMIT_ALL)) {
 			left--;
 			break;
@@ -3524,7 +3531,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 
 	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
 			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
-			       IORING_ENTER_REGISTERED_RING)))
+			       IORING_ENTER_REGISTERED_RING |
+			       IORING_ENTER_NO_OFFLOAD)))
 		return -EINVAL;
 
 	/*
@@ -3575,12 +3583,18 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 
 		ret = to_submit;
 	} else if (to_submit) {
+		unsigned int aux_issue_flags = 0;
+
 		ret = io_uring_add_tctx_node(ctx);
 		if (unlikely(ret))
 			goto out;
 
+		if (flags & IORING_ENTER_NO_OFFLOAD ||
+		    ctx->flags & IORING_SETUP_NO_OFFLOAD)
+			aux_issue_flags = IO_URING_F_NO_OFFLOAD;
+
 		mutex_lock(&ctx->uring_lock);
-		ret = io_submit_sqes(ctx, to_submit);
+		ret = io_submit_sqes(ctx, to_submit, aux_issue_flags);
 		if (ret != to_submit) {
 			mutex_unlock(&ctx->uring_lock);
 			goto out;
@@ -3827,9 +3841,17 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	 * polling again, they can rely on io_sq_thread to do polling
 	 * work, which can reduce cpu usage and uring_lock contention.
 	 */
-	if (ctx->flags & IORING_SETUP_IOPOLL &&
-	    !(ctx->flags & IORING_SETUP_SQPOLL))
-		ctx->syscall_iopoll = 1;
+	ret = -EINVAL;
+	if (ctx->flags & IORING_SETUP_IOPOLL) {
+		/*
+		 * Can't sanely block for issue for IOPOLL, nor does this
+		 * combination make any sense. Disallow it.
+		 */
+		if (ctx->flags & IORING_SETUP_NO_OFFLOAD)
+			goto err;
+		if (!(ctx->flags & IORING_SETUP_SQPOLL))
+			ctx->syscall_iopoll = 1;
+	}
 
 	ctx->compat = in_compat_syscall();
 	if (!capable(CAP_IPC_LOCK))
@@ -3839,7 +3861,6 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	 * For SQPOLL, we just need a wakeup, always. For !SQPOLL, if
 	 * COOP_TASKRUN is set, then IPIs are never needed by the app.
 	 */
-	ret = -EINVAL;
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		/* IPI related flags don't make sense with SQPOLL */
 		if (ctx->flags & (IORING_SETUP_COOP_TASKRUN |
@@ -3969,7 +3990,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
 			IORING_SETUP_COOP_TASKRUN | IORING_SETUP_TASKRUN_FLAG |
 			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
-			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN))
+			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
+			IORING_SETUP_NO_OFFLOAD))
 		return -EINVAL;
 
 	return io_uring_create(entries, &p, params);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 25515d69d205..fb3619ae0fd3 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -76,7 +76,7 @@ int io_uring_alloc_task_context(struct task_struct *task,
 				struct io_ring_ctx *ctx);
 
 int io_poll_issue(struct io_kiocb *req, struct io_tw_state *ts);
-int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr);
+int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr, unsigned int aux_issue_flags);
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin);
 void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node);
 int io_req_prep_async(struct io_kiocb *req);
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 9db4bc1f521a..9f2968a441ce 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -166,7 +166,7 @@ static inline bool io_sqd_events_pending(struct io_sq_data *sqd)
 
 static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 {
-	unsigned int to_submit;
+	unsigned int to_submit, aux_issue_flags = 0;
 	int ret = 0;
 
 	to_submit = io_sqring_entries(ctx);
@@ -179,6 +179,8 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 
 		if (ctx->sq_creds != current_cred())
 			creds = override_creds(ctx->sq_creds);
+		if (ctx->flags & IORING_SETUP_NO_OFFLOAD)
+			aux_issue_flags = IO_URING_F_NO_OFFLOAD;
 
 		mutex_lock(&ctx->uring_lock);
 		if (!wq_list_empty(&ctx->iopoll_list))
@@ -190,7 +192,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 		 */
 		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)) &&
 		    !(ctx->flags & IORING_SETUP_R_DISABLED))
-			ret = io_submit_sqes(ctx, to_submit);
+			ret = io_submit_sqes(ctx, to_submit, aux_issue_flags);
 		mutex_unlock(&ctx->uring_lock);
 
 		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
-- 
2.39.2

