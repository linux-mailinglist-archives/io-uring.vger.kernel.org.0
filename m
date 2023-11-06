Return-Path: <io-uring+bounces-33-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98D367E27A2
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 15:50:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EEDD7B20F17
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 14:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 376F628DB0;
	Mon,  6 Nov 2023 14:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vxlAxBXH"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277F128DAD
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 14:50:13 +0000 (UTC)
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9679EF3
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 06:50:11 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-3593f3ef420so3774365ab.1
        for <io-uring@vger.kernel.org>; Mon, 06 Nov 2023 06:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1699282210; x=1699887010; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZaYfGMB6TQHbx+YMIkNz/bmiJtj5OoHEhNNSTWbORmg=;
        b=vxlAxBXHbWq/U4jk43UjZwxhlR1r/kM+hDu+X4EiJ2wAv2P0r8Yrg3jFNa31JZFSEX
         U4ivYUZh2d3EX0vhu2OlbBD8H4zz9eMazmv0jQKyoQJL937kngQIohF9JlnFQ8jxd/Ax
         +iEQZoxgWWTlvViXvHFfeUE+3meC2Auo9MpbEFPtlhnuWr/Gml/LJVNiAILHtqkJVSdN
         SEFf+Cu8Q7ftokPUySErhSmpTZdNktzdVzGhojyufh2JKyI2ibyMIpuMLacl1akxmN3c
         7Ed+8e0S5jvSOAnY7dT6J37//JcQwPbJOEKrCuWMrsUmFX9inq2OTow3QKoK3d4uA/N+
         UvUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699282210; x=1699887010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZaYfGMB6TQHbx+YMIkNz/bmiJtj5OoHEhNNSTWbORmg=;
        b=Z6yjVv8eQ8udtHdrDBXZGtebVtpqUzbayfkc8bQyC2K5iV6u8Q9CcpwfKEvMgj8OqP
         yurjVaaoxMAn1K/4UcjX1G6iLNoTL84dJPUUvUs/JntNkAsFFvwgt81Qxn/byuLaQLhX
         uAyxw5IZZbeDToPXA/yT/g+j3NMsbQfTrwI6+tPT+PJDcpSPfF84FcSeNPI2d1vACcEC
         pjtXen/dppJTkrVIGlRVMY83pK1HcOb7iVYD+9oQffEHn4ioJX2YB6PiRJj6dBDhWG23
         Lz2wKNpUF++X8eMS78vbS/5wWALlkZWJiqBRvGEzsWZ7NTy/5hBdBO91fz+hqdTRcn1J
         ilIw==
X-Gm-Message-State: AOJu0YyFtNYMS/5/l6tXvKnssJqczNYbtsZ04lZ+5EPwKh8S4c5Ty7Zv
	YOPtPq0L/sSK1iKkeGP2pSJyquEm5quFEOHbkSaP1w==
X-Google-Smtp-Source: AGHT+IGCPbQcXHFsR0ngCwY2RmTSkSiXT88QNZElmilJEORIlmJlU0sX9u8CF0nAfbLtnIOWr67+Hg==
X-Received: by 2002:a6b:db13:0:b0:79f:a8c2:290d with SMTP id t19-20020a6bdb13000000b0079fa8c2290dmr30456897ioc.0.1699282210506;
        Mon, 06 Nov 2023 06:50:10 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t2-20020a6b0902000000b0079fdbe2be51sm2378375ioi.2.2023.11.06.06.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 06:50:08 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dyudaken@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/rw: add separate prep handler for fixed read/write
Date: Mon,  6 Nov 2023 07:47:50 -0700
Message-ID: <20231106144844.71910-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106144844.71910-1-axboe@kernel.dk>
References: <20231106144844.71910-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than sprinkle opcode checks in the generic read/write prep handler,
have a separate prep handler for the vectored readv/writev operation.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/opdef.c |  4 ++--
 io_uring/rw.c    | 30 ++++++++++++++++++------------
 io_uring/rw.h    |  1 +
 3 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 0521a26bc6cd..799db44283c7 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -98,7 +98,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
-		.prep			= io_prep_rw,
+		.prep			= io_prep_rw_fixed,
 		.issue			= io_read,
 	},
 	[IORING_OP_WRITE_FIXED] = {
@@ -111,7 +111,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
-		.prep			= io_prep_rw,
+		.prep			= io_prep_rw_fixed,
 		.issue			= io_write,
 	},
 	[IORING_OP_POLL_ADD] = {
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 63d343bae762..9e3e56b74e35 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -83,18 +83,6 @@ int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	/* used for fixed read/write too - just read unconditionally */
 	req->buf_index = READ_ONCE(sqe->buf_index);
 
-	if (req->opcode == IORING_OP_READ_FIXED ||
-	    req->opcode == IORING_OP_WRITE_FIXED) {
-		struct io_ring_ctx *ctx = req->ctx;
-		u16 index;
-
-		if (unlikely(req->buf_index >= ctx->nr_user_bufs))
-			return -EFAULT;
-		index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
-		req->imu = ctx->user_bufs[index];
-		io_req_set_rsrc_node(req, ctx, 0);
-	}
-
 	ioprio = READ_ONCE(sqe->ioprio);
 	if (ioprio) {
 		ret = ioprio_check_cap(ioprio);
@@ -131,6 +119,24 @@ int io_prep_rwv(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
+int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	u16 index;
+	int ret;
+
+	ret = io_prep_rw(req, sqe);
+	if (unlikely(ret))
+		return ret;
+
+	if (unlikely(req->buf_index >= ctx->nr_user_bufs))
+		return -EFAULT;
+	index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
+	req->imu = ctx->user_bufs[index];
+	io_req_set_rsrc_node(req, ctx, 0);
+	return 0;
+}
+
 /*
  * Multishot read is prepared just like a normal read/write request, only
  * difference is that we set the MULTISHOT flag.
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 32aa7937513a..f9e89b4fe4da 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -17,6 +17,7 @@ struct io_async_rw {
 
 int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_prep_rwv(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_read(struct io_kiocb *req, unsigned int issue_flags);
 int io_readv_prep_async(struct io_kiocb *req);
 int io_write(struct io_kiocb *req, unsigned int issue_flags);
-- 
2.42.0


