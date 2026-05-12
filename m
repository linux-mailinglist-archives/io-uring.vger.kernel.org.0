Return-Path: <io-uring+bounces-13281-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eHdmO90BA2rdzQEAu9opvQ
	(envelope-from <io-uring+bounces-13281-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 12:33:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4345451EA2F
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 12:33:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BC44E3025FB9
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 10:25:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DA65383982;
	Tue, 12 May 2026 10:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kZ6n3SIL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A341F349CCD
	for <io-uring@vger.kernel.org>; Tue, 12 May 2026 10:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778581536; cv=none; b=KjxHiXe0lOp6f6QEh2lKsM9eQW1JM5HoYQqU0o1E8/Eg62krtyz05g2PVs87Yep0YqU0WjROAQnqc1eFRSBoN9FVWMmUBpKq72rcFqw8Tpffh6ePQvWB6nDY7zCvrt4xPLHF0pGBIFybyQcxoTH5FYavkLo7vxuIUMtU0NYaqsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778581536; c=relaxed/simple;
	bh=QQZD5rgSKCz52tDI8pqPd/M30enC3uroMaaCE0+aGlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2Os6RG2gh8vK1jO2q7hgl9r4WBiV9b0xZzhWanWZAIyb3KmDOZ5ZOg6wRuFG+ojAhVcJ8fCR+SaZOr5eaRgBRb8ebLadc8n9wOFxr2wute1LN1dcLpMHw5Tva2F7fG/IkbO1v9ZxWw0d9Cr7ltuV5TwtYS1/JcPvRMQrRBwD1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kZ6n3SIL; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43eb05b1875so3151858f8f.3
        for <io-uring@vger.kernel.org>; Tue, 12 May 2026 03:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778581533; x=1779186333; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xJ/pPOW6DLk5fsFIOdFk0JDGjREEIe88CQ9E+zou+G4=;
        b=kZ6n3SILwF47qcG5vjpYMCFoD1h5t4PZBazxIqDvqzpt3hT3nN2pgzgPYt9Z4k7shK
         WxQpcmyOtKneFY9siHZN/yHUyCbsTzIBzl1D9WquSN7acWwnafxVTSXA5x1V9ihPA76I
         WU8q6yqTKZ5p3gfRu/Tbdn0iL2ANpH8N1NGadRIUTBSLanip7jlXH3olU7Pe+VF5G/wd
         ysNoG7yMpStTXIIv5NW0jZc7NMKJfuGipnvHP/S/Xzbi0JYt5+n+L/B63Fiywy1l52qw
         XngR6t8wGbb01+j0wtrIQyBrxcOqLkBAOSmyGMoaAhl2/2QN8yrg4ZLLwaEjFhe/4o25
         /sXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778581533; x=1779186333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xJ/pPOW6DLk5fsFIOdFk0JDGjREEIe88CQ9E+zou+G4=;
        b=AgGWrHwr1MigVqP47o+5QPMD9NFSpfQuema68JZTYb1QdF2l4QOMR/vI5PR+xO3/Rk
         2FMF5xV3IX/Mb+VfBUR06yKxkcBuBiO5038mFbBIzIZkyBN0y1UmIAuvArn9Ccy47KJj
         x3z0X4hYxq1Vro4ZDbaLGFxJJsWr533rfZYOpAkaR3b2w2IT6E7c4tlHqhzklOuS3xKY
         s995GVUTvAccLLObrPN7aHko5nLabOUv9bcAqtkJALtI1hdk/Iuw2LrZR3PKoyazBN3u
         99Vun8osVbc9a7IcRFi3dy7CGQzetirupgmndxEtYwc4jDjnV5RAolP5lYBuEWnl2oJh
         hRYg==
X-Gm-Message-State: AOJu0YzIqwFhfLwkOtv12KbKVDORiQTrbIve8Qia3FwlQIo1mmsswS3i
	raZ8nJzDzAC/Eth8EQVlsyb6xXQr1+k8Km0JJlD8KyrsrLCKvIXPF+6sH/zX8w==
X-Gm-Gg: Acq92OF5ZqwhB0SVOIUOsxzRoWLq1in+YRF1ZHkTXrz/cOjIu58hTNB1U7HyzR/BbBz
	84t36da7Atxi3dknd658pGuEMNmH0xNER/1zbQabjxftqW5VmGcahs0za+9AnqMnbYv3LQU0WSy
	OhudH4MNe6QE2g5jLK1SppHKfIP9AmUcwy+3xwxWEvro+LajrUJRA/MYs5TMy2IS2prddtBMcRT
	qijyFqDpLNknq3E+AHg45NxK+LpP2ZEqTgbSeOUTnbjljojZXt2uv1/Uj0K1D2CumkH75QkhYkT
	j3mhAdCxmhXNyA3me/JgMs086oxAo9+cUL02hyz9Fgjl8e8JjGloqhgOHD9IfmMTCU0HoM+rVSx
	dRR5tyczdg0AP2Vlfrdl2oki3NNjL/0UlXofqD4LCveM0vSbyHOFH410Ufx7M0/TAOjmS9qxLmw
	PrSV6yUTvTwNu5LPNEQKAcoS+HGLxyjHtzfqu+Q9bsWVAd8a6UdT4NlMLYaUnuLJf3ukSgkqg0h
	9sC4PAkH4z1ZXjK+von
X-Received: by 2002:a05:600c:8b65:b0:488:a824:fdff with SMTP id 5b1f17b1804b1-48e706c7e20mr219541165e9.22.1778581532697;
        Tue, 12 May 2026 03:25:32 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:8c90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e9052c9fesm74352255e9.1.2026.05.12.03.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 03:25:32 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [RFC 6/6] io_uring/zcrx: add dynamic area creation
Date: Tue, 12 May 2026 11:25:06 +0100
Message-ID: <ba6903f8619b69787b1e3dd97244c08f7ef319d2.1778581283.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1778581283.git.asml.silence@gmail.com>
References: <cover.1778581283.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4345451EA2F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-13281-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

It's not always possible for the user to predict during registration how
much memory zcrx will need to sustain the traffic. Allow to dynamically
add more areas with a new ctrl code ZCRX_CTRL_ADD_AREA.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring/zcrx.h |  7 ++++++
 io_uring/zcrx.c                    | 39 +++++++++++++++++++++++++++++-
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring/zcrx.h b/include/uapi/linux/io_uring/zcrx.h
index 5ce02c7a6096..de696eb10db4 100644
--- a/include/uapi/linux/io_uring/zcrx.h
+++ b/include/uapi/linux/io_uring/zcrx.h
@@ -88,6 +88,7 @@ struct io_uring_zcrx_ifq_reg {
 enum zcrx_ctrl_op {
 	ZCRX_CTRL_FLUSH_RQ,
 	ZCRX_CTRL_EXPORT,
+	ZCRX_CTRL_ADD_AREA,
 
 	__ZCRX_CTRL_LAST,
 };
@@ -101,6 +102,11 @@ struct zcrx_ctrl_export {
 	__u32 		__resv1[11];
 };
 
+struct zcrx_ctrl_add_area {
+	__u64		area_ptr; /* pointer to struct io_uring_zcrx_area_reg */
+	__u64		__resv[5];
+};
+
 struct zcrx_ctrl {
 	__u32	zcrx_id;
 	__u32	op; /* see enum zcrx_ctrl_op */
@@ -109,6 +115,7 @@ struct zcrx_ctrl {
 	union {
 		struct zcrx_ctrl_export		zc_export;
 		struct zcrx_ctrl_flush_rq	zc_flush;
+		struct zcrx_ctrl_add_area	zc_area;
 	};
 };
 
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 5fb81bb6f819..4bcf68b8d682 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -481,7 +481,7 @@ static int __zcrx_create_area(struct io_zcrx_ifq *ifq,
 			return -EINVAL;
 		buf_size_shift = ilog2(rx_buf_len);
 	}
-	if (WARN_ON_ONCE(ifq->niov_shift))
+	if (ifq->niov_shift && ifq->niov_shift != buf_size_shift)
 		return -EINVAL;
 	if (!ifq->dev && buf_size_shift != PAGE_SHIFT)
 		return -EOPNOTSUPP;
@@ -967,6 +967,8 @@ int io_register_zcrx(struct io_ring_ctx *ctx,
 			goto err;
 	}
 
+	WARN_ON_ONCE(!ifq->niov_shift);
+
 	reg.zcrx_id = id;
 
 	scoped_guard(mutex, &ctx->mmap_lock) {
@@ -1325,6 +1327,39 @@ static int zcrx_flush_rq(struct io_ring_ctx *ctx, struct io_zcrx_ifq *zcrx,
 	return 0;
 }
 
+static int zcrx_ctrl_add_area(struct io_ring_ctx *ctx, struct io_zcrx_ifq *ifq,
+			      struct zcrx_ctrl *ctrl)
+{
+	struct zcrx_ctrl_add_area *ctrl_add = &ctrl->zc_area;
+	struct io_uring_zcrx_area_reg __user *area_uptr;
+	struct io_uring_zcrx_area_reg area_reg;
+	struct io_zcrx_area *area;
+	int ret;
+
+	area_uptr = u64_to_user_ptr(ctrl_add->area_ptr);
+
+	if (!mem_is_zero(&ctrl_add->__resv, sizeof(ctrl_add->__resv)))
+		return -EINVAL;
+	if (copy_from_user(&area_reg, area_uptr, sizeof(area_reg)))
+		return -EFAULT;
+
+	ret = __zcrx_create_area(ifq, &area_reg, &area, 0);
+	if (ret)
+		return ret;
+
+	if (copy_to_user(area_uptr, &area_reg, sizeof(area_reg))) {
+		io_zcrx_free_area(ifq, area);
+		return -EFAULT;
+	}
+
+	ret = io_zcrx_append_area(ifq, area);
+	if (ret) {
+		io_zcrx_free_area(ifq, area);
+		return ret;
+	}
+	return 0;
+}
+
 int io_zcrx_ctrl(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 {
 	struct zcrx_ctrl ctrl;
@@ -1348,6 +1383,8 @@ int io_zcrx_ctrl(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 		return zcrx_flush_rq(ctx, zcrx, &ctrl);
 	case ZCRX_CTRL_EXPORT:
 		return zcrx_export(ctx, zcrx, &ctrl, arg);
+	case ZCRX_CTRL_ADD_AREA:
+		return zcrx_ctrl_add_area(ctx, zcrx, &ctrl);
 	}
 
 	return -EOPNOTSUPP;
-- 
2.53.0


