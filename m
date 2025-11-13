Return-Path: <io-uring+bounces-10579-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 36D06C5702C
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 11:53:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F0A2F4EC617
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 10:48:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A72133CEA9;
	Thu, 13 Nov 2025 10:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b75MvMOy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F5E33DED3
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 10:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763030800; cv=none; b=UBHDgCaYCSknO3p/PIF4RF3a8R3l7rs92xKYhGOp6nZj/nwOmDykspHHTqDBEG8wjrVp0+CivaUhYLH/vle0DhWVzDss1kPxpi1AF6IhlSceFeES4tar8L8hLOQukbAcrRtajmFaLIrszeLsM2Qd6T6fVhQk50qRtxdF1oc6vqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763030800; c=relaxed/simple;
	bh=pdTcfUVqz8/YNRlOKt4xQAre0a3s1M7SzLnvi4cuuJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kiIvmm58NDYyAwVZi1WwC9Jj3SiSTBfhaCL2bSOobQqn+oZP9TpT2jrf8r/0tTFaipa9+D8LFy8wCK8r6JKrHAwikkFdfn14lr6s6tMzi6ofFTiTH4vI66nu7Mt2A/67Ok2wJ66+ibeprJbBE8tu4qazbID8/MpTCl/leZCp6dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b75MvMOy; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-477775d3728so6506475e9.2
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 02:46:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763030796; x=1763635596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nO2sFmYmHiQzFagsnEhJmZu5s7Jm25sXZW/8bBnTNsA=;
        b=b75MvMOy2KynwHP6b97fnlXx6C+CW8uXSYZzaZJh92JWTQI10Vc1YCWl+xGZrUIfVp
         GofuzLmOO7tslKYDXFq+sU0D5+6xSs1m1jmcVZJ9P3sg4KiiX6RYnF7+hXYnNTF3oZdI
         5+HTlT1W1qPW0dLeu1ojN6OzdWAm/fjPrS2XzFwEdG4UJmVKo1lpkMNSZaTCvQPT5vIQ
         wz3Ssp3A4+yXKmVohbZwAo09WFw6w5xt68bhy1xMCkDEF/w44RXDl8GxD6dJ5bxgJJn9
         SMnNinOe0riC77aQXi8izv39ZI9b21d7DRwPDoXJKd4iibCdDj94zW0ZPxFy9TvxzjqR
         bGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763030796; x=1763635596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nO2sFmYmHiQzFagsnEhJmZu5s7Jm25sXZW/8bBnTNsA=;
        b=u6y1btWClATgTQypkLnCeiphv/QMbGphtjKH82rizdyaaAOgkgxPuHE3PdlIDAVJYc
         TxQEczH4iCFvHaUKHCMyPSf99zU72vxarQcU/0yIyDMN7WV5XvXrRH5ZQPjNki+ga5hR
         kwDXhh+7smwW7Wti2nCU65mnk7pghxHDSA220ULhaO1Z0R5sRUuYhKV4FncYYNp4ngBi
         1/sV2At3FvIs+WmoOksPabDyRRn/wK59gdmBVCaWM7nBMeWhBM3nE+35t5e2qVgmuV5u
         UlHvxS8HA6UBcknLaoUAw73YPQnQdn+EGIGUHRD6iDYjM195lrgmF82hkOuTsnJZpnE0
         aFSw==
X-Gm-Message-State: AOJu0YyDGDgNZCStYI9j/0nEQ+n63vsHnrQbu9xHOod1zxjwHoI/dA09
	XaiIoaAlBd15TC84hIZv1cZIxhEEkmKkQd1BBx5asldOguPSi9llGYST5C7oBw==
X-Gm-Gg: ASbGncsKWCAtJbvQW0jsVerIQL67wL+YBa7cQtedBFL8tqzM+9lGxPkCHrZhY5G/6o8
	7NF6cREiOh4242MWjKboyciD+IzZxmoXXqyTWbhLl/B0VKryijo6EZwdmJKDyAsHYhCsm2xfMev
	wJiDtQ735zU5mOG3LCMvZZwP7IFH9PqbxRVXG76pnHlrj3qt03Sub+AzBVsDnUvVJVxpWJQ+LON
	r+ZqUgO1dHOV48bktY4uai/yC38BRCXI+AhFjN9iBcq339RyJRNTwM/cxm1wVchLlxptTgrYAd3
	8wokiMmmRkiNGCSKjOxhB7SR5yjF4U88qEOJnh8q7hqX/jxT97JJZB9kbiK5rYHkX1abuksj7TC
	n2Sn6debkW0BOB4JFNKTenO7Yze5E16iV/ZyW7Eb8MaaR9aNO570DXEYk0I8=
X-Google-Smtp-Source: AGHT+IFFAzFN0GJZGL0Rld9aaUBzKphb/r9JpvGp4c2KnhaTYn9Fn5SOvm8P3Q9OeCH9kJ5Z1CHHrA==
X-Received: by 2002:a05:600c:1c08:b0:475:df91:de03 with SMTP id 5b1f17b1804b1-477870b67d1mr61038745e9.39.1763030796422;
        Thu, 13 Nov 2025 02:46:36 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e7b12asm3135210f8f.10.2025.11.13.02.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 02:46:35 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH 08/10] io_uring/zcrx: export zcrx via a file
Date: Thu, 13 Nov 2025 10:46:16 +0000
Message-ID: <39e8e26c8c234fbe2c6a0909be763424836ea8c9.1763029704.git.asml.silence@gmail.com>
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

Add an option to wrap a zcrx instance into a file and expose it to the
user space. Currently, users can't do anything meaningful with the file,
but it'll be used in a next patch to import it into another io_uring
instance. It's implemented as a new op called ZCRX_CTRL_EXPORT for the
IORING_REGISTER_ZCRX_CTRL registration opcode.

Signed-off-by: David Wei <dw@davidwei.uk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h | 11 +++++-
 io_uring/zcrx.c               | 68 +++++++++++++++++++++++++++++++----
 2 files changed, 72 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7e20a555b697..a4acb4a3c4e9 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -1087,6 +1087,7 @@ struct io_uring_zcrx_ifq_reg {
 
 enum zcrx_ctrl_op {
 	ZCRX_CTRL_FLUSH_RQ,
+	ZCRX_CTRL_EXPORT,
 
 	__ZCRX_CTRL_LAST,
 };
@@ -1095,12 +1096,20 @@ struct zcrx_ctrl_flush_rq {
 	__u64		__resv[6];
 };
 
+struct zcrx_ctrl_export {
+	__u32		zcrx_fd;
+	__u32 		__resv1[11];
+};
+
 struct zcrx_ctrl {
 	__u32	zcrx_id;
 	__u32	op; /* see enum zcrx_ctrl_op */
 	__u64	__resv[2];
 
-	struct zcrx_ctrl_flush_rq	zc_flush;
+	union {
+		struct zcrx_ctrl_export		zc_export;
+		struct zcrx_ctrl_flush_rq	zc_flush;
+	};
 };
 
 #ifdef __cplusplus
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index e60c5c00a611..815992aff246 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -8,6 +8,7 @@
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/skbuff_ref.h>
+#include <linux/anon_inodes.h>
 
 #include <net/page_pool/helpers.h>
 #include <net/page_pool/memory_provider.h>
@@ -586,6 +587,15 @@ static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
 	}
 }
 
+static void zcrx_unregister(struct io_zcrx_ifq *ifq)
+{
+	if (refcount_dec_and_test(&ifq->user_refs)) {
+		io_close_queue(ifq);
+		io_zcrx_scrub(ifq);
+	}
+	io_put_zcrx_ifq(ifq);
+}
+
 struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
 					    unsigned int id)
 {
@@ -596,6 +606,55 @@ struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
 	return ifq ? &ifq->region : NULL;
 }
 
+static int zcrx_box_release(struct inode *inode, struct file *file)
+{
+	struct io_zcrx_ifq *ifq = file->private_data;
+
+	if (WARN_ON_ONCE(!ifq))
+		return -EFAULT;
+	zcrx_unregister(ifq);
+	return 0;
+}
+
+static const struct file_operations zcrx_box_fops = {
+	.owner		= THIS_MODULE,
+	.release	= zcrx_box_release,
+};
+
+static int zcrx_export(struct io_ring_ctx *ctx, struct io_zcrx_ifq *ifq,
+		       struct zcrx_ctrl *ctrl, void __user *arg)
+{
+	struct zcrx_ctrl_export *ce = &ctrl->zc_export;
+	struct file *file;
+	int fd = -1;
+
+	if (!mem_is_zero(ce, sizeof(*ce)))
+		return -EINVAL;
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
+	ce->zcrx_fd = fd;
+	if (copy_to_user(arg, ctrl, sizeof(*ctrl))) {
+		put_unused_fd(fd);
+		return -EFAULT;
+	}
+
+	refcount_inc(&ifq->refs);
+	refcount_inc(&ifq->user_refs);
+
+	file = anon_inode_create_getfile("[zcrx]", &zcrx_box_fops,
+					 ifq, O_CLOEXEC, NULL);
+	if (IS_ERR(file)) {
+		put_unused_fd(fd);
+		zcrx_unregister(ifq);
+		return PTR_ERR(file);
+	}
+
+	fd_install(fd, file);
+	return 0;
+}
+
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zcrx_ifq_reg __user *arg)
 {
@@ -742,12 +801,7 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 		}
 		if (!ifq)
 			break;
-
-		if (refcount_dec_and_test(&ifq->user_refs)) {
-			io_close_queue(ifq);
-			io_zcrx_scrub(ifq);
-		}
-		io_put_zcrx_ifq(ifq);
+		zcrx_unregister(ifq);
 	}
 
 	xa_destroy(&ctx->zcrx_ctxs);
@@ -1028,6 +1082,8 @@ int io_zcrx_ctrl(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 	switch (ctrl.op) {
 	case ZCRX_CTRL_FLUSH_RQ:
 		return zcrx_flush_rq(ctx, zcrx, &ctrl);
+	case ZCRX_CTRL_EXPORT:
+		return zcrx_export(ctx, zcrx, &ctrl, arg);
 	}
 
 	return -EOPNOTSUPP;
-- 
2.49.0


