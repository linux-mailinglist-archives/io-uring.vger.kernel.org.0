Return-Path: <io-uring+bounces-4581-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEBCF9C32F2
	for <lists+io-uring@lfdr.de>; Sun, 10 Nov 2024 15:55:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E2D228153B
	for <lists+io-uring@lfdr.de>; Sun, 10 Nov 2024 14:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C7A53A8D0;
	Sun, 10 Nov 2024 14:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D3HgzLUc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F52038FA6
	for <io-uring@vger.kernel.org>; Sun, 10 Nov 2024 14:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731250544; cv=none; b=R6rfmvnzpLkH+cYCdY59OK6Htt2uGTgA8zsjiCDioLybmebTXNtZVpNOD4K+Is1ynaX47SSGmrYP7qLQNnESda+9dxBVDv5Z1rNiRdWySUH5c94MyK0tz0ZDook3ZAPdjyD3gy+IG5jXyzjOyAlmzBNO5E3zWsNc3t44VH4RATk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731250544; c=relaxed/simple;
	bh=AHSLn9OAnXLJ0HEHHrRy+2SAlH1kEMl1sAHPTkvg50A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzeOjnlmWxVlSyvQzqkOlb0OVclcgdjngr4rigw5UkEnzmXWzdB7sfQMNzZpoUP42aHyar0tW0Km64aBIqnQQ6LcZfu9+dyTrOkvuhFWKq0hZ4wv4BupypqLdpT9kP9jKdfL3xXXih603N2uGKW7czKVead02HEFkZ3b+4dhkpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D3HgzLUc; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-37d4fd00574so2024622f8f.0
        for <io-uring@vger.kernel.org>; Sun, 10 Nov 2024 06:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731250539; x=1731855339; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D0S9F1LGBxLyKRJ9QzXuymQI3UOu/ax8nqDcfSFVsGM=;
        b=D3HgzLUcjkzxIQcBA2lHVo/pK7Ng4lwmDW2p1VpbGd/KuCSJdHj1HJdY++5P0n2Q6P
         BaFloj/0y4yxJUCsKtsWc96Ixa97NMiilyQoGUBDmw8gEUtmo0kS7PW1TH3irqirpWDs
         oOl9DkQicYvSISEkzjnp++32tEEF7FKEt77KCJ2Tv4wFmKq4wbGq0vqFgD2785hDBPZe
         FTo5JA7wBmTI9PcB6yqufY4ts+fl080IN74wGvRYiX37MOi05ADXzYTMJuovui8S9y04
         6LWsBeYplzQ+LdaENi9sguNS9SeP+vHxAuVEfHCepsbhYDTJ1iZa1RGSFQELD1cuRTkz
         fr+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731250539; x=1731855339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D0S9F1LGBxLyKRJ9QzXuymQI3UOu/ax8nqDcfSFVsGM=;
        b=TGVeVBtlG632DIccst8ypyvCTJn+tHs5evwXxU3lNsQe4oPEabGrZLEUr33Dy3B+gV
         TFikfaF6zKhLLO7a65IDvtOZUT54mHBerqlcVxg9r1guWwv7yXr2EY9SNaoOD+S71A8V
         c+6LeIxbDlcc+eb24EJUYns5g5wflBcvlKvk02FlmZz1Eu+sUkX9MRFy0ng3x5zeYW3b
         Snwa/+pFnedHXXg4QObMiAJlX4Y5Z6fNifqWAa3pCUupSjiCLPoBMcttJXv9AReIwz/H
         FCwmwjUaBSSRwrhz2YwIXlqFAlPJ8gxX6N5dVxHYsJ2rGIaYXPrY8Tnr+hWQAf/EZJ3T
         Caog==
X-Gm-Message-State: AOJu0YzNVTNYkBhiMPjeS6DOx1152iEvATpZYTsZVUX/18VL47M8QXQa
	r7YR6ByX5Nhc+1BSd2R9TwsifpyXqHBdSksNTEIfDwqJWvtDBm+lT3G4PQ==
X-Google-Smtp-Source: AGHT+IHVr7VGP62l/UXv/kQ5iKmPUA8fEqbnAiy0r8Cktb61NNhmVj+ZGlgRwZ4F5s8PXEzLAg1sPQ==
X-Received: by 2002:a05:6000:402c:b0:374:c1ea:2d40 with SMTP id ffacd0b85a97d-381f0f40d9cmr8238964f8f.1.1731250539096;
        Sun, 10 Nov 2024 06:55:39 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432aa6beea6sm182445535e9.20.2024.11.10.06.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 06:55:38 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 1/3] io_uring: introduce request parameter sets
Date: Sun, 10 Nov 2024 14:56:20 +0000
Message-ID: <877a43b660a5fec4d658007a8c77bf73471b0b64.1731205010.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731205010.git.asml.silence@gmail.com>
References: <cover.1731205010.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are lots of parameters we might want to additionally pass to a
request, but SQE has limited space and it may require additional parsing
and checking in the hot path. Then requests take an index specifying
which parameter set to use.

The benefit for the kernel is that we can put any number of arguments in
there and then do pre-processing at the initialisation time like
renumbering flags and enabling static keys for performance deprecated
features. The obvious downside is that the user can't use the entire
parameter space as there could only be a limited number of sets. The
main target here is tuning the waiting loop with finer grained control
when we should wake the task and return to the user.

The current implementation is crude, it needs a SETUP flag disabling
creds/personalities, and is limited to one registration of maximum 16
sets. It could be made to co-exist with creds and be a bit more flexibly
registered and expanded.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  8 ++++++
 include/uapi/linux/io_uring.h  |  9 ++++++
 io_uring/io_uring.c            | 36 ++++++++++++++++--------
 io_uring/msg_ring.c            |  1 +
 io_uring/net.c                 |  1 +
 io_uring/register.c            | 51 ++++++++++++++++++++++++++++++++++
 6 files changed, 94 insertions(+), 12 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index ad5001102c86..79f38c07642d 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -75,6 +75,10 @@ struct io_hash_table {
 	unsigned		hash_bits;
 };
 
+struct io_set {
+	u32 flags;
+};
+
 /*
  * Arbitrary limit, can be raised if need be
  */
@@ -268,6 +272,9 @@ struct io_ring_ctx {
 		unsigned		cached_sq_head;
 		unsigned		sq_entries;
 
+		struct io_set		iosets[16];
+		unsigned int		nr_iosets;
+
 		/*
 		 * Fixed resources fast path, should be accessed only under
 		 * uring_lock, and updated through io_uring_register(2)
@@ -635,6 +642,7 @@ struct io_kiocb {
 
 	struct io_ring_ctx		*ctx;
 	struct io_uring_task		*tctx;
+	struct io_set			*ioset;
 
 	union {
 		/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index ba373deb8406..6a432383e7c3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -158,6 +158,8 @@ enum io_uring_sqe_flags_bit {
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
 #define IORING_SETUP_SUBMIT_ALL	(1U << 7)	/* continue submit on error */
+#define IORING_SETUP_IOSET	(1U << 8)
+
 /*
  * Cooperative task running. When requests complete, they often require
  * forcing the submitter to transition to the kernel to complete. If this
@@ -634,6 +636,8 @@ enum io_uring_register_op {
 	/* register fixed io_uring_reg_wait arguments */
 	IORING_REGISTER_CQWAIT_REG		= 34,
 
+	IORING_REGISTER_IOSETS			= 35,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -895,6 +899,11 @@ struct io_uring_recvmsg_out {
 	__u32 flags;
 };
 
+struct io_uring_ioset_reg {
+	__u64 flags;
+	__u64 __resv[3];
+};
+
 /*
  * Argument for IORING_OP_URING_CMD when file is a socket
  */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f34fa1ead2cf..cf688a9ff737 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2156,6 +2156,7 @@ static void io_init_req_drain(struct io_kiocb *req)
 
 static __cold int io_init_fail_req(struct io_kiocb *req, int err)
 {
+	req->ioset = &req->ctx->iosets[0];
 	/* ensure per-opcode data is cleared if we fail before prep */
 	memset(&req->cmd.data, 0, sizeof(req->cmd.data));
 	return err;
@@ -2238,19 +2239,27 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	}
 
 	personality = READ_ONCE(sqe->personality);
-	if (personality) {
-		int ret;
-
-		req->creds = xa_load(&ctx->personalities, personality);
-		if (!req->creds)
+	if (ctx->flags & IORING_SETUP_IOSET) {
+		if (unlikely(personality >= ctx->nr_iosets))
 			return io_init_fail_req(req, -EINVAL);
-		get_cred(req->creds);
-		ret = security_uring_override_creds(req->creds);
-		if (ret) {
-			put_cred(req->creds);
-			return io_init_fail_req(req, ret);
+		personality = array_index_nospec(personality, ctx->nr_iosets);
+		req->ioset = &ctx->iosets[personality];
+	} else {
+		if (personality) {
+			int ret;
+
+			req->creds = xa_load(&ctx->personalities, personality);
+			if (!req->creds)
+				return io_init_fail_req(req, -EINVAL);
+			get_cred(req->creds);
+			ret = security_uring_override_creds(req->creds);
+			if (ret) {
+				put_cred(req->creds);
+				return io_init_fail_req(req, ret);
+			}
+			req->flags |= REQ_F_CREDS;
 		}
-		req->flags |= REQ_F_CREDS;
+		req->ioset = &ctx->iosets[0];
 	}
 
 	return def->prep(req, sqe);
@@ -3909,6 +3918,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (!ctx)
 		return -ENOMEM;
 
+	ctx->nr_iosets = 0;
+
 	ctx->clockid = CLOCK_MONOTONIC;
 	ctx->clock_offset = 0;
 
@@ -4076,7 +4087,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
 			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
 			IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD_ONLY |
-			IORING_SETUP_NO_SQARRAY | IORING_SETUP_HYBRID_IOPOLL))
+			IORING_SETUP_NO_SQARRAY | IORING_SETUP_HYBRID_IOPOLL |
+			IORING_SETUP_IOSET))
 		return -EINVAL;
 
 	return io_uring_create(entries, &p, params);
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index e63af34004b7..f5a747aa255c 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -98,6 +98,7 @@ static int io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	io_req_set_res(req, res, cflags);
 	percpu_ref_get(&ctx->refs);
 	req->ctx = ctx;
+	req->ioset = &ctx->iosets[0];
 	req->io_task_work.func = io_msg_tw_complete;
 	io_req_task_work_add_remote(req, ctx, IOU_F_TWQ_LAZY_WAKE);
 	return 0;
diff --git a/io_uring/net.c b/io_uring/net.c
index 2ccc2b409431..785987bf9e6a 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1242,6 +1242,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	notif = zc->notif = io_alloc_notif(ctx);
 	if (!notif)
 		return -ENOMEM;
+	notif->ioset = req->ioset;
 	notif->cqe.user_data = req->cqe.user_data;
 	notif->cqe.res = 0;
 	notif->cqe.flags = IORING_CQE_F_NOTIF;
diff --git a/io_uring/register.c b/io_uring/register.c
index 45edfc57963a..e7571dc46da5 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -86,6 +86,48 @@ int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
 	return -EINVAL;
 }
 
+static int io_update_ioset(struct io_ring_ctx *ctx,
+			   const struct io_uring_ioset_reg *reg,
+			   struct io_set *set)
+{
+	if (!(ctx->flags & IORING_SETUP_IOSET))
+		return -EINVAL;
+	if (reg->flags)
+		return -EINVAL;
+	if (reg->__resv[0] || reg->__resv[1] || reg->__resv[2])
+		return -EINVAL;
+
+	set->flags = reg->flags;
+	return 0;
+}
+
+static int io_register_iosets(struct io_ring_ctx *ctx,
+			      void __user *arg, unsigned int nr_args)
+{
+	struct io_uring_ioset_reg __user *uptr = arg;
+	struct io_uring_ioset_reg reg[16];
+	int i, ret;
+
+	/* TODO: one time setup, max 16 entries, should be made more dynamic */
+	if (ctx->nr_iosets)
+		return -EINVAL;
+	if (nr_args >= ARRAY_SIZE(ctx->iosets))
+		return -EINVAL;
+
+	if (copy_from_user(reg, uptr, sizeof(reg[0]) * nr_args))
+		return -EFAULT;
+
+	for (i = 0; i < nr_args; i++) {
+		ret = io_update_ioset(ctx, &reg[i], &ctx->iosets[i]);
+		if (ret) {
+			memset(&ctx->iosets[0], 0, sizeof(ctx->iosets[0]));
+			return ret;
+		}
+	}
+
+	ctx->nr_iosets = nr_args;
+	return 0;
+}
 
 static int io_register_personality(struct io_ring_ctx *ctx)
 {
@@ -93,6 +135,9 @@ static int io_register_personality(struct io_ring_ctx *ctx)
 	u32 id;
 	int ret;
 
+	if (ctx->flags & IORING_SETUP_IOSET)
+		return -EINVAL;
+
 	creds = get_current_cred();
 
 	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)creds,
@@ -846,6 +891,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_cqwait_reg(ctx, arg);
 		break;
+	case IORING_REGISTER_IOSETS:
+		ret = -EINVAL;
+		if (!arg)
+			break;
+		ret = io_register_iosets(ctx, arg, nr_args);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.46.0


