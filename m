Return-Path: <io-uring+bounces-1315-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D6AC890E8E
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 00:35:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE7D529AC3C
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 23:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C3AC80BE0;
	Thu, 28 Mar 2024 23:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="teIZ5hNL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C224E136E2F
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 23:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711668905; cv=none; b=IJndIs2hvn4Z98QOz7NKqJ2JGp9ejLTSIK2MhE3vWGXkYQHFGdsORJMbsrNpIk5K/OLccQwzSNBVNFAtcemKv9hC4sVqP3UZI9Fzn0CfUWQOva2+1bTDIwumeCgQSUpQGzoJMJAXlYGMHzXnQaGidPsKyukGYWDLGGp7i08UOG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711668905; c=relaxed/simple;
	bh=5YqocHr5mxuGOr5Z0D+Jj5Z+RZ0wDYj67RIhWvHLoys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwYwKmynCgat1wzI/PORK9Ql2VKwzQ78WZvilkgPztGwQphO/r0h+hcHx5VsT+UVP8+/fP7g0jalS8nmgkxuJxUGYUrzktZpLbiIHo/9vv4KJUqBMm1amEvelxbQ206z9Oi1hEK7CjGWt2F0E7CZhxI8Wb1bTOCzhpKy/WCZNgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=teIZ5hNL; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5d862e8b163so317588a12.1
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 16:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711668902; x=1712273702; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dRbXBnmBssLCefthvGjqIke1i8J8DEDsrgn5OvhdPnw=;
        b=teIZ5hNLpjWL4f2YYNHiFcN1bHOtAivqdcs11h8WICOgDuAm08cZlHHBv2EQH1xF4A
         48/6RwBNjoOqLOq/tjBZntr/sd5aQruAFLQbZMX4bU9qikozIxkKfmmifiDySxjoQ4mb
         pg03reP5RUTG/aCLsEx9tpvwRfETzgVFNTVXBDFhSfHAdbKbEWfq/gK971wWvOXilAN5
         KUTmD4bWoSV+V+mfA/q1lShTEFLKfffzvzexqqqarQJKVEema9SzVfvbg8sp68hoKJ3h
         3hS/yA4rGMm8LVMXFaapxcC1jlTuNogWSOsyIerH9qF3qbgB45b9TDm7B9A8ZV6Qery8
         2xug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711668902; x=1712273702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dRbXBnmBssLCefthvGjqIke1i8J8DEDsrgn5OvhdPnw=;
        b=OXu/MZi1MF4SBan18DcVOyxL4kQDrvc1y8j+pK44DyCbs7qHQQh8oBbA+Q832ve+VN
         8EDoaua4T8K7aDfc6QRjL7Qk/Ye1aOT2fUaVWYrI+9oi+5peGCy6WMXhL3pcjmRLyxfK
         XB1mEbGo7AL7TAWenL0SihkOSFRTfPWiJqIpimbPrGrpwr+dyf+1tEjhXbIuZfxhFrAG
         d47N/3XsQBSAjglqhAHjgDxkiUvhpX/bt9i5JHSGwsOGKu+EVmvDdA8llnjnKyYSGt5N
         z2DYLvOLWfpKoxFixoi2el9I32jnYt4VJrtgXGCJK+wKsXzHUTFHjgfsKufBbVEdQqAB
         PRtg==
X-Gm-Message-State: AOJu0Yxp+5+zPm2R72TCnvpradGxXIqj+NSpx5iSxdakj5fWY1nBJZhA
	1LrOfCr6jZliesUyYeRkk83PR5wZlhya6BKYnW2dYr3CSShOy41fAug4xS6qTfsCG3bwjibSLPu
	x
X-Google-Smtp-Source: AGHT+IGnkir1bN5136ABMvARK0KWrUS1v8cnv/2ciEs2ZgD62XmYdr831W5IH0VHpvUGUB6Jfiipeg==
X-Received: by 2002:a17:902:c401:b0:1dd:e128:16b1 with SMTP id k1-20020a170902c40100b001dde12816b1mr933529plk.6.1711668902540;
        Thu, 28 Mar 2024 16:35:02 -0700 (PDT)
Received: from localhost.localdomain ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id i6-20020a170902c94600b001e0b3c9fe60sm2216981pla.46.2024.03.28.16.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 16:35:00 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: hannes@cmpxchg.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/11] io_uring/kbuf: protect io_buffer_list teardown with a reference
Date: Thu, 28 Mar 2024 17:31:35 -0600
Message-ID: <20240328233443.797828-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240328233443.797828-1-axboe@kernel.dk>
References: <20240328233443.797828-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No functional changes in this patch, just in preparation for being able
to keep the buffer list alive outside of the ctx->uring_lock.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 15 +++++++++++----
 io_uring/kbuf.h |  2 ++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 72c15dde34d3..206f4d352e15 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -62,6 +62,7 @@ static int io_buffer_add_list(struct io_ring_ctx *ctx,
 	 * always under the ->uring_lock, but the RCU lookup from mmap does.
 	 */
 	bl->bgid = bgid;
+	atomic_set(&bl->refs, 1);
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
@@ -259,6 +260,14 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 	return i;
 }
 
+static void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
+{
+	if (atomic_dec_and_test(&bl->refs)) {
+		__io_remove_buffers(ctx, bl, -1U);
+		kfree_rcu(bl, rcu);
+	}
+}
+
 void io_destroy_buffers(struct io_ring_ctx *ctx)
 {
 	struct io_buffer_list *bl;
@@ -268,8 +277,7 @@ void io_destroy_buffers(struct io_ring_ctx *ctx)
 
 	xa_for_each(&ctx->io_bl_xa, index, bl) {
 		xa_erase(&ctx->io_bl_xa, bl->bgid);
-		__io_remove_buffers(ctx, bl, -1U);
-		kfree_rcu(bl, rcu);
+		io_put_bl(ctx, bl);
 	}
 
 	/*
@@ -671,9 +679,8 @@ int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	if (!bl->is_buf_ring)
 		return -EINVAL;
 
-	__io_remove_buffers(ctx, bl, -1U);
 	xa_erase(&ctx->io_bl_xa, bl->bgid);
-	kfree_rcu(bl, rcu);
+	io_put_bl(ctx, bl);
 	return 0;
 }
 
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index fdbb10449513..8b868a1744e2 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -25,6 +25,8 @@ struct io_buffer_list {
 	__u16 head;
 	__u16 mask;
 
+	atomic_t refs;
+
 	/* ring mapped provided buffers */
 	__u8 is_buf_ring;
 	/* ring mapped provided buffers, but mmap'ed by application */
-- 
2.43.0


