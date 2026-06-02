Return-Path: <io-uring+bounces-13586-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QNoZCN2tHmr7JAAAu9opvQ
	(envelope-from <io-uring+bounces-13586-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 02 Jun 2026 12:18:05 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 70F7F62C685
	for <lists+io-uring@lfdr.de>; Tue, 02 Jun 2026 12:18:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E95383006947
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2026 10:08:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AE913D45F4;
	Tue,  2 Jun 2026 10:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hHNma55q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7958236F91F
	for <io-uring@vger.kernel.org>; Tue,  2 Jun 2026 10:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780394913; cv=none; b=rtdOd9h5GxzHEQJHvqO8IvTT3o5+ztnqHh9FYqYeOOntLdWbCxCFnrGCd8KLZ3czf6qVklZ7nXPqMITSmtCC9UKChVP/SfqGgpPVG/yu0dcmVLNzk58mjFgQ0ox2C48ACI9Oraq88gyNMplXw+xLg1GaLwR7di3DG4gxdGB/tdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780394913; c=relaxed/simple;
	bh=EeJA1pln9s7PAu57U5SzgS/C7K9ylW8yfH6Kyb4d5c8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IfD+pvMbTe6T4Zbqa3ehO4tXRL3qt6C3lE+DCpJbu76yk0w0PoiOxmcK7nZNgKx1CmcQAFG8MKSUea+TkL85WSzG9SD0n6T85S5sEOAwDxqeUPFZrsuL3XUyMNuL6MkYwPuGNHRcux8wI37WbF8Rkl/p/VQEmUbWfkN/pDY4MaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hHNma55q; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-45fd464d51fso1274092f8f.3
        for <io-uring@vger.kernel.org>; Tue, 02 Jun 2026 03:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780394910; x=1780999710; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yjV2ZP9rEdlfylk9FmlUdq8VpDSsa6B2bXbiSQaif7w=;
        b=hHNma55qwNDt4zZ+aROwn6PzgIkLbJNVdODp35qgpaC5uc6YaVIVH+/KyMa1yonf5t
         3LaLmhX6x2JSo3dW7sHA30umAjGqy4n9PN4FvXIJuhZHpTPASlFUQuycbykRM9Dzyo63
         GQj+XGYUsLoJRZO/2ovcaqbQ8v+jDPbjGYa3GKT1pqIrzr+rpHxkJh9ODsiV9tjURme1
         cXyHhoouQbtnvqdbXKdgreWcXcv+xCcVOnUH0VxCoQ4Wn/yh+BAG1rmI7PzPe5DepoiO
         dfYiX04QR/gRYfXeKia9f5mJc8vJ+eHT1PWKaj9VT5n8TUmctbDREELpz69vRNOGFCbE
         06oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780394910; x=1780999710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yjV2ZP9rEdlfylk9FmlUdq8VpDSsa6B2bXbiSQaif7w=;
        b=hpFnKmRu0lsOAwh/fDazZ9eUvVoE8ynkBI0uADnevnYf2yT0UcZ/xDqHLJgwmk+sPh
         dRFDyckYbUsjS/2ObT3IzfJFUCjPhLKHAXAe8A0BTuOxcTZptG0abJVTtsLM32wE1j2K
         o++fbuR2REGXtzIM0FxZajKzrnvxrz/cTd4eof2dh9lOrYbElbS0s+6N6i1+sns4PN6O
         1CyL0GPJeJ6+q+uEAXPqIys7fLuIBaEtYPzGpUX/Qc4CBuFxJgZo2GITIfkvlkWWgKsa
         /0N1Xn1U/J8MPcpL5Xbgb5rSXUcoIHP4zhf1aHyiCQ9YSFczH2Wd9rZkfEkowdPEzYr7
         m9gQ==
X-Gm-Message-State: AOJu0YwwnPrW5xis1eXbLiOxck1nQnq3xymIAgdYeticJUOJyqZh+GU4
	/Fp0/Dw9X2iih9JqD8YA8/xe09ouWjbzVutz0ZkHksbSOYRZuzuTby74APrmtQ==
X-Gm-Gg: Acq92OEYQwiwe2W22YiidnwMdDfJ1PC5dKN56sO2e7twxDmzIXd+v8GVrExWeF/zrbV
	sD343JxGwy/ZSvKBPMyb51oeETc3+d8lHPrjcRbXmVj6dnlSeYf72x8r1AclQTUfl5GiEwObzrx
	GkBdks6ebzE+0GaL+XwDp7NajMOU8iz6VUbnhfTYb7y6Aq2JkOHJtSJeF2g/LnzQRkWCUpLQD7k
	h06hqwqAvtwFyYVikwGBS1J4dxgfCzIoXY11E759jb+psNN0x9dt+8j5N+BY59iN00fboktbW1/
	n5NC8mD548oKKM7lcRv3Rd0A9PIMZt5Erp5skoNy9e83S14inj8e5QjLlLIzHS+L0kg3Rx5cwU6
	b79LbHI7jXqciE1ZhGs5keRcarjvAysvtJsTSZd1xySpGs3lIvHIkANKHYGw0jj0797CgHGDidv
	/PfiwzDs2XfnOPKh597lwYLGQXyfqUf1WECA7A54eDv8Wm7AI0an7tNvki7KXVKDSDuqkJyarKX
	cyySfQhEucxDsjgSi2s7Wa6ZaHz8VChCLVIA3cFtPUh00VfHk8=
X-Received: by 2002:adf:fd11:0:b0:43f:e990:2f5d with SMTP id ffacd0b85a97d-45ef6ba0b4bmr19313892f8f.35.1780394909264;
        Tue, 02 Jun 2026 03:08:29 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46018c87803sm4862695f8f.30.2026.06.02.03.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:08:28 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH 1/1] io_uring/bpf-ops: restrict ctx access to BPF
Date: Tue,  2 Jun 2026 11:08:25 +0100
Message-ID: <5f6ca3649e9e0bae8667db4357e28dd00cd07901.1780394491.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 70F7F62C685
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13586-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

BPF programs should have no need in looking into struct io_ring_ctx, if
anything, most of such cases would be anti patterns like looking up ring
indices directly via the context.

Replace it with a new empty structure, which is just an alias to struct
io_ring_ctx. It'll create a new BTF type and fail verification if a BPF
program tries to access it (beyond the first byte). It'll also give more
flexibility for the future, and otherwise it can be made aligned with
io_ring_ctx as before with struct groups if ever needed or extended in a
different way.

Fixes: d0e437b76bd3c ("io_uring/bpf-ops: implement loop_step with BPF struct_ops")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  4 +++-
 io_uring/bpf-ops.c             |  9 ++++++---
 io_uring/bpf-ops.h             |  2 +-
 io_uring/loop.c                |  2 +-
 io_uring/loop.h                | 10 ++++++++++
 5 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 244392026c6d..cc4a43778d00 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -290,6 +290,8 @@ enum {
 	IO_RING_F_IOWQ_LIMITS_SET	= BIT(12),
 };
 
+struct iou_ctx {};
+
 struct io_ring_ctx {
 	/* const or read-mostly hot data */
 	struct {
@@ -366,7 +368,7 @@ struct io_ring_ctx {
 		struct io_alloc_cache	rw_cache;
 		struct io_alloc_cache	cmd_cache;
 
-		int (*loop_step)(struct io_ring_ctx *ctx,
+		int (*loop_step)(struct iou_ctx *,
 				 struct iou_loop_params *);
 
 		/*
diff --git a/io_uring/bpf-ops.c b/io_uring/bpf-ops.c
index 937e48bef40b..5a50f0675fe5 100644
--- a/io_uring/bpf-ops.c
+++ b/io_uring/bpf-ops.c
@@ -14,15 +14,18 @@ static const struct btf_type *loop_params_type;
 
 __bpf_kfunc_start_defs();
 
-__bpf_kfunc int bpf_io_uring_submit_sqes(struct io_ring_ctx *ctx, u32 nr)
+__bpf_kfunc int bpf_io_uring_submit_sqes(struct iou_ctx *loop_ctx, u32 nr)
 {
+	struct io_ring_ctx *ctx = io_loop_demangle_ctx(loop_ctx);
+
 	return io_submit_sqes(ctx, nr);
 }
 
 __bpf_kfunc
-__u8 *bpf_io_uring_get_region(struct io_ring_ctx *ctx, __u32 region_id,
+__u8 *bpf_io_uring_get_region(struct iou_ctx *loop_ctx, __u32 region_id,
 			      const size_t rdwr_buf_size)
 {
+	struct io_ring_ctx *ctx = io_loop_demangle_ctx(loop_ctx);
 	struct io_mapped_region *r;
 
 	lockdep_assert_held(&ctx->uring_lock);
@@ -58,7 +61,7 @@ static const struct btf_kfunc_id_set bpf_io_uring_kfunc_set = {
 	.set = &io_uring_kfunc_set,
 };
 
-static int io_bpf_ops__loop_step(struct io_ring_ctx *ctx,
+static int io_bpf_ops__loop_step(struct iou_ctx *ctx,
 				 struct iou_loop_params *lp)
 {
 	return IOU_LOOP_STOP;
diff --git a/io_uring/bpf-ops.h b/io_uring/bpf-ops.h
index b39b3fd3acda..0b6d7894915e 100644
--- a/io_uring/bpf-ops.h
+++ b/io_uring/bpf-ops.h
@@ -11,7 +11,7 @@ enum {
 };
 
 struct io_uring_bpf_ops {
-	int (*loop_step)(struct io_ring_ctx *ctx, struct iou_loop_params *lp);
+	int (*loop_step)(struct iou_ctx *, struct iou_loop_params *lp);
 
 	__u32 ring_fd;
 	void *priv;
diff --git a/io_uring/loop.c b/io_uring/loop.c
index 31843cc3e451..bbbb6ef14e6a 100644
--- a/io_uring/loop.c
+++ b/io_uring/loop.c
@@ -49,7 +49,7 @@ static int __io_run_loop(struct io_ring_ctx *ctx)
 		if (unlikely(!ctx->loop_step))
 			return -EFAULT;
 
-		step_res = ctx->loop_step(ctx, &lp);
+		step_res = ctx->loop_step(io_loop_mangle_ctx(ctx), &lp);
 		if (step_res == IOU_LOOP_STOP)
 			break;
 		if (step_res != IOU_LOOP_CONTINUE)
diff --git a/io_uring/loop.h b/io_uring/loop.h
index d7718b9ce61e..4dd4fb3aefef 100644
--- a/io_uring/loop.h
+++ b/io_uring/loop.h
@@ -24,4 +24,14 @@ static inline bool io_has_loop_ops(struct io_ring_ctx *ctx)
 
 int io_run_loop(struct io_ring_ctx *ctx);
 
+static inline struct iou_ctx *io_loop_mangle_ctx(struct io_ring_ctx *ctx)
+{
+	return (struct iou_ctx *)ctx;
+}
+
+static inline struct io_ring_ctx *io_loop_demangle_ctx(struct iou_ctx *ctx)
+{
+	return (struct io_ring_ctx *)ctx;
+}
+
 #endif
-- 
2.54.0


