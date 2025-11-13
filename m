Return-Path: <io-uring+bounces-10581-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CE907C57012
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:52:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 27C35354878
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F0D733EB07;
	Thu, 13 Nov 2025 10:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bAr38nAu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9835D33E373
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763030803; cv=none; b=qcRCtDFSEK0RlOCO4BwvjLRNIk0jQmeKMJOthnF/5g61G0paVTmXo71ARh0ZMYCozgSgzi43XLzuWgrzxNe3X2qKVSL5RLzFgGsiDPqgIWqdlbhlal2SqwrNrEzRupUqQC7wUvW9udJjAF+lUztk566xJ8qiI1XbSj8xir4otRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763030803; c=relaxed/simple;
	bh=81qA4ZUKcISyk/h/kHiInqRUcaxAW8DzjE2dxUhidsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aab0P5s0oyNu25sRk0P4AvGUYhxhmmWTnWkjjLLfkOLXYj4dWy/P/JAcPbRIFiw/6uZkQ1g/edxS8nrEX9DUIwmDwgwJEwrJFrkiAPXVvjw1ILQ8GW8hM0GL3i6XjgSbPu7prE/9BA3kVH7sJhWR5ULIQAtWEwvGXK3pfpFMtjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bAr38nAu; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4775e891b5eso3468475e9.2
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 02:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763030800; x=1763635600; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JXb2ishPj39E4/z5wHUjvNOMlSVBJJXjzfwe3Bgyjz8=;
        b=bAr38nAuLKkskho70mH4ER3XQHclN8CQOvkqYqa6uHcmCa4+jV3T0LMWhuQJnPzl/s
         c8uqjbcgFAnNbcnnRY1jcVWNG6OIrwZqQxYQNGA9Ns6ffB2ovHQdVOiB4v4SylXKaFJw
         xFs7jpBtK+D1ehVJMf9/Ym9KyxsZq5AdYUcat3fHUlG55un7zKqMNYIPoTu+vvkvV2Be
         orjhBoQFM2AW+KaYz/ZmX28OE8urfGg1PaCDNTdM4bUBa6is5r6KVUbBsyFATwveRtRz
         wsqwcUidCpq8nrktCkYvBEmLS+Zc5yW+bvoQzvd/aKkZmz1kYl7lnl43j5RtVtslcahO
         8l1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763030800; x=1763635600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JXb2ishPj39E4/z5wHUjvNOMlSVBJJXjzfwe3Bgyjz8=;
        b=h8HZpaVG0EAzZzZ5ZZ410E2/sywxO2BfUNP3cuiUOu0Lso73geHbbnvh35hNycp+aw
         j3oEWpF+lUjNsRydUuQzcg0US4boVm0XJ9NyHk5Tvc3rRubuQO8/RAnFxmPH5yn0Zei3
         CKitagp3GrEUUJAPeMQcqPgypFe/H6tAVr6LG5r/CtgGEPvYcGFBh49G7tdZwu3n0wtO
         LbG43gGJ4yoPSOV3BCvGVsTwm99C6M3vXkwc1Zd5YBFdBgtE63A00gfFa662Nh4ohhl2
         gCgsZ1dl/fHzzeAVuD9Al60YlP1QCI6MRub/hQX0rEkYdLbkvcXYDTgd+p75M6hNpmo1
         HXvw==
X-Gm-Message-State: AOJu0Yzp643NK+Uzz9ZkFVZrDOsls32l6yVpdtYbWt+nW0iAm0RVbWCw
	Q2Wm6wQBD08AFNUetL/IKHs6kXKZr8hHVtLGR6oqIY3m2QmxolCZJ3vqdk/q0Q==
X-Gm-Gg: ASbGncs8kd102A/jFxPqAarx0A2WMMdbaapKXVZaghGD90QqQ36z8aIFyF5104Qcseo
	cxQbxkg2eE3EKqyQATOLWhvqCGp/25DZlqOZWlMUNDg/sdhJCVMQJyG0WU4ZzbD8iIhN98YQbfD
	NIwU6VxriBxvPE3G+D3HBALQzCIv5srnsmeKPirEAU4Wo9jP5VeXCjfW9p8pLfpLAaoi3+qMFOA
	i0GWaNTjPJhY9P+Ahq5M60l5uHoy4bAfHNUj4WiEcNh5v2TmuIRkoE1jGhPWrVJnHiaHI9Cs29Y
	3hcCIa9VITnRGE5oPLLWE20DHsgpH3ryQJMWcaD2sQ9m/m9zDi4gT5COZ6R/JZyxpt8GhpZlvG4
	OBjpX8iBxrBbk7508N2SBdgzYauYP74NgXqpCW6EowPVMa3k0MoM3RH105yA=
X-Google-Smtp-Source: AGHT+IGidb4hzqe1cMai/PRO3YYe3yCigLBZkoHC1WZpcYshjDp7qHtVmbRVFtkr8/fSND7/vgx3ZA==
X-Received: by 2002:a05:600c:6298:b0:471:672:3486 with SMTP id 5b1f17b1804b1-4778706edd0mr57111475e9.15.1763030799541;
        Thu, 13 Nov 2025 02:46:39 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e7b12asm3135210f8f.10.2025.11.13.02.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 02:46:38 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 10/10] io_uring/zcrx: share an ifq between rings
Date: Thu, 13 Nov 2025 10:46:18 +0000
Message-ID: <010805428bd2451a94dc3e3bd77af33e573118ca.1763029704.git.asml.silence@gmail.com>
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

From: David Wei <dw@davidwei.uk>

Add a way to share an ifq from a src ring that is real (i.e. bound to a
HW RX queue) with other rings. This is done by passing a new flag
IORING_ZCRX_IFQ_REG_IMPORT in the registration struct
io_uring_zcrx_ifq_reg, alongside the fd of an exported zcrx ifq.

Signed-off-by: David Wei <dw@davidwei.uk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  4 +++
 io_uring/zcrx.c               | 63 +++++++++++++++++++++++++++++++++--
 2 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index a4acb4a3c4e9..21b8d159f637 100644
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
index da7e556c349e..b99cf2c6670a 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -660,6 +660,63 @@ static int zcrx_export(struct io_ring_ctx *ctx, struct io_zcrx_ifq *ifq,
 	return 0;
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
@@ -685,11 +742,13 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
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
2.49.0


