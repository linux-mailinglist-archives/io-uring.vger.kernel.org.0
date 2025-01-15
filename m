Return-Path: <io-uring+bounces-5894-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A5762A12C8A
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 21:26:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D08A91888478
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 20:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16E4F1D9324;
	Wed, 15 Jan 2025 20:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hOzzcs/Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6F51D90A9
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 20:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736972783; cv=none; b=O8C1G+qcQDIaiKSbp/HuyfHzBrHT3Bketyw80SE/jD1Pr15We2cmwGEOhNE9J6M2ASnkligMrKJ7IUptSmPa67b2BruWV2+pB35SMOOkw/vNo7AwEjiZni3cfv2HVtWaXpj5ChAUHxXnGmA7mlY/lkkYuwK9b4c5wuLsoSiXBu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736972783; c=relaxed/simple;
	bh=Wbj8wHc9hI+sc5M7Z80jkx1gKa1NoydY6mW7SjRm1PM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=XoleguvCJimkekQnwe/btdselY7Oi7zlWDsu1SBQrlOm3eR17EVUoKV7F1o7G+jbJiy/UXGlK7OiivQN1hC73YGEpweN6qIHGJrHvXcE61XGNUPdiOM0y0/2i9jiDn1HjrU7v9nviOVZuE5M0Nj64XtxkWSpNiOCNdzUx5BYUj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hOzzcs/Y; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4368a290e0dso10985e9.1
        for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 12:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736972778; x=1737577578; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ky6sqF/DxV3HW/KuX+jGIKyXzTOtCRQ/H4Z1APLNpdQ=;
        b=hOzzcs/YqARgINOqDBF+SuVzTsthYpZyunZaQ6qB/EjCb06gkTB6Bh4HddKAd+4ifh
         66fod9i77PV7caAotWwpuaCENsboXVxX5CRDPEswLZp6j+sGGRlxAM2DUFVvAgyUB34L
         VUr9eJ6AdZOT3/q6GgZ4A2I/2Pt9GlATOABuhW3eI5vaYPWE40N9BOSSpiVWkstA7rId
         7uLgXZ1l5vcSPjvgQFYZ/fWOXO+nHM6wpo1UmCHzdRiSSDpHDvFuwL0md/BT9SkqtboV
         iy+tBBltGjUGZJ2nm/x05lrOrVkV6PtXpWyM2BppWsKm7jQ5bvnEFxTmQh51rQFefPiK
         PFmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736972778; x=1737577578;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ky6sqF/DxV3HW/KuX+jGIKyXzTOtCRQ/H4Z1APLNpdQ=;
        b=QWLJEokEKr0tFWqjzZeN+WuJZhHANlgNT10OWKP61QKjgx3V0ePW+Toy9eaokEBYLH
         XdgB6KtI/2tA1kO6Ct49Y9eolfr4MwOLDrQNWlJUhfzez46B54A1qzAKJCvoOW/Q3A7k
         fZEZ2WZhsJXZ2jr3s9iV0wDfjtbh54TTt0PysC0CKoLuhceBwzC4w2mf8j/kTvVFp2a4
         9IdOP1vVgCVbytmbef9l1slgb3uU5aScGN1w0MtUEJJYiaB8+blQ2qYnqu9r/zxg8WdX
         iyhaw1oHAqJ9wQdYoVBoEBIvSt0slUw9gsjjGJQqAwJEKgDtVW16bzpucpFbxmFHPjwp
         itNA==
X-Gm-Message-State: AOJu0Yx6FTUL4iNOoKhKIJ4qfIS0/lFxwSuS8aODMQeFvcdiQ+1j6Hy3
	dJy88oAjFDTQQM4WATsj3mFDWghfwhb74lMW11Z/S/TG0UXMK0hArcMmfjLauA==
X-Gm-Gg: ASbGncsZnTo93uahIugy/SrWXb91D838K1xxTroayMp18acDGmsmXjzPwO6MVfpgNOl
	pr2ljfeyU25XBGNP1hbxYuFJQfevnZKlYQPNu1bIaocizi1E7WKK8/XgimkqW4jvYk4XdMYrkp3
	88rsEvn4jgrVdxp7eKt0FgtkSGfxDkbTPJcZ2SXTDsfjkqGMRKqy7je85CPLkOD2Q5DrBVCjzJO
	Cb2GkgFQ683Hmu7+ZHKXsK88xGA1fLDDy2WzNcOFW6VOA==
X-Google-Smtp-Source: AGHT+IEMPaeI5PrSe2O9UFoYl0YyTRUodMrljDEYcPZZyFnTQLxQNA0YUBLH+y4f9UoINBr6AvQBOQ==
X-Received: by 2002:a05:600c:19c9:b0:42c:9e35:cde6 with SMTP id 5b1f17b1804b1-4388b2ec3a2mr165965e9.2.1736972777649;
        Wed, 15 Jan 2025 12:26:17 -0800 (PST)
Received: from localhost ([2a00:79e0:9d:4:7175:4098:36d3:bfd7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c74accc3sm35317545e9.14.2025.01.15.12.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 12:26:17 -0800 (PST)
From: Jann Horn <jannh@google.com>
Date: Wed, 15 Jan 2025 21:26:03 +0100
Subject: [PATCH v2] io_uring/rsrc: Simplify buffer cloning by locking both
 rings
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250115-uring-clone-refactor-v2-1-7289ba50776d@google.com>
X-B4-Tracking: v=1; b=H4sIANoZiGcC/4WNSw7CIBCGr9LM2jEMCTa68h6mixZGOkkFA5VoG
 u4u9gIuv/+5QeYknOHSbZC4SJYYGuhDB3Yeg2cU1xi00kYRGXwlCR7tEgNj4vto15hQnZyz7Bx
 PSkGrPpsj7332NjSeJbfYZ38p9FP/DBZCwkm7syHT91rR1cfoFz7a+ICh1voFYi19CbkAAAA=
X-Change-ID: 20250115-uring-clone-refactor-06ddceddeb00
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jann Horn <jannh@google.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1736972773; l=5934;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=Wbj8wHc9hI+sc5M7Z80jkx1gKa1NoydY6mW7SjRm1PM=;
 b=hLPL5px54/4jPG4P/qQJvPSY2WunB5VTCui3wPThbJE7Ac8zGEQY8rw1g8Pt91am+H4Ffr10+
 np8xN99ZQ8wCZLMfnUI4lRi/ILRMr8SDvmMXhVhQRzwqkLgyhnrIT7H
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=

The locking in the buffer cloning code is somewhat complex because it goes
back and forth between locking the source ring and the destination ring.

Make it easier to reason about by locking both rings at the same time.
To avoid ABBA deadlocks, lock the rings in ascending kernel address order,
just like in lock_two_nondirectories().

Signed-off-by: Jann Horn <jannh@google.com>
---
(patch is based on top of Jens' for-next tree)
---
Changes in v2:
- fold in suggested changes from Jens (https://lore.kernel.org/r/2439336d-b6ae-4d08-a1e8-2372fc6df383@kernel.dk)
- Link to v1: https://lore.kernel.org/r/20250115-uring-clone-refactor-v1-1-b2d951577201@google.com
---
 io_uring/rsrc.c | 73 +++++++++++++++++++++++++++++++--------------------------
 1 file changed, 40 insertions(+), 33 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index e32ac58533914706c8e031754432ed634d7c0354..a1c7c8db55455e6db862a17ed611f3d6ce885b3d 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -921,6 +921,16 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 	return 0;
 }
 
+/* Lock two rings at once. The rings must be different! */
+static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2)
+{
+	if (ctx1 > ctx2)
+		swap(ctx1, ctx2);
+	mutex_lock(&ctx1->uring_lock);
+	mutex_lock_nested(&ctx2->uring_lock, SINGLE_DEPTH_NESTING);
+}
+
+/* Both rings are locked by the caller. */
 static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx,
 			    struct io_uring_clone_buffers *arg)
 {
@@ -928,6 +938,9 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 	int i, ret, off, nr;
 	unsigned int nbufs;
 
+	lockdep_assert_held(&ctx->uring_lock);
+	lockdep_assert_held(&src_ctx->uring_lock);
+
 	/*
 	 * Accounting state is shared between the two rings; that only works if
 	 * both rings are accounted towards the same counters.
@@ -942,7 +955,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 	if (ctx->buf_table.nr && !(arg->flags & IORING_REGISTER_DST_REPLACE))
 		return -EBUSY;
 
-	nbufs = READ_ONCE(src_ctx->buf_table.nr);
+	nbufs = src_ctx->buf_table.nr;
 	if (!arg->nr)
 		arg->nr = nbufs;
 	else if (arg->nr > nbufs)
@@ -966,27 +979,20 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		}
 	}
 
-	/*
-	 * Drop our own lock here. We'll setup the data we need and reference
-	 * the source buffers, then re-grab, check, and assign at the end.
-	 */
-	mutex_unlock(&ctx->uring_lock);
-
-	mutex_lock(&src_ctx->uring_lock);
 	ret = -ENXIO;
 	nbufs = src_ctx->buf_table.nr;
 	if (!nbufs)
-		goto out_unlock;
+		goto out_free;
 	ret = -EINVAL;
 	if (!arg->nr)
 		arg->nr = nbufs;
 	else if (arg->nr > nbufs)
-		goto out_unlock;
+		goto out_free;
 	ret = -EOVERFLOW;
 	if (check_add_overflow(arg->nr, arg->src_off, &off))
-		goto out_unlock;
+		goto out_free;
 	if (off > nbufs)
-		goto out_unlock;
+		goto out_free;
 
 	off = arg->dst_off;
 	i = arg->src_off;
@@ -1001,7 +1007,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 			dst_node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 			if (!dst_node) {
 				ret = -ENOMEM;
-				goto out_unlock;
+				goto out_free;
 			}
 
 			refcount_inc(&src_node->buf->refs);
@@ -1011,10 +1017,6 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		i++;
 	}
 
-	/* Have a ref on the bufs now, drop src lock and re-grab our own lock */
-	mutex_unlock(&src_ctx->uring_lock);
-	mutex_lock(&ctx->uring_lock);
-
 	/*
 	 * If asked for replace, put the old table. data->nodes[] holds both
 	 * old and new nodes at this point.
@@ -1023,24 +1025,17 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		io_rsrc_data_free(ctx, &ctx->buf_table);
 
 	/*
-	 * ctx->buf_table should be empty now - either the contents are being
-	 * replaced and we just freed the table, or someone raced setting up
-	 * a buffer table while the clone was happening. If not empty, fall
-	 * through to failure handling.
+	 * ctx->buf_table must be empty now - either the contents are being
+	 * replaced and we just freed the table, or the contents are being
+	 * copied to a ring that does not have buffers yet (checked at function
+	 * entry).
 	 */
-	if (!ctx->buf_table.nr) {
-		ctx->buf_table = data;
-		return 0;
-	}
+	WARN_ON_ONCE(ctx->buf_table.nr);
+	ctx->buf_table = data;
+	return 0;
 
-	mutex_unlock(&ctx->uring_lock);
-	mutex_lock(&src_ctx->uring_lock);
-	/* someone raced setting up buffers, dump ours */
-	ret = -EBUSY;
-out_unlock:
+out_free:
 	io_rsrc_data_free(ctx, &data);
-	mutex_unlock(&src_ctx->uring_lock);
-	mutex_lock(&ctx->uring_lock);
 	return ret;
 }
 
@@ -1054,6 +1049,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 {
 	struct io_uring_clone_buffers buf;
+	struct io_ring_ctx *src_ctx;
 	bool registered_src;
 	struct file *file;
 	int ret;
@@ -1071,7 +1067,18 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 	file = io_uring_register_get_file(buf.src_fd, registered_src);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
-	ret = io_clone_buffers(ctx, file->private_data, &buf);
+
+	src_ctx = file->private_data;
+	if (src_ctx != ctx) {
+		mutex_unlock(&ctx->uring_lock);
+		lock_two_rings(ctx, src_ctx);
+	}
+
+	ret = io_clone_buffers(ctx, src_ctx, &buf);
+
+	if (src_ctx != ctx)
+		mutex_unlock(&src_ctx->uring_lock);
+
 	if (!registered_src)
 		fput(file);
 	return ret;

---
base-commit: 1ac3ba2b3cc41645a30e49f93d3e09bd05e6d2c7
change-id: 20250115-uring-clone-refactor-06ddceddeb00

-- 
Jann Horn <jannh@google.com>


