Return-Path: <io-uring+bounces-6912-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E01C7A4C5BD
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 16:52:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E3847A727D
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 15:49:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32737214A6C;
	Mon,  3 Mar 2025 15:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IIJUBar8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A0D214A6E
	for <io-uring@vger.kernel.org>; Mon,  3 Mar 2025 15:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741017014; cv=none; b=LtY8/vOcsn30k30KWTNHv85+zyOua1X9IdPX2ckFNLPVsOCL8YNwnqocNY38hsxlEFXrX+z5lEm7sffT2ulvhcmQzqpzfjBvkP/8IeKLS4GeJT41XeJnu9KEmrEDFZG1iuUL5XKMxg30hsWJBVijaBYnIDWxk+1R1EIp51eEEfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741017014; c=relaxed/simple;
	bh=zWZarhNyJi53T++SjywLAAUqP8VMK2X1hgd352VZQsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKUas4vqmXqJC+yLxMhlPEVNYE9sb283dehu1GJAwsTodOx53bmX1HrHRs3VO45Hu9raETf2jI/jQ1PhRb/odGZPyPn7V1fm0U0GOevRCFRlCVPCtHmjoo60YS4m+ws9FtG1PQ+qZ3KMXxEZKAE+zb2F+winiDTLmh0A3iWV3Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IIJUBar8; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-abf4cebb04dso413378966b.0
        for <io-uring@vger.kernel.org>; Mon, 03 Mar 2025 07:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741017010; x=1741621810; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7RWfRi6x1mSPiivij2EBvrzcTuGy50QoeAUbZiSRBp0=;
        b=IIJUBar8/k+bxtmvHurlEzB5Cv2jK35MaecjFRlkM2PmK8l7ixxSNN7UPzWjC6PjUv
         L36iymqPYLV2vv+IPzJRSxSZcJdtgRxFkxYRXUtAhA7nYxwnl/HLg3wC+o5SXvTWOuNQ
         QIasMwTJmZqi9gLTHf32BPpTUYQyeUu0QyYTKXvO4Vf7O6MahN6O5x+FieSLt6j3Ozrg
         MfuW0bcV+Sjc0wAeiKw6gSJ51Es2KYdz/mwwJU7DiTxwP86R3Y8QzGQ4zWMwg44GZaEe
         /t3wEeEB8wlzVQxHW983pwElsqr3WBSIOKMzfq1mQuS3GBaQLfmzx4FAcF2SGsy+94px
         6Nmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741017010; x=1741621810;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7RWfRi6x1mSPiivij2EBvrzcTuGy50QoeAUbZiSRBp0=;
        b=ufnHa0h7J0JejG2LjaHKBwnFyibdGStttvTxjPSa0aNJ3lfrPvyLgzp7UFbn6j8b26
         +IHjTROGPK4ysFy3S44AL6ab1WIr+Hffit0hKuA5EczOo8IBJ4Tr49qomC3iu/ofubyD
         EBk64Ausuakdpp2eQYxTBdRogIXhHS8+T9hKnH9X8ibt2+XCQAzDRvjGpV46R5RAbJ3F
         ozjAFZCeXyHishTDAIvevoMUPiD/yESDlGNpSMlvICMQI7i9UAWro0NKqSYSFjy/Z7IA
         Nfa6yD1TUcQCt46oVHJhxXf74c5F4WRwOG3K+Rly5/ApxlDqL6+P9e9qVVoQg9Hc+ipl
         pVPA==
X-Gm-Message-State: AOJu0YwZ2a983PqL95IeLhiCog9bme098OSTTT+vUyPUPU/xANK5kPJl
	7TQki/EvJbyJ1jX2QLzEsypDO7ok0ZRX5tHLDqTh8JrvMFK+m9TVTnAplg==
X-Gm-Gg: ASbGncu8ckkqawTbPePo6cpRmbV3ezIClv0e50NdXdehYN5x6icgb1Zq/3WZaKsDwKT
	jCRQhBsgr2nvTsjJ/F+Sl+MTd0rIkxalo2toaZ+6u5mZr/t+GY/teq2lOLORBVviyyBHv4A8Qie
	6EadB1KgKadzPwxodBHmOFdbZ9LUUZi16W+58VQP0kLl4vK9LZ+0kIcWOQBVsFeE+xwJtp/6I6K
	M0giJ6GZhGf+e6gINiCTe16V+ktmb8cGIWgumYuwePfkWzfzF+sfcKEr7tJ++qXJ5aUNgU5rXFA
	bYtSreC6dZIOFMgOvbLs1xmP8Lz9
X-Google-Smtp-Source: AGHT+IE7eDNYUt6NKBIYxCRHut2Ooazzn759df/qNoG+3i/G1s06Av6sl2D0z0JB1DSAgoI8e6C/mQ==
X-Received: by 2002:a17:906:acc:b0:abf:4a3b:454d with SMTP id a640c23a62f3a-abf4a3b62demr1076997466b.7.1741017009882;
        Mon, 03 Mar 2025 07:50:09 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:299a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf4e50c80esm492335266b.61.2025.03.03.07.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 07:50:09 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Andres Freund <andres@anarazel.de>
Subject: [PATCH 7/8] io_uring/net: convert to struct iou_vec
Date: Mon,  3 Mar 2025 15:51:02 +0000
Message-ID: <52aad74e49bfff5d7751ddd232cd4e2733dabae9.1741014186.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741014186.git.asml.silence@gmail.com>
References: <cover.1741014186.git.asml.silence@gmail.com>
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


