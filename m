Return-Path: <io-uring+bounces-11940-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aEvtNtyReGmirAEAu9opvQ
	(envelope-from <io-uring+bounces-11940-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 11:22:20 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4500D92B1D
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 11:22:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7135E3090919
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 10:15:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F9933D6D8;
	Tue, 27 Jan 2026 10:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j3e4SKh4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B4233D503
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 10:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769508881; cv=none; b=SUGqJQekBZfbmbLMpZ7KL1vQyzp8/kPmbaww69ZYRyOwWBZpLJiYLgj+0FzZIbZLnkliq6tyA2HdXBE5+mKSFuAysMy1eMIRm7CJ8+JoyYS61NDflJCbS09l3kH0ch03dS6HPXA0fuXGanbDV9UaFcgFORu2HkI8/R/bdd854og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769508881; c=relaxed/simple;
	bh=DF2A1Gd2KkRL+mK3TLCrWFGlaCBn12MkbiyDGInYTRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnrHHIO9vLY4R7Qs9cDnt+4bDCougbIPvVReJjUEpz0DGD7VFgUAULRR0idl5tMFUJVtAuIL/p/GzML2i+7BxioO+lejBDle2QRP8I6ISrfxxoDSrpj5dnBQUjjoUVyl33EhuqCWXCTRMnusvL2g9Xw2hEnoeVaGxScsRxq64U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j3e4SKh4; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-430f3ef2d37so4743588f8f.3
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 02:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769508877; x=1770113677; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bHP/nubeTxOYBfaUQh6UZzNUyhXiKY+VbQsOPOEWQLI=;
        b=j3e4SKh4SoF6Q3vp4bNiIP9gpdh3ADrV2Aoi+NQcNVyE59oDj2K2f17dFNYTAF/K47
         DqTCCsURdyqagH1tAJCv2vv5M4Van9CbqXTTwCHo22WOu/D+vLS6nYTy4pRA3vZDk+DQ
         x6xRtF8qolK0hpZf5w5CGkCqpb+3+cwSUimJeNFKJ+88URgSxFg+iU+IQ3Q+R1qwqDup
         dOFN0weH9iG4tyTYCCM74Ho7zzVQnL94URd/6hrhIx9Tp9oV1D7SWdAoOTVhFVfpdFxL
         YDPTaO7rZReplnsKcbF+XCdnX9F9kCRs+JVjnsMBXSI0CyrnbGD9pq4BrAj+wK0rXJeP
         7faA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769508877; x=1770113677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bHP/nubeTxOYBfaUQh6UZzNUyhXiKY+VbQsOPOEWQLI=;
        b=eNTbWPoSNCjKKQT3VjoNXR7YyHmTMfDHk9OH1NZZdFqVsNERlbqu89ujCKb4Ra2/0b
         sRaRZ+igLxGizgEgBziq0Ao1d+3ruqgg+K2UBP4Hy/gycB0E1iE/mJaLYAP3W7YeFemv
         GWiQunwzbWIf45TS4flFYhPc3R88GRkuPUrgIxrN2AHsdA27JF+NzT5fg9Qk5lQazyak
         bP5ixjDoWI1zS3qnCXV72CYW+InTaeLd0vYtOUsx4xRBPF29C/sxW9P8Quos8XTxDO0K
         rarQgiQR+FUaFSNcq5XvDnycdsoaGUgG/5Qyheu4FNUhvBnhIQ4rivXKb5OkaWTDkQqT
         ALrg==
X-Gm-Message-State: AOJu0YxnOnAKMJGF4WA0O0Jxce9JJ2k94mD0v5Rlq0l9vyNdR6PqtwX/
	CFvjg9p6t62fiuIzeIDiYSRkrx+3qwRHAvJWCemIVXYBJ/kEurQk9KE92cAXHyFf
X-Gm-Gg: AZuq6aJP5M64unhTOxz5aF1Rg5C5sCsOQXOmC5frU0eutDl1pOECMZrGkmC1Fc1wzWG
	fvD/8F6tit44nk6iYTMxvBq46UFuljXEiK0P6F5DoIlch62fgWTD2CtCgHvxZ7eMu6D6jvD0T1+
	vTdYHVmPzc+C7gt2YA+Eh8IBH5j2C2lodZmrpg9ETEt5MsqoQaKb7w8zXCVTVahcoYG++8ckznV
	m/qrrGRjJd7FLaqZXUWkIfe/tZjp7FMBqZRboydODZfpe+kpJ4LHWyZ669YpIUMFr4e4XuKZp1R
	0VczYgqgrUpbYGnGpm/4Hc5WOR9kNPfeHa3tYORbA+mA+uOMfxbP5QWjnlmzrWrJdV/WM+VLQOo
	mKCIrnL5ZCvbyvNM4eqeCRQWrhDhYV/4O5Ta2reCVkzFRFlHN3sTh+HtAzVBF09KNKtaOcxiXOW
	aP5XqliFKyuqGldBxuf/3aLryS0mi3o0ciW/3hiz+VU/Xb6IC2Pm7frG1CHPiX8NJaQTl2zvkxl
	TV+YyDqVH3mzRPI7w==
X-Received: by 2002:a5d:5f56:0:b0:42b:2dfd:5350 with SMTP id ffacd0b85a97d-435dd1d92a1mr1557838f8f.56.1769508877080;
        Tue, 27 Jan 2026 02:14:37 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435b1c24acdsm38190407f8f.13.2026.01.27.02.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 02:14:36 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org
Subject: [PATCH v4 5/6] io_uring/bpf-ops: add bpf struct ops registration
Date: Tue, 27 Jan 2026 10:14:09 +0000
Message-ID: <ba105ce0c281f7f4ad5f06a795a0641fc83b84ac.1769470552.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769470552.git.asml.silence@gmail.com>
References: <cover.1769470552.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-11940-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4500D92B1D
X-Rspamd-Action: no action

Implement BPF struct ops registration. It's registered from the BPF
path, and can be removed by BPF as well as io_uring, which is why it's
protected by a global lock io_bpf_ctrl_mutex.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  5 ++
 io_uring/bpf-ops.c             | 87 +++++++++++++++++++++++++++++++++-
 io_uring/bpf-ops.h             |  8 ++++
 io_uring/io_uring.c            |  1 +
 4 files changed, 100 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 9990df98790d..5dfe3608dbb9 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -8,6 +8,9 @@
 #include <linux/llist.h>
 #include <uapi/linux/io_uring.h>
 
+struct iou_loop_params;
+struct io_uring_bpf_ops;
+
 enum {
 	/*
 	 * A hint to not wake right away but delay until there are enough of
@@ -462,6 +465,8 @@ struct io_ring_ctx {
 	DECLARE_HASHTABLE(napi_ht, 4);
 #endif
 
+	struct io_uring_bpf_ops		*bpf_ops;
+
 	/*
 	 * Protection for resize vs mmap races - both the mmap and resize
 	 * side will need to grab this lock, to prevent either side from
diff --git a/io_uring/bpf-ops.c b/io_uring/bpf-ops.c
index ad4e3dc889ba..26955ff06ecf 100644
--- a/io_uring/bpf-ops.c
+++ b/io_uring/bpf-ops.c
@@ -4,10 +4,12 @@
 
 #include "io_uring.h"
 #include "register.h"
+#include "loop.h"
 #include "memmap.h"
 #include "bpf-ops.h"
 #include "loop.h"
 
+static DEFINE_MUTEX(io_bpf_ctrl_mutex);
 static const struct btf_type *loop_params_type;
 
 __bpf_kfunc_start_defs();
@@ -141,16 +143,99 @@ static int bpf_io_init_member(const struct btf_type *t,
 			       const struct btf_member *member,
 			       void *kdata, const void *udata)
 {
+	u32 moff = __btf_member_bit_offset(t, member) / 8;
+	const struct io_uring_bpf_ops *uops = udata;
+	struct io_uring_bpf_ops *ops = kdata;
+
+	switch (moff) {
+	case offsetof(struct io_uring_bpf_ops, ring_fd):
+		ops->ring_fd = uops->ring_fd;
+		return 1;
+	}
+	return 0;
+}
+
+static int io_install_bpf(struct io_ring_ctx *ctx, struct io_uring_bpf_ops *ops)
+{
+	if (ctx->flags & (IORING_SETUP_SQPOLL | IORING_SETUP_IOPOLL))
+		return -EOPNOTSUPP;
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
+		return -EOPNOTSUPP;
+
+	if (ctx->bpf_ops)
+		return -EBUSY;
+	if (WARN_ON_ONCE(!ops->loop_step))
+		return -EINVAL;
+
+	ops->priv = ctx;
+	ctx->bpf_ops = ops;
+	ctx->loop_step = ops->loop_step;
 	return 0;
 }
 
 static int bpf_io_reg(void *kdata, struct bpf_link *link)
 {
-	return -EOPNOTSUPP;
+	struct io_uring_bpf_ops *ops = kdata;
+	struct io_ring_ctx *ctx;
+	struct file *file;
+	int ret = -EBUSY;
+
+	file = io_uring_register_get_file(ops->ring_fd, false);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+	ctx = file->private_data;
+
+	scoped_guard(mutex, &io_bpf_ctrl_mutex) {
+		guard(mutex)(&ctx->uring_lock);
+		ret = io_install_bpf(ctx, ops);
+	}
+
+	fput(file);
+	return ret;
+}
+
+static void io_eject_bpf(struct io_ring_ctx *ctx)
+{
+	struct io_uring_bpf_ops *ops = ctx->bpf_ops;
+
+	if (!WARN_ON_ONCE(!ops))
+		return;
+	if (WARN_ON_ONCE(ops->priv != ctx))
+		return;
+
+	ops->priv = NULL;
+	ctx->bpf_ops = NULL;
+	ctx->loop_step = NULL;
 }
 
 static void bpf_io_unreg(void *kdata, struct bpf_link *link)
 {
+	struct io_uring_bpf_ops *ops = kdata;
+	struct io_ring_ctx *ctx;
+
+	guard(mutex)(&io_bpf_ctrl_mutex);
+	ctx = ops->priv;
+	if (ctx) {
+		guard(mutex)(&ctx->uring_lock);
+		if (WARN_ON_ONCE(ctx->bpf_ops != ops))
+			return;
+
+		io_eject_bpf(ctx);
+	}
+}
+
+void io_unregister_bpf_ops(struct io_ring_ctx *ctx)
+{
+	/* check it first to avoid taking io_bpf_ctrl_mutex */
+	scoped_guard(mutex, &ctx->uring_lock) {
+		if (!ctx->bpf_ops)
+			return;
+	}
+
+	guard(mutex)(&io_bpf_ctrl_mutex);
+	guard(mutex)(&ctx->uring_lock);
+	if (ctx->bpf_ops)
+		io_eject_bpf(ctx);
 }
 
 static struct bpf_struct_ops bpf_ring_ops = {
diff --git a/io_uring/bpf-ops.h b/io_uring/bpf-ops.h
index b9e589ad519a..bf4d5b9bb8c9 100644
--- a/io_uring/bpf-ops.h
+++ b/io_uring/bpf-ops.h
@@ -17,4 +17,12 @@ struct io_uring_bpf_ops {
 	void *priv;
 };
 
+#ifdef CONFIG_IO_URING_BPF
+void io_unregister_bpf_ops(struct io_ring_ctx *ctx);
+#else
+static inline void io_unregister_bpf_ops(struct io_ring_ctx *ctx)
+{
+}
+#endif
+
 #endif /* IOU_BPF_OPS_H */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 09920e56c9c9..9d6eef7ccf22 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2141,6 +2141,7 @@ static __cold void io_req_caches_free(struct io_ring_ctx *ctx)
 
 static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
+	io_unregister_bpf_ops(ctx);
 	io_sq_thread_finish(ctx);
 
 	mutex_lock(&ctx->uring_lock);
-- 
2.52.0


