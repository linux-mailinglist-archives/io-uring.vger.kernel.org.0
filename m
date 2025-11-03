Return-Path: <io-uring+bounces-10355-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 56F08C2E731
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 00:43:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF424189B346
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 23:43:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F5993203AA;
	Mon,  3 Nov 2025 23:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="pudkzmHB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A35831815E
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 23:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762213297; cv=none; b=ebIXpHzRcpYRwbKXQRL5+YXYXqaM9F64N2S7nGXqSwtiwH6MuhFCyTTKeogrH5h7ql/UmtQi9Ir+zPd9xUUK+NGAkPioAoXEzVl46quLAIZHLaP4rBe/SFBOPwj0hbnOnIwsF4r81jBfU4Q31uOIL9HQXZNhx/4636ZLhSecQIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762213297; c=relaxed/simple;
	bh=d6KYxwJSe+Hrozb4yTNX8Cgfsyd+WgyWztAHNMgXXok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYyWSJ87uxw2+11zjXvomrnn0Plpq56jQs/JWrlzyXx+V65U/16sLnfFDZfCxgp51VO6u9Xcn0rKSoV6WpAiihQ2ewAVbChstGyXASWt7WV8fgEjVd21UPwKkDosCTkhtgINsBScYpa7km7b79YGm82adQoFquBK1acaakkrUc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=pudkzmHB; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-3c9991e6ad1so3459965fac.0
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 15:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762213294; x=1762818094; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BF/J7v8J0/Dte4eU+0zQzKjzlMyWXCGE8k4QyKJoGkM=;
        b=pudkzmHBgzv/QakrOMp4qCzoQKeVw9mOCpGzWX1ey1UryX6BUY4RcbqZay1mkojY5l
         9DG6T8hOmDgKF7a+h06BwhFp4WjYtP05Aw4qmXFY6XXjoM8h6VkoBrRdt3G+M6JB8SzO
         /um20+BitkkgIVm55CypOq0XVtKUmshPpNcMTgKc0+V3q09T9/JmI15t65EBzLU+NwGr
         C4gD3wvtkwqyIZMSNwbyNxZwUAPNjeE7+j7EDFmVZ1UpKtB/0ehgP8uKI+dMqtZFEvod
         yVZjEyxSyPB1rwHW1oiJFsOSnSsbEzKi1wI/BEfEZOJx7JiIp16ALOfzwEZXBOgTr1CS
         u96g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762213294; x=1762818094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BF/J7v8J0/Dte4eU+0zQzKjzlMyWXCGE8k4QyKJoGkM=;
        b=SdOQ/GmFjJaB2UB2WW0QJTXTBmSsdwqZ0wWpKcpR+ora6noU9tbnGzFz5h6bjGtOZt
         K2MFzr7iW2mJLsMDmwkaicpTKJxidPK99eviz5GGEZqXW7L4VBWXdyuNH6xKxiKkUG4P
         CMhXgzlMSKguEh1xvBQ0AC3QXsHZADsyzBou5wHT79+XMmsleBMnGALUKYlSla9W3lno
         O96z+ymaSWcR6oGAu+PgNjmy9RA3+JXRM020B6W+pfgjXFrh2VNguQXi61KwvFD3xv2/
         57yOk8CHZqOQfcV9XNMREGZvA1j/ZOcqitUgVDl/Eh5aAwukCDloVg6BvPHGidjqHYzT
         b/hw==
X-Gm-Message-State: AOJu0YypGS7gr/hANNG0uUUggq3MU5aMJ3iJgEGbTChHzOU8UHLfz69b
	fhY0uRZFt5V1kMagLZ9VDNRjHFizeMc9ySvD3TeQC50s2iy6K1oJXlD2q6kxTy3ijFIIHgU09/1
	7+jij
X-Gm-Gg: ASbGncv+1uH6VLgunu+EVtHWzkZztHQyfbrMO6A5ikgw1i4Rad7/XfVcbPqNKuDExOf
	CiiO47iG2wmBA8jsn8KYB1rcuaoPYtHNyhI68UGsVlsG2fqQMf0IA2qIkVYqL9Wl7MhfWFYToJO
	NSGMweTKXbtJKIOFcZsOzBGAjm5QZFxLUJEpE7vXoJ25sFgrcxPsLr8qSfmdXINbSkDOLQIULgr
	J/PmAyhkQFRwlmo7+g5kPHebFNflq+vNTwYdpvh5yWBFwoyXouvfRCPL7VBqGGutrXloimt1HUa
	6StBSjrnocT6QsFhyQ4HRw0Xfpp8K04sGspqnOL0rJR+UVtv+biWctz1k6Zchr3KqEMfnrxZiwr
	MxjBNq9bpJreImvZOvssaK1hK58TBmUpRMfqW/4asR4bOp0F3Ki+dEJ0LnqcR914JKlZyJcRdxt
	fy6pYySQ+hnedU/+TBXJjiYtmwwsdE
X-Google-Smtp-Source: AGHT+IGpYF5YgLXou700S/8P5JP1PTW88U7Z59M4iZOCvtrEOdD7fzaKkvdy6sgcUFrV36iIxsOevg==
X-Received: by 2002:a05:6870:c4d:b0:3d1:c783:2107 with SMTP id 586e51a60fabf-3e03a6e4d6bmr644020fac.8.1762213294622;
        Mon, 03 Nov 2025 15:41:34 -0800 (PST)
Received: from localhost ([2a03:2880:12ff:3::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3dff6f625b7sm529407fac.15.2025.11.03.15.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 15:41:34 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v4 12/12] io_uring/zcrx: share an ifq between rings
Date: Mon,  3 Nov 2025 15:41:10 -0800
Message-ID: <20251103234110.127790-13-dw@davidwei.uk>
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
index 34bd32402902..0ead7f6b2094 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -1063,6 +1063,10 @@ struct io_uring_zcrx_area_reg {
 	__u64	__resv2[2];
 };
 
+enum io_uring_zcrx_ifq_reg_flags {
+	IORING_ZCRX_IFQ_REG_IMPORT	= 1,
+};
+
 /*
  * Argument for IORING_REGISTER_ZCRX_IFQ
  */
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 17ce49536f41..5a0af9dd6a8e 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -625,6 +625,11 @@ static int export_zcrx(struct io_ring_ctx *ctx, struct io_zcrx_ifq *ifq,
 	struct file *file;
 	int fd = -1;
 
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
+		return -EINVAL;
+	if (!(ctx->flags & (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED)))
+		return -EINVAL;
+
 	if (!mem_is_zero(&ctrl->resv, sizeof(ctrl->resv)))
 		return -EINVAL;
 	fd = get_unused_fd_flags(O_CLOEXEC);
@@ -646,6 +651,58 @@ static int export_zcrx(struct io_ring_ctx *ctx, struct io_zcrx_ifq *ifq,
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
 int io_zcrx_ctrl(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 {
 	struct zcrx_ctrl ctrl;
@@ -695,11 +752,13 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		return -EINVAL;
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
-	if (copy_from_user(&rd, u64_to_user_ptr(reg.region_ptr), sizeof(rd)))
-		return -EFAULT;
 	if (!mem_is_zero(&reg.__resv, sizeof(reg.__resv)) ||
 	    reg.__resv2 || reg.zcrx_id)
 		return -EINVAL;
+	if (reg.flags & IORING_ZCRX_IFQ_REG_IMPORT)
+		return import_zcrx(ctx, arg, &reg);
+	if (copy_from_user(&rd, u64_to_user_ptr(reg.region_ptr), sizeof(rd)))
+		return -EFAULT;
 	if (reg.if_rxq == -1 || !reg.rq_entries || reg.flags)
 		return -EINVAL;
 	if (reg.rq_entries > IO_RQ_MAX_ENTRIES) {
-- 
2.47.3


