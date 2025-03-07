Return-Path: <io-uring+bounces-6990-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE45FA56C8C
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:48:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF2151709D7
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 15:48:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5162DF71;
	Fri,  7 Mar 2025 15:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WwajzKdN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC65194C78
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 15:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741362503; cv=none; b=e7jz/rDnPFDJEUzGykXWMRWSUQ1n8e2f4ddLzqWwL7RQXxT9dmsJxcIkAsyEyBKgG3cGJOsXTf8HHMd2nWs7z+TndzbgxXWDog2Z8qFaQoSYkahbURRFqU0jx+fdp4CxhGYkGfvwq6rLPrZvzxh28Y6gxGCoj/QjykYIyumsdJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741362503; c=relaxed/simple;
	bh=hdM/yveeqx/cwJF39LxfDEQxflleuBmQE+zj5qDwnIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jchXRgZP3Am7sHSSC0O0IAtKnk/mV3NUFHaMQ6eYpIU2IWQwi0ZBAbJ8EZWN4Yc1oc3XPXr/fJG1s31fy1g2fG6Cnf2O9U5olnp+VDSMAhDTkirtvyEJokUSe55M2asPd7ooWFK+6Ei9BpKf+Em56OIcobj0MomQ85mtwnkPAaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WwajzKdN; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5e549af4927so3571832a12.2
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 07:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741362498; x=1741967298; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zac3vga/E698ojFWUHp/OWmE620rH3affaJufXu525s=;
        b=WwajzKdNaIRQaaoIy5wH5ALwnBVA9B7EMvnX9TO9zAHCi11CvIAWt4Sy7TmYm1DaVd
         N/YA2SSH9fopP7iLlWHrQjxzUm8eSAjarJipcKtSmRncdiTkis5c/9UGjjtyaLwdaFN+
         Py9z+Fo+7ZEqe0lS+9ZWuchvWo1oy2FpKDQ2O1WIxg17Zj/wDIy0HjcEmwWUh07bK4VM
         NfOhblcus2zcmnvO8Z+s+v1pSbL6B/ckmNh/+E6BGuf8S+jz0rBC+TEk9Wp3jomy+k6y
         lziN8S27nBoeg6vxvCOtGmFHkPeMYY47klsCIx3KY2osdgYmMs47rxjKYk0S5u/oZGM0
         hcEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741362498; x=1741967298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zac3vga/E698ojFWUHp/OWmE620rH3affaJufXu525s=;
        b=pMjH/7F/ty92WQ27zfevF96mxstj6VYt8DSTl+EEYrkfsYlIc6uGC01d/S4ufDIG56
         PRXaqC0zdLfphh26VGCW04MkkbmtPd0STZBfFk0DV4HInK32LcUWttbZ8aiABxRbL3x5
         M/RdTtLoAIG4u8PH5z4hfyxVv3k44BTIpyILV3xMvXT/v2ttfDUmJvwkS2WJJH/2VCok
         5B+lNt0QH5cGhxz3OcZe9GJr0GVYRdDbWIhnRUbfQ4fxHjOgyEgK2qSkDpPZIkQ+fzce
         9TMBY1L+GdGFADG95hkrsXc4QNHXFnEA+ZZ8Zj7JHXSlQJi8jhIO3Aqdw1lZHj95eV5e
         HQuw==
X-Gm-Message-State: AOJu0Yz1joD39lI0TPwUVfRbKrtQW0iFkE9DwlMYTU+1cRn3bR2xtl9S
	hcE20Kd3+givASg8hTAjwvuDFD9w4C4dWqR+s39KYBuVx5+JldeRApb2nw==
X-Gm-Gg: ASbGncu2NCwsrUB0BO/6dVhQ7piUyDWnjXkVBLFm7diUUuA0UMxED03keqtdwMZN4vl
	yKAqtBNaNttTDhHWPA92f+UzG+RH+V9UAwogLFfTnJAOzaqmOKh0KJqayKZchta7ZOcDHn4qwCY
	Sj+gK8k7VoYjbvuOohN5u/lU3GgvxMP2tGNzM5nBZlvqo7WjRoRD0rDhsAm/HGj1irIOKFBM33G
	2unraXIsTjlk/3VdrR0I3Avf6Ti+/hASbRrUDLMXPa9BsooI3kDYvb3X/yfZ6krE13m8dhiuao3
	Of0ESufrRl3ZxoCQf9a4/cedEpr+
X-Google-Smtp-Source: AGHT+IHyo8PN39OruwYo6/8uZoc5QntCXAl1kiNVmtVbsj/VhQG+lt0dllXa562T8Ip8hYyKkK23ig==
X-Received: by 2002:a05:6402:5106:b0:5e4:c8fd:3ba0 with SMTP id 4fb4d7f45d1cf-5e5e22c05acmr4365401a12.6.1741362498176;
        Fri, 07 Mar 2025 07:48:18 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:1422])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e5c766a033sm2665591a12.56.2025.03.07.07.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 07:48:17 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 7/9] io_uring/net: convert to struct iou_vec
Date: Fri,  7 Mar 2025 15:49:08 +0000
Message-ID: <4527d9152e7ebc75e3481879e724518e6a990778.1741361926.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741361926.git.asml.silence@gmail.com>
References: <cover.1741361926.git.asml.silence@gmail.com>
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
index 7f68eff2e7f3..d33ce159ef33 100644
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


