Return-Path: <io-uring+bounces-10322-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 214A9C2C453
	for <lists+io-uring@lfdr.de>; Mon, 03 Nov 2025 14:55:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 87AF24E2338
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 13:53:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DC0827510B;
	Mon,  3 Nov 2025 13:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AnCDSYu5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48A1274B2B
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 13:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762178011; cv=none; b=iKPEJElx4Mj7tCiXzMo2RFeEFfDZxcPLOGFgXsavk9N9rt4hk4gCYfGxc3TyPVOYvy4/UyTTJBQH/R9Znozll4OFhzLFEEKL9ZSEvdka7G3q84XTkx/E9PwlPuWlof5BZ0EEtinlGHN6qaV47yRqASVobR6TxA5O8V4iOP2hZnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762178011; c=relaxed/simple;
	bh=If/WlxBsDuFL5hNjP4bfbYgHfiuGv1csCL0N24GLKM0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rJAZER1zT8zf4iLkb5lc+Sk3WCdoLlQpfP3N855PpItWM8FsFVbH0pgE8kvtaq7t9jJDmAwGERosIh2+hTYyprRGK3exWfROrLG2CV/9+cvFXvuKBar64gC2s0yrdes45Bqdgo34bQTN9yg34N9p4Y51ClJYGoCczAdlz6kO1HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AnCDSYu5; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-429b895458cso2899650f8f.1
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 05:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762178007; x=1762782807; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ph/r87eDxJ9CZgf7lhVHnKUdE/7WOULfC+/FGQDSVNg=;
        b=AnCDSYu5cji0XBoX5d0UuhEIavZ1sU32iLymYZyoPJ5j3b4FgKKkN5NulXAEN8ohAj
         Ms5LwkJCF6HfNqDCM08ByKp7TOUDy69va5hkXgb/IdOoGKepcweAVvMDOtWyaCWmhvBo
         IJaCLzRz38QRwdi/cgphrTVfsi/uN1/kNj6tlav2Uing1A/TcsypGh5Jahii78rHU0JR
         CeYjA2F/Y5V41xJQ9np81s8t/lzZlg+lsTHVjijREX0fKL0vtsMkLCXsVdh4SnOnDCOg
         Sghj8vN/qftB2vrnxried9iAVoqFGwwWbMcYpwLZdqfkVQOUwoub5yAmnccO0gDk92V8
         LaGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762178007; x=1762782807;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ph/r87eDxJ9CZgf7lhVHnKUdE/7WOULfC+/FGQDSVNg=;
        b=XIpVyYAexKkKa5Tvor5L9TiCPJ+rx6h/FKKrkUTUN6MALTLEKL/fC4vygchDwyUjfP
         aYMv763Q9FNe1PemMWi0p8xJ2jf8+idNc9qKCDjiIRzHgficbrEc3jy+N1vyzL70yiCj
         qPIjdXqkCBVifHHam+Ls8SuCj560MFOkfcuYsiXzEJS29rAg29f+cfSoI+jLmYqebX8Q
         12f/H5ech4dO+xb1+1KRF+3vHZiINAfOZ6+rkLx2nKIlcofKjMLWe1SN4pzGnV6OCPT6
         Ag6uuB8thKyOBQfprtbIxq/WbdqX03tnrnhoxfpugRuK3mt2Iu72PnigubYv9ZsaOmHJ
         WzKQ==
X-Gm-Message-State: AOJu0Yyjr6AR01Sy+DSGzrK42826wgWWkr8McIcwRJLWgu7ZAGAlcBR7
	dCMYkJIpAgVanDOARlXsPRz2WJbsBZmgdyKqXwo7bVhMolyf1hxLnNbL2hyjKg==
X-Gm-Gg: ASbGnct5IwbRtzu1fcUgUPrrV2nl4ySKl1qorxi6Pg6fuu2MjEy34FkIBLUZR+A59BQ
	KhzJB8jDhuuI9G8JMm9BgOTVNoXHNXY/div6z8VSvQ/1aPcyI9niLU2UfPKDaCw9n7TPNyWsFUL
	i7RECATamnVYMqf4OzS3EhSK+nNgjQjefTwWxLSor+gwefqY57MFnYL5lzkDw8Nq6kTdpif1y22
	gBhIbvqqz4CcGj3IY7AGDhfGs7gVUu/WW5q2HJanbDgrVuvU5VcG8iggZGsdcJh890emOgPsIp2
	P69fAKGs3qzM7SiS0FtMS8I4BT2O+lDl+y7ERKuPZtIuUCSQBneKFP4J0wh3iCtDFthC6kfa6PT
	y7RYtuBzMqDFxFuC6tYKcVLOKv4KDwQaYj7ouFMvohIr8yhSIlJF2hqeq0bGcKWlLBn0pCQ==
X-Google-Smtp-Source: AGHT+IGxav6G3GQSLa6XlbNAkTHjBQxacOkWRjGknmhUtmrXyBmoYnU0Yyuk2yMYBVSXNwz+J1ZDbQ==
X-Received: by 2002:a05:6000:430c:b0:429:d565:d7e0 with SMTP id ffacd0b85a97d-429d565db67mr2094852f8f.45.1762178007507;
        Mon, 03 Nov 2025 05:53:27 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:21ea])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c13e1c9esm21376388f8f.22.2025.11.03.05.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 05:53:26 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH for-6.18] io_uring/zcrx: remove sync refill uapi
Date: Mon,  3 Nov 2025 13:53:13 +0000
Message-ID: <60717dd76d7c38fe750c288a831e5d3a7379a70c.1762164871.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a better way to handle the problem IORING_REGISTER_ZCRX_REFILL
solves. The uapi can also be slightly adjusted to accommodate future
extensions. Remove the feature for now, it'll be reworked for the next
release.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h | 12 -------
 io_uring/register.c           |  3 --
 io_uring/zcrx.c               | 68 -----------------------------------
 io_uring/zcrx.h               |  7 ----
 4 files changed, 90 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 263bed13473e..b7c8dad26690 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -689,9 +689,6 @@ enum io_uring_register_op {
 	/* query various aspects of io_uring, see linux/io_uring/query.h */
 	IORING_REGISTER_QUERY			= 35,
 
-	/* return zcrx buffers back into circulation */
-	IORING_REGISTER_ZCRX_REFILL		= 36,
-
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -1073,15 +1070,6 @@ struct io_uring_zcrx_ifq_reg {
 	__u64	__resv[3];
 };
 
-struct io_uring_zcrx_sync_refill {
-	__u32		zcrx_id;
-	/* the number of entries to return */
-	__u32		nr_entries;
-	/* pointer to an array of struct io_uring_zcrx_rqe */
-	__u64		rqes;
-	__u64		__resv[2];
-};
-
 #ifdef __cplusplus
 }
 #endif
diff --git a/io_uring/register.c b/io_uring/register.c
index 2e4717f1357c..d189b266b8cc 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -827,9 +827,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	case IORING_REGISTER_QUERY:
 		ret = io_query(ctx, arg, nr_args);
 		break;
-	case IORING_REGISTER_ZCRX_REFILL:
-		ret = io_zcrx_return_bufs(ctx, arg, nr_args);
-		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index a816f5902091..b1b723222cdb 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -928,74 +928,6 @@ static const struct memory_provider_ops io_uring_pp_zc_ops = {
 	.uninstall		= io_pp_uninstall,
 };
 
-#define IO_ZCRX_MAX_SYS_REFILL_BUFS		(1 << 16)
-#define IO_ZCRX_SYS_REFILL_BATCH		32
-
-static void io_return_buffers(struct io_zcrx_ifq *ifq,
-			      struct io_uring_zcrx_rqe *rqes, unsigned nr)
-{
-	int i;
-
-	for (i = 0; i < nr; i++) {
-		struct net_iov *niov;
-		netmem_ref netmem;
-
-		if (!io_parse_rqe(&rqes[i], ifq, &niov))
-			continue;
-
-		scoped_guard(spinlock_bh, &ifq->rq_lock) {
-			if (!io_zcrx_put_niov_uref(niov))
-				continue;
-		}
-
-		netmem = net_iov_to_netmem(niov);
-		if (!page_pool_unref_and_test(netmem))
-			continue;
-		io_zcrx_return_niov(niov);
-	}
-}
-
-int io_zcrx_return_bufs(struct io_ring_ctx *ctx,
-			void __user *arg, unsigned nr_arg)
-{
-	struct io_uring_zcrx_rqe rqes[IO_ZCRX_SYS_REFILL_BATCH];
-	struct io_uring_zcrx_rqe __user *user_rqes;
-	struct io_uring_zcrx_sync_refill zr;
-	struct io_zcrx_ifq *ifq;
-	unsigned nr, i;
-
-	if (nr_arg)
-		return -EINVAL;
-	if (copy_from_user(&zr, arg, sizeof(zr)))
-		return -EFAULT;
-	if (!zr.nr_entries || zr.nr_entries > IO_ZCRX_MAX_SYS_REFILL_BUFS)
-		return -EINVAL;
-	if (!mem_is_zero(&zr.__resv, sizeof(zr.__resv)))
-		return -EINVAL;
-
-	ifq = xa_load(&ctx->zcrx_ctxs, zr.zcrx_id);
-	if (!ifq)
-		return -EINVAL;
-	nr = zr.nr_entries;
-	user_rqes = u64_to_user_ptr(zr.rqes);
-
-	for (i = 0; i < nr;) {
-		unsigned batch = min(nr - i, IO_ZCRX_SYS_REFILL_BATCH);
-		size_t size = batch * sizeof(rqes[0]);
-
-		if (copy_from_user(rqes, user_rqes + i, size))
-			return i ? i : -EFAULT;
-		io_return_buffers(ifq, rqes, batch);
-
-		i += batch;
-
-		if (fatal_signal_pending(current))
-			return i;
-		cond_resched();
-	}
-	return nr;
-}
-
 static bool io_zcrx_queue_cqe(struct io_kiocb *req, struct net_iov *niov,
 			      struct io_zcrx_ifq *ifq, int off, int len)
 {
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 33ef61503092..a48871b5adad 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -63,8 +63,6 @@ struct io_zcrx_ifq {
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
-int io_zcrx_return_bufs(struct io_ring_ctx *ctx,
-			void __user *arg, unsigned nr_arg);
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			 struct io_uring_zcrx_ifq_reg __user *arg);
 void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx);
@@ -97,11 +95,6 @@ static inline struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ct
 {
 	return NULL;
 }
-static inline int io_zcrx_return_bufs(struct io_ring_ctx *ctx,
-				      void __user *arg, unsigned nr_arg)
-{
-	return -EOPNOTSUPP;
-}
 #endif
 
 int io_recvzc(struct io_kiocb *req, unsigned int issue_flags);
-- 
2.49.0


