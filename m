Return-Path: <io-uring+bounces-10345-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 77B74C2E6FC
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 00:41:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id EFEBE34C076
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 23:41:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C377430E85E;
	Mon,  3 Nov 2025 23:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="RwAS/UPh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8E93019B7
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 23:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762213282; cv=none; b=nc4Ej/v8l4YSz5iHoGmn/LyblGozL1dzk2RdP1jxI+UoD1KrAPl0w8QYinjrrCufByZAts0iD7XnrFQnOkdVLCD77eS/7Ubu2saOziEmxmPyUBxi+EyQygpRuPm5QBSgZaQZE+qGrqIuIuVyAeIpry/Pgp5sOUX1580mC84iq3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762213282; c=relaxed/simple;
	bh=lAr74GBqxBV0xGcJVxnqiWLD/1vfXOM+DZWfUMPduNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfyIEt71ZRHKelGC1lwailywstP2jIc1sUL6a+z+S/COK/kJA3jNFnf9a2B6rXnBgu33qGr6I1ybfw51vel3bxHWKPHrtBwCsWhTMvv1UsSuOwFQU/sRYK/Tir6wapdKcx8aWpnN27ckv7W9yLD737euOKKvHBSkGfub10Ym9YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=RwAS/UPh; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-656b251d27cso18742eaf.2
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 15:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762213280; x=1762818080; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yQ9cLZwPoaCiKGoK2gvn737P1RXVNR7hjgiKGyXyYRM=;
        b=RwAS/UPhA4KR6GmkjMz8cn/UQR5QXO+f3Uq5frLJqR4wfjT80dVwku22Jl5I6/e3p+
         +nSXHobLnoe8kKjihiMEsvJ13liJ5JF6YtiX2AsTP/7yG1clG86tgt+ijyQiwh3Pwa+Q
         FXyYhXFmdGyLXa4IA/ezH5++q9HHdX42GBBBTSLyh7u9+dl8gwjx3GSQ+OEXHcc2w34H
         OJOydlYUH9HY4f9Fn9PMrmcMpBzrT+J+EIf9F1Jelt9uDz2kWQe0O2xyEA0GnTzPHQkP
         w76/Kp1/qf3dzNkvYV/ArOws9BOks7JHdWQR+z0BM8nLc9KzoyU0dfCHoa3lueHxKyXp
         5RSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762213280; x=1762818080;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yQ9cLZwPoaCiKGoK2gvn737P1RXVNR7hjgiKGyXyYRM=;
        b=kGMB1fTOQE8m8/p2MMUdzCJ9G7wKaNnfZ87W3dmrov3XiHu59fDUrXLR6Q1FsUaQB0
         pIhIwid6bzUR4mYaXdgcu46c4jO893mnhut33GJ3bXk/weiA0R/Jz3OzNiilS89+ALAq
         63A1GwjxT3SzH9MqmS5006az4K0VEF5fNTsqzcA65twy6cN6Blknxg1w92YO93+NNDNt
         Apl1C+xDiEpda9sRsJKcOkWCjNeYPWdID0+2iCox6RbYSQ+ov0vLDs08W2+sXqNx0X7B
         3VtM1LlrDNg0ISkMGbPUYlyYmSVKUBdpnIrp8rvfJXKna9HOr6zepd3NvydDgWRvRnCV
         9h9w==
X-Gm-Message-State: AOJu0YyMs9TD77PJHVKwzW0n01yBgnNdrblznczSELQSF52jCMYMMy1r
	O8hfOgRf4gLxRtrKVnGbiGtdOdD+qwif3b3S42f2YDObD5PzppFuabRg6CHaWQwFONmgbAsLtYL
	kuh2i
X-Gm-Gg: ASbGncuxBoZNDxxzqopYtyk4Tjbm1Sd8ydQis9emJkopHE01gGinMKzl7UkpQ5o/+wL
	gWNB327P25A72/75Ve1jms2gIv++6IKW02VP7jDF4FYaJSPDcrx7TixbmPYkgkMzy9cWJSnlLWz
	PKExBMQWCkSC7Q+P14k3ob3XDsWMKaj1WV9O5xkhpUONc9Ri7ArSN6JC1BbDyt85QtbHEIgJSwe
	prXvwVW1+nmgMivTgf6hZG8OswjjjZXLL9ub6oaTZib1i/6BVt+CjU/CzzemhVnBbUA+4VeFcMC
	y9REKvMqag0HKp60hH1cglg0G/j/D6624VSCwO6DGHsEvb8vvLBLNdYCy+FjafJu7mt0uyjii9J
	0F4GR1fXUtgXH/xTNsqByFI1FbItTfv909vgxkWy/CMum/mstvOJFhrPpuONfEWFdaPeUmdftGX
	DDrxhe7Oa8Aco0EwdbrfeckMC4fqHYhA==
X-Google-Smtp-Source: AGHT+IFciK3DlG/OKbMBbiVWE5sQ6Kj9JiVMPmZCXUxodQT36csulO/vIgiBtROoIZe1B3B4ocEKSA==
X-Received: by 2002:a05:6808:1687:b0:44d:b8b7:fbf4 with SMTP id 5614622812f47-44f95dfbc03mr6355593b6e.12.1762213280151;
        Mon, 03 Nov 2025 15:41:20 -0800 (PST)
Received: from localhost ([2a03:2880:12ff:70::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-44fd8882d8esm444902b6e.16.2025.11.03.15.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 15:41:19 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v4 02/12] io_uring/zcrx: introduce IORING_REGISTER_ZCRX_CTRL
Date: Mon,  3 Nov 2025 15:41:00 -0800
Message-ID: <20251103234110.127790-3-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251103234110.127790-1-dw@davidwei.uk>
References: <20251103234110.127790-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Introduce IORING_REGISTER_ZCRX_CTRL and add some boilerplate code
forwarding it to zcrx. There are no actual users in this patch, it'll be
used for refill queue flushing and other features.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/uapi/linux/io_uring.h | 13 +++++++++++++
 io_uring/register.c           |  3 +++
 io_uring/zcrx.c               | 21 ++++++++++++++++++++-
 io_uring/zcrx.h               |  7 +++----
 4 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index e96080db3e4d..8b4935b983e7 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -697,6 +697,9 @@ enum io_uring_register_op {
 	/* query various aspects of io_uring, see linux/io_uring/query.h */
 	IORING_REGISTER_QUERY			= 35,
 
+	/* auxiliary zcrx configuration, see enum zcrx_ctrl_op */
+	IORING_REGISTER_ZCRX_CTRL		= 36,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -1078,6 +1081,16 @@ struct io_uring_zcrx_ifq_reg {
 	__u64	__resv[3];
 };
 
+enum zcrx_ctrl_op {
+	__ZCRX_CTRL_LAST,
+};
+
+struct zcrx_ctrl {
+	__u32	zcrx_id;
+	__u32	op; /* see enum zcrx_ctrl_op */
+	__u64	resv[8];
+};
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/io_uring/register.c b/io_uring/register.c
index d8ce1b5cc3a2..38b20a7a34db 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -826,6 +826,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	case IORING_REGISTER_QUERY:
 		ret = io_query(ctx, arg, nr_args);
 		break;
+	case IORING_REGISTER_ZCRX_CTRL:
+		ret = io_zcrx_ctrl(ctx, arg, nr_args);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index b694fa582d29..3e9d8333a301 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -541,6 +541,25 @@ struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
 	return ifq ? &ifq->region : NULL;
 }
 
+int io_zcrx_ctrl(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
+{
+	struct zcrx_ctrl ctrl;
+	struct io_zcrx_ifq *ifq;
+
+	if (nr_args)
+		return -EINVAL;
+	if (copy_from_user(&ctrl, arg, sizeof(ctrl)))
+		return -EFAULT;
+	if (ctrl.op >= __ZCRX_CTRL_LAST)
+		return -EOPNOTSUPP;
+
+	ifq = xa_load(&ctx->zcrx_ctxs, ctrl.zcrx_id);
+	if (!ifq)
+		return -ENXIO;
+
+	return -EINVAL;
+}
+
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zcrx_ifq_reg __user *arg)
 {
@@ -966,7 +985,7 @@ static void io_return_buffers(struct io_zcrx_ifq *ifq,
 }
 
 __maybe_unused
-int io_zcrx_return_bufs(struct io_ring_ctx *ctx,
+static int io_zcrx_return_bufs(struct io_ring_ctx *ctx,
 			void __user *arg, unsigned nr_arg)
 {
 	struct io_uring_zcrx_rqe rqes[IO_ZCRX_SYS_REFILL_BATCH];
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 33ef61503092..d7bef619e8ad 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -63,8 +63,7 @@ struct io_zcrx_ifq {
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
-int io_zcrx_return_bufs(struct io_ring_ctx *ctx,
-			void __user *arg, unsigned nr_arg);
+int io_zcrx_ctrl(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_arg);
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			 struct io_uring_zcrx_ifq_reg __user *arg);
 void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx);
@@ -97,8 +96,8 @@ static inline struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ct
 {
 	return NULL;
 }
-static inline int io_zcrx_return_bufs(struct io_ring_ctx *ctx,
-				      void __user *arg, unsigned nr_arg)
+static inline int io_zcrx_ctrl(struct io_ring_ctx *ctx,
+			       void __user *arg, unsigned nr_arg)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.47.3


