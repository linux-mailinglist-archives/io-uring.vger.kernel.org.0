Return-Path: <io-uring+bounces-3880-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 064E09A95F1
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 04:04:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C6CD1F221CF
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 02:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4238B12D766;
	Tue, 22 Oct 2024 02:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sCTlyHp/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2EF5B216
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 02:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729562679; cv=none; b=QwEHP8YYNUjQbijVL8v+A5Ln0usQ9Rc7pgDMi+j1FmbW2UjgVisg/QBP2/SxnTK048RzmzT1I1D07A4Z9OX7mRPPFsMBleZ9Wq5rGOpwc9nn/zuK0hlEhdrhfavsDaygOFfvdadpTVkc8ExD4qt+FChDktgHti/f98RFtLBO4KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729562679; c=relaxed/simple;
	bh=3kYq0C5TWd8rkmdhoT6VK1j4LEkRJ2s4Y0vBsL4z25o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/aR59e1wbQiCAcArzSO1ixvLVVwtorrKyNt/NMepHDkj2dviP5ZWk3JuuNO4yaWMOeXZjMeB8wfubnaiAE5pCPPat21aUndSIu1EGlywCoaSR7vTRor9JVsDU33pCgszdFkH06i7f3LM2x39aHEuPxU28yvwC9z9RnyGymor4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sCTlyHp/; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-2887326be3dso2283115fac.1
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 19:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729562676; x=1730167476; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fPVCm1Xor1/HRTQ9izeciEoHtF5Hj038MRohwzPQcik=;
        b=sCTlyHp/mo1YzTXTqWaWIX4iN1qpUh4mMl9KzS/AY1cpgI0853XXlMddcMcCxeL+4R
         hlXdHx6BqbKvyZxrY4y9u4R3vsJiD5viM5OCXA6gnX4V7VJaW7hZ/NxkZ8Poch0fyVv4
         Y4GBAere12hEEFNE3aEnO5Jmpe8myCDI9rgSfbQulfkFTM2eKeXfFyLqKtD5SjY9JOyY
         PHS4S6iPCp8PYyl/tKPJlzdUh2mKhpRn/MOiE326ChPxnPjqGHHRoGl06+io7exvYOV7
         pVIG+/BO7JUBor3MfZettjlq3dW/MnYbIfr4MU0eH7O15qsoTVOVmuevjFJ4MYW4Lyt1
         q7jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729562676; x=1730167476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fPVCm1Xor1/HRTQ9izeciEoHtF5Hj038MRohwzPQcik=;
        b=TEXL3dIoC56GW+oc/DvYssa6nIp3NCVviv0IGfEqkCnu9a/Bh2Mn0hNzpO3NLsA7uA
         JkSlRJrNHZ0PelnV+iKdVFsnViIkVTxxcibWQBHIBLmJQ5zq30EhmGmCDd5iFzQcVh1C
         pFmY9wyb6B+j7AoiGqE3tXF+Q48BI9IW/Rtk7NkCxpGQF+HblriMaTeMZfO6QU7+G5De
         A90Em3X6zb1ypgHqBuoH+8mLgVaVsP3w2l+lYLuOOvSvrwO7w9m4uA09BDrKL/wrYcaf
         TqJo5bZjyXiDMXw7G2m2tKMfDXFIapDBH6gC2+ct2KM1Fll0HZmFsm0kfJVie3O919+m
         sTxQ==
X-Gm-Message-State: AOJu0YxF4+GVY5EaqBv8jQaN3dJjSXN7603PNQdP6WebRrp4NqyJWGD/
	8ftWkI77YaSYqJaZFtuxdTX5dDq6VuSEFACkCY5vWKDHweL1R5KpMKr3o3taMvmJ0NTti9Uk657
	D
X-Google-Smtp-Source: AGHT+IEYPoUAg5MV17CYQZv1kDpTbLIkqP/K3YjUAxpvTanRuZR6viOAeWiPyVK3ZSnb9+rnVnCrZw==
X-Received: by 2002:a05:6870:7012:b0:277:e1bc:7da7 with SMTP id 586e51a60fabf-28caff8e345mr1027006fac.22.1729562676315;
        Mon, 21 Oct 2024 19:04:36 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7eaeab58820sm3845534a12.52.2024.10.21.19.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 19:04:34 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring/net: move send zc fixed buffer import to issue path
Date: Mon, 21 Oct 2024 20:03:22 -0600
Message-ID: <20241022020426.819298-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241022020426.819298-1-axboe@kernel.dk>
References: <20241022020426.819298-1-axboe@kernel.dk>
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


