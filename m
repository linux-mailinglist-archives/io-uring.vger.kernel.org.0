Return-Path: <io-uring+bounces-9012-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AE66B29597
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:43:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED98020263E
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:43:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93F7F21767C;
	Sun, 17 Aug 2025 22:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GwdZfZU3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22D812DDA1
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470634; cv=none; b=c86yWGBZM+avyWMdTRQwqyqqNLFDh7u+4cJSSjfYn4pMC4nPHo/iiM/uGQC5yDwqBvmxu1nVH2JWJNglV4kxAvGifUBqOyDe8OfQ+bbSQOyoL1gJKvzrTjeD9KHmTIMpHU86wgZ8umLRqx7rcWDZvuCQKGiqbcxrGJ5EELSgy5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470634; c=relaxed/simple;
	bh=vDtEwG2j8dsb7ehLz3sFxngv/flgNpAYXfTcA1IYsgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrRUJOaR2TimLtMy318MA+6Wg6PU1vfCsbfog629asIRmw8AxH/QwpYWs4IFsHyfy7sYipLXaPBa7Eo2XI6Ngz/hb8o9JHwci6+o4g9nqr0/R/AukajNt1i1YQ0L2W1LpeGGSosRkVeqtgBthoCNsTi4JbD6n5SPtT0oAPZtuus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GwdZfZU3; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45a1b0b42d5so23858325e9.2
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470631; x=1756075431; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R9VagiSYqvoi2bCubfdEBu666PF45sWyx/zSLPAbuKo=;
        b=GwdZfZU3muqDqeKA9CdeB0FXDb3kZ5wJSqhieQdLwyspAiQSY4TMnDVmbdcltmH1yv
         JWQdZzgCDpZ8BWoDDJgkohdvMEwe0FD6GQPoTxMxELJrCOLJkXSMXO5c/FWFmD4i3EaA
         aLXozvNsNsAQXW+J9yKEa5O9FoqDdbzxR+dI/JuNlCohH3NgFMNfxDc9tQt9j8VriNcj
         iVGHjVVFKA8m3+ayJFTOkQPhq1AcuHpNqnr+yme1NnaEeMJPDaGUl1ZQpcI8OEWhz3Mo
         /acZnQydd0RWQJsW4WbGogIWxn9XejIxOcYkdhErdIGasHy+uOGD2uzjstfEpgtny+oO
         WkKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470631; x=1756075431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R9VagiSYqvoi2bCubfdEBu666PF45sWyx/zSLPAbuKo=;
        b=xSVJkAVG6l4R65pooDS0h2+ltzp3FcawM9PapIXtkwe/vY5lrblnkqcVpCFnDSd40j
         xbIfGCHtVARuxZal64C2eBNZeBNgZV4fqtILt4yFA/mETvgM1InPgieENvaqzcePyq2d
         Hv2luV6l0IlVZ/B6j4dKX0N51sbC/6G3Ov+xdYsQm6WoOLGjaD9Xoteoe9EQAkFCj1YQ
         K77elXmYf4DxKNI2m6WIGjKBJQUpRrqDH+zPYXb/s42Wr4WBC7nthr7M9eCtGcnu0gaI
         kqS/kT5tA+GKlfFDc8JcM/zjE8v2APm1IoR4qDsT9wvjS5YzwcoVZaJO/78rLJ6kkCsg
         I/vQ==
X-Gm-Message-State: AOJu0Ywaqz3gSRso9kzdmeBhAloSqVUODx397nA5jomtwSgzBuh4kBt+
	mR8tVyVE9x8cYxXd5oCdgoFaM2efAJiDFZ33wlzfTfkFF383tieO4oSQr8qa5A==
X-Gm-Gg: ASbGncskmLa+QCsnd/QuYZvAXtad8djHGFwCY+hJhFXeVpuHR3u6ITDauNS7GPkbm4Z
	GZFyqmYB2EtQ/cAssDhSft7zjy9ftv+rWxFBRSUrpUvk8ByIgVnjka/dyvPw2z0h5Mdhu4Q17jJ
	jziMmY7T6ht976ddJnTyPlyleNxXSRllzdxnksaprCB6PC1g10ihsGTqJ2T4KJynjzFM9TDQ310
	dZrkvhiyv1uHAjGdfo0Vdx0IqYmWQPMSXZo2KipXno+z8ZYBJCTKJRMNmFDmhd3b1yIjjI6adZi
	21MmPyhhdZzdefUFWqfTGP6SoVQy+05EQxEF43MsW/Q9zuJCpBFbhKf/gxl6U593JWNZp0mz4mo
	QNmN4AjgkDoZWm9A0coFxtoSr0yXff7aiNg==
X-Google-Smtp-Source: AGHT+IFi6QhcK/1ozkZ4CQSCMgq+JFdcQCge7R5RIqpUV5sypknNinJZk4vAjnMKotEFFoAaOOj8kA==
X-Received: by 2002:a05:600c:1c81:b0:459:d3ce:2cbd with SMTP id 5b1f17b1804b1-45a21803fb3mr71087955e9.13.1755470630562;
        Sun, 17 Aug 2025 15:43:50 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a2231a67asm104759135e9.11.2025.08.17.15.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:43:49 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 2/2] io_uring/zcrx: allow synchronous buffer return
Date: Sun, 17 Aug 2025 23:44:58 +0100
Message-ID: <3f915dbb730c2a8bdaccfb83f1208ed931a998be.1755468077.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755468077.git.asml.silence@gmail.com>
References: <cover.1755468077.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Returning buffers via a ring is performant and convenient, but it
becomes a problem when/if the user misconfigured the ring size and it
becomes full. Add a synchronous way to return buffers back to the page
pool via a new register opcode. It's supposed to be a reliable slow
path for refilling.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h | 10 ++++++
 io_uring/register.c           |  3 ++
 io_uring/zcrx.c               | 64 +++++++++++++++++++++++++++++++++++
 io_uring/zcrx.h               |  7 ++++
 4 files changed, 84 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6957dc539d83..97b206df4cc1 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -665,6 +665,9 @@ enum io_uring_register_op {
 
 	IORING_REGISTER_MEM_REGION		= 34,
 
+	/* return zcrx buffers back into circulation */
+	IORING_REGISTER_ZCRX_REFILL		= 35,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -1046,6 +1049,13 @@ struct io_uring_zcrx_ifq_reg {
 	__u64	__resv[3];
 };
 
+struct io_uring_zcrx_refill {
+	__u32		zcrx_id;
+	__u32		nr_entries;
+	__u64		rqes;
+	__u64		__resv[2];
+};
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/io_uring/register.c b/io_uring/register.c
index a59589249fce..5155ea627f65 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -835,6 +835,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_mem_region(ctx, arg);
 		break;
+	case IORING_REGISTER_ZCRX_REFILL:
+		ret = io_zcrx_return_bufs(ctx, arg, nr_args);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index d510ebc3d382..4540e5cd7430 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -922,6 +922,70 @@ static const struct memory_provider_ops io_uring_pp_zc_ops = {
 	.uninstall		= io_pp_uninstall,
 };
 
+#define IO_ZCRX_MAX_SYS_REFILL_BUFS		(1 << 16)
+#define IO_ZCRX_SYS_REFILL_BATCH		32
+
+static void io_return_buffers(struct io_zcrx_ifq *ifq,
+			      struct io_uring_zcrx_rqe *rqes, unsigned nr)
+{
+	int i;
+
+	for (i = 0; i < nr; i++) {
+		struct net_iov *niov;
+		netmem_ref netmem;
+
+		if (!io_parse_rqe(&rqes[i], ifq, &niov))
+			continue;
+
+		scoped_guard(spinlock_bh, &ifq->rq_lock) {
+			if (!io_zcrx_put_niov_uref(niov))
+				continue;
+		}
+
+		netmem = net_iov_to_netmem(niov);
+		if (!page_pool_unref_and_test(netmem))
+			continue;
+		io_zcrx_return_niov(niov);
+	}
+}
+
+int io_zcrx_return_bufs(struct io_ring_ctx *ctx,
+			void __user *arg, unsigned nr_arg)
+{
+	struct io_uring_zcrx_rqe rqes[IO_ZCRX_SYS_REFILL_BATCH];
+	struct io_uring_zcrx_rqe __user *urqes;
+	struct io_uring_zcrx_refill zr;
+	struct io_zcrx_ifq *ifq;
+	unsigned nr, i;
+
+	if (nr_arg)
+		return -EINVAL;
+	if (copy_from_user(&zr, arg, sizeof(zr)))
+		return -EFAULT;
+	if (!zr.nr_entries || zr.nr_entries > IO_ZCRX_MAX_SYS_REFILL_BUFS)
+		return -EINVAL;
+	if (!mem_is_zero(&zr.__resv, sizeof(zr.__resv)))
+		return -EINVAL;
+
+	ifq = xa_load(&ctx->zcrx_ctxs, zr.zcrx_id);
+	if (!ifq)
+		return -EINVAL;
+	nr = zr.nr_entries;
+	urqes = u64_to_user_ptr(zr.rqes);
+
+	for (i = 0; i < nr;) {
+		unsigned batch = min(nr - i, IO_ZCRX_SYS_REFILL_BATCH);
+
+		if (copy_from_user(rqes, urqes + i, sizeof(rqes)))
+			return i ? i : -EFAULT;
+		io_return_buffers(ifq, rqes, batch);
+
+		i += batch;
+		cond_resched();
+	}
+	return nr;
+}
+
 static bool io_zcrx_queue_cqe(struct io_kiocb *req, struct net_iov *niov,
 			      struct io_zcrx_ifq *ifq, int off, int len)
 {
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index a48871b5adad..33ef61503092 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -63,6 +63,8 @@ struct io_zcrx_ifq {
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
+int io_zcrx_return_bufs(struct io_ring_ctx *ctx,
+			void __user *arg, unsigned nr_arg);
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			 struct io_uring_zcrx_ifq_reg __user *arg);
 void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx);
@@ -95,6 +97,11 @@ static inline struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ct
 {
 	return NULL;
 }
+static inline int io_zcrx_return_bufs(struct io_ring_ctx *ctx,
+				      void __user *arg, unsigned nr_arg)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 int io_recvzc(struct io_kiocb *req, unsigned int issue_flags);
-- 
2.49.0


