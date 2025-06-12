Return-Path: <io-uring+bounces-8315-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94755AD6BC2
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 11:09:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 415C5178664
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 09:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3453922FAFD;
	Thu, 12 Jun 2025 09:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PVVpzrpf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370A0222593;
	Thu, 12 Jun 2025 09:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749719318; cv=none; b=M9+DjA5tPQU9PiU6FFhtNe8IZ+AqqIc2HZx9Uij3Xpm4pIFs0zrs1CtJFATSpOqpDeUZuHPMwj8cDrgYnPPolz+iVyojraaTob/UFTHvFln1tYFhnQeSa8p5OxrsooUU6m9zN4sgOaYRUJlP7fpDE3V/K+3oHR6nNXoZqaARUNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749719318; c=relaxed/simple;
	bh=eMUl/jO2IVLo6EW2JY+EPAcCS4TRrMK9eFzvDVA1m+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAXq2Y8R4SD+KfpQnomReQohjnXP07Bvs6w+Yvnjwg8m3GYITHdDjbMOcDAd8DX/BuzGJS951l3AEC4PYfvYRFg4k6eoZUcJrsThvI9Hcnk+IruNPaA/grTXTkzXgOFGgWjB2J8EgC98HmvJI0TlxOeU9xzGuWdRB45g3Or7PFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PVVpzrpf; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ade5a0442dfso128630066b.1;
        Thu, 12 Jun 2025 02:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749719314; x=1750324114; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m8eHglNY3BYuvhpWh6vTwMM9gZVFRkTRv6U8o7bWvz4=;
        b=PVVpzrpf5+FmDTrPp4pN0MMEgo1LH+7wjxrWW+5kxdzi3xRqApEadys7pqV4e6SdeK
         6aMKiBt12aOEWaagCJtOrgfQCKhT1V3iosI1igwyV0LbBFXcYehIjqkwWMrOP6n4Mprn
         tYyARcSPNBQdTvW/5kGBVgjNKQuZMAMtTelKmCbB7yKh/DTSc1y0LaADXDb5Xn8wQYJi
         ikUi0n0wTK+ld8rJIxRER8c2H/XjQ02IXZK8eWEa2iARKN91ROsSr7cG9kz0rsSwWYSg
         txkFlbHIjjbt/bX5bm3QuXpeM9+g0E+jSrjLnySYsKR2cYtnmNMzXj7iNsQof9T6SQTE
         BTLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749719314; x=1750324114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m8eHglNY3BYuvhpWh6vTwMM9gZVFRkTRv6U8o7bWvz4=;
        b=bVDArctsge+MzbBrjO7GzqdDSt8l8oF112sbWw5RuZWpep5ZsLbkNEzh/oMW4/KSZP
         QnWJwYirCaCTU3qwvySiB+J12ntsy/8cMUG5xI6JnOakgjmlisxklS6joNX6PGel/PP3
         0/FJRa0qkRbCrqIKjkQgaEudSCZfQxyt45Ec5s6n5tT/J9g2aFypw8KSKDzCdD4ETKK3
         +vqeCL6CijxfZtCmXn2hxve1mCuYkMSSEJ7KV1f/TVfzPbUjg7Oz82Ms8uvyEGo3kQ2y
         3qSIioONKUA+Ncji69qWjFCTiuRe2byxXQebNF+ALJV+qCaVn8d5GFv9sOVtbxe1aziW
         9mfg==
X-Forwarded-Encrypted: i=1; AJvYcCUwFanPsO9cLioil+F30agOWhssQ8GWUDAwy0mQloMdwV9UcewVaoIYnQ+BGMBh2b1GL1MrIFc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmkY/GQkaVoAzwwoVPeYvFl0VpFq9nB9iXJXfdlMimLGT0ZvV7
	cSy+qHC6XiAMTThJj+1p17NsZFWzDv4m/A6wGRXBl0MlOnhA2lHtrk2bdLHo0Q==
X-Gm-Gg: ASbGncvf5kRvy3thjmZgRgXqRLaBvm5Y9ECcao4P2jMteP2d/hHWhJsqtMlK1e0uDga
	pAppaW+u75c5LKAEYieYpvoBzGMbUWx8CcP7nJFppvdxVZNjiyLoXkCMGTLH3nQUYM6JPc9SOuw
	aTcKJPCTIZIPd/zJOkAckCrZImU9KRp6EPlGm0QVAcaAcF6hoSaxjALk671V9ljlbUL68YPb09c
	HTCmFBwou15lsAlyshpnb7JaT8vTw9/bITVjL3zhBtrfF66h5y2P2rBTh/rKAG9bEH2GcJuYRz1
	Cdcfhiz8zFC6OmjNdcMidc11dvsVFI4+HVedRXM/EeP6
X-Google-Smtp-Source: AGHT+IGO21p0+UDlzAcDRb4++NRWCVjd2h8w/OuEG9enAjOShI6YOC4bhFADbr4cGAJfN/qdBzGvQA==
X-Received: by 2002:a17:907:706:b0:ad8:7656:4d75 with SMTP id a640c23a62f3a-ade893db0aemr593887966b.12.1749719313854;
        Thu, 12 Jun 2025 02:08:33 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:be2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adeaded7592sm96883166b.155.2025.06.12.02.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 02:08:32 -0700 (PDT)
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
	Richard Cochran <richardcochran@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jason Xing <kerneljasonxing@gmail.com>
Subject: [PATCH v3 4/5] io_uring: add mshot helper for posting CQE32
Date: Thu, 12 Jun 2025 10:09:42 +0100
Message-ID: <84c0a25a6f23db997b439cdc4707118b0d71577e.1749657325.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1749657325.git.asml.silence@gmail.com>
References: <cover.1749657325.git.asml.silence@gmail.com>
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
index 98a701fc56cc..4352cf209450 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -793,6 +793,21 @@ bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow)
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
@@ -904,6 +919,31 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
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
index d59c12277d58..1263af818c47 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -81,6 +81,7 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags);
+bool io_req_post_cqe32(struct io_kiocb *req, struct io_uring_cqe src_cqe[2]);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
 void io_req_track_inflight(struct io_kiocb *req);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 02cec6231831..b228b84a510f 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -328,3 +328,14 @@ int io_cmd_poll_multishot(struct io_uring_cmd *cmd,
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
index 50a6ccb831df..9e11da10ecab 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -17,6 +17,10 @@ void io_uring_cmd_cleanup(struct io_kiocb *req);
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


