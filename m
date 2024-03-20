Return-Path: <io-uring+bounces-1159-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF24E88090F
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 02:23:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 505E2B22568
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 01:23:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAA472582;
	Wed, 20 Mar 2024 01:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="F9uk2wbU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8061747F
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 01:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710897807; cv=none; b=Sk0vTLZwXgtonZmXFJRSjXpk64P1pf93CY7YikHDQam12vzRnwB5TunSDcc5fBd+x+lX0mPICe57VECQTk2LvsUdCOF22mTSzVjfi8OH/5J2q5CSIRG2R5cN6C9umN+gFxPpcBoHy6ToeE+qaOU2jAMU/+/Dz9+6JO+xZaYEfUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710897807; c=relaxed/simple;
	bh=ADwvS3dajz3v2D54m8dyWJSN7t8lj2nDbVxRCbQ+I3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILGy5ci+1bhd7z9ba7SXy0En03WKznJshiNoLdvneSN5wl+E9quuAIsS8qt1dIn59dEDLGB0XGmVe9bQStZ8g7/RTozhRqoRph8W1PEayBfiQ7ma8u01zRF5Ys4o+xSrM/+opmRCBNYS5jUgUCSooOdJUK7sZeX95aFWSRl36Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=F9uk2wbU; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-6e677ec9508so776715a34.1
        for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 18:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710897804; x=1711502604; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CPARoiYjtkNf6hhumA2MQ7GeD1lCOyuUTnmEortuRVI=;
        b=F9uk2wbUZMdypahMo2omQJadUWH6Wn1bjb9PuwfPPp1PovAE/vK9HincZ6E7JdHTjv
         fvhvQIHd6nSg4PiB8Kw7UcjudDvq4RPBUJYBYiGbrw9I6kUMSNjFHRWXA2NY/tD1Nhh0
         tzayoPauUZm5noa9lJ5XXfgi1OaYC3285vCQ+v20xCTlkBg1BUMd2yBW0QpbO1w84saB
         I7Ngr2JYp/a65QJp+y/wD0lc2pMGZhgg69zAfmIswS0GeH5Q8l203eXVsVf5XGjAiJln
         ImRq2DyihPBmvoHfwcw7RRLir4ewBhiC+MK91UrlWWX7Luot54ekk1FsTBjEzuz4AQuW
         nfkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710897804; x=1711502604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CPARoiYjtkNf6hhumA2MQ7GeD1lCOyuUTnmEortuRVI=;
        b=BuVF6HJhW6HJtM0ie7eoo9hHKJv3BxQTkZSyS+DIuO+UOdn/Gyzl2nfNwM89ZYYOow
         BpyRM9UCiCBbctQT33IgYFBCCjhclI85AGM18wcLz2bkC/zBzN1J+i+ItVmKxvKf455w
         92MHLjdRWM8XWfgOzX0RnHuE2C/HHCxv7m25PxTAwNXn0qkXxCN1W9GrLChFXgmQJ7Ky
         PocWqv3n8ttv7wR0m+ECQ3Ew8T9gZ5duT15zd7GdeCWj1CTn7ybwmJRRPvCWsyWGa2X/
         nkT68KDnBKLrk8jtTM60MgqGSlsQXVuyD0WMJxDXhwa6XSV0WHKLBM2oII4h/hq99+KD
         sxrg==
X-Gm-Message-State: AOJu0YyavkKR1Wj669sbbgjM2OKqxH2UcxfobkecL++wnwdtxrNBSIvT
	3T/UjlB6w76odGH4sfUhNE7+dF1qtpCQpCI9+zpukLNLtjZxbHgBZ5fvjVSeY4WVdrjrx+4J0RZ
	U
X-Google-Smtp-Source: AGHT+IEWNk6cvWL2LwvsXfWzGpuLa2wZdzp37saL6nuGeMBvMG2uC9X0bo8gZGms+q8Ze/Avxz+6gA==
X-Received: by 2002:a05:6358:7211:b0:17f:1d24:1432 with SMTP id h17-20020a056358721100b0017f1d241432mr844508rwa.3.1710897804374;
        Tue, 19 Mar 2024 18:23:24 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id v22-20020a634816000000b005dc26144d96sm9618007pga.75.2024.03.19.18.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 18:23:23 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 15/15] io_uring: drop ->prep_async()
Date: Tue, 19 Mar 2024 19:17:43 -0600
Message-ID: <20240320012251.1120361-16-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240320012251.1120361-1-axboe@kernel.dk>
References: <20240320012251.1120361-1-axboe@kernel.dk>
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
index 4c0e9688a159..ac98decf7891 100644
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
+		.async_size		= sizeof(struct io_async_connect),
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
-		.async_size		= sizeof(struct io_async_connect),
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


