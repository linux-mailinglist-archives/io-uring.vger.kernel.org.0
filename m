Return-Path: <io-uring+bounces-3933-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 88B909ABBA0
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 04:37:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F4072B217A2
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 02:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E441A4D8D1;
	Wed, 23 Oct 2024 02:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YEzZS6Cn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5A649659
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 02:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729651068; cv=none; b=s1e6dv3c97XbA/zjmdTjZRE8abpfEOUyptbRDL+Nt0utUVgnz/ggLhmobVXRXSecP8mzTik0rq5GpcrEeFbB7LNCWyR1YfEDue/ezVr0ou05aQ+D4V07MtZDNZ5o0dO+Th+WPrPxQhl3PvzhpS1Wy0BxkM0ziWZdtEld1McV7as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729651068; c=relaxed/simple;
	bh=DGJiRNm1uxrVPT+D0PYHhHPXANKsKAeXgHzLGUqZzS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/tRG3T/+7teKTP6Nq0/lMrLAk8cjBLxx9id436J53EWTCZ5NKGk2VMqe6DALnOz8SADzduOc2g+R1xtEbuHTYHZWzhC45Kx8OjbssTaAcwyDUzYEKkIdqIX+j2l3fIHVyiG/AlB9lD2U21R2DeyZbg0vCaEDKmrFtPmwYTyQWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YEzZS6Cn; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5c9c28c1ecbso8095359a12.0
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 19:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729651065; x=1730255865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JLns/gCvXAoxA+K3r+ie+TtYMtfuDR/vLKoP6gq63Z4=;
        b=YEzZS6CneZAauYin/JoRauF57bl+IexFs0qPkK5mhu64HndK3oA0UHXs3lUFTYY20z
         t/OCPPl675uXszPHFfeFo4pXDqg2vrP6Xuj5IvYL/KYmojOUPN/p7cblSaZD43ya73En
         TO7Qk4m828B0izE4ab7V+yMj/e/5nhGMzAg9oLZpRGS8o0ISOg2SVeXHya3wLQ77ctZF
         PJWjXBEX++17Gvk7sLu4UN4hl8LLPVI3AcOjbbyBLCeeZ+djbTi92NhlJ10uKlkEJQik
         vQ6HoFuiutNzt5781+omHsgFrgWMK/uGlTqxqkM3fTmY2TbPyaZsGPaYl3qmm4EnHkqh
         v3eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729651065; x=1730255865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JLns/gCvXAoxA+K3r+ie+TtYMtfuDR/vLKoP6gq63Z4=;
        b=fRCi1vL9o3tRWkhmhmGGRqALqGd9OykZVXbbt6tJAzAR8I/JcLcRAgVFECYh+W0pBn
         41tXRVr0Pr9U2cOJums/2VCv9JiKaN4+iH7rky/l+EUT/izPz6oLuXY/a9Z9Inm4B+ot
         GRxM8FM0RKsjdl43VHvog22uQomuqBV1iqquhgNDnK6yGySLgpH0KJbLazmObKMkOaZk
         bV3NH6BORsPjDnaRvendwzpEYv+8kbXk9KofnWFbgJVZXmzozEuJ6Rs62Uqf1FYfVG79
         9AEh5Z/ekNL0ykxX0OCrnQzTvfaZlmbFbnZWjX9GfBJNrwgdWLJ1rCdSnRtm9oeqP3HU
         9aCw==
X-Gm-Message-State: AOJu0YwfgUm3JQUKAnDQzlb7/Y/KkpT+wOJPGaidBeRNsR2/+05R0lFu
	qA/sCCO0fExGTf1rllvlbczd2aeVSFqq6BLnDFnzDY1b2AGGboA2+8moEg==
X-Google-Smtp-Source: AGHT+IH5Ge6B8XYenhlOfEyQqfK2mpVWjk9mxcZVnsIbi20vN91j7QBagWFJr50KxeqPlWO+4RWjbQ==
X-Received: by 2002:a17:907:9726:b0:a99:523d:2108 with SMTP id a640c23a62f3a-a9abf866556mr100410366b.16.1729651064927;
        Tue, 22 Oct 2024 19:37:44 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a91371046sm410418766b.139.2024.10.22.19.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 19:37:44 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 2/4] io_uring/net: allow mixed bvec/iovec caching
Date: Wed, 23 Oct 2024 03:38:19 +0100
Message-ID: <f2a5d334c292e9ddc6aa9d7ef41234b196ff2dc4.1729650350.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1729650350.git.asml.silence@gmail.com>
References: <cover.1729650350.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We're going to have allocated bvecs shortly, we need a place to store
them and intra releasing it. Reuse the struct io_async_msghdr iovec
caching for that. Get rid of typing and switch to bytes instead of
keeping the number of iov elements the cached array can store.
Performance wise it should be just fine as divisions will be compiled
into binary shifts.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 67 +++++++++++++++++++++++++++-----------------------
 io_uring/net.h |  4 +--
 2 files changed, 38 insertions(+), 33 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index bd24290fa646..bc062b5a7a55 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -128,14 +128,19 @@ static bool io_net_retry(struct socket *sock, int flags)
 static inline void io_kmsg_set_iovec(struct io_async_msghdr *kmsg,
 				     struct iovec *iov, int nr)
 {
-	kmsg->free_iov_nr = nr;
-	kmsg->free_iov = iov;
+	kmsg->free_vec_bytes = nr * sizeof(*iov);
+	kmsg->free_vec = iov;
+}
+
+static int io_kmsg_nr_free_iov(struct io_async_msghdr *kmsg)
+{
+	return kmsg->free_vec_bytes / sizeof(struct iovec);
 }
 
 static void io_netmsg_iovec_free(struct io_async_msghdr *kmsg)
 {
-	if (kmsg->free_iov) {
-		kfree(kmsg->free_iov);
+	if (kmsg->free_vec) {
+		kfree(kmsg->free_vec);
 		io_kmsg_set_iovec(kmsg, NULL, 0);
 	}
 }
@@ -143,7 +148,7 @@ static void io_netmsg_iovec_free(struct io_async_msghdr *kmsg)
 static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_msghdr *hdr = req->async_data;
-	struct iovec *iov;
+	void *vec;
 
 	/* can't recycle, ensure we free the iovec if we have one */
 	if (unlikely(issue_flags & IO_URING_F_UNLOCKED)) {
@@ -152,10 +157,10 @@ static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	/* Let normal cleanup path reap it if we fail adding to the cache */
-	iov = hdr->free_iov;
+	vec = hdr->free_vec;
 	if (io_alloc_cache_put(&req->ctx->netmsg_cache, hdr)) {
-		if (iov)
-			kasan_mempool_poison_object(iov);
+		if (vec)
+			kasan_mempool_poison_object(vec);
 		req->async_data = NULL;
 		req->flags &= ~REQ_F_ASYNC_DATA;
 	}
@@ -168,9 +173,9 @@ static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req)
 
 	hdr = io_alloc_cache_get(&ctx->netmsg_cache);
 	if (hdr) {
-		if (hdr->free_iov) {
-			kasan_mempool_unpoison_object(hdr->free_iov,
-				hdr->free_iov_nr * sizeof(struct iovec));
+		if (hdr->free_vec) {
+			kasan_mempool_unpoison_object(hdr->free_vec,
+						hdr->free_vec_bytes);
 			req->flags |= REQ_F_NEED_CLEANUP;
 		}
 		req->flags |= REQ_F_ASYNC_DATA;
@@ -192,8 +197,8 @@ static int io_net_vec_assign(struct io_kiocb *req, struct io_async_msghdr *kmsg,
 {
 	if (iov) {
 		req->flags |= REQ_F_NEED_CLEANUP;
-		if (kmsg->free_iov)
-			kfree(kmsg->free_iov);
+		if (kmsg->free_vec)
+			kfree(kmsg->free_vec);
 		io_kmsg_set_iovec(kmsg, iov, kmsg->msg.msg_iter.nr_segs);
 	}
 	return 0;
@@ -220,9 +225,9 @@ static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 	struct iovec *iov;
 	int ret, nr_segs;
 
-	if (iomsg->free_iov) {
-		nr_segs = iomsg->free_iov_nr;
-		iov = iomsg->free_iov;
+	if (iomsg->free_vec) {
+		nr_segs = io_kmsg_nr_free_iov(iomsg);
+		iov = iomsg->free_vec;
 	} else {
 		iov = &iomsg->fast_iov;
 		nr_segs = 1;
@@ -270,9 +275,9 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 	struct iovec *iov;
 	int ret, nr_segs;
 
-	if (iomsg->free_iov) {
-		nr_segs = iomsg->free_iov_nr;
-		iov = iomsg->free_iov;
+	if (iomsg->free_vec) {
+		nr_segs = io_kmsg_nr_free_iov(iomsg);
+		iov = iomsg->free_vec;
 	} else {
 		iov = &iomsg->fast_iov;
 		nr_segs = 1;
@@ -478,7 +483,7 @@ static int io_bundle_nbufs(struct io_async_msghdr *kmsg, int ret)
 	if (iter_is_ubuf(&kmsg->msg.msg_iter))
 		return 1;
 
-	iov = kmsg->free_iov;
+	iov = kmsg->free_vec;
 	if (!iov)
 		iov = &kmsg->fast_iov;
 
@@ -611,9 +616,9 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 			.nr_iovs = 1,
 		};
 
-		if (kmsg->free_iov) {
-			arg.nr_iovs = kmsg->free_iov_nr;
-			arg.iovs = kmsg->free_iov;
+		if (kmsg->free_vec) {
+			arg.nr_iovs = io_kmsg_nr_free_iov(kmsg);
+			arg.iovs = kmsg->free_vec;
 			arg.mode = KBUF_MODE_FREE;
 		}
 
@@ -626,7 +631,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 		if (unlikely(ret < 0))
 			return ret;
 
-		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->free_iov) {
+		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->free_vec) {
 			io_kmsg_set_iovec(kmsg, arg.iovs, ret);
 			req->flags |= REQ_F_NEED_CLEANUP;
 		}
@@ -1088,9 +1093,9 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 			.mode = KBUF_MODE_EXPAND,
 		};
 
-		if (kmsg->free_iov) {
-			arg.nr_iovs = kmsg->free_iov_nr;
-			arg.iovs = kmsg->free_iov;
+		if (kmsg->free_vec) {
+			arg.nr_iovs = io_kmsg_nr_free_iov(kmsg);
+			arg.iovs = kmsg->free_vec;
 			arg.mode |= KBUF_MODE_FREE;
 		}
 
@@ -1109,7 +1114,7 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 		}
 		iov_iter_init(&kmsg->msg.msg_iter, ITER_DEST, arg.iovs, ret,
 				arg.out_len);
-		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->free_iov) {
+		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->free_vec) {
 			io_kmsg_set_iovec(kmsg, arg.iovs, ret);
 			req->flags |= REQ_F_NEED_CLEANUP;
 		}
@@ -1807,9 +1812,9 @@ void io_netmsg_cache_free(const void *entry)
 {
 	struct io_async_msghdr *kmsg = (struct io_async_msghdr *) entry;
 
-	if (kmsg->free_iov) {
-		kasan_mempool_unpoison_object(kmsg->free_iov,
-				kmsg->free_iov_nr * sizeof(struct iovec));
+	if (kmsg->free_vec) {
+		kasan_mempool_unpoison_object(kmsg->free_vec,
+					kmsg->free_vec_bytes);
 		io_netmsg_iovec_free(kmsg);
 	}
 	kfree(kmsg);
diff --git a/io_uring/net.h b/io_uring/net.h
index 52bfee05f06a..65d497985572 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -7,8 +7,8 @@ struct io_async_msghdr {
 #if defined(CONFIG_NET)
 	struct iovec			fast_iov;
 	/* points to an allocated iov, if NULL we use fast_iov instead */
-	struct iovec			*free_iov;
-	int				free_iov_nr;
+	void				*free_vec;
+	int				free_vec_bytes;
 	int				namelen;
 	__kernel_size_t			controllen;
 	__kernel_size_t			payloadlen;
-- 
2.46.0


