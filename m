Return-Path: <io-uring+bounces-8138-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 10783AC8D76
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 14:18:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D332A1BA4DD7
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 12:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B26E322CBFA;
	Fri, 30 May 2025 12:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sy742sLm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C642221CC52;
	Fri, 30 May 2025 12:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748607444; cv=none; b=c7GPSuQuxMHC9R5LYnLgZ9Ea8XokUymH2P9Va1Y3GOHLBddXW1PXdqFfmYPs/V44guksAvJWLuUdzMXNqG2PT5oIAwbzFmYi5rrfbnpWPAP2GmgTD/QrwDz3DlytpXqwFnHLTHuurecMz8nkbR6ZLlJiRuyEK6Q4dWkhW98Jh7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748607444; c=relaxed/simple;
	bh=Iv1DMavYcgUp6Omqxv+7Bjt8Z8VIsID8hu9hTljFuWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRXn5B6VtGYrrqV7dT2sOW+sh/oewqtYs09F6YSeJ4z8MUtqrQ/SQILram+iCpCiHlFOSG9DSvNginxQimawGknH1jjgJrHl05dpv1zy16BzNvUiHKM3SIDnIfEpNuY4oW/Y1mmTQ9TL1AGw0xQIMR39ppq1zoDrKncvJWFe+8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sy742sLm; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6020ff8d51dso3204266a12.2;
        Fri, 30 May 2025 05:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748607441; x=1749212241; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M70NQJS9jUx4+Sj1DxGQ1qgeJuVpolj2AVUh0COE2Fs=;
        b=Sy742sLmQx35wDwKRcdwG8eVPylMdHeVcUG8lGG9coIj8baLmXHivubGIFoFXS8xzj
         Vl80uNYmEqgLOKef2c8Q5vIIMjwKEnCCVYN9PqQmmiLdSXr/hAl8J1MyEC7wKqqbD6R3
         Rgq//LLm+WOp42anFwDQSmBTkHRpdaSriiArFh4JQWecLM2smzAORHPOQ1usLsIABsnP
         ksVMIfthPTP1je0NfB1fHIGwBpe/99nMRNeOiyOEYGmULLF/SkLQjO3sgBFzTGvHflNT
         QKpQ7neoK8pJuXedwLb858E/znPxD/QM+daL8jsWJ7+15dXK1vu8YKL8J5AwWnvKnFWE
         Gu3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748607441; x=1749212241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M70NQJS9jUx4+Sj1DxGQ1qgeJuVpolj2AVUh0COE2Fs=;
        b=YqBt+PdNR7ILk2RcDou+H4a62DKJ809RW97wVMbSAnSZZQoLjxiW03Ib6BGPQHG+4l
         phKLTH/LYTnxMjM2gK1n1byw0kJdSstDSLT2vuZeZyvPWCfUvYhmrjLDbIO3by/ff/RL
         uK+g0fFZ2U+l71iDnwydqReDa5oTuu50QC2UWY+jDasEv+BYcBG9uM1lW3ZVaj/9CNdw
         0gTh5ZNpTyF5yUgWe8iSydZBJJY+URyDZAKX7HnXVN3sPHu77tuVMiqREZ3ON7jOgOys
         6B67oIY2FxHMi9GMxxfX2eJkhvD/X92J353Gpg1Ba8i06Of8gMh4/9PkjOBQJB7U7WUf
         fKrg==
X-Forwarded-Encrypted: i=1; AJvYcCVz9ewz/cak+iRGxZj+r+azdlEkCjmrS4VeCn7j51RkqvyczPES0YF0KLeM3rChftoaM/OQ+7g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8Mc9Y578CnkNtSuS+YFMDExiUIBx0C70IVEdOLSDaAGaFFSLV
	ICUjSpl3S6aa+0ju/On4N86f3REG2QRX5vQXrBxRdemgVPjvB4iP9uLt1CTQsw==
X-Gm-Gg: ASbGnctMD/dIJvFaPg6Xhy/3nF3iUG8c6QJkBt23RpxC14MamnJ+fUAyruZn97Kc1bJ
	wt4UT6fTLiblu9sQjXszezQBTdrbch9srSTXsy0hv4d38+ThitkxpCjvhM26SGy/g+Zbh5/H95e
	mmjyb4JD0Pks8X1KTRgesSmJVqgyMCRV8tRvJ36xKoytx+YtmcfbMmE2ivHAtk9UUf5+nirtWcR
	80DB2lCDjkTKn0j2dGoLmXmVY+kHmXkF0PJzwAQwBWNLg8qoGbFDuRN42mWpVKfAiwPTRti91LO
	/08Rx6iFnJ5/C68b1HfELZ3oLiBR4Onxt8E=
X-Google-Smtp-Source: AGHT+IHCp/j/zU4q1abUFn4x6PgNtyi3G1FMXc2QJ4M2snD5tDNPjYh78FPPfYokszTAVTpk2h3Yqw==
X-Received: by 2002:a17:907:9611:b0:ad5:56fa:1904 with SMTP id a640c23a62f3a-adb32580624mr272858066b.44.1748607440355;
        Fri, 30 May 2025 05:17:20 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada5d82ccedsm318566966b.48.2025.05.30.05.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 05:17:19 -0700 (PDT)
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
Subject: [PATCH 4/5] io_uring: add mshot helper for posting CQE32
Date: Fri, 30 May 2025 13:18:22 +0100
Message-ID: <3f8d2967e615ee7a2c34d3ffae6d3aab96684554.1748607147.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1748607147.git.asml.silence@gmail.com>
References: <cover.1748607147.git.asml.silence@gmail.com>
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


