Return-Path: <io-uring+bounces-3829-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 356919A4607
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 20:40:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C53DC284200
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 18:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD2522040A8;
	Fri, 18 Oct 2024 18:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gq1h6AbA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88DA2038D8
	for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 18:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729276799; cv=none; b=Zu7yjqD9h8AwH2wXpnD3GFxRK+szvgjwvBkV4LAFU+eUgxIxkitTDz+Fw58QnZon1B+JBpVSI1O9xXA9TXwdfHZaeT3GAH5X0OYuTiRaGDXRzet/3CxPYOrbujQUOqOp8X9EqcGpSQdYOF/RFwZnrkKbb7U/wDZPc+jnMw/JyQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729276799; c=relaxed/simple;
	bh=3kYq0C5TWd8rkmdhoT6VK1j4LEkRJ2s4Y0vBsL4z25o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYmLk9IdnzaOIAIrflIHgsTTrz3JGYSCWC6mDVP6iJHg+ivYAOF1JkvWIBhcAufe70ugYFlrTrXOcZ3VzGO/lRZBJDAwFj0bJg57ULP/11Zf9DcuN6T6QT1dopppEUBSjK0n3Upw3rjsF+kDOGaShDBfmeKJ4v1Ukh6uOjCw3zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gq1h6AbA; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3a3938e73d3so9696855ab.1
        for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 11:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729276796; x=1729881596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fPVCm1Xor1/HRTQ9izeciEoHtF5Hj038MRohwzPQcik=;
        b=gq1h6AbAMEzgJZlsOaafOZH671wMowke70uS8hefy8mXCfHRCg7kLbhFGlit8Jm7it
         XbcBIwWl2ZKy+NmkUEaWysTiwObBepnDqU7j7fD8f5jxieLdmTOSV40+lCdpCq7j4XZz
         rn4RXMun1k1o+x4BlFh4d43LlNNQ88Dj87ynk9Zs1f9/ayZRNR0bizRRLCqZzqtL/66B
         yLn41IUX7NAWMGpSLbDnUcJJVd3t39C//4rMeH/6YHu1OxHkpQe331Kh4HWsbc62qtNi
         GB2f+oenD3QcLcYgPVI5ptMkhfZz/hvOB+EOTp0UW3WLNbSyTgVr4YiwevGp6N/DD8AL
         UMKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729276796; x=1729881596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fPVCm1Xor1/HRTQ9izeciEoHtF5Hj038MRohwzPQcik=;
        b=EhzSWK7goS7lNEUBgiZlJkScZABBghYfA525GHek3DLb/XBxfVCfJzYaGff1snq47M
         f6TRyqhad/QFS/lVF07ypZ3vnDRmcDsaTl9z7CIyLkEoXR783tOVQOWpn+NNMJNDp2Ml
         ymI65RXgWaZU6ROp8rdxL9gsACmil6Y+VxiVfmS4piyddyR8WFsTjNII0i0TOYODbDML
         kwn4HUZZjfAnIhdE4rEnV48INIbnqE3IpqIgCL+i0FL38lmM4QgTCKEvRtT0zaN1xtm8
         nNcLJ/jkIZ/5LWRetb4iNvaTJArzxcMlsGoH58RklKjS49h+xuSJ2ULZ/YW/zTY2zDZi
         YXQg==
X-Gm-Message-State: AOJu0YwtVB33l95HF7Bd0GmPQ1sZ7hAU1XNwMNfBTzOy9EVdCnOkpzvd
	pxGRQRP/igSeVy+LUloVPcHL6D/BX2ncVmQy1XT7kwVHIr30zvHW9pbUQqpf8z6Wq1OllDNl3p5
	X
X-Google-Smtp-Source: AGHT+IHoicl9s8LUSowgRtGN9Vey7K9X1wQzlYyjqJXBM910/DOBRrC16dNryWAz9d+Cx0dYE929Hw==
X-Received: by 2002:a05:6e02:20cc:b0:3a0:bd91:3842 with SMTP id e9e14a558f8ab-3a3f40b1184mr35295875ab.24.1729276796354;
        Fri, 18 Oct 2024 11:39:56 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc10c2b424sm534387173.98.2024.10.18.11.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2024 11:39:55 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring/net: move send zc fixed buffer import to issue path
Date: Fri, 18 Oct 2024 12:38:25 -0600
Message-ID: <20241018183948.464779-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241018183948.464779-1-axboe@kernel.dk>
References: <20241018183948.464779-1-axboe@kernel.dk>
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


