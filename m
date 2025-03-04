Return-Path: <io-uring+bounces-6941-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B4B5A4E488
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 16:59:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B8B27A376B
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 15:57:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D77C298CCD;
	Tue,  4 Mar 2025 15:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yl2erDxx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6B9298CB1
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 15:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741102785; cv=none; b=pmjaO4VLbOWCd7qdT12mm3+yf9d95eyh1q6SIDmKo1T2UMMEynnGtvCN1I0b/NfKtYdHge13Lk6tCX5WvecFt3T0XmuhwT3mzHHc0L63UTUcCm/BnbOQ0AJaqcLmo3IdJV5jQUg2XhPt5XusQbq1MNXiHzSejHi+VrDSRuGeERs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741102785; c=relaxed/simple;
	bh=zWZarhNyJi53T++SjywLAAUqP8VMK2X1hgd352VZQsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxbsLEOZTIWZJWZ6xKvmKWT1JUlnEF6OHrFY9IKyh8wxggUWN2LOq1D9vq+h+5DHDQievq3UQKhbSMPa7Rc1Wh/3Nyj5C7XhcwtSCrFkmVQNKCkrirv8eBNms8iC7al75IH/t/D9PvzCsNFbeHZRoxeeN6PlYhpQt34WprpVlto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yl2erDxx; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-abf45d8db04so547435666b.1
        for <io-uring@vger.kernel.org>; Tue, 04 Mar 2025 07:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741102781; x=1741707581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7RWfRi6x1mSPiivij2EBvrzcTuGy50QoeAUbZiSRBp0=;
        b=Yl2erDxxvKlBSXiKMgGGxAORzJfvwr8Hn+nICktGhyaV3lBYF3khpSUBeE979v14WX
         oEDuRZVfzeMGtidc2KQW5gJEWB2NKKj81QIdrSliOoFW00fU6MJTk6gBnsiQW4cKEqbN
         xV0DxUIr+FoYt8YPBqpNp7JeOEggTfOv9qRldUwzbXBIkXFSaJfq2E54TdcUlckltqKM
         UjkfXU383PhTAPRgdW+OGDxyemp3LvnJH9roSaoKwTJRpuNvWX8uXiWaKn30QlFmjebc
         OlimAS1HlSvCbACLEJ8ixKXZE0k1mMpl27k7eK3J2RWNTSaJoXKzXFR4u/mIMdOqytZk
         cmEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741102781; x=1741707581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7RWfRi6x1mSPiivij2EBvrzcTuGy50QoeAUbZiSRBp0=;
        b=tKZTclnt/2pkzf1wFrFYhhIgUuAl7NCCV8V5XLANA6+hGiu0wX6zGk3w4Ov8Ev29SQ
         XevU1m/ONvRR+AEQ78UaML5ga6SXQjahaaugQxXGRScNCG1TMU7mx+u0lkSS6/B0Ik2I
         y6qO4H5hSXI8EBGuKNiC4W2OZLDXHS0Xh1QxIxB70MFlzVYBP5DB3eE3C4aTXie+EEVb
         QT3pClFNdsZdAAE8NwCXwOWGso6paryDEopXy76EdXL1h42gxU3za38k1HOtrRu8LJqQ
         VV8LXVl5ZL8ZvsaXJ+BiPQwnmp9W/lLSRRPP2zC1LrdN0QmpdnVl/ySiTEQH4ZKFnr+o
         ZFRQ==
X-Gm-Message-State: AOJu0YzoiBPr3+FRHiV29690GuZaH+xpYZUKhz7EhYpXR3HnXEZt5ibI
	70BhxX3V8i8BpoFBdtdaoqWAi3Odbr+nyWvo9bVEX89I5xm7TXpvXG7vog==
X-Gm-Gg: ASbGnctoWygQUDfpIWvImdc8rMmEqkssktR4hGMC+KE6sB8OIubh0TGfJjmQN90pWqk
	hFIjQATfDtwF5WbOfSjWyRJGwzYGUlE1kMCmBjAgMOEWFwz5Q2sZ6toiz2BUcs7EhM7mKzFtXxF
	gKTC3CNl+6XD3aPmXfn+9lm+695+rpVpnx64DZ9Q7LwFt5gB0OilWHtjAyElvrFea8Zktgw/uDb
	eJtndV4r2y6AHeWUs/PnfpIVYVYfrAyDI/WjuDAKCg0cmK/6CQ89aRqR14hzGUd5t1HRyz4ChGK
	OzibfcO5BAXlVg/1Sjp37GI5gL6E
X-Google-Smtp-Source: AGHT+IHMUHrwzkgKWkhbjtHORjGFuk9rE/fkXaSlVEt/16ru+vPKkCRSKX8XcrCVrXY5mPsp7YcOIg==
X-Received: by 2002:a17:907:9622:b0:abf:4f72:538e with SMTP id a640c23a62f3a-abf4f728fd5mr1581937366b.55.1741102780780;
        Tue, 04 Mar 2025 07:39:40 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:3bd7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1ecafa17fsm168420966b.162.2025.03.04.07.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 07:39:39 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Andres Freund <andres@anarazel.de>
Subject: [PATCH v2 7/9] io_uring/net: convert to struct iou_vec
Date: Tue,  4 Mar 2025 15:40:28 +0000
Message-ID: <a5dfea0c0c904c7dc81bfd16c0c8a04b5af88e7e.1741102644.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741102644.git.asml.silence@gmail.com>
References: <cover.1741102644.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert net.c to use struct iou_vec.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/alloc_cache.h |  9 --------
 io_uring/net.c         | 51 ++++++++++++++++++------------------------
 io_uring/net.h         |  6 ++---
 3 files changed, 25 insertions(+), 41 deletions(-)

diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index 0dd17d8ba93a..7094d9d0bd29 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -16,15 +16,6 @@ bool io_alloc_cache_init(struct io_alloc_cache *cache,
 
 void *io_cache_alloc_new(struct io_alloc_cache *cache, gfp_t gfp);
 
-static inline void io_alloc_cache_kasan(struct iovec **iov, int *nr)
-{
-	if (IS_ENABLED(CONFIG_KASAN)) {
-		kfree(*iov);
-		*iov = NULL;
-		*nr = 0;
-	}
-}
-
 static inline bool io_alloc_cache_put(struct io_alloc_cache *cache,
 				      void *entry)
 {
diff --git a/io_uring/net.c b/io_uring/net.c
index cbb889b85cfc..a4b39343f345 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -136,11 +136,8 @@ static bool io_net_retry(struct socket *sock, int flags)
 
 static void io_netmsg_iovec_free(struct io_async_msghdr *kmsg)
 {
-	if (kmsg->free_iov) {
-		kfree(kmsg->free_iov);
-		kmsg->free_iov_nr = 0;
-		kmsg->free_iov = NULL;
-	}
+	if (kmsg->vec.iovec)
+		io_vec_free(&kmsg->vec);
 }
 
 static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
@@ -154,7 +151,7 @@ static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	/* Let normal cleanup path reap it if we fail adding to the cache */
-	io_alloc_cache_kasan(&hdr->free_iov, &hdr->free_iov_nr);
+	io_alloc_cache_vec_kasan(&hdr->vec);
 	if (io_alloc_cache_put(&req->ctx->netmsg_cache, hdr)) {
 		req->async_data = NULL;
 		req->flags &= ~REQ_F_ASYNC_DATA;
@@ -171,7 +168,7 @@ static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req)
 		return NULL;
 
 	/* If the async data was cached, we might have an iov cached inside. */
-	if (hdr->free_iov)
+	if (hdr->vec.iovec)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	return hdr;
 }
@@ -182,10 +179,7 @@ static void io_net_vec_assign(struct io_kiocb *req, struct io_async_msghdr *kmsg
 {
 	if (iov) {
 		req->flags |= REQ_F_NEED_CLEANUP;
-		kmsg->free_iov_nr = kmsg->msg.msg_iter.nr_segs;
-		if (kmsg->free_iov)
-			kfree(kmsg->free_iov);
-		kmsg->free_iov = iov;
+		io_vec_reset_iovec(&kmsg->vec, iov, kmsg->msg.msg_iter.nr_segs);
 	}
 }
 
@@ -208,9 +202,9 @@ static int io_net_import_vec(struct io_kiocb *req, struct io_async_msghdr *iomsg
 	struct iovec *iov;
 	int ret, nr_segs;
 
-	if (iomsg->free_iov) {
-		nr_segs = iomsg->free_iov_nr;
-		iov = iomsg->free_iov;
+	if (iomsg->vec.iovec) {
+		nr_segs = iomsg->vec.nr;
+		iov = iomsg->vec.iovec;
 	} else {
 		nr_segs = 1;
 		iov = &iomsg->fast_iov;
@@ -468,7 +462,7 @@ static int io_bundle_nbufs(struct io_async_msghdr *kmsg, int ret)
 	if (iter_is_ubuf(&kmsg->msg.msg_iter))
 		return 1;
 
-	iov = kmsg->free_iov;
+	iov = kmsg->vec.iovec;
 	if (!iov)
 		iov = &kmsg->fast_iov;
 
@@ -584,9 +578,9 @@ static int io_send_select_buffer(struct io_kiocb *req, unsigned int issue_flags,
 		.nr_iovs = 1,
 	};
 
-	if (kmsg->free_iov) {
-		arg.nr_iovs = kmsg->free_iov_nr;
-		arg.iovs = kmsg->free_iov;
+	if (kmsg->vec.iovec) {
+		arg.nr_iovs = kmsg->vec.nr;
+		arg.iovs = kmsg->vec.iovec;
 		arg.mode = KBUF_MODE_FREE;
 	}
 
@@ -599,9 +593,9 @@ static int io_send_select_buffer(struct io_kiocb *req, unsigned int issue_flags,
 	if (unlikely(ret < 0))
 		return ret;
 
-	if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->free_iov) {
-		kmsg->free_iov_nr = ret;
-		kmsg->free_iov = arg.iovs;
+	if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->vec.iovec) {
+		kmsg->vec.nr = ret;
+		kmsg->vec.iovec = arg.iovs;
 		req->flags |= REQ_F_NEED_CLEANUP;
 	}
 	sr->len = arg.out_len;
@@ -1085,9 +1079,9 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 			.mode = KBUF_MODE_EXPAND,
 		};
 
-		if (kmsg->free_iov) {
-			arg.nr_iovs = kmsg->free_iov_nr;
-			arg.iovs = kmsg->free_iov;
+		if (kmsg->vec.iovec) {
+			arg.nr_iovs = kmsg->vec.nr;
+			arg.iovs = kmsg->vec.iovec;
 			arg.mode |= KBUF_MODE_FREE;
 		}
 
@@ -1106,9 +1100,9 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 		}
 		iov_iter_init(&kmsg->msg.msg_iter, ITER_DEST, arg.iovs, ret,
 				arg.out_len);
-		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->free_iov) {
-			kmsg->free_iov_nr = ret;
-			kmsg->free_iov = arg.iovs;
+		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->vec.iovec) {
+			kmsg->vec.nr = ret;
+			kmsg->vec.iovec = arg.iovs;
 			req->flags |= REQ_F_NEED_CLEANUP;
 		}
 	} else {
@@ -1874,8 +1868,7 @@ void io_netmsg_cache_free(const void *entry)
 {
 	struct io_async_msghdr *kmsg = (struct io_async_msghdr *) entry;
 
-	if (kmsg->free_iov)
-		io_netmsg_iovec_free(kmsg);
+	io_vec_free(&kmsg->vec);
 	kfree(kmsg);
 }
 #endif
diff --git a/io_uring/net.h b/io_uring/net.h
index b804c2b36e60..43e5ce5416b7 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -2,12 +2,12 @@
 
 #include <linux/net.h>
 #include <linux/uio.h>
+#include <linux/io_uring_types.h>
 
 struct io_async_msghdr {
 #if defined(CONFIG_NET)
-	struct iovec			*free_iov;
-	/* points to an allocated iov, if NULL we use fast_iov instead */
-	int				free_iov_nr;
+	struct iou_vec				vec;
+
 	struct_group(clear,
 		int				namelen;
 		struct iovec			fast_iov;
-- 
2.48.1


