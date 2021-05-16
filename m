Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E53538215D
	for <lists+io-uring@lfdr.de>; Sun, 16 May 2021 23:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbhEPV7x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 May 2021 17:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhEPV7v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 May 2021 17:59:51 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B70C06174A
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:36 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id c14so2621150wrx.3
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=p+hJI0HovtYmpNHRZgtfBLBMF8M+vQo12o2fEFpY2uQ=;
        b=eCsymxmqxQ7Z68n/yJLUsTdKfhKHQfAsw0yYC2RiDWvsvYvDS+TBhrZjRBCgJbSpxw
         9R9C6ZmzQsdtrPn/RvgE8Mv6/dG4B4ql6ZHAnC9mx+LynGzWVNCsE64a5nZGPq0xmTjV
         3In2RparEVAowSSVHlubPe5es3zkZsKZA8YPtNIufPksOHblAbXnuIUnRiROXvBAmLZH
         UFKQt+BRQ4zXoMvv2XDJouHEaCLOJO1CHH3KSk+ZIK8iyZeuApezTDkJ5E3IsUKBC8ji
         vSHrZkLsCY5+OAxSFeYJSucYIkWiRE3/nXuZ0cfu0gKN7LuOYj2U5TU1IbaIWy2TUpJU
         DywQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p+hJI0HovtYmpNHRZgtfBLBMF8M+vQo12o2fEFpY2uQ=;
        b=BBXD5DxP8iwPk99BYc+yu/1PYYbRjSpC4A/hWSB3AarMV8F+mDVoG4qQVkk8bkM5BP
         qHSsnajhj9RAx4eFzfIU27Nc7QQRqwEzOUGFXrXCKJ+hICS+MBdKWNaKelRFu7VqCckM
         vqBK0AE7x9Hi3DAw/hJJZeJX0DdzxBQvyIqUbJnmRPqAe8Ak2tabznTCrYTw/hztOkE+
         qsSWAZg5ZHltg4szU5AL/nh2MpVbsBUFvnmIJA+Ce00Ap2YT3LWOmCmVcyJkE3EIOzpp
         df5p+6Xe61wdAXSSTMeLVfVUxnq8fBM4HFxlia22nndG/7uXLXg/u3UbuhujPTDvXuWY
         if0Q==
X-Gm-Message-State: AOAM531OjMlFlEm4ZCnGCfkMikHxtMlKbVwRny2DquHLC3dZFEPoneq7
        JUQPZfc+q4QGDZZhMUKUWXxW35Ap7HQ=
X-Google-Smtp-Source: ABdhPJw/2pao1fVZFfap4l8l+RTjFIF+21INPR8nqEbzVboW7V9k9Xk34CUXS5elhiG2iScRloExnQ==
X-Received: by 2002:adf:f9ce:: with SMTP id w14mr12591008wrr.387.1621202315324;
        Sun, 16 May 2021 14:58:35 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.7])
        by smtp.gmail.com with ESMTPSA id p10sm13666365wmq.14.2021.05.16.14.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 14:58:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 10/13] io_uring: deduce cq_mask from cq_entries
Date:   Sun, 16 May 2021 22:58:09 +0100
Message-Id: <d439efad0503c8398451dae075e68a04362fbc8d.1621201931.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621201931.git.asml.silence@gmail.com>
References: <cover.1621201931.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

No need to cache cq_mask, it's exactly cq_entries - 1, so just deduce
it to not carry it around.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f06bd4123a98..2bdc30ebf708 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -362,7 +362,6 @@ struct io_ring_ctx {
 		u32			*sq_array;
 		unsigned		cached_sq_head;
 		unsigned		sq_entries;
-		unsigned		sq_mask;
 		unsigned		sq_thread_idle;
 		unsigned		cached_sq_dropped;
 		unsigned		cached_cq_overflow;
@@ -408,7 +407,6 @@ struct io_ring_ctx {
 	struct {
 		unsigned		cached_cq_tail;
 		unsigned		cq_entries;
-		unsigned		cq_mask;
 		atomic_t		cq_timeouts;
 		unsigned		cq_last_tm_flush;
 		unsigned		cq_extra;
@@ -1362,7 +1360,7 @@ static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
 static inline struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings = ctx->rings;
-	unsigned tail;
+	unsigned tail, mask = ctx->cq_entries - 1;
 
 	/*
 	 * writes to the cq entry need to come after reading head; the
@@ -1373,7 +1371,7 @@ static inline struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
 		return NULL;
 
 	tail = ctx->cached_cq_tail++;
-	return &rings->cqes[tail & ctx->cq_mask];
+	return &rings->cqes[tail & mask];
 }
 
 static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
@@ -6675,7 +6673,7 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
 static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 {
 	u32 *sq_array = ctx->sq_array;
-	unsigned head;
+	unsigned head, mask = ctx->sq_entries - 1;
 
 	/*
 	 * The cached sq head (or cq tail) serves two purposes:
@@ -6685,7 +6683,7 @@ static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 	 * 2) allows the kernel side to track the head on its own, even
 	 *    though the application is the one updating it.
 	 */
-	head = READ_ONCE(sq_array[ctx->cached_sq_head++ & ctx->sq_mask]);
+	head = READ_ONCE(sq_array[ctx->cached_sq_head++ & mask]);
 	if (likely(head < ctx->sq_entries))
 		return &ctx->sq_sqes[head];
 
@@ -9495,8 +9493,6 @@ static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	rings->cq_ring_mask = p->cq_entries - 1;
 	rings->sq_ring_entries = p->sq_entries;
 	rings->cq_ring_entries = p->cq_entries;
-	ctx->sq_mask = rings->sq_ring_mask;
-	ctx->cq_mask = rings->cq_ring_mask;
 
 	size = array_size(sizeof(struct io_uring_sqe), p->sq_entries);
 	if (size == SIZE_MAX) {
-- 
2.31.1

