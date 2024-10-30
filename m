Return-Path: <io-uring+bounces-4217-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F18579B6A24
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 18:06:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 82E9F1F222CB
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 17:06:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75201213150;
	Wed, 30 Oct 2024 16:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HzziUcGR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CF9217903
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 16:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730307366; cv=none; b=eGepnNAG8D4FdXL0dNAb2KYLHGh8udZF32709IsxmF11sylzH5adVgsCB1+J1WaRgXLoPqczi9lXX5ziFZz5rPDqZ1Fu/KHDOIDZG8+Bmr+Jv3Ihu32f4/YxlSb5i2KCs4uUjKLiko3HOt+Mv5nmGMVSp9n4t1aPqUQ+x7WbfOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730307366; c=relaxed/simple;
	bh=OM6XGvWvIT4znwOiWvt6RGkPUZDnayJ6RUCn6Wp0rvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sd4Cd+0G+0DWXxEn2iykERUi6nU4CrO5ZMgRJc+pTB2AYzCgXKjZFtMLtdUjqp+VfFcaQ0fZT/AK84DFDs3kEMNArAbqNMRuLfj6M07P0fLGEcYdVdg1GbTloR88Xx/cZ6SylI12TWdRTi+SvuhlX9u4KsCnHgNpukb/8j9UR4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HzziUcGR; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-83aa3ced341so259594239f.0
        for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 09:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730307362; x=1730912162; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r8oicw4JG1QlM3BuTkCfyvAy/EKiuoKsDBMw093ebqQ=;
        b=HzziUcGRgf9/m9pZTgDzbqFdmNPmkZ43OfOwAxV7oecRTHJuU+rxj8phWJClSHgHx7
         4mdMxA2bqhsq+PYIMLmo3vM7uYqjVUkDCapgLJCNh315cLrnKzkY0w50JgzgQgdSGozK
         JLoVwHjwOHYDA8CZu/uvcdH1xo02e6++RbZ9O++rh6S6nA+b93mAr00lPha4fT/qTTgt
         qMhR0+NvxWGHK+KQUT/Gxg8j1I756g0Hd0sBXbRg5+iy9QN8JefNL0eAZXwcyVa5wwFH
         efzzuEBpHW7AcST78pbXH9VRNi4Adgs74d9fKKbRswMvC2SLgyxyvOcOwE1BQ7MFs3ZG
         R7Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730307362; x=1730912162;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r8oicw4JG1QlM3BuTkCfyvAy/EKiuoKsDBMw093ebqQ=;
        b=r6lJnOypS/5VdTzSNi4OZkQ49W9A+G+cn6NWbHbGvEHRPOF8aWvUv1OY81SmBcWE3D
         3vKEVeZ7iV9+DqLaxSebPW4RoQ1YeAo09+CMlZ6RP4pg2rm/COM7qdN9BUpGUA/cCw01
         Qf2OgF6Qg3/hoHGtNWfQRfWKEGXBPq2PAtHqJ0LE6RsODvcJ/l2AL3CkR/KQNl15iHsX
         zQVPyrs/i1t1JTLsGyK6sku4w00tVnQX92+nt9pc2xG9ru4jzpFt0lnlHFQVf2vj3L+i
         AUfl914B+oxTmyqOpn12NOVK2/4qlz9/QNscV+NeHHl2yMRibg6+X//d8lCry8t0DVQN
         wjug==
X-Gm-Message-State: AOJu0YyKilV8dIl0ivkfl0xe+pN3Obm0qXR6QK4xMqN6KBZjYkUaxhb5
	m+kUFbwg9lePL8dHMLks5x2UrfF5PxUSThNtfQN44MBlcFwC8ir9pO6ED0RRMp2Y7DWfGSoFE2+
	eaSg=
X-Google-Smtp-Source: AGHT+IEhPViuRXPoSPJGuYWOWBfVLZsG1ySCxWaRN7rOSj+ZoyslBamofPTbtBQzAFQ4wXVx2JxFAg==
X-Received: by 2002:a05:6602:2d95:b0:832:40d0:902a with SMTP id ca18e2360f4ac-83b64fb5fbdmr31938239f.6.1730307362484;
        Wed, 30 Oct 2024 09:56:02 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc727505fdsm2980035173.120.2024.10.30.09.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 09:56:01 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/rsrc: allow cloning with node replacements
Date: Wed, 30 Oct 2024 10:54:15 -0600
Message-ID: <20241030165556.64918-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241030165556.64918-1-axboe@kernel.dk>
References: <20241030165556.64918-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently cloning a buffer table will fail if the destination already has
a table. But it should be possible to use it to replace existing elements.
Add a IORING_REGISTER_DST_REPLACE cloning flag, which if set, will allow
the destination to already having a buffer table. If that is the case,
then entries designated by offset + nr buffers will be replaced if they
already exist.

Note that it's allowed to use IORING_REGISTER_DST_REPLACE and not have
an existing table, in which case it'll work just like not having the
flag set and an empty table - it'll just assign the newly created table
for that case.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  3 ++-
 io_uring/rsrc.c               | 24 ++++++++++++++++++++----
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index cc8dbe78c126..ce58c4590de6 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -713,7 +713,8 @@ struct io_uring_clock_register {
 };
 
 enum {
-	IORING_REGISTER_SRC_REGISTERED = 1,
+	IORING_REGISTER_SRC_REGISTERED	= (1U << 0),
+	IORING_REGISTER_DST_REPLACE	= (1U << 1),
 };
 
 struct io_uring_clone_buffers {
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 4c149dc42fd7..9829c51105ed 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -990,9 +990,25 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 	/* Have a ref on the bufs now, drop src lock and re-grab our own lock */
 	mutex_unlock(&src_ctx->uring_lock);
 	mutex_lock(&ctx->uring_lock);
-	if (!ctx->buf_table.nr) {
+
+	/*
+	 * Not replacing, or replacing an empty table. Just install the
+	 * new table.
+	 */
+	if (!(arg->flags & IORING_REGISTER_DST_REPLACE) || !ctx->buf_table.nr) {
 		ctx->buf_table = data;
 		return 0;
+	} else if (arg->flags & IORING_REGISTER_DST_REPLACE) {
+		/* put nodes in overlapping spots, if any */
+		for (i = arg->src_off; i < arg->nr; i++) {
+			if (data.nodes[i] == rsrc_empty_node)
+				continue;
+			io_reset_rsrc_node(&ctx->buf_table, i);
+			ctx->buf_table.nodes[i] = data.nodes[i];
+			data.nodes[i] = NULL;
+		}
+		io_rsrc_data_free(&data);
+		return 0;
 	}
 
 	mutex_unlock(&ctx->uring_lock);
@@ -1026,12 +1042,12 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 	struct file *file;
 	int ret;
 
-	if (ctx->buf_table.nr)
-		return -EBUSY;
 	if (copy_from_user(&buf, arg, sizeof(buf)))
 		return -EFAULT;
-	if (buf.flags & ~IORING_REGISTER_SRC_REGISTERED)
+	if (buf.flags & ~(IORING_REGISTER_SRC_REGISTERED|IORING_REGISTER_DST_REPLACE))
 		return -EINVAL;
+	if (!(buf.flags & IORING_REGISTER_DST_REPLACE) && ctx->buf_table.nr)
+		return -EBUSY;
 	if (memchr_inv(buf.pad, 0, sizeof(buf.pad)))
 		return -EINVAL;
 
-- 
2.45.2


