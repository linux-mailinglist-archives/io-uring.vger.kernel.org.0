Return-Path: <io-uring+bounces-12434-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CBpaOJJBoGmrhAQAu9opvQ
	(envelope-from <io-uring+bounces-12434-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 13:50:26 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 569DD1A5E68
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 13:50:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9ED8E30F4DD6
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 12:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C6DE2D8387;
	Thu, 26 Feb 2026 12:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bix3hwSt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDC0288C81
	for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 12:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772110134; cv=none; b=WEwjxXdKbSNsgyhMbY66dQMJTTWknuy6FfiCFNhHSN5+HG5xfzFzHFHbP1TaQo3doVRRDsTJYN+80A1ikSaKxV7ZX0gEH8d1OOUMr6b1G/mHdtE7zhFycJ8PXjEoAw7YCx4lmU7cQHdH6eUDmOZsX+oFfHyIRoVu43tSiMAqboY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772110134; c=relaxed/simple;
	bh=cE2dDHs6RKQc47MczEEt/fgaBkR+JvJoy3UpL32ZwQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8is7DbaUMYTFAFwXltnsYtlP0fCpGDImjRUZ+ZQvyyGznBTovEKtwXueRrNwSgX2dojH8el7WuCHIqQ6siFBUm89XxtnQ+uUgdSPj56Ihb6NLLg3j1bZdA2xmnmav3QbrLaAIQrWHS+wUuURfzBFRpV9VjrWTQmMc/RqwfROaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bix3hwSt; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4806cc07ce7so9785825e9.1
        for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 04:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772110131; x=1772714931; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QtxpGMpLhs0MsBTHyKZ/F4kyrnSIwfSyIpyKCH7U5YU=;
        b=bix3hwStz8ZIIt7hRZRRIVey2WK6RAY2yIBXJB5FmdIK8bchBn5HUNsMr0/wVCLMG3
         5x8MTqzLPt8w1Oq7DYaICgAXnudIgyKy2mn7BcZyyQYzdl0HhZM2D+kBeGhOCbLBCFTt
         9nhtnYfUuFS5+AGi6QfIz9+kdqFzpCtO/sSgbCyB1+dxFLLjjbUnH00eENAUzY2x1MzT
         KzIygC/ytS6wiCRcHn6zgrcU/WjKlPS/aX/3VfBVs7GVVufS+m55hA3YJ+1XqFpOMEB+
         2vfFjGxigeqWvYkPvy6j1SRmPkTOsJ5TPKk+fkPrdPtXK0grN88b5cOGMwJ4j+OJ9X4f
         5xOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772110131; x=1772714931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QtxpGMpLhs0MsBTHyKZ/F4kyrnSIwfSyIpyKCH7U5YU=;
        b=FQ4JqAqxluK/Z0HLdMHGZBksI+g38YUmJPAkxrge/brBCaXT/wV1+PZYs4N5UpezAY
         jlFF6Th1u0A7aNKAYCGtzYDt/BzzyqOKMkH/YxI2BUiFUrBm2KOTY2MM8ep2DBF73BVj
         8YruuucU9eMNJ6eWdDIvpu0MdrHAORisN3PsRP7I28V1Wn+qmhRsIgHR1bn7qH2iSpOr
         cozypKnrBDtsd0bOzXOvJm0rYGdjQkyMMALvtNHQ5CR6fODQhDbB2w0B24WYzQ76vlY+
         mGAQmls3NwyoctVnjm/j/ZQlRtJVbDiCjt4mb9cS+PQw0PbZLtJXAmVKUARFIdIR599w
         hJMQ==
X-Gm-Message-State: AOJu0YxE3h0HPtLZ/YKcKFKsxxmOhBQUThaz5DNAU3fzit+qxpdMDLXW
	oHBz1u6/QJBmvJipnIdQe7ggutUJrczmCS4f44VDOReWy+kmtlB2zyZBHjBjww==
X-Gm-Gg: ATEYQzxQVO1Ecw4wqHK/ovkGKzqmfNaDAMFcc0xz6+MGmbt3TQglAyKilKv84kSQqtu
	cvBEb8kdpHEBODbqw0L5TyXINpBImUJAj5cSkamjQV+/ewXq9Ey1NxK5uifVjkgZclRsj4gL+0m
	DgpBhYkLRe388yLDp4mxQdd/yUhcDFU0euwoLW/4QFr7rKFSlZp9u27NZfi5R96U8aGqrggPCVr
	mrqsk1EfS0RW8IuVVRftHrwQP+6d6wMTeV/kTUaLRdjoYHmx3NjQA0QCUdT22GuhOKNPodEJxUZ
	ksfsja6X5UeK/pEOC49AGVa7/gActD7ViE3J6Qd1us80OclOlz66zZQa4/71YdxfQ/jtug3gA4V
	diJyRJzISABwoFDq3vZk6JRPSIv0S4ep/ViAxGeJjXv2B6Ju2Gr5/Cdv/K7Oui7z7geFwVcQ7HW
	zHZp5W3YSzoPsV1dBVb0V2QAGCw3X2VTrlNe1kXYn7gUtvlSu4Gyh5MYW5uHHanMTMaXujhCeCu
	vKLVBGf4pARlQ==
X-Received: by 2002:a05:600c:6296:b0:483:a361:41a5 with SMTP id 5b1f17b1804b1-483c3df4633mr35734445e9.30.1772110130806;
        Thu, 26 Feb 2026 04:48:50 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:2ab0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d4c977sm43734576f8f.32.2026.02.26.04.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 04:48:50 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v10 4/4] io_uring/bpf-ops: implement bpf ops registration
Date: Thu, 26 Feb 2026 12:48:41 +0000
Message-ID: <1f46bffd76008de49cbafa2ad77d348810a4f69e.1772109579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772109579.git.asml.silence@gmail.com>
References: <cover.1772109579.git.asml.silence@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-12434-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 569DD1A5E68
X-Rspamd-Action: no action

Implement BPF struct ops registration. It's registered off the BPF
path, and can be removed by BPF as well as io_uring. To protect it,
introduce a global lock synchronising registration. ctx->uring_lock can
be nested under it. ctx->bpf_ops is write protected by both locks and
so it's safe to read it under either of them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  5 ++
 io_uring/bpf-ops.c             | 92 +++++++++++++++++++++++++++++++++-
 io_uring/bpf-ops.h             |  8 +++
 io_uring/io_uring.c            |  1 +
 4 files changed, 104 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index cceac329fcfd..976d85f82f86 100644
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
@@ -481,6 +484,8 @@ struct io_ring_ctx {
 	DECLARE_HASHTABLE(napi_ht, 4);
 #endif
 
+	struct io_uring_bpf_ops		*bpf_ops;
+
 	/*
 	 * Protection for resize vs mmap races - both the mmap and resize
 	 * side will need to grab this lock, to prevent either side from
diff --git a/io_uring/bpf-ops.c b/io_uring/bpf-ops.c
index 17518f4ecca9..e4b244337aa9 100644
--- a/io_uring/bpf-ops.c
+++ b/io_uring/bpf-ops.c
@@ -5,10 +5,11 @@
 
 #include "io_uring.h"
 #include "register.h"
+#include "loop.h"
 #include "memmap.h"
 #include "bpf-ops.h"
-#include "loop.h"
 
+static DEFINE_MUTEX(io_bpf_ctrl_mutex);
 static const struct btf_type *loop_params_type;
 
 __bpf_kfunc_start_defs();
@@ -143,16 +144,103 @@ static int bpf_io_init_member(const struct btf_type *t,
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
+	if (WARN_ON_ONCE(!ops))
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
+	/*
+	 * ->bpf_ops is write protected by io_bpf_ctrl_mutex and uring_lock,
+	 * and read protected by either. Try to avoid taking the global lock
+	 * for rings that never had any bpf installed.
+	 */
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
index b9e589ad519a..b39b3fd3acda 100644
--- a/io_uring/bpf-ops.h
+++ b/io_uring/bpf-ops.h
@@ -17,4 +17,12 @@ struct io_uring_bpf_ops {
 	void *priv;
 };
 
+#ifdef CONFIG_IO_URING_BPF_OPS
+void io_unregister_bpf_ops(struct io_ring_ctx *ctx);
+#else
+static inline void io_unregister_bpf_ops(struct io_ring_ctx *ctx)
+{
+}
+#endif
+
 #endif /* IOU_BPF_OPS_H */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 548ea5a080a0..b154dac396d3 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2154,6 +2154,7 @@ static __cold void io_req_caches_free(struct io_ring_ctx *ctx)
 
 static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
+	io_unregister_bpf_ops(ctx);
 	io_sq_thread_finish(ctx);
 
 	mutex_lock(&ctx->uring_lock);
-- 
2.53.0


