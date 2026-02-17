Return-Path: <io-uring+bounces-12289-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YCp5BppSlGl3CgIAu9opvQ
	(envelope-from <io-uring+bounces-12289-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 12:35:54 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A3B5E14B746
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 12:35:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9B1CB305E377
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 11:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6377E335063;
	Tue, 17 Feb 2026 11:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bML03YVU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A763314D1
	for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 11:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771328040; cv=none; b=ESQZM2vJTByKEWTwBNDEibGMiVvbvY5d4/vilakVbds4zhThcCaGXHoFJdTCJWMpKay2nAWbYHKgvSAVp3CF4wwqphNrX3SLb0qMrARTDO1xQkRmdfCzH/9bwsXJkOjDyQ1jiSwhJmmP6YkIDETh5zOBGQcMcz9XyfhNhFZAyew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771328040; c=relaxed/simple;
	bh=FXnktX6iI9F9MCvVYyjxyRN0DuKuhlPhArCuw2Hg4KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/6VyI5Sk+uYIK6hLhJUlgRzdUMWV9oSL/ogvRiitRMYj6ofJbElWcrT74IMgNIWkbZ90tpFc1chnlLwogub1TF03a4O7EDNkjqI547lCFc5gl6K2P9coxF7jKLoXch+T2URrditZyCQQa9cQEtYTMDc96/vUmV9PI2ow9XLh9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bML03YVU; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4359249bbacso4080074f8f.0
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 03:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771328036; x=1771932836; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5rFGI29TUm/XHZMUUq+bMECbjvA2fMBfcIenQ+N9bZU=;
        b=bML03YVU5QNeNJbh+Xi5q2MuX/vTNvChTgv+FBR+r+GJNtNs/nKLtFhtJU2Q4msJvQ
         CjXrJzf9/LdDFG935yN46qHEOKLr8MSKnUMQoZW883uTI80uyWMRSgKkBTZqnqEmUxNw
         PhvB/p8+b6NOweE9kQdpyq46Ip/TmFcX7jDXl5X1NxYPy60H3j/nYkvBImGM3op/1RAX
         ePb6F1wKP+KmgoRucxl1V2dEOHvqYt92OfJWA3gQ0/Lo2pZ1vK4UMG6qYRd2FG0EdOI2
         tWh3AJRQsgtfLv7mhcpR6w9pfGiWjHiZ6D0VlEq4O+6OBAF27EPipAOXQY5LdbZ++4hN
         iBig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771328036; x=1771932836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5rFGI29TUm/XHZMUUq+bMECbjvA2fMBfcIenQ+N9bZU=;
        b=eO2dKSGNmc8hoJVUPU9QcDQOJlyjorZDJu+Dqpmy4y46rZQQ5b1w9CnhVtpBatD/ZM
         XjnRXck2qcVoxRSc3mM1y/lPjcBDm8cuhp8qOy2WFfRKL4c74kgHGq860wqEzPt1VUFi
         fsobCJXD4h2CyhL1qALJ6qXPKEY8gBBFEodU0IjGIuf5KBCye1Qo8DjFOs1W8bsEbTMH
         +UwXQa4PK+cn02JcaqPIVxMpueJDVUtWd8xBciwEydA2OUan0ZUt9jr5Fv8chFRc4II8
         Rpiz4J5/ncIKGaxk30OZnmKPHTod4xeXkSBYGLBiQu7jVF7Y9RWbbN7fPt3OhGePyy0p
         NpJQ==
X-Gm-Message-State: AOJu0YxIYCwnFXFtSmvsPqfSqx+qvgmRlBmBIpWI4FKe/IrA5dnThOjr
	/4d8LqSDagmd05kgSUmR/udDhoJ9gF/fcLty50OCjSEYBd5Na+F9gun1ZbiGhQ==
X-Gm-Gg: AZuq6aIiiGycpfIjM8sH5pfdPAS/QsLxYdsTLO3p1mV00/gGK7em5ejHU3QY3rZPYEb
	CrP/71X+JfOLZUfrPwRlOL0yBjQznkQljvUs2S+w1YFfPHc1cORe6OoK3Y263+AO8os1tETAjSM
	4uiTmhYo0i43SSTlUooe+zQeQVCNJXkMiE3SWm1eg/PBV3QX/Vj5N4AwlTwEYXXhO027CnAk6VP
	t+gNsDBAjY4W/k4BG5WwZbYsANynirr1740hWGsU2VYsVSdO8DiJXXPIfzqWdAj1dtFUO7C4SAr
	PInhH0f1CzuWFcQwjQpS7OT91LHBhPzOhw+fXvcKMbLP34LdXovovA/fDG8uyfZi0BOKhGkkAll
	pMo+mDoTBFgUJXwanj/Qdodo2Uunq8Baa9btz09yAGGIRODLnO1+L/Pvuv19A33c1FqusMKIvaK
	tgtnZneXBegeOZZC5dFDcqtnY27xCTLmiXdwseC/Ny+oqIydH7272XRIFkUP39TumyR6t7ZIQo+
	xVCGmTUXhCxqNO1awpVxrHoW2LrOw==
X-Received: by 2002:a05:6000:40da:b0:436:339a:9a9f with SMTP id ffacd0b85a97d-4379d5e3fadmr22571463f8f.10.1771328036138;
        Tue, 17 Feb 2026 03:33:56 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796ac800esm36258343f8f.27.2026.02.17.03.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 03:33:55 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v8 4/5] io_uring/bpf-ops: implement bpf ops registration
Date: Tue, 17 Feb 2026 11:33:46 +0000
Message-ID: <2aafe124e44c0acf5d3b412abe74101ca2c0aa29.1771327059.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1771327059.git.asml.silence@gmail.com>
References: <cover.1771327059.git.asml.silence@gmail.com>
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
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TAGGED_FROM(0.00)[bounces-12289-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: A3B5E14B746
X-Rspamd-Action: no action

Implement BPF struct ops registration. It's registered off the BPF
path, and can be removed by BPF as well as io_uring. To protect it,
introduce a global lock synchronising registration. ctx->uring_lock can
be nested under it. ctx->bpf_ops is write protected by both locks and
so it's safe to read it under either of them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  5 ++
 io_uring/bpf-ops.c             | 91 +++++++++++++++++++++++++++++++++-
 io_uring/bpf-ops.h             |  8 +++
 io_uring/io_uring.c            |  1 +
 4 files changed, 104 insertions(+), 1 deletion(-)

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
index 17518f4ecca9..1ffe7ba73b89 100644
--- a/io_uring/bpf-ops.c
+++ b/io_uring/bpf-ops.c
@@ -5,10 +5,12 @@
 
 #include "io_uring.h"
 #include "register.h"
+#include "loop.h"
 #include "memmap.h"
 #include "bpf-ops.h"
 #include "loop.h"
 
+static DEFINE_MUTEX(io_bpf_ctrl_mutex);
 static const struct btf_type *loop_params_type;
 
 __bpf_kfunc_start_defs();
@@ -143,16 +145,103 @@ static int bpf_io_init_member(const struct btf_type *t,
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
2.52.0


