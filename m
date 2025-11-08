Return-Path: <io-uring+bounces-10464-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10C81C4332E
	for <lists+io-uring@lfdr.de>; Sat, 08 Nov 2025 19:15:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C143188E751
	for <lists+io-uring@lfdr.de>; Sat,  8 Nov 2025 18:15:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF10279334;
	Sat,  8 Nov 2025 18:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="L7UPL5ra"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A2A279907
	for <io-uring@vger.kernel.org>; Sat,  8 Nov 2025 18:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762625676; cv=none; b=TdhiE+FusDawnHcAqu1rB9eR+CFEvgbT1W9dI4YsXugkGvh2vRusOI+3aZLb1Wkne3RdBGJ5syKwyfmiCvLpqNqbrAEZouBP9GA6KNuASjpBtfUdFvjmiavbvi79MeFvFYRicnOsZIRf9nN2QOR+oRoFgnhRtL2jp2f9iTooZfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762625676; c=relaxed/simple;
	bh=QMbgf28t7Wf8iojQhsSnuWgYkc5TK4ZVRXgndF/GowU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPnmg3Mvey6t9sctsF9eN3UiabXN9Mu7pL8RjJsDBiJ/xQWW06mzOZ1JjU6P4OP+VQ8nKoxK66LaJDaAujWF3t1CsnjoNAJ++q19jdMiVBlvQm+oo6NnyqULKMm3D3LdypKo38RzakPbpV7S6CvfZaCvqnOazrwkdq/9mZyaPWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=L7UPL5ra; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-450136c3e05so782016b6e.3
        for <io-uring@vger.kernel.org>; Sat, 08 Nov 2025 10:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762625673; x=1763230473; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n/PdQmrlcLPfoOh3SahN7VasJ5pX5oJY3C7hCi9nQfw=;
        b=L7UPL5rad8kGqn94CPQ8LyxjK7k9SFZPgDT8G+FPyxmPFoR2TTzyC1zUtDIuqusidV
         GlitEA0GFC7rHOqXuNsRaj35ai2SNodlHmbKFTp2cTfPAORcwslDKU/fe2gYkrfWe47c
         steg1v9OMcT8DNPc0JCy0OKLVJFJ67swTR3gKNbgqF2BoY/0i+IVZcBiPs/tweNfjQ5D
         0xvpTo8o4UGUMBHQqFhxJK3vcIpyB/qchg+OV7Zt6D0ch/Lb5Q2S3stDRh12393cuHCI
         Oztqb3Og7sjGH8+kh9RWyfPkDYoVDHAF+imYYuS3YL2m9ftneM/XVHv+8INjF2dLU8Hp
         mBxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762625673; x=1763230473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n/PdQmrlcLPfoOh3SahN7VasJ5pX5oJY3C7hCi9nQfw=;
        b=ANNNlamG89kTxf7ADygWa4ymAHbborpxXicCTNC1mOkZPy3zujfqy0INIv2VGkHT5s
         fRmHftzW29G16cvwwkiNlmZK9y2NTePvguuKkyG5OmSA4y50hmX6l+zixx/xe/JuZhVc
         3Qg03ll43T2l70tsBPlRiWuXb3+afZ4AC2J+GFgQme7TiBwN7Ep8AsMTLfd77cZBrXvz
         B3SOSGz7m/rSylQvzban1J2/a/y7rl9NidwsoP09XnOJOx+oGPAQC2Pq7fCaCMOTgtXI
         EdqJ4kAO2+jsCEycMfVj5+o83Q6+JczfszxZdTLxpkFe6Xushi8db/bNoxfNdryeJUYJ
         4okw==
X-Gm-Message-State: AOJu0YzLP9idylcdZ3HHGgILWy0r/uI5ofD/v8qyjAMhnnH0ZwQ5ixFR
	AydPeaamhcjrGXXQaGZL1lSja+oWNBeEeUCoFLNrr/2WqP+5pR3VYJpgqYQnbFRDOgsXzIs0Ic8
	49F1L
X-Gm-Gg: ASbGnctB4rvIy3nsTc3jdp5malRCV0eW1WKcjJkAJVSYlT4t4bwE+jVWa5XUj7YlNnn
	IwYsWuIRk+G0ay6plpuGoLX/Y8/kGC0P04IMFi/tbtTI0iTy+lxyadN0w3KK/QxC2UZ+PM+i86D
	u2IzHRRFP2zpmWR/y60+lznV0QwDx5Kk9o8i5Z/VvkQi6RaKr4yXf1pD19LUAOsuPRwg1FRE0Td
	shbyu0593JhYZL6z0VMo+vtOmXhiUesw37tK833AjDCgbqxZ7SQM5oLrAlneLqzCaU+FXLZFOuS
	M5wVtZ1Xh4aVWIF36PncXSocUcQu3gZz/my53qW7RNz4Zb+6JbpL2tXpqPHJVK052smyK23MknF
	0HCLVG9cS4qrMibhG8MMOvFVaT1FBqZvaGA3ptADU43i/Px/47Fe4x7u6T1hxK03zbPnTq5/Hfl
	TDxixwU2Yl2AjlNV6MY7SfOwun8OknMg==
X-Google-Smtp-Source: AGHT+IFkpJmAP6lQuXqOAJ3jQQni9HN1oW5izLgQ0227Q+Wen+0S6Ls5aLGwf8xEgoUMU70zsODDBw==
X-Received: by 2002:a05:6808:218f:b0:438:3b4c:c414 with SMTP id 5614622812f47-4502a1cb142mr1705910b6e.18.1762625673645;
        Sat, 08 Nov 2025 10:14:33 -0800 (PST)
Received: from localhost ([2a03:2880:12ff:70::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4500280856fsm3823182b6e.24.2025.11.08.10.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Nov 2025 10:14:33 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v6 5/5] io_uring/zcrx: share an ifq between rings
Date: Sat,  8 Nov 2025 10:14:23 -0800
Message-ID: <20251108181423.3518005-6-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251108181423.3518005-1-dw@davidwei.uk>
References: <20251108181423.3518005-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a way to share an ifq from a src ring that is real (i.e. bound to a
HW RX queue) with other rings. This is done by passing a new flag
IORING_ZCRX_IFQ_REG_IMPORT in the registration struct
io_uring_zcrx_ifq_reg, alongside the fd of an exported zcrx ifq.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/uapi/linux/io_uring.h |  4 +++
 io_uring/zcrx.c               | 63 +++++++++++++++++++++++++++++++++--
 2 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f5dae95bc0a8..49c3ce7f183b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -1067,6 +1067,10 @@ struct io_uring_zcrx_area_reg {
 	__u64	__resv2[2];
 };
 
+enum zcrx_reg_flags {
+	ZCRX_REG_IMPORT	= 1,
+};
+
 /*
  * Argument for IORING_REGISTER_ZCRX_IFQ
  */
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 49990c89ce95..ef6819fc51db 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -651,6 +651,63 @@ static int export_zcrx(struct io_ring_ctx *ctx, struct io_zcrx_ifq *ifq,
 	return fd;
 }
 
+static int import_zcrx(struct io_ring_ctx *ctx,
+		       struct io_uring_zcrx_ifq_reg __user *arg,
+		       struct io_uring_zcrx_ifq_reg *reg)
+{
+	struct io_zcrx_ifq *ifq;
+	struct file *file;
+	int fd, ret;
+	u32 id;
+
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
+		return -EINVAL;
+	if (!(ctx->flags & (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED)))
+		return -EINVAL;
+	if (reg->if_rxq || reg->rq_entries || reg->area_ptr || reg->region_ptr)
+		return -EINVAL;
+
+	fd = reg->if_idx;
+	CLASS(fd, f)(fd);
+	if (fd_empty(f))
+		return -EBADF;
+
+	file = fd_file(f);
+	if (file->f_op != &zcrx_box_fops || !file->private_data)
+		return -EBADF;
+
+	ifq = file->private_data;
+	refcount_inc(&ifq->refs);
+	refcount_inc(&ifq->user_refs);
+
+	scoped_guard(mutex, &ctx->mmap_lock) {
+		ret = xa_alloc(&ctx->zcrx_ctxs, &id, NULL, xa_limit_31b, GFP_KERNEL);
+		if (ret)
+			goto err;
+	}
+
+	reg->zcrx_id = id;
+	io_fill_zcrx_offsets(&reg->offsets);
+	if (copy_to_user(arg, reg, sizeof(*reg))) {
+		ret = -EFAULT;
+		goto err_xa_erase;
+	}
+
+	scoped_guard(mutex, &ctx->mmap_lock) {
+		ret = -ENOMEM;
+		if (xa_store(&ctx->zcrx_ctxs, id, ifq, GFP_KERNEL))
+			goto err_xa_erase;
+	}
+
+	return 0;
+err_xa_erase:
+	scoped_guard(mutex, &ctx->mmap_lock)
+		xa_erase(&ctx->zcrx_ctxs, id);
+err:
+	zcrx_unregister(ifq);
+	return ret;
+}
+
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zcrx_ifq_reg __user *arg)
 {
@@ -676,11 +733,13 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		return -EINVAL;
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
-	if (copy_from_user(&rd, u64_to_user_ptr(reg.region_ptr), sizeof(rd)))
-		return -EFAULT;
 	if (!mem_is_zero(&reg.__resv, sizeof(reg.__resv)) ||
 	    reg.__resv2 || reg.zcrx_id)
 		return -EINVAL;
+	if (reg.flags & ZCRX_REG_IMPORT)
+		return import_zcrx(ctx, arg, &reg);
+	if (copy_from_user(&rd, u64_to_user_ptr(reg.region_ptr), sizeof(rd)))
+		return -EFAULT;
 	if (reg.if_rxq == -1 || !reg.rq_entries || reg.flags)
 		return -EINVAL;
 	if (reg.rq_entries > IO_RQ_MAX_ENTRIES) {
-- 
2.47.3


