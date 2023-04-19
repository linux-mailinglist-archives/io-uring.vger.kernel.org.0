Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4616E7F94
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 18:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbjDSQ0B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 12:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbjDSQ0A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 12:26:00 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC70410C1
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 09:25:58 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-63b7b18a336so11252b3a.1
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 09:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681921558; x=1684513558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YwYrlY5CnjdbXSCvAeq+mcm2xkAzawti+ArxhyJebv4=;
        b=m1b7S5Bg39SqRKV+vQbPBGPTjHRqt/q0FCJzZLEXaamHpVDnv8GT96gyfRuXKFivcJ
         e3XVJxQZkYGw8ov8ojO8rTBd60ar5P9VVMAEFtZsaDum7FZAVQS81SNJqeDjyJw9/l6z
         Au2/dK4ySlBISQXfvpYYOoYUSBbXRyOIJDwX8wa+WIDd2B2hSJQY/cYfEWEW19Ux8ytP
         GpaqJy+MX/q/ihynadOHvn3RDAyWE+5BW/0dfq+F2gFk1Yu4jUCR1WXVgEV5tb8KvT9a
         5s/UfT5tKZ2vF6Accd6GbO5+V68AVxOOagVfQw3VMHyZbrKt6UOm5/6nCSNaS1yysTry
         zi/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681921558; x=1684513558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YwYrlY5CnjdbXSCvAeq+mcm2xkAzawti+ArxhyJebv4=;
        b=BFTgYvskmIL/49InOSlcHc/lTf1WpW8Kd13xGMqBAiJFTA1bL6Gb3DyMc6a0USKOGd
         nEU1xIvkSFJIEEtUgIgo1pFClNg931qO4Pu3JvWi20bPm2DPXqr2foEZWdIr8VDY1+F/
         rVeQcMKu1HgyMru6JAcEEqWFI+rVUAvUZ3sPLH20wQ1Rt1KNyEEn2kghUxiy4PwWMsxl
         xLdn5xZs0SchSPZOb344HOfelkeudF3F30CljYxNSMd343mBiU8M9/lfvOlBUDsCmS9d
         LH0BER2lCcBQpwWt8xA9zihsvxtzhWh9In9FH8XBcJEV8ZVXkp+3Pt76ayDQbnhpKeD+
         ChFQ==
X-Gm-Message-State: AAQBX9d5nr+4r2aSXEi38X5VUQ4E5ZDZaQuVhK4tyRBqeaCFzFf0L2gi
        zOTEfl1uklHna5ZSddHU6hGlYaNsGUMXUfEc5h0=
X-Google-Smtp-Source: AKy350YAW6Dck9P0dOhM/4ITciGkiRcBYocqYUz4FQt6QlVnNUJHdqZ6dbNDyCkkzOM8bFAptXmacg==
X-Received: by 2002:a05:6a00:338f:b0:5e4:f141:568b with SMTP id cm15-20020a056a00338f00b005e4f141568bmr19984387pfb.3.1681921557616;
        Wed, 19 Apr 2023 09:25:57 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k19-20020aa790d3000000b0063d2cd02d69sm4531334pfk.54.2023.04.19.09.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 09:25:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     luhongfei@vivo.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] io_uring: add support for NO_OFFLOAD
Date:   Wed, 19 Apr 2023 10:25:49 -0600
Message-Id: <20230419162552.576489-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230419162552.576489-1-axboe@kernel.dk>
References: <20230419162552.576489-1-axboe@kernel.dk>
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
 include/linux/io_uring_types.h |  3 +++
 include/uapi/linux/io_uring.h  |  7 +++++++
 io_uring/io_uring.c            | 26 ++++++++++++++++++++------
 io_uring/io_uring.h            |  2 +-
 io_uring/sqpoll.c              |  3 ++-
 5 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 4dd54d2173e1..c54f3fb7ab1a 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -403,6 +403,7 @@ enum {
 	REQ_F_APOLL_MULTISHOT_BIT,
 	REQ_F_CLEAR_POLLIN_BIT,
 	REQ_F_HASH_LOCKED_BIT,
+	REQ_F_NO_OFFLOAD_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
@@ -475,6 +476,8 @@ enum {
 	REQ_F_CLEAR_POLLIN	= BIT_ULL(REQ_F_CLEAR_POLLIN_BIT),
 	/* hashed into ->cancel_hash_locked, protected by ->uring_lock */
 	REQ_F_HASH_LOCKED	= BIT_ULL(REQ_F_HASH_LOCKED_BIT),
+	/* don't offload to io-wq, issue blocking if needed */
+	REQ_F_NO_OFFLOAD	= BIT_ULL(REQ_F_NO_OFFLOAD_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
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
index 9568b5e4cf87..04770b06de16 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1947,6 +1947,10 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!io_assign_file(req, def, issue_flags)))
 		return -EBADF;
 
+	if (req->flags & REQ_F_NO_OFFLOAD &&
+	    (!req->file || !file_can_poll(req->file)))
+		issue_flags &= ~IO_URING_F_NONBLOCK;
+
 	if (unlikely((req->flags & REQ_F_CREDS) && req->creds != current_cred()))
 		creds = override_creds(req->creds);
 
@@ -2337,7 +2341,7 @@ static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
 }
 
 static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
-			 const struct io_uring_sqe *sqe)
+			 const struct io_uring_sqe *sqe, bool no_offload)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_link *link = &ctx->submit_state.link;
@@ -2385,6 +2389,9 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		return 0;
 	}
 
+	if (no_offload)
+		req->flags |= REQ_F_NO_OFFLOAD;
+
 	io_queue_sqe(req);
 	return 0;
 }
@@ -2466,7 +2473,7 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 	return false;
 }
 
-int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
+int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr, bool no_offload)
 	__must_hold(&ctx->uring_lock)
 {
 	unsigned int entries = io_sqring_entries(ctx);
@@ -2495,7 +2502,7 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		 * Continue submitting even for sqe failure if the
 		 * ring was setup with IORING_SETUP_SUBMIT_ALL
 		 */
-		if (unlikely(io_submit_sqe(ctx, req, sqe)) &&
+		if (unlikely(io_submit_sqe(ctx, req, sqe, no_offload)) &&
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
@@ -3575,12 +3583,17 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 
 		ret = to_submit;
 	} else if (to_submit) {
+		bool no_offload;
+
 		ret = io_uring_add_tctx_node(ctx);
 		if (unlikely(ret))
 			goto out;
 
+		no_offload = flags & IORING_ENTER_NO_OFFLOAD ||
+				ctx->flags & IORING_SETUP_NO_OFFLOAD;
+
 		mutex_lock(&ctx->uring_lock);
-		ret = io_submit_sqes(ctx, to_submit);
+		ret = io_submit_sqes(ctx, to_submit, no_offload);
 		if (ret != to_submit) {
 			mutex_unlock(&ctx->uring_lock);
 			goto out;
@@ -3969,7 +3982,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
 			IORING_SETUP_COOP_TASKRUN | IORING_SETUP_TASKRUN_FLAG |
 			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
-			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN))
+			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
+			IORING_SETUP_NO_OFFLOAD))
 		return -EINVAL;
 
 	return io_uring_create(entries, &p, params);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 25515d69d205..c5c0db7232c0 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -76,7 +76,7 @@ int io_uring_alloc_task_context(struct task_struct *task,
 				struct io_ring_ctx *ctx);
 
 int io_poll_issue(struct io_kiocb *req, struct io_tw_state *ts);
-int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr);
+int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr, bool no_offload);
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin);
 void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node);
 int io_req_prep_async(struct io_kiocb *req);
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 9db4bc1f521a..9a9417bf9e3f 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -166,6 +166,7 @@ static inline bool io_sqd_events_pending(struct io_sq_data *sqd)
 
 static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 {
+	bool no_offload = ctx->flags & IORING_SETUP_NO_OFFLOAD;
 	unsigned int to_submit;
 	int ret = 0;
 
@@ -190,7 +191,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 		 */
 		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)) &&
 		    !(ctx->flags & IORING_SETUP_R_DISABLED))
-			ret = io_submit_sqes(ctx, to_submit);
+			ret = io_submit_sqes(ctx, to_submit, no_offload);
 		mutex_unlock(&ctx->uring_lock);
 
 		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
-- 
2.39.2

