Return-Path: <io-uring+bounces-4252-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FC019B7237
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 02:49:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A9742811BC
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 01:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54C628BE5;
	Thu, 31 Oct 2024 01:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1XeceYge"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9872E406
	for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 01:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730339199; cv=none; b=V0yghVgjC5fvC6Wtg/9pLSPHYubMb06frlQ9IEInjIXb9k+pl4waDaOQcFotBVSLPllHvqG4npJ9axpV/GST2AZCMUgauezKQB4H8thvx6wcpYsSjssM+EtPlDwPIL9eCZVz8/0Q5hK2g4Qg+QkW4mu7Pw0KTsExr0NFa4lO7HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730339199; c=relaxed/simple;
	bh=sg3VKsYKsMcKEPhJ6KP60n7sMwrFuR8vpAzlOn2TBTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQvqMQMjXLJRQsCVGdfyOoo6EC1zIZrnHm0Z2qMW1tPlx0XDMbTGj8ikEhWeKOySZ0JhO8lcnxsqRvlgQACt/Fowz0AhcPsfn922gH5AE0Yjn17XjG2s6BPo9IiG2gUkO4pi4pBee+G2PK2b3HoOT55u8xjgP637zxwi54oSMMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1XeceYge; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-71e983487a1so335340b3a.2
        for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 18:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730339196; x=1730943996; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DnMm/gehdUoU0nc4Lg5FWge2zIvUQmjhMYJrom18ThY=;
        b=1XeceYgeBl3TlGmS38ojRu+hcP38XyP2z0tlrpMwjXTm8wO5nhTuGwxQCauveAkQnp
         OBvmisi3oZ5uONKNxpylH9gS7uB9gllke7fsXblvoanYqvTLhcrXssPeOrMsN1flihad
         hRrb7lZbQK6oZWURhsGsk7uDhzxzpvvxRnefkYQHxRdZTyoszzTAmLascahYAzartQ+W
         d4S2fuqH5ARJe8w7vhc1mfU9HsItkCUEyC4yBDywFsQMYi2BQFV+lEg2xd5WTlqJL819
         No09XmAAtiI++QdmmolZ67mdbNx/kyEjdC9I6gEDlCR3bU6zsVYmBtnv5apF0OGIAJLk
         pz/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730339196; x=1730943996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DnMm/gehdUoU0nc4Lg5FWge2zIvUQmjhMYJrom18ThY=;
        b=b/qAZ28GF2RtKsBXTEoSwCltbnEzeVfTCW6OxdTEXUwALjfDqGR8s2tnmhxIEZkOwQ
         bSsSo3WPGrtXhbJy1SUJXDVtNgML6X6adFyqVBhAluWsDqiQv28MeUsjSODF/hgV5MkQ
         AFGGZVFRwR5raMf+wR/jSIcB++BvS8RGsm9JxIBbRvu0bPPG9XWasTf7FnySYop4IF45
         ZzV2xvnspCx2X3TnuoVEb+GnLr7A8RrqghRH43TLpe2DYmnE7kAj2+OrWcQan5KPgKOW
         xzn+2xGRJyPQBJ1BXbJVfxQU/bopec1BoKwuVVpMSG5szfvbAD7SXVKoxJMlu26kxmOY
         SPTw==
X-Gm-Message-State: AOJu0YwOTRQsThc3Wl+x6BvI9yv+BzOzKlkne2IxphYG/sUygNXKsLK4
	Fu3sfrg+NReiaCyr5EhC1J1w1K+V2i0ePaDVnraro7N/p1iWd88C8XxFTxKWwUPVgMkyOPpcBm4
	CMTE=
X-Google-Smtp-Source: AGHT+IEvTEg5LrntTAc/5ui+cGtM+oAECNm1hTvBqO5bJk8TG8LN8uesUXcv7NEeMBOy7p6SpE/R8A==
X-Received: by 2002:a05:6a00:148f:b0:71e:4296:2e with SMTP id d2e1a72fcca58-720b9c942damr1343051b3a.11.1730339195888;
        Wed, 30 Oct 2024 18:46:35 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc315aafsm285872b3a.197.2024.10.30.18.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 18:46:35 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/rsrc: allow cloning with node replacements
Date: Wed, 30 Oct 2024 19:44:56 -0600
Message-ID: <20241031014629.206573-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241031014629.206573-1-axboe@kernel.dk>
References: <20241031014629.206573-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently cloning a buffer table will fail if the destination already has
a table. But it should be possible to use it to replace existing elements.
Add a IORING_REGISTER_DST_REPLACE cloning flag, which if set, will allow
the destination to already having a buffer table. If that is the case,
then entries designated by offset + nr buffers will be replaced if they
already exist.

Note that it's allowed to use IORING_REGISTER_DST_REPLACE and not have
an existing table, in which case it'll work just like not having the
flag set and an empty table - it'll just assign the newly created table
for that case.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  3 +-
 io_uring/rsrc.c               | 66 +++++++++++++++++++++++++++--------
 2 files changed, 54 insertions(+), 15 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index cc8dbe78c126..ce58c4590de6 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -713,7 +713,8 @@ struct io_uring_clock_register {
 };
 
 enum {
-	IORING_REGISTER_SRC_REGISTERED = 1,
+	IORING_REGISTER_SRC_REGISTERED	= (1U << 0),
+	IORING_REGISTER_DST_REPLACE	= (1U << 1),
 };
 
 struct io_uring_clone_buffers {
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d00870128bb9..673ff00da727 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -927,8 +927,40 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx,
 			    struct io_uring_clone_buffers *arg)
 {
-	int i, ret, nbufs, off, nr;
 	struct io_rsrc_data data;
+	int i, ret, off, nr;
+	unsigned int nbufs;
+
+	/* if offsets are given, must have nr specified too */
+	if (!arg->nr && (arg->dst_off || arg->src_off))
+		return -EINVAL;
+	/* not allowed unless REPLACE is set */
+	if (ctx->buf_table.nr && !(arg->flags & IORING_REGISTER_DST_REPLACE))
+		return -EBUSY;
+
+	nbufs = READ_ONCE(src_ctx->buf_table.nr);
+	if (!arg->nr)
+		arg->nr = nbufs;
+	else if (arg->nr > nbufs)
+		return -EINVAL;
+	else if (arg->nr > IORING_MAX_REG_BUFFERS)
+		return -EINVAL;
+	if (check_add_overflow(arg->nr, arg->dst_off, &nbufs))
+		return -EOVERFLOW;
+
+	ret = io_rsrc_data_alloc(&data, max(nbufs, ctx->buf_table.nr));
+	if (ret)
+		return ret;
+
+	/* Fill entries in data from dst that won't overlap with src */
+	for (i = 0; i < min(arg->dst_off, ctx->buf_table.nr); i++) {
+		struct io_rsrc_node *src_node = ctx->buf_table.nodes[i];
+
+		if (src_node) {
+			data.nodes[i] = src_node;
+			src_node->refs++;
+		}
+	}
 
 	/*
 	 * Drop our own lock here. We'll setup the data we need and reference
@@ -951,14 +983,6 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		goto out_unlock;
 	if (off > nbufs)
 		goto out_unlock;
-	if (check_add_overflow(arg->nr, arg->dst_off, &off))
-		goto out_unlock;
-	ret = -EINVAL;
-	if (off > IORING_MAX_REG_BUFFERS)
-		goto out_unlock;
-	ret = io_rsrc_data_alloc(&data, off);
-	if (ret)
-		goto out_unlock;
 
 	off = arg->dst_off;
 	i = arg->src_off;
@@ -986,6 +1010,20 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 	/* Have a ref on the bufs now, drop src lock and re-grab our own lock */
 	mutex_unlock(&src_ctx->uring_lock);
 	mutex_lock(&ctx->uring_lock);
+
+	/*
+	 * If asked for replace, put the old table. data->nodes[] holds both
+	 * old and new nodes at this point.
+	 */
+	if (arg->flags & IORING_REGISTER_DST_REPLACE)
+		io_rsrc_data_free(&ctx->buf_table);
+
+	/*
+	 * ctx->buf_table should be empty now - either the contents are being
+	 * replaced and we just freed the table, or someone raced setting up
+	 * a buffer table while the clone was happening. If not empty, fall
+	 * through to failure handling.
+	 */
 	if (!ctx->buf_table.nr) {
 		ctx->buf_table = data;
 		return 0;
@@ -995,14 +1033,14 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 	mutex_lock(&src_ctx->uring_lock);
 	/* someone raced setting up buffers, dump ours */
 	ret = -EBUSY;
-	i = nbufs;
 out_put_free:
+	i = data.nr;
 	while (i--) {
 		io_buffer_unmap(src_ctx, data.nodes[i]);
 		kfree(data.nodes[i]);
 	}
-	io_rsrc_data_free(&data);
 out_unlock:
+	io_rsrc_data_free(&data);
 	mutex_unlock(&src_ctx->uring_lock);
 	mutex_lock(&ctx->uring_lock);
 	return ret;
@@ -1022,12 +1060,12 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 	struct file *file;
 	int ret;
 
-	if (ctx->buf_table.nr)
-		return -EBUSY;
 	if (copy_from_user(&buf, arg, sizeof(buf)))
 		return -EFAULT;
-	if (buf.flags & ~IORING_REGISTER_SRC_REGISTERED)
+	if (buf.flags & ~(IORING_REGISTER_SRC_REGISTERED|IORING_REGISTER_DST_REPLACE))
 		return -EINVAL;
+	if (!(buf.flags & IORING_REGISTER_DST_REPLACE) && ctx->buf_table.nr)
+		return -EBUSY;
 	if (memchr_inv(buf.pad, 0, sizeof(buf.pad)))
 		return -EINVAL;
 
-- 
2.45.2


