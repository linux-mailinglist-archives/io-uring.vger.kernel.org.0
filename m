Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37E9667854
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 15:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240265AbjALO62 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 09:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240175AbjALO6C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 09:58:02 -0500
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE8763185;
        Thu, 12 Jan 2023 06:44:20 -0800 (PST)
Received: by mail-ej1-f45.google.com with SMTP id az20so26222455ejc.1;
        Thu, 12 Jan 2023 06:44:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WsaMXqRGnAjzrXyFKJpI3zGOQIGJAJrZOr3w/exX7fI=;
        b=wy/tOmbskAfElnZVgV1cy4MSSs+k3EFY7THkddVI4Wks9OKvcUUNCpq3AToT0cpkWc
         2yME016v3HwOoQOmz0jbZJmhonD5Tt7gpcbpETjeupXTlYqXlrATGuqO1ROxItoM75oc
         zePsGcWxQ5D4cMxdshVnPoKtieiXm6IcVJf2gX4ZfZW0fmyt56uRmlBqaba7buTNY+A6
         q1CNituj7qUz1o6bz3M9qyTpX5skjfgnEruE0eK6ip83ACY1Z4vIvGRa8AemJJLT0weD
         BvVQFgiICLhps2B9CMUNmggvYfT9rZoRLVG06d4w9LO0B/HKDtsvZJQxUiGoybDlPw5l
         KuZw==
X-Gm-Message-State: AFqh2kpS4bSCxn9tclRwKU1tLqnRpQNajhji3I+fPbPcczFIice9M8jF
        3zvSIVPPgM+d4CM+FyGRRF8=
X-Google-Smtp-Source: AMrXdXtnb3+TkGDposSNHyE17TkjfBWtzUm/pcU6e1WQxdulT1PY7oVm1CuVudFeaQvlMOnaXxfJpg==
X-Received: by 2002:a17:907:a643:b0:83c:7308:b2ed with SMTP id vu3-20020a170907a64300b0083c7308b2edmr67547625ejc.17.1673534658894;
        Thu, 12 Jan 2023 06:44:18 -0800 (PST)
Received: from localhost (fwdproxy-cln-000.fbsv.net. [2a03:2880:31ff::face:b00c])
        by smtp.gmail.com with ESMTPSA id d26-20020a170906305a00b0084c90164a56sm7488501ejd.29.2023.01.12.06.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 06:44:18 -0800 (PST)
From:   Breno Leitao <leitao@debian.org>
To:     asml.silence@gmail.com, dylany@meta.com, axboe@kernel.dk,
        io-uring@vger.kernel.org
Cc:     leitao@debian.org, leit@fb.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] io_uring: Rename struct io_op_def
Date:   Thu, 12 Jan 2023 06:44:10 -0800
Message-Id: <20230112144411.2624698-1-leitao@debian.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The current io_op_def struct is becoming huge and the name is a bit
generic.

The goal of this patch is to rename this struct to `io_issue_def`. This
struct will contain the hot functions associated with the issue code
path.

For now, this patch only renames the structure, and an upcoming patch
will break up the structure in two, moving the non-issue fields to a
secondary struct.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 io_uring/io_uring.c | 26 +++++++++++++-------------
 io_uring/opdef.c    | 16 ++++++++--------
 io_uring/opdef.h    |  4 ++--
 io_uring/poll.c     |  2 +-
 io_uring/rw.c       |  2 +-
 5 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2ac1cd8d23ea..ac7868ec9be2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -407,7 +407,7 @@ static inline void io_arm_ltimeout(struct io_kiocb *req)
 
 static void io_prep_async_work(struct io_kiocb *req)
 {
-	const struct io_op_def *def = &io_op_defs[req->opcode];
+	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (!(req->flags & REQ_F_CREDS)) {
@@ -980,7 +980,7 @@ void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 void io_req_defer_failed(struct io_kiocb *req, s32 res)
 	__must_hold(&ctx->uring_lock)
 {
-	const struct io_op_def *def = &io_op_defs[req->opcode];
+	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
@@ -1708,8 +1708,8 @@ unsigned int io_file_get_flags(struct file *file)
 
 bool io_alloc_async_data(struct io_kiocb *req)
 {
-	WARN_ON_ONCE(!io_op_defs[req->opcode].async_size);
-	req->async_data = kmalloc(io_op_defs[req->opcode].async_size, GFP_KERNEL);
+	WARN_ON_ONCE(!io_issue_defs[req->opcode].async_size);
+	req->async_data = kmalloc(io_issue_defs[req->opcode].async_size, GFP_KERNEL);
 	if (req->async_data) {
 		req->flags |= REQ_F_ASYNC_DATA;
 		return false;
@@ -1719,7 +1719,7 @@ bool io_alloc_async_data(struct io_kiocb *req)
 
 int io_req_prep_async(struct io_kiocb *req)
 {
-	const struct io_op_def *def = &io_op_defs[req->opcode];
+	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 
 	/* assign early for deferred execution for non-fixed file */
 	if (def->needs_file && !(req->flags & REQ_F_FIXED_FILE))
@@ -1728,7 +1728,7 @@ int io_req_prep_async(struct io_kiocb *req)
 		return 0;
 	if (WARN_ON_ONCE(req_has_async_data(req)))
 		return -EFAULT;
-	if (!io_op_defs[req->opcode].manual_alloc) {
+	if (!io_issue_defs[req->opcode].manual_alloc) {
 		if (io_alloc_async_data(req))
 			return -EAGAIN;
 	}
@@ -1801,7 +1801,7 @@ static void io_clean_op(struct io_kiocb *req)
 	}
 
 	if (req->flags & REQ_F_NEED_CLEANUP) {
-		const struct io_op_def *def = &io_op_defs[req->opcode];
+		const struct io_issue_def *def = &io_issue_defs[req->opcode];
 
 		if (def->cleanup)
 			def->cleanup(req);
@@ -1827,7 +1827,7 @@ static void io_clean_op(struct io_kiocb *req)
 
 static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags)
 {
-	if (req->file || !io_op_defs[req->opcode].needs_file)
+	if (req->file || !io_issue_defs[req->opcode].needs_file)
 		return true;
 
 	if (req->flags & REQ_F_FIXED_FILE)
@@ -1840,7 +1840,7 @@ static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 {
-	const struct io_op_def *def = &io_op_defs[req->opcode];
+	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	const struct cred *creds = NULL;
 	int ret;
 
@@ -1894,7 +1894,7 @@ struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
 void io_wq_submit_work(struct io_wq_work *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-	const struct io_op_def *def = &io_op_defs[req->opcode];
+	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	unsigned int issue_flags = IO_URING_F_UNLOCKED | IO_URING_F_IOWQ;
 	bool needs_poll = false;
 	int ret = 0, err = -ECANCELED;
@@ -2106,7 +2106,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		       const struct io_uring_sqe *sqe)
 	__must_hold(&ctx->uring_lock)
 {
-	const struct io_op_def *def;
+	const struct io_issue_def *def;
 	unsigned int sqe_flags;
 	int personality;
 	u8 opcode;
@@ -2124,7 +2124,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		req->opcode = 0;
 		return -EINVAL;
 	}
-	def = &io_op_defs[opcode];
+	def = &io_issue_defs[opcode];
 	if (unlikely(sqe_flags & ~SQE_COMMON_FLAGS)) {
 		/* enforce forwards compatibility on users */
 		if (sqe_flags & ~SQE_VALID_FLAGS)
@@ -3762,7 +3762,7 @@ static __cold int io_probe(struct io_ring_ctx *ctx, void __user *arg,
 
 	for (i = 0; i < nr_args; i++) {
 		p->ops[i].op = i;
-		if (!io_op_defs[i].not_supported)
+		if (!io_issue_defs[i].not_supported)
 			p->ops[i].flags = IO_URING_OP_SUPPORTED;
 	}
 	p->ops_len = i;
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 3aa0d65c50e3..3c95e70a625e 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -46,7 +46,7 @@ static __maybe_unused int io_eopnotsupp_prep(struct io_kiocb *kiocb,
 	return -EOPNOTSUPP;
 }
 
-const struct io_op_def io_op_defs[] = {
+const struct io_issue_def io_issue_defs[] = {
 	[IORING_OP_NOP] = {
 		.audit_skip		= 1,
 		.iopoll			= 1,
@@ -536,7 +536,7 @@ const struct io_op_def io_op_defs[] = {
 const char *io_uring_get_opcode(u8 opcode)
 {
 	if (opcode < IORING_OP_LAST)
-		return io_op_defs[opcode].name;
+		return io_issue_defs[opcode].name;
 	return "INVALID";
 }
 
@@ -544,12 +544,12 @@ void __init io_uring_optable_init(void)
 {
 	int i;
 
-	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
+	BUILD_BUG_ON(ARRAY_SIZE(io_issue_defs) != IORING_OP_LAST);
 
-	for (i = 0; i < ARRAY_SIZE(io_op_defs); i++) {
-		BUG_ON(!io_op_defs[i].prep);
-		if (io_op_defs[i].prep != io_eopnotsupp_prep)
-			BUG_ON(!io_op_defs[i].issue);
-		WARN_ON_ONCE(!io_op_defs[i].name);
+	for (i = 0; i < ARRAY_SIZE(io_issue_defs); i++) {
+		BUG_ON(!io_issue_defs[i].prep);
+		if (io_issue_defs[i].prep != io_eopnotsupp_prep)
+			BUG_ON(!io_issue_defs[i].issue);
+		WARN_ON_ONCE(!io_issue_defs[i].name);
 	}
 }
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index df7e13d9bfba..d718e2ab1ff7 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -2,7 +2,7 @@
 #ifndef IOU_OP_DEF_H
 #define IOU_OP_DEF_H
 
-struct io_op_def {
+struct io_issue_def {
 	/* needs req->file assigned */
 	unsigned		needs_file : 1;
 	/* should block plug */
@@ -41,7 +41,7 @@ struct io_op_def {
 	void (*fail)(struct io_kiocb *);
 };
 
-extern const struct io_op_def io_op_defs[];
+extern const struct io_issue_def io_issue_defs[];
 
 void io_uring_optable_init(void);
 #endif
diff --git a/io_uring/poll.c b/io_uring/poll.c
index ee7da6150ec4..7a6d5d0da966 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -658,7 +658,7 @@ static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
 
 int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 {
-	const struct io_op_def *def = &io_op_defs[req->opcode];
+	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
 	__poll_t mask = POLLPRI | POLLERR | EPOLLET;
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 8227af2e1c0f..54b44b9b736c 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -516,7 +516,7 @@ static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
 static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 			     struct io_rw_state *s, bool force)
 {
-	if (!force && !io_op_defs[req->opcode].prep_async)
+	if (!force && !io_issue_defs[req->opcode].prep_async)
 		return 0;
 	if (!req_has_async_data(req)) {
 		struct io_async_rw *iorw;
-- 
2.30.2

