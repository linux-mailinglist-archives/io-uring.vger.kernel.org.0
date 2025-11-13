Return-Path: <io-uring+bounces-10597-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ED97C574FB
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 13:01:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 473C84E62D7
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 12:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21BBB34EEFA;
	Thu, 13 Nov 2025 12:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BVc0kn6U"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BD334DB62
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 12:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763035213; cv=none; b=KT9Ggv+6GY9zGy+Jca/5ry8XfPw98+oE2NcBv0sJOtZGpXKCSg0pTC9lOKD3UfgFCANxmH8rEpunUFO/dLHZcMHs8taKTPqp81d+z0izhUYMRnaD0q3g+KnUxkIadRCfeW6leQkt/yfJ7abqXhVzmvJyL7pa1dCYh3U4aXDYhGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763035213; c=relaxed/simple;
	bh=MNZ4D/SrnRFTD01ItzWyiXrd+rn7QST4Vx8UBMBgO4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3lwdWONz/e2b0vhv3h7CcpNsiXZcs8n0k2XmEU8LB7BWWo9nOFNzIpMbu4k7Lyrv12EeNzN08c91rBy3eh4OrMp4+A2e4NiKj6Rs/AkuhL0N+mEvGOt3r1AF6+IT/4bh1nHvPVedUfwhtq/vhY5fuqVV+FtVGhDiQUYzLeaSRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BVc0kn6U; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4710022571cso7038025e9.3
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 04:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763035209; x=1763640009; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hRUMaJ6pXxrABHSX63UTKKMqTjolP/B2q2kqV6Fs/SI=;
        b=BVc0kn6UBDe7XI9h76iaaaKVSyfgOUKJ29VTlHd7KfVoYOEQG7lwZgh8D56UD4+pYA
         VNf5MA+Y3qC8+u/rtqnkdYjnz2fXbvGJqkOa6zygqpUb3WiyJWZuvqe6mwNNaJON7yRT
         U2XWqJQ3qx6G+F6a1a6kB9XuxrwWTUZcxgwFjZD2UbadOmDIUT56pdQceem9Oh24hEHy
         bc3VeZ4QpvmSNuQIFW8nAD6zZUfW1WeqdDl18tKcybEzagM6+ZoWHmSXsl3CDCDzU7Bb
         UMOmClNeVtNbjwUb59NhdkhR9Ib0uzDtqHZqdO4ZBoP9psjY3jBkLaUmksTJ/kKundWA
         gyCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763035209; x=1763640009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hRUMaJ6pXxrABHSX63UTKKMqTjolP/B2q2kqV6Fs/SI=;
        b=Q4tjGROrJzBlUuSD4TgS9LXOlaJV23pH1bIfisWA2N9ZRjOpAbt+lHgrynJRDR+ZKr
         Hd4sTkbBkP2u4bzVL7eRVPseeyrKd9ViDYFuQRN+Aq5C+uqih/F+S4woOwNdYF5nK/pu
         pew479KxrEGz2O2D2ghCMtTHFyziOBU3wJa5EhgbuZdEzETbGE0uzzooUt/EkPinaVFy
         LNE7UdkRhTBcvd0f5jz6M7uBsYsN5yUDTrWYANpYd3qhdGc5Q5wAz2NQh+gjzNs76gG8
         7Y5u0Lov+iYbezPMVCE/cmLODEKz+6WouGcFdStcZp1jWWBNRvCOKSW2AVj6S7KVMvTV
         +Rpw==
X-Gm-Message-State: AOJu0YyMnU8JBhySdMzjEkXziJrAxvEL5W4IIZpFtKUtMEDrc6nXgSO7
	TRmu6sV9ZJu0FNSCxd3S2UaYHTFh/pK2PFsi3tEWfuSGUimW2D1Hmbqz4iEKNQ==
X-Gm-Gg: ASbGncunRqUqvshkDgANPkhJJxladiyzoxYAXt0FnhYvD/5TDLl2rBFK+V2/rky6sdL
	LhQS/+8miMvsH94DPr4h/HMffJg1LK3aBcAQMtS7HOK04wX7kS3nm47phyvttoe5RaYRDuD1YX6
	lcV+1d2Oz3UpH/mpcNB4RLuzzyA6UBQUSecOBOHCdBX2YisMRMMM2tYCkWCTWg62Rh916J322gU
	xm5eH3XK4JDcbJFp5rBtpTto55nQJujED/SnkLDWdU0HDB9SG/oL+8QwSW5e/kDINC1vqr/Sj5R
	YlOsEEaIdXGQ+QOfFUoIMZkVsoljSjzgT7KgAvjG7fMgf7glOO92YsO+5uZn2cbQAOLIjiNy8eF
	dUNUXq5VjG/CAMXVQLdbd/QGjRCiW17xJjLH7TJKt70URzU1+w8PZWn+eLAiG9CQ9fYpZXQ==
X-Google-Smtp-Source: AGHT+IE0KuUqERCq/bafVQh8aR2dqLKvM5VESGGRfnTOT7ZRQTnfW1F5DAhA/qAt0qJbP+pRoZ+FIA==
X-Received: by 2002:a05:600c:1f92:b0:477:54cd:2029 with SMTP id 5b1f17b1804b1-47787071a7bmr56593245e9.4.1763035208649;
        Thu, 13 Nov 2025 04:00:08 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e85e6fsm3686816f8f.18.2025.11.13.04.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 04:00:08 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	Martin KaFai Lau <martin.lau@linux.dev>,
	bpf@vger.kernel.org,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	ming.lei@redhat.com
Subject: [PATCH v3 07/10] io_uring/bpf: implement struct_ops registration
Date: Thu, 13 Nov 2025 11:59:44 +0000
Message-ID: <cce6ee02362fe62aefab81de6ec0d26f43c6c22d.1763031077.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1763031077.git.asml.silence@gmail.com>
References: <cover.1763031077.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add ring_fd to the struct_ops and implement [un]registration.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  2 +
 io_uring/bpf.c                 | 69 +++++++++++++++++++++++++++++++++-
 2 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 43432a06d177..3a71ed2d05ea 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -274,6 +274,8 @@ struct io_ring_ctx {
 		unsigned int		compat: 1;
 		unsigned int		iowq_limits_set : 1;
 
+		unsigned int		bpf_installed: 1;
+
 		struct task_struct	*submitter_task;
 		struct io_rings		*rings;
 		struct percpu_ref	refs;
diff --git a/io_uring/bpf.c b/io_uring/bpf.c
index 24dd2fe9134f..683e87f1a58b 100644
--- a/io_uring/bpf.c
+++ b/io_uring/bpf.c
@@ -4,6 +4,7 @@
 #include "bpf.h"
 #include "register.h"
 
+static DEFINE_MUTEX(io_bpf_ctrl_mutex);
 static const struct btf_type *loop_state_type;
 
 static int io_bpf_ops__loop(struct io_ring_ctx *ctx, struct iou_loop_state *ls)
@@ -87,20 +88,86 @@ static int bpf_io_init_member(const struct btf_type *t,
 			       const struct btf_member *member,
 			       void *kdata, const void *udata)
 {
+	u32 moff = __btf_member_bit_offset(t, member) / 8;
+	const struct io_uring_ops *uops = udata;
+	struct io_uring_ops *ops = kdata;
+
+	switch (moff) {
+	case offsetof(struct io_uring_ops, ring_fd):
+		ops->ring_fd = uops->ring_fd;
+		return 1;
+	}
+	return 0;
+}
+
+static int io_install_bpf(struct io_ring_ctx *ctx, struct io_uring_ops *ops)
+{
+	if (ctx->bpf_ops)
+		return -EBUSY;
+	ops->priv = ctx;
+	ctx->bpf_ops = ops;
+	ctx->bpf_installed = 1;
 	return 0;
 }
 
 static int bpf_io_reg(void *kdata, struct bpf_link *link)
 {
-	return -EOPNOTSUPP;
+	struct io_uring_ops *ops = kdata;
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
+	struct io_uring_ops *ops = ctx->bpf_ops;
+
+	if (!WARN_ON_ONCE(!ops))
+		return;
+	if (WARN_ON_ONCE(ops->priv != ctx))
+		return;
+
+	ops->priv = NULL;
+	ctx->bpf_ops = NULL;
 }
 
 static void bpf_io_unreg(void *kdata, struct bpf_link *link)
 {
+	struct io_uring_ops *ops = kdata;
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
 }
 
 void io_unregister_bpf(struct io_ring_ctx *ctx)
 {
+	if (!ctx->bpf_installed)
+		return;
+	guard(mutex)(&io_bpf_ctrl_mutex);
+	guard(mutex)(&ctx->uring_lock);
+	if (ctx->bpf_ops)
+		io_eject_bpf(ctx);
 }
 
 static struct bpf_struct_ops bpf_io_uring_ops = {
-- 
2.49.0


