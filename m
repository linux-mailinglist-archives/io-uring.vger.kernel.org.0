Return-Path: <io-uring+bounces-2691-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A19A094DF79
	for <lists+io-uring@lfdr.de>; Sun, 11 Aug 2024 03:34:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CFD91F216DA
	for <lists+io-uring@lfdr.de>; Sun, 11 Aug 2024 01:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D05BC5234;
	Sun, 11 Aug 2024 01:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1lsi9pwE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07D133C9
	for <io-uring@vger.kernel.org>; Sun, 11 Aug 2024 01:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723340050; cv=none; b=Mse37r4I2SKqLfOHkeJ95xQcj8Mx6cCHZFGR6453G2Rfda7nc33XXD8vpiBVfHTPCgcfNc2Z2fSN/PezfHRgHxmKbylPIyaC2c6RpHR0+8BJG0HxcaqGGtOxQJhV99e9kKm1gDnFadf1aZboYo7/BhcVakyjTh9hqsaf40dL1Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723340050; c=relaxed/simple;
	bh=FoZsxdqVqhOWIGcTvUPOWRC5eoH9cmbu+fhErSzCvWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmYdMxTV8OjRXiWw2OZQJ9MOpNnOZ9GihcuEmecB2V5c7kvvbhwYDjJR1XEghlWW11X7ENp1oqplMEqJ6OR9VKp1pkv5UoC4At2BTHpTbauWvASTGRlcyHsyTKqDInBoURmA9BLwvB/qXIKH2V3Nb8VvSJxQ5OEArge4VVWER2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1lsi9pwE; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2cb5a947b7dso655695a91.3
        for <io-uring@vger.kernel.org>; Sat, 10 Aug 2024 18:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723340046; x=1723944846; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sygJSb5oQSy7tKqXgFhTlLsR2iXwwWidUNtJbMEOPAI=;
        b=1lsi9pwEjbnbRr5tNPkiwPAnJXnLjurSJxh0+ocXXOkLS4WDg5MfPSAF/WcOutEBDy
         UQALmqrPx4a3ruuOndHQN06Ds0U5zQjSsuv3iQPWWkHfsYpG69Lp6wWEFm1yVqjZcIYR
         zbIVLdkFFmiVm0xFUeEN0VK7Zq4L1zruJ8oHe5aGJSssA4ONKszYzHzTv1jI1RLZD+GW
         s37BB8HfpkD3J0YFCHhB4JDlneaZZwutzqyRn1LBvpzW/UyGyk/OeIOI70SEuIy6iXSv
         m3Dv2Ea+iBQy1W3F9+IHVIzyLJlFDZjT65ZGNM+0cM6qMpBiDacqvZcpCjJUAvVtRndh
         JLDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723340046; x=1723944846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sygJSb5oQSy7tKqXgFhTlLsR2iXwwWidUNtJbMEOPAI=;
        b=h7mamtiN2Go5LZ+Sv/Ll8pSK3kGiuaVrM/olugXR3W1aqjdjeZfqp3QFtHto9v49yJ
         NHQtAhUo61hhJ7SSzXgMySlOxz9jQMbYaa2VTyGn2FuNWNU7oS3eSqPrycl4tVQmylYs
         QlqR9xKHQoTDdFA/WKy/32O4Eu5VRNhfZpBCc8X8RTa61Tgf7LCQoJlMrj08X0TPre/c
         W8HfKQKTnY4+d97w7LMYPzaFFD21mllgvEbbVaxwYlOwNcj4fSrg24zAG7fJPg3lXFlU
         RChnt+uJBh2+NHYKBxbmzRiPl6Ad0zKQBWws6BhngJTm9eH8k53DjrCb9PBbdENmgkJv
         vZMA==
X-Gm-Message-State: AOJu0YyUcX+IPJD5tXk1bGiU29bNWXfj5zy16C7r8PGf8nXKtYGGcjUW
	crx9z0A7ViBz7joJEIGcLJW5ivUeUdKwajZYh+T/I4Tby8iu6Kfzwb8cpqoNnOBL5vfcAgI/615
	P
X-Google-Smtp-Source: AGHT+IGQBWIJsuRWIpi8Mvm8zsmvCnlARj5NX+WVYZdEyll5JJJWZITc/3vkyfTlbdrMaZr3Aj59Ag==
X-Received: by 2002:a05:6a20:a10e:b0:1c6:89d3:5a59 with SMTP id adf61e73a8af0-1c89f9ae58dmr5109500637.0.1723340046566;
        Sat, 10 Aug 2024 18:34:06 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c3dbea4389sm1852477a12.84.2024.08.10.18.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Aug 2024 18:34:05 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/kbuf: turn io_buffer_list booleans into flags
Date: Sat, 10 Aug 2024 19:33:00 -0600
Message-ID: <20240811013359.7112-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240811013359.7112-1-axboe@kernel.dk>
References: <20240811013359.7112-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We could just move these two and save some space, but in preparation
for adding another flag, turn them into flags first.

This saves 8 bytes in struct io_buffer_list, making it exactly half
a cacheline on 64-bit archs now rather than 40 bytes.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 35 +++++++++++++++++------------------
 io_uring/kbuf.h | 14 +++++++++-----
 2 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index c75b22d246ec..277b8e66a8cb 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -189,7 +189,7 @@ void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 
 	bl = io_buffer_get_list(ctx, req->buf_index);
 	if (likely(bl)) {
-		if (bl->is_buf_ring)
+		if (bl->flags & IOBL_BUF_RING)
 			ret = io_ring_buffer_select(req, len, bl, issue_flags);
 		else
 			ret = io_provided_buffer_select(req, len, bl);
@@ -284,7 +284,7 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 	if (unlikely(!bl))
 		goto out_unlock;
 
-	if (bl->is_buf_ring) {
+	if (bl->flags & IOBL_BUF_RING) {
 		ret = io_ring_buffers_peek(req, arg, bl);
 		/*
 		 * Don't recycle these buffers if we need to go through poll.
@@ -317,7 +317,7 @@ int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg)
 	if (unlikely(!bl))
 		return -ENOENT;
 
-	if (bl->is_buf_ring) {
+	if (bl->flags & IOBL_BUF_RING) {
 		ret = io_ring_buffers_peek(req, arg, bl);
 		if (ret > 0)
 			req->flags |= REQ_F_BUFFERS_COMMIT;
@@ -337,22 +337,22 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 	if (!nbufs)
 		return 0;
 
-	if (bl->is_buf_ring) {
+	if (bl->flags & IOBL_BUF_RING) {
 		i = bl->buf_ring->tail - bl->head;
 		if (bl->buf_nr_pages) {
 			int j;
 
-			if (!bl->is_mmap) {
+			if (!(bl->flags & IOBL_MMAP)) {
 				for (j = 0; j < bl->buf_nr_pages; j++)
 					unpin_user_page(bl->buf_pages[j]);
 			}
 			io_pages_unmap(bl->buf_ring, &bl->buf_pages,
-					&bl->buf_nr_pages, bl->is_mmap);
-			bl->is_mmap = 0;
+					&bl->buf_nr_pages, bl->flags & IOBL_MMAP);
+			bl->flags &= ~IOBL_MMAP;
 		}
 		/* make sure it's seen as empty */
 		INIT_LIST_HEAD(&bl->buf_list);
-		bl->is_buf_ring = 0;
+		bl->flags &= ~IOBL_BUF_RING;
 		return i;
 	}
 
@@ -439,7 +439,7 @@ int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 	if (bl) {
 		ret = -EINVAL;
 		/* can't use provide/remove buffers command on mapped buffers */
-		if (!bl->is_buf_ring)
+		if (!(bl->flags & IOBL_BUF_RING))
 			ret = __io_remove_buffers(ctx, bl, p->nbufs);
 	}
 	io_ring_submit_unlock(ctx, issue_flags);
@@ -586,7 +586,7 @@ int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 		}
 	}
 	/* can't add buffers via this command for a mapped buffer ring */
-	if (bl->is_buf_ring) {
+	if (bl->flags & IOBL_BUF_RING) {
 		ret = -EINVAL;
 		goto err;
 	}
@@ -638,8 +638,8 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 	bl->buf_pages = pages;
 	bl->buf_nr_pages = nr_pages;
 	bl->buf_ring = br;
-	bl->is_buf_ring = 1;
-	bl->is_mmap = 0;
+	bl->flags |= IOBL_BUF_RING;
+	bl->flags &= ~IOBL_MMAP;
 	return 0;
 error_unpin:
 	unpin_user_pages(pages, nr_pages);
@@ -662,8 +662,7 @@ static int io_alloc_pbuf_ring(struct io_ring_ctx *ctx,
 		return -ENOMEM;
 	}
 
-	bl->is_buf_ring = 1;
-	bl->is_mmap = 1;
+	bl->flags |= (IOBL_BUF_RING | IOBL_MMAP);
 	return 0;
 }
 
@@ -702,7 +701,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	bl = io_buffer_get_list(ctx, reg.bgid);
 	if (bl) {
 		/* if mapped buffer ring OR classic exists, don't allow */
-		if (bl->is_buf_ring || !list_empty(&bl->buf_list))
+		if (bl->flags & IOBL_BUF_RING || !list_empty(&bl->buf_list))
 			return -EEXIST;
 	} else {
 		free_bl = bl = kzalloc(sizeof(*bl), GFP_KERNEL);
@@ -744,7 +743,7 @@ int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	bl = io_buffer_get_list(ctx, reg.bgid);
 	if (!bl)
 		return -ENOENT;
-	if (!bl->is_buf_ring)
+	if (!(bl->flags & IOBL_BUF_RING))
 		return -EINVAL;
 
 	xa_erase(&ctx->io_bl_xa, bl->bgid);
@@ -768,7 +767,7 @@ int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg)
 	bl = io_buffer_get_list(ctx, buf_status.buf_group);
 	if (!bl)
 		return -ENOENT;
-	if (!bl->is_buf_ring)
+	if (!(bl->flags & IOBL_BUF_RING))
 		return -EINVAL;
 
 	buf_status.head = bl->head;
@@ -799,7 +798,7 @@ struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
 	bl = xa_load(&ctx->io_bl_xa, bgid);
 	/* must be a mmap'able buffer ring and have pages */
 	ret = false;
-	if (bl && bl->is_mmap)
+	if (bl && bl->flags & IOBL_MMAP)
 		ret = atomic_inc_not_zero(&bl->refs);
 	rcu_read_unlock();
 
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index b90aca3a57fa..2ed141d7662e 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -4,6 +4,13 @@
 
 #include <uapi/linux/io_uring.h>
 
+enum {
+	/* ring mapped provided buffers */
+	IOBL_BUF_RING	= 1,
+	/* ring mapped provided buffers, but mmap'ed by application */
+	IOBL_MMAP	= 2,
+};
+
 struct io_buffer_list {
 	/*
 	 * If ->buf_nr_pages is set, then buf_pages/buf_ring are used. If not,
@@ -25,12 +32,9 @@ struct io_buffer_list {
 	__u16 head;
 	__u16 mask;
 
-	atomic_t refs;
+	__u16 flags;
 
-	/* ring mapped provided buffers */
-	__u8 is_buf_ring;
-	/* ring mapped provided buffers, but mmap'ed by application */
-	__u8 is_mmap;
+	atomic_t refs;
 };
 
 struct io_buffer {
-- 
2.43.0


