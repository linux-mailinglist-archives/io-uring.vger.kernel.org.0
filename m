Return-Path: <io-uring+bounces-8206-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A770ACDA1A
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 10:42:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A56B1888A5D
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 08:42:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B702F28A70D;
	Wed,  4 Jun 2025 08:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RJVBTWhZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA94428C5B6;
	Wed,  4 Jun 2025 08:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749026494; cv=none; b=qf3p993W9sBbHr73oVFDFfdjBAbOzSM8T+ZAx03YU8Sqhm8qG/9vdaXCpZkhuIqglcjKE5Um3aSpba6YUBQ+lWN54+dBdT0psZDBe2/5uxVNXSwXQIpa3BViifMqYrw7qkTgaK09YKEMC7UIhf8Rbk8EIw72jtUoz0YyjGC56Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749026494; c=relaxed/simple;
	bh=Iv1DMavYcgUp6Omqxv+7Bjt8Z8VIsID8hu9hTljFuWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHlM0ZsLHAJ7Hl0s31hAzrHRZWSIWWpeRqEEcpj1dgBF/3Ws7ii274HNG8vMTc04lHZoYroPnA1g5rWD5vpEJLDeaLcjrchBDJW/wnJOio/edPBaXhDduudH/ADz5jXnIwj0zRVIdgg5n/MZnWOpRrdUfNXfpJ+VO9PmTkYP+Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RJVBTWhZ; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-604b9c53f6fso2490560a12.2;
        Wed, 04 Jun 2025 01:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749026490; x=1749631290; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M70NQJS9jUx4+Sj1DxGQ1qgeJuVpolj2AVUh0COE2Fs=;
        b=RJVBTWhZfk3n/31zgim2D9NrcpHaxVdadYUgSVMzdbVa/g7Kpf5Mnjl7otoAUinJca
         s5voHQRDwVxnJUiFVWUihCdl+FKYwjrAPSa/iVzsDawRr07p0SF8hJk/LhqZ/isNnIeT
         JZpACjUyL0uZpQc1id6aKNstw57oZQpuQl/2kNIJVZWFyrj9mrU1QewJ8cXJcnx5aFke
         HZ5ao0wCOE7spgha7fZ1apbgE5dAuQ8/Wd9sH7yn/ptR7Of5uV8b/H8l3Lge6uSfYGUU
         MyeSGyzkvI3lh3XUXCovqo1o0SeRaW121knzFSRAFYis+VfOKCAnU7gBuo9/WfpcGkTp
         hSxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749026490; x=1749631290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M70NQJS9jUx4+Sj1DxGQ1qgeJuVpolj2AVUh0COE2Fs=;
        b=hyhg965kbMTjWgHTWjDt2T9no6kwSVh9tD5roKtI5C7HBkvjbWauShJU9TB04+/X9k
         TmcFFRitFpSkgCmwXpBr76Z18f+rhUKTF2ne6ZYAV47Q7HZcB9krUqQQOBRUXJK7h2nV
         px7vT5eImTA1b7CEuzkbRhI98n5nDkJWPZNi9pqHiyC4APp220Pmo92j/dOB0y05Z1TZ
         KdDcQEbEFPa/yEJuYfCrT83neiLqYmVvVxQr/jpL+DhAGgHno5wVqjWVlgXRrfYWNp5d
         zOliY9OpgfY9fBWoMK/Ytlm65qOHHCnFErcmMQfm25CI6hLbx2PRb5ix3lrmjEquRqKp
         XNUA==
X-Forwarded-Encrypted: i=1; AJvYcCXbZ4KDwvHkGyEWZ+kN2zQ8ZHhjLOPPbshogv3MSsksZ+YYgtsqSGLtH9T+VbTH8Ia3wsyi7/Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyP/U8EDBx/O7U9iM/EbPYrRRSIiWm25o29793KkjRGMOJDs75/
	xhxhWiDvxzuQEt+Q6bI2mrVN4dh5jJ8EnNz7acLiXms+gn1MlzDGUJo17zgn9A==
X-Gm-Gg: ASbGnctUJjx7XAmEys5Ph/NhPTFYidHiYvgsIRIvSq83pRC/xSCDwhI88AZmHlChZrn
	OBM+5Etap/cKuJuRIaFmnzfniR8u4kX/J6RlPluhA9h8ozBCWd2RontsFVI+3DwoLlNT5uEy8I7
	10/OVtiVFltJiM+TEjzMTB+IRCjGRrtQjbLo1s1/b6BqJnZzWUfxibWT2HNC3pJuo3Tlr7QUr3R
	Jg8I9xMi4efhcT2abQuMpXA4HNDNaeRmQcWHMKqFp/uibbBnhZUBFtpZlndY2t34bQLFK/uzdYM
	Vz+4XF37/2/VaUD+TLYJnzPqHGnuI4ABCsb+H7v4y7KsjkzWl6/V/BpC
X-Google-Smtp-Source: AGHT+IG68AEhLHwpRsWOtgcoAb/f/Wt0iEW1lslQpU04sblgyh7Ox/4Ouw/c7rV89E90zRwNE0W6Hg==
X-Received: by 2002:a05:6402:1ec6:b0:602:48:ba35 with SMTP id 4fb4d7f45d1cf-606e94518ccmr2348231a12.13.1749026489660;
        Wed, 04 Jun 2025 01:41:29 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b3d1])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-606f3ace23bsm544261a12.12.2025.06.04.01.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 01:41:28 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH v2 4/5] io_uring: add mshot helper for posting CQE32
Date: Wed,  4 Jun 2025 09:42:30 +0100
Message-ID: <8973bbb2ad72628a3e1c9825a1da6f88afd89300.1749026421.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1749026421.git.asml.silence@gmail.com>
References: <cover.1749026421.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a helper for posting 32 byte CQEs in a multishot mode and add a cmd
helper on top. As it specifically works with requests, the helper ignore
the passed in cqe->user_data and sets it to the one stored in the
request.

The command helper is only valid with multishot requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c  | 40 ++++++++++++++++++++++++++++++++++++++++
 io_uring/io_uring.h  |  1 +
 io_uring/uring_cmd.c | 11 +++++++++++
 io_uring/uring_cmd.h |  4 ++++
 4 files changed, 56 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c7a9cecf528e..4ca357057384 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -788,6 +788,21 @@ bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow)
 	return true;
 }
 
+static bool io_fill_cqe_aux32(struct io_ring_ctx *ctx,
+			      struct io_uring_cqe src_cqe[2])
+{
+	struct io_uring_cqe *cqe;
+
+	if (WARN_ON_ONCE(!(ctx->flags & IORING_SETUP_CQE32)))
+		return false;
+	if (unlikely(!io_get_cqe(ctx, &cqe)))
+		return false;
+
+	memcpy(cqe, src_cqe, 2 * sizeof(*cqe));
+	trace_io_uring_complete(ctx, NULL, cqe);
+	return true;
+}
+
 static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 			      u32 cflags)
 {
@@ -899,6 +914,31 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	return posted;
 }
 
+/*
+ * A helper for multishot requests posting additional CQEs.
+ * Should only be used from a task_work including IO_URING_F_MULTISHOT.
+ */
+bool io_req_post_cqe32(struct io_kiocb *req, struct io_uring_cqe cqe[2])
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	bool posted;
+
+	lockdep_assert(!io_wq_current_is_worker());
+	lockdep_assert_held(&ctx->uring_lock);
+
+	cqe[0].user_data = req->cqe.user_data;
+	if (!ctx->lockless_cq) {
+		spin_lock(&ctx->completion_lock);
+		posted = io_fill_cqe_aux32(ctx, cqe);
+		spin_unlock(&ctx->completion_lock);
+	} else {
+		posted = io_fill_cqe_aux32(ctx, cqe);
+	}
+
+	ctx->submit_state.cq_flush = true;
+	return posted;
+}
+
 static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 0ea7a435d1de..bff5580507ba 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -81,6 +81,7 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags);
+bool io_req_post_cqe32(struct io_kiocb *req, struct io_uring_cqe src_cqe[2]);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
 struct file *io_file_get_normal(struct io_kiocb *req, int fd);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 2710521eec62..429a3e4a6a02 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -333,3 +333,14 @@ int io_cmd_poll_multishot(struct io_uring_cmd *cmd,
 	ret = io_arm_apoll(req, issue_flags, mask);
 	return ret == IO_APOLL_OK ? -EIOCBQUEUED : -ECANCELED;
 }
+
+bool io_uring_cmd_post_mshot_cqe32(struct io_uring_cmd *cmd,
+				   unsigned int issue_flags,
+				   struct io_uring_cqe cqe[2])
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
+
+	if (WARN_ON_ONCE(!(issue_flags & IO_URING_F_MULTISHOT)))
+		return false;
+	return io_req_post_cqe32(req, cqe);
+}
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index 9565ca5d5cf2..be97407e4019 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -16,6 +16,10 @@ void io_uring_cmd_cleanup(struct io_kiocb *req);
 bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 				   struct io_uring_task *tctx, bool cancel_all);
 
+bool io_uring_cmd_post_mshot_cqe32(struct io_uring_cmd *cmd,
+				   unsigned int issue_flags,
+				   struct io_uring_cqe cqe[2]);
+
 void io_cmd_cache_free(const void *entry);
 
 int io_cmd_poll_multishot(struct io_uring_cmd *cmd,
-- 
2.49.0


