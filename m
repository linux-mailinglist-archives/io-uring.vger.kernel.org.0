Return-Path: <io-uring+bounces-9819-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 149ECB599F4
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 16:28:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 93D614E15D4
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 14:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D47F21578D;
	Tue, 16 Sep 2025 14:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X5YTV2F5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB56B34A321
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 14:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032836; cv=none; b=psXtn0K/ZP4nNJi/XvE/3Gt32dHQRo4ozWFsmQViyS8vNU+Fy9mEkmw8LkNhm6RDyI3rloHBVYGLNyXiW+pmJphMvMdDa9yzoSqM3Vizv0/JmlU189DsVAHhWXSaKqrNbx/VU8RUFTSDrWh1mP+g4ORw0g5XaZ0ifkjZLshwm80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032836; c=relaxed/simple;
	bh=Ba3hf/psu5OQZXAnx6TZcurBfaGJDa+2Se1quaTSuCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmE0CSHbB0V/8Ij8xCDK7qfcfuhkVnoAsIluXdGawutQTXRrPoKq7cY7Z+58haWO/8GTaYkvD54C0dcVMKj33tm2IWKjJQvr0U/cJEWh7IffL0j2YyUT6N0HCELbt6IoP4i/ZtS4U3iSddkfFmKF45togaE7m6boCQ4u2/UM7IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X5YTV2F5; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3d3ff4a4d6fso3782769f8f.0
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 07:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758032832; x=1758637632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tnhQ2XXV23z7U+HTiOtSf/kpovvCRSuBmGZhnRRXPq0=;
        b=X5YTV2F5NqM76wCpwaqk10BHtohOpnxgDqLme+XlRO/BQlHkHqqst5qM/ec4tAOvAX
         TMSVyRA8LGNbjjgRXvkvCXw/6vl3Vq2Ix3ZDkVRWaaaL3DOPKs45MUcNjFJyJZox+v8z
         2tNl2gkLlmGxrLrPjL9Li8LBKcxN+7H7bcQGKKV7H0/DbdZsGmTSYf08BZ9iIMGJdSFy
         lxxKKO5zZe1i3GXLRSr9O0K4PGyjW9NNoKX1ub2RxheeTBrNPmEPKeb9ZgekcUx2R18J
         l55fWqE9J+wePP4e5AG7bTyLzatqCLviDJ3X68USNUNDaLKEWmUk0zHvquyqohqkZJ1+
         eIiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758032832; x=1758637632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tnhQ2XXV23z7U+HTiOtSf/kpovvCRSuBmGZhnRRXPq0=;
        b=ILIfWxqbjqbC13ji/kas2Is0ileFhy9GsMwQ6MG/2eUbWbHdC/dNanF05rqy3YCMOj
         iydHNfW5X1ZsewhASFsrSVNGiukiLTDVzBN6wcM6WIGg7BDnFlDRw6yWKXZUJwBF0mEa
         uHJ/oUDuflixckwbD+OyPIPOKqAFqMRVUUkiK8/zzPBt3/MKBK/iTBqa63G0SiMX/m8n
         VRsSU80Q19JoGnWTW6qf5I0KB0ZFaJLYnUw72xd6ZgERlqla8a9XKF5Ft4ofMwVMC+qE
         GiZqq7Brdo2F6xn41btqJwNb8H1ngeVB6rtHp/VZiR/u1/UHH1dUwZ/bjXdN0OhDTRV0
         /oMA==
X-Gm-Message-State: AOJu0YzPAKfb8Cfs4r++P52LNSW9Zqo8wJEnNLX3RVO+QiV+t847W1eb
	ufcjgkSzcDt8CS4pT6hJQJHuJoJQUF1M75BQ3Ixp6sEyblLAgTMHD9AmgU0gvg==
X-Gm-Gg: ASbGncuyLfnQVYIGhDyhnr2kMcf+ph87SPE3DHsD7EIe/8EllyENYxINv3PHBbe1lb4
	2E/BkJbUQh2XZ6XxAhP+svWWsWhRdY4+wvT5l4lTfbQB3sw/Km10I1aX/o4a1E4Aj76z/9ok1QM
	gu8gGEVPti8VRqSpN1UhXKXHFYtHDQuseUlAamPNtrLBrN5N96QIQ7RMRIDPJ4bfP5TvLhowSZE
	hvnZJlXo06igzPWQoFcr9X+eh+5lP1XR1kND6wAFIovP7nE5Kp2CSHrrECJ1tRHnFyrifSgli5I
	smxpvEM+bTFJtew3AVBugKbE9sTkOv/9+NoDkscs1ItDfjdT3C0RRCr4Y7QNwK1MIovO6nwZ3R1
	KdVEgsXOuluErUEZD
X-Google-Smtp-Source: AGHT+IHVtUpHvbO1TB2mc0kzm63gElyhmdY7z7qm+eSR8wnk0sHhyctDcwXADnLJP2V2lNh4dIfpBA==
X-Received: by 2002:a5d:4e91:0:b0:3e8:e7a6:e5a9 with SMTP id ffacd0b85a97d-3e8e7a6e869mr7652854f8f.48.1758032832293;
        Tue, 16 Sep 2025 07:27:12 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdc967411sm327971f8f.46.2025.09.16.07.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:27:11 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring for-6.18 19/20] io_uring/zcrx: allow synchronous buffer return
Date: Tue, 16 Sep 2025 15:28:02 +0100
Message-ID: <58e9280cb02c97e52d9a2f15944f7a9e4d344927.1758030357.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1758030357.git.asml.silence@gmail.com>
References: <cover.1758030357.git.asml.silence@gmail.com>
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
 include/uapi/linux/io_uring.h | 12 +++++++
 io_uring/register.c           |  3 ++
 io_uring/zcrx.c               | 68 +++++++++++++++++++++++++++++++++++
 io_uring/zcrx.h               |  7 ++++
 4 files changed, 90 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 1ce17c535944..a0cc1cc0dd01 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -689,6 +689,9 @@ enum io_uring_register_op {
 	/* query various aspects of io_uring, see linux/io_uring/query.h */
 	IORING_REGISTER_QUERY			= 35,
 
+	/* return zcrx buffers back into circulation */
+	IORING_REGISTER_ZCRX_REFILL		= 36,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -1070,6 +1073,15 @@ struct io_uring_zcrx_ifq_reg {
 	__u64	__resv[3];
 };
 
+struct io_uring_zcrx_sync_refill {
+	__u32		zcrx_id;
+	/* the number of entries to return */
+	__u32		nr_entries;
+	/* pointer to an array of struct io_uring_zcrx_rqe */
+	__u64		rqes;
+	__u64		__resv[2];
+};
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/io_uring/register.c b/io_uring/register.c
index 96e9cac12823..43f04c47522c 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -833,6 +833,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	case IORING_REGISTER_QUERY:
 		ret = io_query(ctx, arg, nr_args);
 		break;
+	case IORING_REGISTER_ZCRX_REFILL:
+		ret = io_zcrx_return_bufs(ctx, arg, nr_args);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 81d4aa75a69f..07a114f9a542 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -927,6 +927,74 @@ static const struct memory_provider_ops io_uring_pp_zc_ops = {
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
+	struct io_uring_zcrx_rqe __user *user_rqes;
+	struct io_uring_zcrx_sync_refill zr;
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
+	user_rqes = u64_to_user_ptr(zr.rqes);
+
+	for (i = 0; i < nr;) {
+		unsigned batch = min(nr - i, IO_ZCRX_SYS_REFILL_BATCH);
+		size_t size = batch * sizeof(rqes[0]);
+
+		if (copy_from_user(rqes, user_rqes + i, size))
+			return i ? i : -EFAULT;
+		io_return_buffers(ifq, rqes, batch);
+
+		i += batch;
+
+		if (fatal_signal_pending(current))
+			return i;
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


