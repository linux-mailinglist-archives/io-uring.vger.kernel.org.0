Return-Path: <io-uring+bounces-7969-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A32AAB5B2B
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 19:26:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 979624673C4
	for <lists+io-uring@lfdr.de>; Tue, 13 May 2025 17:26:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C1D14F70;
	Tue, 13 May 2025 17:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H49h44c4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB9715B54C
	for <io-uring@vger.kernel.org>; Tue, 13 May 2025 17:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747157158; cv=none; b=Ej/0Z+W5Z6B4K+CkATd1Wc7XUt7QploPy4lcsXcnYOX5DADS+Umkn7QR0DgzvE7x/ZdpOen0hGL5mtlVwN6lHsWAvxBEn0F+w0yjVkqr3ztPH3eEqWXI47PIY22IQjLs8USG9Hs2IW++eUg3kfg0qpfbiPKCEeRXDNldUapU9Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747157158; c=relaxed/simple;
	bh=oGlwomZUz9wiw3tBb5v4oTAz0AcTrS7+8tQy2GAVK5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PK5fkWbga5IZqayLBt9XY9fllEKX8gKqcnNpDDQfBPiJsUt5SGBgcOrqViVCYEONTWcbXfeGeNH/y0VATBgObg7wS2b2/+ikgkBAHAxspqjjsflRW0lP9cWhe3MmeiK5CMx7GhMDZu4Ruq3gyGxnGccug67A1pv7DiMYyNVH3lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H49h44c4; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-441ab63a415so61367385e9.3
        for <io-uring@vger.kernel.org>; Tue, 13 May 2025 10:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747157155; x=1747761955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aoVCmKh2uTUZiji6NdMlPn+3oerlr37x100gWA4OSlc=;
        b=H49h44c4JU0h6/4xnfgb21OuLMmwL4lqFcoPTEymyJdH16sEtiBdUTMSXYwdnuDsSM
         hdl475mzuvCUG9vuTK267FgTlIyN9mxR25YjfMozOj92VGP7EKox4Vvgzi3aa+lGvEr0
         L+mNQGquVTivW1ChAnhkDKilgMTxgE1ttN/7wY/m9BW0bo4rbmVaz5ffKv6AKSq2Qtju
         Nfsvdm6uheuT+iSKNtlHCfY/ZWecaVyOUqNGvjx6NctUg2y1S1E/FIK1uZQk/0to/NiT
         B7Nba3m60ol3M0mVFDcn5a0B78ev9s3sUuXAncnrTbXyLFyTcwKCXxJ9Dl7JE3WCg9hN
         FtzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747157155; x=1747761955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aoVCmKh2uTUZiji6NdMlPn+3oerlr37x100gWA4OSlc=;
        b=Xexj0oGFFrXE25r2ENT3xmhg0+aaDf8brjgMRGU3QzVDh4GGJZh1cgp60hmARammJW
         fLn5eoh4SFJIkvd/Op7VWyFg0mDsBQrY16ixDk71okFHjAtF/iljM64klvvXRp4I9BXy
         dVa6ExVCrM1ncsXNU0mI0LHhzi1FeiH0al/dehhNpviQ7GOQwFmZRSTXQwPeq0OucmJO
         XMzQJQevW/WsIGs3/Gowxa7R6ZzO6NzJPx92KO906bjMPS1QCSQ1tnUXtflAtfBOwq16
         17chsm7TUTICpat/bUXs+LjY8QNCXYtMEK0n/SopXHdFYn6XlJpE3pr/0S0I6ccaQJbX
         bk5Q==
X-Gm-Message-State: AOJu0Yx7tIGwIu4b2tTAj3u5/F/3ioYNDun7iYV3grID3CBW4/DejGbx
	u/P8cK9e5ekl9K84V1VkGnmrXuxA9FUsBDFoWPpuUYFYXRfo2nCTzVAPkg==
X-Gm-Gg: ASbGncsISlaGSeVmpn0dYTXIGZ/qRW1ZYrEnLxTW+7/KOZG13cIzBria6VBfJa4W+Gs
	2TYIlCXOwFRK2HAaL3Kj0zC3Px/EcnfiecxWz7O6FkMrXOaAgPoDZar1z3OffZBLt4qHj/+LVhc
	9iVFe+Ga+Q6cwmT7mXp2m3KayJlmWMwBS2rrXfyJPRhtWHCD4luIximv0Rq6fQSy30mzpt8yALP
	PPSwkwSJulUdgQBo7ZGj3srIAauJcDAmrKsYiVAHpbub/RJRgl11DaLP6dE8C+WzI4BXuzgD9dU
	/MHJdBP+e+0n4huJnqCzsNB/0q6Xye/iQocNwq8JlRs1PdNU86FwS0Belfkb0nxi5g==
X-Google-Smtp-Source: AGHT+IF0JrRPoY212Ltj2yQng9nxuZFG+no/AbHpugy+jHoH6fdhDcYt60hL0n8TEN/GepGlNNGzIQ==
X-Received: by 2002:a05:600c:45c5:b0:43d:fa59:af98 with SMTP id 5b1f17b1804b1-442f2179d72mr1191105e9.33.1747157154543;
        Tue, 13 May 2025 10:25:54 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.237])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d67e0ff1sm173034745e9.14.2025.05.13.10.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 10:25:53 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 6/6] io_uring/kbuf: unify legacy buf provision and removal
Date: Tue, 13 May 2025 18:26:51 +0100
Message-ID: <f61af131622ad4337c2fb9f7c453d5b0102c7b90.1747150490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1747150490.git.asml.silence@gmail.com>
References: <cover.1747150490.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Combine IORING_OP_PROVIDE_BUFFERS and IORING_OP_REMOVE_BUFFERS
->issue(), so that we can deduplicate ring locking and list lookups.
This way we further reduce code for legacy provided buffers. Locking is
also separated from buffer related handling, which makes it a bit
simpler with label jumps.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c  | 73 +++++++++++++++++++-----------------------------
 io_uring/kbuf.h  |  4 +--
 io_uring/opdef.c |  4 +--
 3 files changed, 31 insertions(+), 50 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index df8aeb42e910..823e7eb15fb2 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -450,30 +450,6 @@ int io_remove_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_provide_buf *p = io_kiocb_to_cmd(req, struct io_provide_buf);
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_buffer_list *bl;
-	int ret = 0;
-
-	io_ring_submit_lock(ctx, issue_flags);
-
-	ret = -ENOENT;
-	bl = io_buffer_get_list(ctx, p->bgid);
-	if (bl) {
-		ret = -EINVAL;
-		/* can't use provide/remove buffers command on mapped buffers */
-		if (!(bl->flags & IOBL_BUF_RING))
-			ret = io_remove_buffers_legacy(ctx, bl, p->nbufs);
-	}
-	io_ring_submit_unlock(ctx, issue_flags);
-	if (ret < 0)
-		req_set_fail(req);
-	io_req_set_res(req, ret, 0);
-	return IOU_OK;
-}
-
 int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	unsigned long size, tmp_check;
@@ -535,37 +511,44 @@ static int io_add_buffers(struct io_ring_ctx *ctx, struct io_provide_buf *pbuf,
 	return i ? 0 : -ENOMEM;
 }
 
-int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
+static int __io_manage_buffers_legacy(struct io_kiocb *req,
+					struct io_buffer_list *bl)
 {
 	struct io_provide_buf *p = io_kiocb_to_cmd(req, struct io_provide_buf);
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_buffer_list *bl;
-	int ret = 0;
-
-	io_ring_submit_lock(ctx, issue_flags);
+	int ret;
 
-	bl = io_buffer_get_list(ctx, p->bgid);
-	if (unlikely(!bl)) {
+	if (!bl) {
+		if (req->opcode != IORING_OP_PROVIDE_BUFFERS)
+			return -ENOENT;
 		bl = kzalloc(sizeof(*bl), GFP_KERNEL_ACCOUNT);
-		if (!bl) {
-			ret = -ENOMEM;
-			goto err;
-		}
+		if (!bl)
+			return -ENOMEM;
+
 		INIT_LIST_HEAD(&bl->buf_list);
-		ret = io_buffer_add_list(ctx, bl, p->bgid);
+		ret = io_buffer_add_list(req->ctx, bl, p->bgid);
 		if (ret) {
 			kfree(bl);
-			goto err;
+			return ret;
 		}
 	}
-	/* can't add buffers via this command for a mapped buffer ring */
-	if (bl->flags & IOBL_BUF_RING) {
-		ret = -EINVAL;
-		goto err;
-	}
+	/* can't use provide/remove buffers command on mapped buffers */
+	if (bl->flags & IOBL_BUF_RING)
+		return -EINVAL;
+	if (req->opcode == IORING_OP_PROVIDE_BUFFERS)
+		return io_add_buffers(req->ctx, p, bl);
+	return io_remove_buffers_legacy(req->ctx, bl, p->nbufs);
+}
+
+int io_manage_buffers_legacy(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_provide_buf *p = io_kiocb_to_cmd(req, struct io_provide_buf);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_buffer_list *bl;
+	int ret;
 
-	ret = io_add_buffers(ctx, p, bl);
-err:
+	io_ring_submit_lock(ctx, issue_flags);
+	bl = io_buffer_get_list(ctx, p->bgid);
+	ret = __io_manage_buffers_legacy(req, bl);
 	io_ring_submit_unlock(ctx, issue_flags);
 
 	if (ret < 0)
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 0798a732e6cb..4d2c209d1a41 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -66,10 +66,8 @@ int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg);
 void io_destroy_buffers(struct io_ring_ctx *ctx);
 
 int io_remove_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
-int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags);
-
 int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
-int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags);
+int io_manage_buffers_legacy(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index db36433c2294..6e0882b051f9 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -333,13 +333,13 @@ const struct io_issue_def io_issue_defs[] = {
 		.audit_skip		= 1,
 		.iopoll			= 1,
 		.prep			= io_provide_buffers_prep,
-		.issue			= io_provide_buffers,
+		.issue			= io_manage_buffers_legacy,
 	},
 	[IORING_OP_REMOVE_BUFFERS] = {
 		.audit_skip		= 1,
 		.iopoll			= 1,
 		.prep			= io_remove_buffers_prep,
-		.issue			= io_remove_buffers,
+		.issue			= io_manage_buffers_legacy,
 	},
 	[IORING_OP_TEE] = {
 		.needs_file		= 1,
-- 
2.49.0


