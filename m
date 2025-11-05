Return-Path: <io-uring+bounces-10387-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 44791C3781C
	for <lists+io-uring@lfdr.de>; Wed, 05 Nov 2025 20:37:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 003B64E1421
	for <lists+io-uring@lfdr.de>; Wed,  5 Nov 2025 19:37:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6901D221703;
	Wed,  5 Nov 2025 19:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oedYMyN5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7450A334C0C
	for <io-uring@vger.kernel.org>; Wed,  5 Nov 2025 19:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762371425; cv=none; b=aE77a6DigrnTuJCuFv5zkPtdPdNNbyUJwqcaQdOXOHj716FFvQnQy2Ce7nBYfq8jyb0Pm2InLCmMgLw4XDxKMSi6oUklkItxs/ieJQFpaSbZxWklCR10+37NMT42WXnTy/PxsKTm4HgF3igeEt7K3lhBKT4HHR9wFWyXYoLwRBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762371425; c=relaxed/simple;
	bh=reCvpzujG051GVC0Ke92A4ThpmdgPCe9u+p3Pw9S588=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJQW+klvDMjSn4X1SCPLLZBx6g6zkUtByc3T11KRoiguyO8YzaDZGOxHWkjUAvloVacs3L+4zjFq2wDGgwyjm1XkLrPmaDdau6tOMkItaT0CofCDJMxaiumpGfW7p8c/ZwsxkHaB/62oTO3QJyVdhf+5Rs6AK3z1/DY7D/JNXG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oedYMyN5; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-93e2d42d9b4so5251539f.2
        for <io-uring@vger.kernel.org>; Wed, 05 Nov 2025 11:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762371422; x=1762976222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R1CWT+AxJOwJ1TTtt9CFhRpX7WesJKuF2Yn1nZMXcpU=;
        b=oedYMyN5HFMor3GNtKHGli/jKYF0gx8Zw2LdLVAgZvF0h2kShNPSxPUdfqBma9/UOL
         NwsRrc3HuO6iUPCAIJLqAyr/PbQkX0THb8pKFZQNTCRDPmd1UXCe3AHlMoTaWEVHVE5v
         NDRse41cFl1mVCx/irzKkMg9+/1c1L3h3stkCHhOuNX0bsFs3HcFCUFkoWNj871RabDJ
         hWXsid6ChRPBM7kDHlNSF1ErsaiVZjNpuY1rvEDC9EU5lU0zyEZecjGIh5E/LajcwBvg
         gEr7PTkpSOme5dTm1EC1wuhfIBnwPSN1ua9cBBsBppkZQM8qv6JBhFClpTqkCoX+jZxr
         yWNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762371422; x=1762976222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R1CWT+AxJOwJ1TTtt9CFhRpX7WesJKuF2Yn1nZMXcpU=;
        b=VOpFDHPktSFat6VpGPa/cm2P0fGKm3PHJyoGLGFkJ39KwWA1ApYZ4I6G/QxP+nDiMJ
         qJBx7BZCTrS9XGGJtznDLOc3RJwgRtqEvqTx4xzzpfhlYCE9/B7eE+YcTHXXcAvD9JD6
         2ReCyIdu5cFtuT7x+pAGHyktkzxeHpkdeY1EHWGn9iKDlzu4cUcH/O++k3JbjpYmes07
         XDoJioUvUCTWetiDi1rI14X8s7QxjWLXYFjx+FNzAboKAIM9doA31cwpxiav9e31sMYO
         UVXitsjZYLWnFevNb2NirY8RHgbRmxyvA6gkbxyZfw+g2pFR9R5uix3AVmwYngUolsD2
         2mFQ==
X-Gm-Message-State: AOJu0YyHskt+0MlPrCXCd7tjIRwJSxdpRA5evhTNLz1rJzSlmxikrDT3
	klQnTUorIPj4/qkaGPSaqL7FN7teFkUy09X8tpY4IpZFS2gO6JboOxOjLpksv9e8dgcvc8ePMG4
	QBxe/
X-Gm-Gg: ASbGncsvCM+Xc4aWA5wYThpKPYmdrlkDsu36f8QdRDzIMCUy+O+VMqCm9+gMfxEtC6K
	/7NT+tfHKYXP6TyTCL7DQBsiTYiFC4h/auiaQZ/6tfZXt96F7fWUGxguevwlyJmAuFxLx1PtwI9
	jDWuoxabomqQrfLDwEqskQOmJlh9ip74alPdJsfRSdOo9s0iHAfkQu1yssGjjFHGSbmr655pICZ
	AP7oQgdnDl7RO2V5CLpDjs4FWHUG4MyBPwPJZZWazlX2ZlL0NYcBbHtadbkHv4I2n2xm5E7WKmX
	z+MUlIYnWyApLfOET3g3tzEt2qSx0J6D5A8wFilEYFA14t/4u4kyVqz6ur81ZAQHTPVUFhY3a5X
	lkxqMzAS/4rvxT5l6r0lT7VMTkfR823jKspSI8nL1r6Yk+1l2OkI=
X-Google-Smtp-Source: AGHT+IEbMEhG0B3nYlu95Een09E64xC7X4Vra7oIl97vNC0SEQ+v/HmeV7XhKBBSj5QhGKGSaQyemQ==
X-Received: by 2002:a05:6e02:2488:b0:433:1e9b:61de with SMTP id e9e14a558f8ab-433407c9ea8mr60187895ab.24.1762371422211;
        Wed, 05 Nov 2025 11:37:02 -0800 (PST)
Received: from m2max.wifi.delta.com ([99.196.133.153])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b7467d43cdsm39467173.13.2025.11.05.11.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 11:37:01 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/net: add IORING_CQE_F_SOCK_FULL if a send needed to poll arm
Date: Wed,  5 Nov 2025 12:30:59 -0700
Message-ID: <20251105193639.235441-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105193639.235441-1-axboe@kernel.dk>
References: <20251105193639.235441-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a send/sendmsg/sendzc/sendmsgzc needed to wait for space in the
socket to complete, add IORING_CQE_F_SOCK_FULL to the cqe->flags to tell
the application about it. This meant that the socket was full when the
operation was attempted.

This adds IORING_CQE_F_SOCK_FULL as a new CQE flag. It borrows the value
of IORING_CQE_F_SOCK_NONEMPTY, which is a flag only used on the receive
side. Hence there can be no confusion on which of the two meanings is
included in a given CQE, as the application must know which kind of
operation the completion refers to.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  4 ++++
 io_uring/net.c                | 19 +++++++++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index e96080db3e4d..3d921cbb84f8 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -495,6 +495,9 @@ struct io_uring_cqe {
  * IORING_CQE_F_BUFFER	If set, the upper 16 bits are the buffer ID
  * IORING_CQE_F_MORE	If set, parent SQE will generate more CQE entries
  * IORING_CQE_F_SOCK_NONEMPTY	If set, more data to read after socket recv
+ * IORING_CQE_F_SOCK_FULL	If set, the socket was full when this send or
+ *			sendmsg was attempted. Hence it had to wait for POLLOUT
+ *			before being able to complete.
  * IORING_CQE_F_NOTIF	Set for notification CQEs. Can be used to distinct
  * 			them from sends.
  * IORING_CQE_F_BUF_MORE If set, the buffer ID set in the completion will get
@@ -518,6 +521,7 @@ struct io_uring_cqe {
 #define IORING_CQE_F_BUFFER		(1U << 0)
 #define IORING_CQE_F_MORE		(1U << 1)
 #define IORING_CQE_F_SOCK_NONEMPTY	(1U << 2)
+#define IORING_CQE_F_SOCK_FULL		IORING_CQE_F_SOCK_NONEMPTY
 #define IORING_CQE_F_NOTIF		(1U << 3)
 #define IORING_CQE_F_BUF_MORE		(1U << 4)
 #define IORING_CQE_F_SKIP		(1U << 5)
diff --git a/io_uring/net.c b/io_uring/net.c
index a95cc9ca2a4d..6a834237fd5c 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -530,11 +530,21 @@ static inline bool io_send_finish(struct io_kiocb *req,
 
 	/* Otherwise stop bundle and use the current result. */
 finish:
+	if (req->flags & REQ_F_POLL_TRIGGERED)
+		cflags |= IORING_CQE_F_SOCK_FULL;
 	io_req_set_res(req, sel->val, cflags);
 	sel->val = IOU_COMPLETE;
 	return true;
 }
 
+static int io_send_complete(struct io_kiocb *req, int ret, unsigned cflags)
+{
+	if (req->flags & REQ_F_POLL_TRIGGERED)
+		cflags |= IORING_CQE_F_SOCK_FULL;
+	io_req_set_res(req, ret, cflags);
+	return IOU_COMPLETE;
+}
+
 int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
@@ -580,8 +590,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		ret += sr->done_io;
 	else if (sr->done_io)
 		ret = sr->done_io;
-	io_req_set_res(req, ret, 0);
-	return IOU_COMPLETE;
+	return io_send_complete(req, ret, 0);
 }
 
 static int io_send_select_buffer(struct io_kiocb *req, unsigned int issue_flags,
@@ -1516,8 +1525,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 		zc->notif = NULL;
 		io_req_msg_cleanup(req, 0);
 	}
-	io_req_set_res(req, ret, IORING_CQE_F_MORE);
-	return IOU_COMPLETE;
+	return io_send_complete(req, ret, IORING_CQE_F_MORE);
 }
 
 int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
@@ -1586,8 +1594,7 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 		sr->notif = NULL;
 		io_req_msg_cleanup(req, 0);
 	}
-	io_req_set_res(req, ret, IORING_CQE_F_MORE);
-	return IOU_COMPLETE;
+	return io_send_complete(req, ret, IORING_CQE_F_MORE);
 }
 
 void io_sendrecv_fail(struct io_kiocb *req)
-- 
2.51.0


