Return-Path: <io-uring+bounces-1178-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 068528819B9
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 23:58:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A89E1C20C66
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 22:58:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 928FD1E87E;
	Wed, 20 Mar 2024 22:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wYthfjIZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA42185C65
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 22:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710975505; cv=none; b=PGaevBJ4IYWScXVY0k00G2dgjtjDyKc9kJlzvhdjIW6jo1QZhqSpIxJzwp7yMSpdaFELOEjO2AZn3n55Pc7Uuwtnr98bZKh8HzIwT5+oi6dAtTPeNlWXTvYfBmLFX07WPllIPf7cvi8TeOeEyWIr4ySluetbejQA9i8AsgQebxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710975505; c=relaxed/simple;
	bh=ykZAf3Q8DBafxceYbZ4oIWwEr1AaVUCtxIWXCkoSqK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G45zFrHQ9vPePhJbYiq1t7rMbLYBkuVji+qfufEYCpD0c1cqOUgYqqVwtzZoYPeU/IKIEjqSO0wJ0bEWAB7CO7YL1SBv9+vbwRN9RvxTlHpNeTEoBgQEzrl858OCMmA2+a+jmTNO3C18pCCppjLtXOQvlCVfiNgVUyBTwg1pr3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wYthfjIZ; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7cc0e831e11so2542839f.1
        for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 15:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710975502; x=1711580302; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CU0lTkJ8eZZ/oUI5/c9z1/jTv3vXx4pfsrXqhBT1eCI=;
        b=wYthfjIZ8AAmSUpMwwD0GG6NlQAO3uwojXyaSJvXoIDRLs9pgvxCtRScj1PZmX1+0I
         GnyFnjNEUlLoB3zysHN1Jgc9ys9+1j/SUUfLJw8c6FZ2QvyoUXLvIB60DGhxtm+3vS4S
         BTF8RuFjwJmXF7t8HFBrdEpAy0PGEtcocow66W5djc3IgZisa/bZzC9nUlJMt/SgQS9X
         x+QzQDIORV0LIpBlzLQ1EFd+GR0c0ma68siVHjWDYa3BcMQlBExHTvtNqrld5cuQ6bsc
         pRWkL5zVppKyi5FZ4tm7yTuCmW/+7cnM4flHPJGnpBMSw46JPAFiMDrftv7gIni0tuEu
         L0qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710975502; x=1711580302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CU0lTkJ8eZZ/oUI5/c9z1/jTv3vXx4pfsrXqhBT1eCI=;
        b=llWavvyOox21Wmak6F6NHW7nPXUOlyr2BQg9y+i8LcGUs2e9U67Y2FNUshvLMjUMTj
         +LFRRLD8/uQBUUqeyMZKisIFtvflEcQjfaL3at/cCxKyBB/axRGfvdGyzDB4iJWhz1M8
         KHokoTcP++vp0QKfjcjItHAT9j2V8VRw1NUNeZfJXaJhbtnMna3WCCHYa2zqFwz+OJhn
         f9hs3BEsx41DUqkQSHu8U+rlxKr8O3twQR10lbzu3VKVhcLlQb47ZjcPsXv29gTwMo4m
         amj8nzRRLvK9j3q5wEKgYP80c1fhE6g4qioxlIHykNJHa53rzAqIPHjYI4meDQErteik
         EjAA==
X-Gm-Message-State: AOJu0YwY2Tv9/t4JlcKoLkIsO6BPngO5A+wJcwxdSK1JFI3Ml2ZBx578
	4F8W++fXeWMkctWfIRaIdFg/rwVA7ln5lfQY9NIO2niIuZ5A00YEmjOnnxKdiyDX20Uj8UMw1oT
	4
X-Google-Smtp-Source: AGHT+IG2IWqUFRMJSX+L6O7af1bBSAT7u3K7tOr5pCZlpjJ42wf5sXJQj5shIsxvXqwCHO+RjAhFWw==
X-Received: by 2002:a05:6602:59:b0:7c8:ad73:a702 with SMTP id z25-20020a056602005900b007c8ad73a702mr7016324ioz.0.1710975502352;
        Wed, 20 Mar 2024 15:58:22 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z19-20020a6b0a13000000b007cf23a498dcsm434384ioi.38.2024.03.20.15.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 15:58:20 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 16/17] io_uring: drop ->prep_async()
Date: Wed, 20 Mar 2024 16:55:31 -0600
Message-ID: <20240320225750.1769647-17-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240320225750.1769647-1-axboe@kernel.dk>
References: <20240320225750.1769647-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's now unused, drop the code related to it. This includes the
io_issue_defs->manual alloc field.

While in there, and since ->async_size is now being used a bit more
frequently and in the issue path, move it to io_issue_defs[].

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c  | 36 ++++--------------------------------
 io_uring/io_uring.h  |  1 -
 io_uring/opdef.c     | 44 +++++++++++++++++++-------------------------
 io_uring/opdef.h     |  9 +++------
 io_uring/uring_cmd.h |  1 -
 5 files changed, 26 insertions(+), 65 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e2b9b00eedef..5eee07563079 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1709,8 +1709,10 @@ io_req_flags_t io_file_get_flags(struct file *file)
 
 bool io_alloc_async_data(struct io_kiocb *req)
 {
-	WARN_ON_ONCE(!io_cold_defs[req->opcode].async_size);
-	req->async_data = kmalloc(io_cold_defs[req->opcode].async_size, GFP_KERNEL);
+	const struct io_issue_def *def = &io_issue_defs[req->opcode];
+
+	WARN_ON_ONCE(!def->async_size);
+	req->async_data = kmalloc(def->async_size, GFP_KERNEL);
 	if (req->async_data) {
 		req->flags |= REQ_F_ASYNC_DATA;
 		return false;
@@ -1718,25 +1720,6 @@ bool io_alloc_async_data(struct io_kiocb *req)
 	return true;
 }
 
-int io_req_prep_async(struct io_kiocb *req)
-{
-	const struct io_cold_def *cdef = &io_cold_defs[req->opcode];
-	const struct io_issue_def *def = &io_issue_defs[req->opcode];
-
-	/* assign early for deferred execution for non-fixed file */
-	if (def->needs_file && !(req->flags & REQ_F_FIXED_FILE) && !req->file)
-		req->file = io_file_get_normal(req, req->cqe.fd);
-	if (!cdef->prep_async)
-		return 0;
-	if (WARN_ON_ONCE(req_has_async_data(req)))
-		return -EFAULT;
-	if (!def->manual_alloc) {
-		if (io_alloc_async_data(req))
-			return -EAGAIN;
-	}
-	return cdef->prep_async(req);
-}
-
 static u32 io_get_sequence(struct io_kiocb *req)
 {
 	u32 seq = req->ctx->cached_sq_head;
@@ -2049,13 +2032,6 @@ static void io_queue_sqe_fallback(struct io_kiocb *req)
 		req->flags |= REQ_F_LINK;
 		io_req_defer_failed(req, req->cqe.res);
 	} else {
-		int ret = io_req_prep_async(req);
-
-		if (unlikely(ret)) {
-			io_req_defer_failed(req, ret);
-			return;
-		}
-
 		if (unlikely(req->ctx->drain_active))
 			io_drain_req(req);
 		else
@@ -2265,10 +2241,6 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	 * conditions are true (normal request), then just queue it.
 	 */
 	if (unlikely(link->head)) {
-		ret = io_req_prep_async(req);
-		if (unlikely(ret))
-			return io_submit_fail_init(sqe, req, ret);
-
 		trace_io_uring_link(req, link->head);
 		link->last->link = req;
 		link->last = req;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index ef9bf610734c..caf1f573bb87 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -101,7 +101,6 @@ int io_poll_issue(struct io_kiocb *req, struct io_tw_state *ts);
 int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr);
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin);
 void __io_submit_flush_completions(struct io_ring_ctx *ctx);
-int io_req_prep_async(struct io_kiocb *req);
 
 struct io_wq_work *io_wq_free_work(struct io_wq_work *work);
 void io_wq_submit_work(struct io_wq_work *work);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 745246086c23..2de5cca9504e 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -67,6 +67,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
 		.vectored		= 1,
+		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_readv,
 		.issue			= io_read,
 	},
@@ -81,6 +82,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
 		.vectored		= 1,
+		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_writev,
 		.issue			= io_write,
 	},
@@ -99,6 +101,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_read_fixed,
 		.issue			= io_read,
 	},
@@ -112,6 +115,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_write_fixed,
 		.issue			= io_write,
 	},
@@ -138,8 +142,8 @@ const struct io_issue_def io_issue_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.ioprio			= 1,
-		.manual_alloc		= 1,
 #if defined(CONFIG_NET)
+		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_sendmsg_prep,
 		.issue			= io_sendmsg,
 #else
@@ -152,8 +156,8 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollin			= 1,
 		.buffer_select		= 1,
 		.ioprio			= 1,
-		.manual_alloc		= 1,
 #if defined(CONFIG_NET)
+		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_recvmsg_prep,
 		.issue			= io_recvmsg,
 #else
@@ -162,6 +166,7 @@ const struct io_issue_def io_issue_defs[] = {
 	},
 	[IORING_OP_TIMEOUT] = {
 		.audit_skip		= 1,
+		.async_size		= sizeof(struct io_timeout_data),
 		.prep			= io_timeout_prep,
 		.issue			= io_timeout,
 	},
@@ -191,6 +196,7 @@ const struct io_issue_def io_issue_defs[] = {
 	},
 	[IORING_OP_LINK_TIMEOUT] = {
 		.audit_skip		= 1,
+		.async_size		= sizeof(struct io_timeout_data),
 		.prep			= io_link_timeout_prep,
 		.issue			= io_no_issue,
 	},
@@ -199,6 +205,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 #if defined(CONFIG_NET)
+		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_connect_prep,
 		.issue			= io_connect,
 #else
@@ -239,6 +246,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_read,
 		.issue			= io_read,
 	},
@@ -252,6 +260,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_write,
 		.issue			= io_write,
 	},
@@ -272,8 +281,9 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollout		= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
-		.manual_alloc		= 1,
+		.buffer_select		= 1,
 #if defined(CONFIG_NET)
+		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_sendmsg_prep,
 		.issue			= io_send,
 #else
@@ -288,6 +298,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 #if defined(CONFIG_NET)
+		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_recvmsg_prep,
 		.issue			= io_recv,
 #else
@@ -403,6 +414,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.plug			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.async_size		= 2 * sizeof(struct io_uring_sqe),
 		.prep			= io_uring_cmd_prep,
 		.issue			= io_uring_cmd,
 	},
@@ -412,8 +424,8 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollout		= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
-		.manual_alloc		= 1,
 #if defined(CONFIG_NET)
+		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_send_zc_prep,
 		.issue			= io_send_zc,
 #else
@@ -425,8 +437,8 @@ const struct io_issue_def io_issue_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.ioprio			= 1,
-		.manual_alloc		= 1,
 #if defined(CONFIG_NET)
+		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_send_zc_prep,
 		.issue			= io_sendmsg_zc,
 #else
@@ -439,10 +451,12 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollin			= 1,
 		.buffer_select		= 1,
 		.audit_skip		= 1,
+		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_read_mshot_prep,
 		.issue			= io_read_mshot,
 	},
 	[IORING_OP_WAITID] = {
+		.async_size		= sizeof(struct io_waitid_async),
 		.prep			= io_waitid_prep,
 		.issue			= io_waitid,
 	},
@@ -488,13 +502,11 @@ const struct io_cold_def io_cold_defs[] = {
 		.name			= "NOP",
 	},
 	[IORING_OP_READV] = {
-		.async_size		= sizeof(struct io_async_rw),
 		.name			= "READV",
 		.cleanup		= io_readv_writev_cleanup,
 		.fail			= io_rw_fail,
 	},
 	[IORING_OP_WRITEV] = {
-		.async_size		= sizeof(struct io_async_rw),
 		.name			= "WRITEV",
 		.cleanup		= io_readv_writev_cleanup,
 		.fail			= io_rw_fail,
@@ -503,12 +515,10 @@ const struct io_cold_def io_cold_defs[] = {
 		.name			= "FSYNC",
 	},
 	[IORING_OP_READ_FIXED] = {
-		.async_size		= sizeof(struct io_async_rw),
 		.name			= "READ_FIXED",
 		.fail			= io_rw_fail,
 	},
 	[IORING_OP_WRITE_FIXED] = {
-		.async_size		= sizeof(struct io_async_rw),
 		.name			= "WRITE_FIXED",
 		.fail			= io_rw_fail,
 	},
@@ -524,7 +534,6 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_SENDMSG] = {
 		.name			= "SENDMSG",
 #if defined(CONFIG_NET)
-		.async_size		= sizeof(struct io_async_msghdr),
 		.cleanup		= io_sendmsg_recvmsg_cleanup,
 		.fail			= io_sendrecv_fail,
 #endif
@@ -532,13 +541,11 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_RECVMSG] = {
 		.name			= "RECVMSG",
 #if defined(CONFIG_NET)
-		.async_size		= sizeof(struct io_async_msghdr),
 		.cleanup		= io_sendmsg_recvmsg_cleanup,
 		.fail			= io_sendrecv_fail,
 #endif
 	},
 	[IORING_OP_TIMEOUT] = {
-		.async_size		= sizeof(struct io_timeout_data),
 		.name			= "TIMEOUT",
 	},
 	[IORING_OP_TIMEOUT_REMOVE] = {
@@ -551,14 +558,10 @@ const struct io_cold_def io_cold_defs[] = {
 		.name			= "ASYNC_CANCEL",
 	},
 	[IORING_OP_LINK_TIMEOUT] = {
-		.async_size		= sizeof(struct io_timeout_data),
 		.name			= "LINK_TIMEOUT",
 	},
 	[IORING_OP_CONNECT] = {
 		.name			= "CONNECT",
-#if defined(CONFIG_NET)
-		.async_size		= sizeof(struct io_async_msghdr),
-#endif
 	},
 	[IORING_OP_FALLOCATE] = {
 		.name			= "FALLOCATE",
@@ -578,12 +581,10 @@ const struct io_cold_def io_cold_defs[] = {
 		.cleanup		= io_statx_cleanup,
 	},
 	[IORING_OP_READ] = {
-		.async_size		= sizeof(struct io_async_rw),
 		.name			= "READ",
 		.fail			= io_rw_fail,
 	},
 	[IORING_OP_WRITE] = {
-		.async_size		= sizeof(struct io_async_rw),
 		.name			= "WRITE",
 		.fail			= io_rw_fail,
 	},
@@ -596,7 +597,6 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_SEND] = {
 		.name			= "SEND",
 #if defined(CONFIG_NET)
-		.async_size		= sizeof(struct io_async_msghdr),
 		.cleanup		= io_sendmsg_recvmsg_cleanup,
 		.fail			= io_sendrecv_fail,
 #endif
@@ -604,7 +604,6 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_RECV] = {
 		.name			= "RECV",
 #if defined(CONFIG_NET)
-		.async_size		= sizeof(struct io_async_msghdr),
 		.cleanup		= io_sendmsg_recvmsg_cleanup,
 		.fail			= io_sendrecv_fail,
 #endif
@@ -676,12 +675,10 @@ const struct io_cold_def io_cold_defs[] = {
 	},
 	[IORING_OP_URING_CMD] = {
 		.name			= "URING_CMD",
-		.async_size		= 2 * sizeof(struct io_uring_sqe),
 	},
 	[IORING_OP_SEND_ZC] = {
 		.name			= "SEND_ZC",
 #if defined(CONFIG_NET)
-		.async_size		= sizeof(struct io_async_msghdr),
 		.cleanup		= io_send_zc_cleanup,
 		.fail			= io_sendrecv_fail,
 #endif
@@ -689,18 +686,15 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_SENDMSG_ZC] = {
 		.name			= "SENDMSG_ZC",
 #if defined(CONFIG_NET)
-		.async_size		= sizeof(struct io_async_msghdr),
 		.cleanup		= io_send_zc_cleanup,
 		.fail			= io_sendrecv_fail,
 #endif
 	},
 	[IORING_OP_READ_MULTISHOT] = {
-		.async_size		= sizeof(struct io_async_rw),
 		.name			= "READ_MULTISHOT",
 	},
 	[IORING_OP_WAITID] = {
 		.name			= "WAITID",
-		.async_size		= sizeof(struct io_waitid_async),
 	},
 	[IORING_OP_FUTEX_WAIT] = {
 		.name			= "FUTEX_WAIT",
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index 9e5435ec27d0..7ee6f5aa90aa 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -27,22 +27,19 @@ struct io_issue_def {
 	unsigned		iopoll : 1;
 	/* have to be put into the iopoll list */
 	unsigned		iopoll_queue : 1;
-	/* opcode specific path will handle ->async_data allocation if needed */
-	unsigned		manual_alloc : 1;
 	/* vectored opcode, set if 1) vectored, and 2) handler needs to know */
 	unsigned		vectored : 1;
 
+	/* size of async data needed, if any */
+	unsigned short		async_size;
+
 	int (*issue)(struct io_kiocb *, unsigned int);
 	int (*prep)(struct io_kiocb *, const struct io_uring_sqe *);
 };
 
 struct io_cold_def {
-	/* size of async data needed, if any */
-	unsigned short		async_size;
-
 	const char		*name;
 
-	int (*prep_async)(struct io_kiocb *);
 	void (*cleanup)(struct io_kiocb *);
 	void (*fail)(struct io_kiocb *);
 };
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index b0ccff7091ee..477ea8865639 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -9,7 +9,6 @@ struct uring_cache {
 
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags);
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
-int io_uring_cmd_prep_async(struct io_kiocb *req);
 void io_uring_cache_free(struct io_cache_entry *entry);
 
 bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
-- 
2.43.0


