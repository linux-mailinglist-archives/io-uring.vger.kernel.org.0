Return-Path: <io-uring+bounces-6999-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 439D9A56CF4
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:02:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 789E93B5E30
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:00:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F374522156C;
	Fri,  7 Mar 2025 15:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eS87PlY+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE42221713
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 15:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741363195; cv=none; b=rSceNQL4NqrqyaNb2LTyzbQ02bsgskASWYgF+F/HbsSHv1vxjT62TerCYVe3NUwZptGmMcSSfbTlxGFz1Kpml6PfXa7vLV/qzbzjdu7KQJ1/o/vJ0cp1HQqdI/rZNIfNPyzmA/8WlJzj1F7stttwp4Gn5Eq/Dl0rDUPL8qCLY0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741363195; c=relaxed/simple;
	bh=hdM/yveeqx/cwJF39LxfDEQxflleuBmQE+zj5qDwnIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6/+tnfrRrVzxm52o2H4Wct015TzeIKBIxCLtTsC5FhAJ6VJjhGYuSueTJg5LtLXT2eWnCCymMC2nX5vGsq2UEPB5Jy4n5nQLPq/OyC206OXEts3bIpfPy/6ksxAeMPRHGt3IRRPHDd0Zjyl8vdsn5Uac4BwiruzsgHcqFNfIJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eS87PlY+; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aaec61d0f65so405653266b.1
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 07:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741363192; x=1741967992; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zac3vga/E698ojFWUHp/OWmE620rH3affaJufXu525s=;
        b=eS87PlY+V4O6hXRw3kLvC6XBw0IeQl+xPcVGZMorXTV3JdwElyChd1yD1MlieGZ7om
         z6bn1pYM/IGYjgFzUVkUcNIHErpflPMH4fq2uwVj9YUTRR2sXwLqp4t/LeSnzweqW3aJ
         dehflWq1SUVTaAnJQ1a9ymsxI9joZPBCXCRz23p9nbdK9EfB1x+BpqvrlsF08iU2BqTB
         ILN+KHY4j+ZDyTVuBT3cN0ThirbFE/SEqjkKqMh2zC1yfLdVsDJ6YtIvn+ABbTwmAPbJ
         Wk+J5t/VUoa5xWuwTTpd0RcU+e48vVM0DreWCE5DQ0JcnF+onvX0BhPGEKekEk3sm1Lp
         wX2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741363192; x=1741967992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zac3vga/E698ojFWUHp/OWmE620rH3affaJufXu525s=;
        b=s76mSIYB4E6Z89gYuQxeLiXBbP1uB0EGzWe3YpZOpsgMXKsw12ZbdCZiC25yihAXsI
         n59azRTbFC91+KCXkQX1hRZegAUYQOtwOzImNqE6yGwIeupA3jQpvYN+3abz8lYQqEks
         s5fkNhdayrM8uTOp/BElFWfVKZ0jh3GQUARv/owoBYnULyorx/iReplCyO8428nlqDvz
         fgbaXbnZxEnLbCMcR6a3kxhCWyleqAW6sPzFGf1bSOrRKoYYZ77BegYxmgI62rnNWOaV
         1FD/4bWXs6eInKGUCyE0yI2kLzC6C4OEK0b9JlViP1BSg6+eSwaP8f9aM3XF2cFcWqC+
         3hAA==
X-Gm-Message-State: AOJu0YzXwLEqAkiKLHI641YRsNxB7UeDKf2jxj7U6zouXHKUtTAPBtPL
	fOwOBUEAKLVEzSTfv6GoE7qKODsmEVWVXj5LEk22v/4NbZBb13waxII+6Q==
X-Gm-Gg: ASbGncuFiubr0lVVXlZOznhMODbPvPnqgMyY/d0pqr6gUgv0L7VxLkobt5np3M+zLYu
	cU2kvNAWM0d5hYkvaB+DJqupzKy5xOiioFGtI62ekQaHCyvchHFUN+5o0qrnh/PiFa3gsEFlvOi
	IJmUQblbONObdfg5iAtBZh3fLL2hHvRh61M5EPWEKZgx53Ec7OjFqMKBLUGN8Q+hTrmc+NBp7P5
	T8dayIXJ/ZyW9pNrPkt5KVnOA5uW79r47alXpSAQdLLX4keqbaGv8vTDUgevazJlVYeSjz+dESa
	ECo6UeqV6WkCPj0ynM6itCO4beaX
X-Google-Smtp-Source: AGHT+IGBb9pG0RCCgyU60lVLo5dZwJoyA2mHQGei0kcapQYDJgg6adu3zgeTHCyTto1FGB2O6TDiMg==
X-Received: by 2002:a17:907:3604:b0:ac1:dc0f:e03e with SMTP id a640c23a62f3a-ac252628a87mr488727266b.13.1741363191529;
        Fri, 07 Mar 2025 07:59:51 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:a068])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac2399d7a17sm297369166b.179.2025.03.07.07.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 07:59:50 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 7/9] io_uring/net: convert to struct iou_vec
Date: Fri,  7 Mar 2025 16:00:35 +0000
Message-ID: <6437b57dabed44eca708c02e390529c7ed211c78.1741362889.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741362889.git.asml.silence@gmail.com>
References: <cover.1741362889.git.asml.silence@gmail.com>
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


