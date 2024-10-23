Return-Path: <io-uring+bounces-3935-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CB9C29ABBA1
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 04:37:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46EC11F2466E
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 02:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AD068825;
	Wed, 23 Oct 2024 02:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MqqoQ6wO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE291487A7
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 02:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729651072; cv=none; b=QaX5OcODgTM2Q7Ksub0fa4Xqw4r+3tbc6hSAA9BaWog8RdWSHzOEyMh+KKMTvq275SOp8I1dbsHB1J/P7Yy+SN3ly12e2VLfeBtY9W7HSn1x1QAbAeB4j9693dtqb0NjoHlxQYWM8A+w9ZR9ChhJMTCjsRujMyy1ef/41VXbDkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729651072; c=relaxed/simple;
	bh=TxZJssuzzLpXjABpyyiaqo/BqMUvUtqrO4xYLcFoukw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErA0ae9JqGeD17I3nWITaNY6usjPRJvMGfJmekwA9hsrAuDdsF0orMF3CrjjPZsrfnypdi3iodODfvO3sZzJ1ZUpMEcFT1ViLnNxQM909q3xJ1t60/sFrgbOEilnVvq+qLOaLyCpCdRpJBf5XyEJcDR6/Hm/6F0bAR5a99mso9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MqqoQ6wO; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5c903f5bd0eso3366309a12.3
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 19:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729651068; x=1730255868; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lC8EWOJ/M38xO5z8xunAoNX/+lyqVLN/bqiRMncMjMI=;
        b=MqqoQ6wOK35KJz5qdXTFwZMQeInGdjUoLhrdH0JzkCYtmWbwJlXdWNACCNVcWV8Y6T
         OKYYDPWFzKNv0j2yTdr63NFg5rlSvk1tgBA1zvcDzsC3tyr2TF6vAB0s2gO6B6OzEOzx
         fFIA8WyxjTP7hou8PxP5giWAfEL1iixnapPadNKD7LO4jPAX21v1/XWgQB+SR6ejVUju
         lQU2K9wDJptrWXmj0YYiSJYQtd3ejpCVve4FGmIJ2Kr9YGVgxkQynI9vqhxYQNKBNuLX
         GtFqE4G6a1dT3zvi6nd5ZPcC1UUN1sDwpAMB29Z7Hu+bZMjAs/8wOWPcRUopsIXDIcBw
         cpHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729651068; x=1730255868;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lC8EWOJ/M38xO5z8xunAoNX/+lyqVLN/bqiRMncMjMI=;
        b=s0vIEXw+WKfGQhgov8fdAQq2hvUQFZ7FVn60FsId+HnNlUZUDlO70UYMhl++EjOm9f
         RqhLFVxh37Szng6vlYlzKxBEB5c0ikT/2kfS1AqdVdqIfbomhnJiVR3bAWngNoex0Yd3
         P8paQUzE8ygY5WEmcZ/1H3AuAeJO7Ohmti66M+t5+Ht4Ly7aaPxjibbUU6LUwf4MlS1D
         x6gCiChXP1g6ojzTRTTed+osh08fPxkOFvhCTzmQcI3XjLRBqPXlwyjpe3gY9CPCyh3K
         ApBNhuNocGxPOd7OuceEmcCfNQCr9aDvyCwab5cFm36k0paN95T89NLui2bZnGZSkkwn
         XblQ==
X-Gm-Message-State: AOJu0Yyb4DZ6Po4h/mXSV3y6sQDaPWUyJhom/HveSzH31Aee+uNCgFaO
	fUvZ0b1y3iuGNqtsauhN7rMdMGxf6K2nEuCL9gYfx8nCkkCxLAhkdwz7dQ==
X-Google-Smtp-Source: AGHT+IELJDdeBoLDtN4SioPM//CuShks/3lPMxdQkVX/kOIe6DwgXZ5k9WN5ByE4zpUUwHg5fVyOiQ==
X-Received: by 2002:a17:907:7290:b0:a9a:478:2ee3 with SMTP id a640c23a62f3a-a9abf92f3b4mr84937666b.40.1729651068523;
        Tue, 22 Oct 2024 19:37:48 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a91371046sm410418766b.139.2024.10.22.19.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 19:37:48 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 4/4] io_uring/net: sendzc with vectored fixed buffers
Date: Wed, 23 Oct 2024 03:38:21 +0100
Message-ID: <c41b921eb777146fde5aaf08a57a657044399c92.1729650350.git.asml.silence@gmail.com>
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

Currently, we can use registered buffers with send zerocopy but not
sendmsg. However, users want to use it with zc sendmsg as well, and
pass a scatter list into a registered buffer.

Implement a vectored registered buffer support for sendmsg zerocopy.
The ABI should be intuitive. The user should set sqe->buf_index to the
desired registered buffer and also and pass IORING_RECVSEND_FIXED_BUF
flag. msghdr should still point to an iovec with user addresses served
to calculate offsets how it has always been with registered buffers.
In other words, in most cases the user passes the same iovec it'd pass
to the non-registered buffer version.

It's the first step and requires some more work cleaning the
infrastructure. It'll also need some imporvement on the bvec caching
side.

Note, we can easily enable it for non zc version, and even extend the
feature to read/write requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 47 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 45 insertions(+), 2 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index bc062b5a7a55..6a19b6a7dc06 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -204,6 +204,18 @@ static int io_net_vec_assign(struct io_kiocb *req, struct io_async_msghdr *kmsg,
 	return 0;
 }
 
+static void io_net_bvec_assign(struct io_kiocb *req, struct io_async_msghdr *kmsg,
+				struct bio_vec *bvec, int max_segs)
+{
+	if (bvec) {
+		req->flags |= REQ_F_NEED_CLEANUP;
+		if (kmsg->free_vec)
+			kfree(kmsg->free_vec);
+		kmsg->free_vec_bytes = max_segs * sizeof(*bvec);
+		kmsg->free_vec = bvec;
+	}
+}
+
 static inline void io_mshot_prep_retry(struct io_kiocb *req,
 				       struct io_async_msghdr *kmsg)
 {
@@ -267,6 +279,31 @@ static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 }
 #endif
 
+static int io_send_setup_sg_fixed(struct io_kiocb *req, struct iovec *iovec,
+				  int nr_iovs, int ddir)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct io_async_msghdr *iomsg = req->async_data;
+	struct iov_iter *iter = &iomsg->msg.msg_iter;
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_mapped_ubuf *imu;
+	struct bio_vec *bvec;
+	int idx;
+
+	if (unlikely(sr->buf_index >= ctx->nr_user_bufs))
+		return -EFAULT;
+	idx = array_index_nospec(sr->buf_index, ctx->nr_user_bufs);
+	imu = READ_ONCE(ctx->user_bufs[idx]);
+	io_req_set_rsrc_node(sr->notif, ctx, 0);
+
+	bvec = io_import_fixed_vec(ddir, iter, imu, iovec, nr_iovs);
+	if (unlikely(IS_ERR(bvec)))
+		return PTR_ERR(bvec);
+
+	io_net_bvec_assign(req, iomsg, bvec, iter->nr_segs);
+	return 0;
+}
+
 static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 			   struct user_msghdr *msg, int ddir)
 {
@@ -413,6 +450,14 @@ static int io_sendmsg_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	ret = io_sendmsg_copy_hdr(req, kmsg);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
+
+	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
+		struct iovec *iov;
+
+		iov =  kmsg->free_vec ? kmsg->free_vec : &kmsg->fast_iov;
+		return io_send_setup_sg_fixed(req, iov,
+				kmsg->msg.msg_iter.nr_segs, ITER_SOURCE);
+	}
 	return ret;
 }
 
@@ -1270,8 +1315,6 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->opcode != IORING_OP_SEND_ZC) {
 		if (unlikely(sqe->addr2 || sqe->file_index))
 			return -EINVAL;
-		if (unlikely(zc->flags & IORING_RECVSEND_FIXED_BUF))
-			return -EINVAL;
 	}
 
 	zc->len = READ_ONCE(sqe->len);
-- 
2.46.0


