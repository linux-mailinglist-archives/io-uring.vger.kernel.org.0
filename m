Return-Path: <io-uring+bounces-10575-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DE2AFC5700F
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:52:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1D0E94EBF1C
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F7AE2D7DC0;
	Thu, 13 Nov 2025 10:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y9/mTpgS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B889633C53F
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763030795; cv=none; b=honFaeDfsv7yGF8LtLQ5F8NoTkj/WB21mBpePlrJDbDHM0zPbYtvpB7PaQZ8sN38bPUOHcQNG5GjcVkmh6IDyAvkAR0oWmIKVrRMmdZoL6mGMLFCWRvaP4XCxCYpOUXUFndcILXxtYm9VH4wttsA+OPvWrE3p6kkUHxKtedGFSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763030795; c=relaxed/simple;
	bh=fxImp9PCBrRzLacyzw0s4/YWShfUB5rnWGk2JRRT9hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nj/SP31i5gdWSOA4HU5EEilIwrPjU3ItTJT7hPHnRTB4HT+oYrmv5VQDhpQJSsXwDV0s+v01JlDHt1+4eSHIcG9csSiXKT2+lJvrXns9q4tz9aY60DzIqdxDv03pLaV7l4J1kM9cKidWWQbG4iYHAhWa3aXjWuUvSRo9X4R3pEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y9/mTpgS; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-42b3b0d76fcso459060f8f.3
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 02:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763030791; x=1763635591; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s05tFvB4WFd+B9gxrucMuUCTKso703qwSrt2nkbSvSc=;
        b=Y9/mTpgSTx7siF99SxSZ7icekfwwNM4PrMFYhhggKmtfqDTDNDC9asyapzQPaCg2YT
         O/T63mpjZ68RHbYic33oSekEhkCLmZACRYqLTFv+P9Uv2dwNgdVPDCVxd2g/WF9gfSEy
         NJGsy133fYHiE0Dn+tJiyk3N6zTbBs25P3HOVvznrNUHZgVY+2/YoTr9MmOl8Snz5pNR
         iB8TMxmsliJJutOqxaEPaoZkGqE0UJbBYqnkQ01L14KIuixheEcGjYcvdKBp3GZj8bZ3
         JsHbupPo+D87oMlnkyvYPBbYkkiGBQvAl/UO2CYUAemhlHBw9YnbU+wL/FXqwufGEDmi
         pFEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763030791; x=1763635591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s05tFvB4WFd+B9gxrucMuUCTKso703qwSrt2nkbSvSc=;
        b=P6I4GlbD8MaeUSrmd+GkpOXSPrE9ORe9aHvEaz6OKrpD8H2Mj1fuVz/VrIoMBFfyCA
         qjQvVF1Kzh3sbrO1FROTuww1d7wADpFBmaOveIrLq1wOo0N12ilDDHHp/A+vOaKbT5YD
         1KLE7IdZFjrWgb7hNycr4F5xgSFobF5IMRPGWgCH80+jas6/gPrNGQrnwwMH0jPikwiU
         kHnOBAamzYKhUm08HOpjbS7JI2bFK6CAwJWlV5CUqAFNXNDgo/QhutNQYsvJy/s5zbFI
         7GfGK+uz2vcWQn40yfqCYUmd76spCJmPKP3nPXH7uf/+qXQeyIAj61BEdGyTH+ZfcbJs
         Z1fQ==
X-Gm-Message-State: AOJu0YwZi//dWdZg20txWG88kdPTwYwL5LukyRvCU3RE5ylOYxgFuLNm
	uP+zd+wewE+WjiSusC3A4Ekv/WbuLvq+uM/FHPiEegE31Wyjx2q1YuRum2WXxQ==
X-Gm-Gg: ASbGncvMXCV1OLSZnpvXtjYBf1VDzME8cOXm5+BrTDzuKEJntAZIoYh6Wqr33ciIzsQ
	SgMUB+PN+uxQbllBr7yt+42DziPYZuecLEx7NUz6TgTQNqFGK7urKvVFM83XIOhevI7VdzlKXIx
	LilSG37grejMimFoxy85E83w0MuWzgMz9T9+r7Gvld4TPwR6SsU4kWMW2WnXD1LEGkWqbdmErC9
	wsa8S2AcEVnkcZ/bp51IUwfgtapfRR/YzYAtUqPsUj9zS/vUnTiKQGqV16WJJSb4CTxdSkHcW6W
	CeTsTEzbPryuBRkMC9A3Uztp0d2T8aL642BVxU4iwkFBK8hfAQpwSLu1ylvsSIfKcC24qON640t
	1bQtu9gNdPqcmrn+uMmk1T8YvVyI3tZdHjAvH4rDiuF32OKi/GbFOhwvFmtc=
X-Google-Smtp-Source: AGHT+IFTizU/twJ2tH/xFdwQQ3KWcjN7Nqmib5bArJ/lMR51LKVnPXeqH4/Ou4Tn/oy9DSZegVM6jA==
X-Received: by 2002:a05:6000:2003:b0:42b:40df:2339 with SMTP id ffacd0b85a97d-42b4bdb9f74mr6123087f8f.57.1763030790638;
        Thu, 13 Nov 2025 02:46:30 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e7b12asm3135210f8f.10.2025.11.13.02.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 02:46:29 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH 04/10] io_uring/zcrx: introduce IORING_REGISTER_ZCRX_CTRL
Date: Thu, 13 Nov 2025 10:46:12 +0000
Message-ID: <781c0f06a0e7f2d0520d7fe59a13725efd647a85.1763029704.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1763029704.git.asml.silence@gmail.com>
References: <cover.1763029704.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It'll be annoying and take enough of boilerplate code to implement
new zcrx features as separate io_uring register opcode. Introduce
IORING_REGISTER_ZCRX_CTRL that will multiplex such calls to zcrx.
Note, there are no real users of the opcode in this patch.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h | 13 +++++++++++++
 io_uring/register.c           |  3 +++
 io_uring/zcrx.c               | 21 +++++++++++++++++++++
 io_uring/zcrx.h               |  6 ++++++
 4 files changed, 43 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 3d921cbb84f8..5b7851704efe 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -701,6 +701,9 @@ enum io_uring_register_op {
 	/* query various aspects of io_uring, see linux/io_uring/query.h */
 	IORING_REGISTER_QUERY			= 35,
 
+	/* auxiliary zcrx configuration, see enum zcrx_ctrl_op */
+	IORING_REGISTER_ZCRX_CTRL		= 36,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -1082,6 +1085,16 @@ struct io_uring_zcrx_ifq_reg {
 	__u64	__resv[3];
 };
 
+enum zcrx_ctrl_op {
+	__ZCRX_CTRL_LAST,
+};
+
+struct zcrx_ctrl {
+	__u32	zcrx_id;
+	__u32	op; /* see enum zcrx_ctrl_op */
+	__u64	__resv[8];
+};
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/io_uring/register.c b/io_uring/register.c
index ec13ff876a38..2761a751ab66 100644
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
index 149bf9d5b983..0b5f4320c7a9 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -941,6 +941,27 @@ static const struct memory_provider_ops io_uring_pp_zc_ops = {
 	.uninstall		= io_pp_uninstall,
 };
 
+int io_zcrx_ctrl(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
+{
+	struct zcrx_ctrl ctrl;
+	struct io_zcrx_ifq *zcrx;
+
+	if (nr_args)
+		return -EINVAL;
+	if (copy_from_user(&ctrl, arg, sizeof(ctrl)))
+		return -EFAULT;
+	if (!mem_is_zero(&ctrl.__resv, sizeof(ctrl.__resv)))
+		return -EFAULT;
+
+	zcrx = xa_load(&ctx->zcrx_ctxs, ctrl.zcrx_id);
+	if (!zcrx)
+		return -ENXIO;
+	if (ctrl.op >= __ZCRX_CTRL_LAST)
+		return -EOPNOTSUPP;
+
+	return -EINVAL;
+}
+
 static bool io_zcrx_queue_cqe(struct io_kiocb *req, struct net_iov *niov,
 			      struct io_zcrx_ifq *ifq, int off, int len)
 {
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index c9b9bfae0547..f29edc22c91f 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -65,6 +65,7 @@ struct io_zcrx_ifq {
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
+int io_zcrx_ctrl(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_arg);
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			 struct io_uring_zcrx_ifq_reg __user *arg);
 void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx);
@@ -93,6 +94,11 @@ static inline struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ct
 {
 	return NULL;
 }
+static inline int io_zcrx_ctrl(struct io_ring_ctx *ctx,
+				void __user *arg, unsigned nr_arg)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 int io_recvzc(struct io_kiocb *req, unsigned int issue_flags);
-- 
2.49.0


