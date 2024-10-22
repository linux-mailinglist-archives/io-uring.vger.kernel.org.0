Return-Path: <io-uring+bounces-3904-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3E669AA33F
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 15:34:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5EABBB2280E
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 13:34:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92424126BFA;
	Tue, 22 Oct 2024 13:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iDoOaZSl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62DB8063C
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 13:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729604095; cv=none; b=SjhwI9wixnxHLZKirunQ6VlA5uXAno4PWjeL5yqxHPDMB5K5u7Wq8j53QzObd5w1j2F/Iiju1maKBP1yInUxUDWF0aWlZlKTOEgvnJjxIKuMdmNwGlQAXQLx8bXbYgwmn9MC/QNYmFdSpVnqY1/YkzzyXR4FouMeKOpG3X3epgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729604095; c=relaxed/simple;
	bh=3kYq0C5TWd8rkmdhoT6VK1j4LEkRJ2s4Y0vBsL4z25o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYRpNAoKMVMcjAF4jH1yQO5k1dFs1kNEC75N1emsNrfX+dY88dwic/SEovPl2KS7ZyujSGnMfLeoNK5I8fg1OQ5YB6w/xvIjnVZX15RkxtRJOrGh6jzsQF7S8sZL69d/iousRP6dpgsoVvNvi/7yj5DeruUYtmHNRxmxdOfC6GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iDoOaZSl; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3a3bb6a01eeso21723615ab.0
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 06:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729604092; x=1730208892; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fPVCm1Xor1/HRTQ9izeciEoHtF5Hj038MRohwzPQcik=;
        b=iDoOaZSl2X+GXiwz3u/g/xTL9QFrzHwHQ9TYicH87O45A/7yvt22wF6w3mFAu6QigK
         FcN+cm5yXkK20y8mXytT5EHBaLYOEIiEF14i/wf5ZNFqowqtguiuJY4k2q0rq9WQRhQJ
         1Xoe3XuHx2wAoMOWQmLxuxfKijgVq1LpK/YKIOTYSjZV1BphMglFTWlRltKdQZ75iogM
         fxevf/ilj0lL6v4T+qZv6sEOl8xRpTa9KUGcR9pW2QcKUn8uq1OzYvWnfAylSJBGrOUT
         CE9WLsklHgOYvcoevmDV/5LfO2E2QpnFAq+Rz9D6y6qmOfLcyTIPUgsGMv8fjVd/uTUs
         n18Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729604092; x=1730208892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fPVCm1Xor1/HRTQ9izeciEoHtF5Hj038MRohwzPQcik=;
        b=Ub51A06MdxhUQIkyd1FzD0tJ37VhV416s0HMWed+7YsLFvwxLGuiZHecbweUzal5Co
         hXJfM1DdiBMu/QgP5W4MkhnTnXDAgcTFL4pRL/1ofvCnHJGF8Q4ENkosRWvP9HPr4FfL
         b8DgJhWPJdCdR+1SgSh0mNdWCrNNP7bY1TTedH7fdV9zFhwnm5eVmgn4kZMs5R++K3Zt
         qnpp3mEDnJKArL1QMhSFAwsKCp5jLXSbxs3oboHnebfJ6aPWurB2HxQi3LhPHquWzPq6
         RDTW0RJmd3Z//Hk4/GjPtaFZGKicURs5KvnD/1AkQkwju+hyz21acsq/E1yviroK/kZU
         hYPA==
X-Gm-Message-State: AOJu0Yw32l8Jpc4rRroujlayV0/FCGbRien7xVlUAVf7fHyjbEbexhVM
	0Ca1HjIjE+SA0YxaFzK6WRGKz52ShMSFopu6I0BH8B62nbBCKJKtWFsBE+nedJu+dNEu8ndf+7e
	6
X-Google-Smtp-Source: AGHT+IF8niKoHZhVwTWMWJUiRfWuzp6ACHcwRl6C2M7He1AnnX8Ne8CBQJzx7kA6h/bHl5OIzw1uJQ==
X-Received: by 2002:a05:6e02:18c8:b0:3a0:8f20:36e7 with SMTP id e9e14a558f8ab-3a4cb4f25c7mr42552375ab.19.1729604092171;
        Tue, 22 Oct 2024 06:34:52 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a400b7c76bsm18032385ab.72.2024.10.22.06.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 06:34:49 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring/net: move send zc fixed buffer import to issue path
Date: Tue, 22 Oct 2024 07:32:57 -0600
Message-ID: <20241022133441.855081-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241022133441.855081-1-axboe@kernel.dk>
References: <20241022133441.855081-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Let's keep it close with the actual import, there's no reason to do this
on the prep side. With that, we can drop one of the branches checking
for whether or not IORING_RECVSEND_FIXED_BUF is set.

As a side-effect, get rid of req->imu usage.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 18507658a921..a5b875a40bbf 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -76,6 +76,7 @@ struct io_sr_msg {
 	/* initialised and used only by !msg send variants */
 	u16				addr_len;
 	u16				buf_group;
+	u16				buf_index;
 	void __user			*addr;
 	void __user			*msg_control;
 	/* used only for send zerocopy */
@@ -1254,16 +1255,6 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		}
 	}
 
-	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
-		unsigned idx = READ_ONCE(sqe->buf_index);
-
-		if (unlikely(idx >= ctx->nr_user_bufs))
-			return -EFAULT;
-		idx = array_index_nospec(idx, ctx->nr_user_bufs);
-		req->imu = READ_ONCE(ctx->user_bufs[idx]);
-		io_req_set_rsrc_node(notif, ctx, 0);
-	}
-
 	if (req->opcode == IORING_OP_SEND_ZC) {
 		if (READ_ONCE(sqe->__pad3[0]))
 			return -EINVAL;
@@ -1279,6 +1270,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	zc->buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	zc->len = READ_ONCE(sqe->len);
 	zc->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL | MSG_ZEROCOPY;
+	zc->buf_index = READ_ONCE(sqe->buf_index);
 	if (zc->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 
@@ -1339,13 +1331,24 @@ static int io_sg_from_iter(struct sk_buff *skb,
 	return ret;
 }
 
-static int io_send_zc_import(struct io_kiocb *req, struct io_async_msghdr *kmsg)
+static int io_send_zc_import(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct io_async_msghdr *kmsg = req->async_data;
 	int ret;
 
 	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
-		ret = io_import_fixed(ITER_SOURCE, &kmsg->msg.msg_iter, req->imu,
+		struct io_ring_ctx *ctx = req->ctx;
+		struct io_mapped_ubuf *imu;
+		int idx;
+
+		if (unlikely(sr->buf_index >= ctx->nr_user_bufs))
+			return -EFAULT;
+		idx = array_index_nospec(sr->buf_index, ctx->nr_user_bufs);
+		imu = READ_ONCE(ctx->user_bufs[idx]);
+		io_req_set_rsrc_node(sr->notif, ctx, issue_flags);
+
+		ret = io_import_fixed(ITER_SOURCE, &kmsg->msg.msg_iter, imu,
 					(u64)(uintptr_t)sr->buf, sr->len);
 		if (unlikely(ret))
 			return ret;
@@ -1382,7 +1385,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 		return -EAGAIN;
 
 	if (!zc->done_io) {
-		ret = io_send_zc_import(req, kmsg);
+		ret = io_send_zc_import(req, issue_flags);
 		if (unlikely(ret))
 			return ret;
 	}
-- 
2.45.2


