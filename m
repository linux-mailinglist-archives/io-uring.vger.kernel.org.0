Return-Path: <io-uring+bounces-8359-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B60FFADAC3C
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 11:46:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A085171ED8
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 09:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F1DD270578;
	Mon, 16 Jun 2025 09:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jgc1CcAs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC2926E718;
	Mon, 16 Jun 2025 09:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750067135; cv=none; b=L4U2rfIp6vTzIYi0dWGDxbX2W85gLLvAZHSxyChKC/yZUQKDsKu9570HsfevY1IacLDG6jXuJdQyZq9VHrlwsKjlWy0AxnOafvzuhj8nqOsH6MtpLbR4TmjeMRiKLtehkq/DEpkFTfp2hHcqCsfaXeLSVyGW8RUi6epZsDFHJas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750067135; c=relaxed/simple;
	bh=eMUl/jO2IVLo6EW2JY+EPAcCS4TRrMK9eFzvDVA1m+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENOFv/0r94ghJmvWmvswh0aWESSf/vPtYcLtmXtNeMjzlVk9Tf9ASPFNlbqeB0b7sOFAH7byuOniNhATitMOtAcUmv2iL2jZ1Eor3dnQBVMPal+Oeln3xn8l9iyMY7xvUUXsrS/DAaUHWfkjfNL1sR4omdNj93tPwhkROPptgkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jgc1CcAs; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ade30256175so835986466b.1;
        Mon, 16 Jun 2025 02:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750067130; x=1750671930; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m8eHglNY3BYuvhpWh6vTwMM9gZVFRkTRv6U8o7bWvz4=;
        b=Jgc1CcAs+Dnq5nbSTbTcks+sntKuBgikFHNt+sp39A1gqUg3j/VdmC3gRISu6IL5Fg
         p9+AMcNHLOMw9USCQIq4Kk1PtQoR4hRNBDHITDJQE+7F7F56N805bDKqVpclbPLPZsu7
         KQe9B/9i6m5Jp6iGK3VXAwWNf41udX5gY4ow3qmnJYpsiumj5Ln22fYVoUS/v2qaYC4x
         8D+wKDNNUXhIk85THUQ7/6BJ7xVjCS86lBwhCpppcg48j6KE3mI/3PgHerMJSzdqmsfF
         fWYuEPlEMbpIIa2KVP4d7nnMI1BZ/Qv39QyeNZ8om5osI2H3trcGk6V/NbvA534L9Q2r
         vkBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750067130; x=1750671930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m8eHglNY3BYuvhpWh6vTwMM9gZVFRkTRv6U8o7bWvz4=;
        b=X1LlslMMr6SJ0RLQlnmov/35UESTCYXqbe/4lAklqLP1EMP9qL+JNX//aHHa0WFD0u
         lbp5V/bLlPIPPUDpT7t7YzWL6yp4ahO8AxS4xtlskhCK1oimoAqAyUt/E86aN0UVqYGq
         ma80v+ycq/9i9fK7/3AtYKR0ZF6YqWnlkZLolcCEro9ucJvWlU5e7+CHz2YqtcS4OhR/
         SRkUkqeO3lYAmJ+3cStpYKYhwUMhuselZx5+wuOCitriVyPpzCmuwH9gProVymRCmrT9
         /9TnomJdzVaiHo/JAXr3Yr4S6kSTPXkXAMWx0zcEH0U1FRuYS3+w5r05YjMAbtpQBBtS
         o3NQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1n/MsLE99xLzx+xTDwUCywu6XbKqfzfa+KGA8r8+R01bsFHe25ilkhLTybaEAR/B4PaFE3S8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8F7phnHJYG5VV6FYbZEepCuXfCyt0UDBCoitoWn9ihBl9vXiI
	tfTIt8EICucd6JqOabCdrB2oWcLpA/J4mIx11zxt6d/LJj2j3TxXHLopnuiOXg==
X-Gm-Gg: ASbGncuXD9FEIEnt7HlLAPqtEhBJfcdiP5Jh9tH1mlaIYFdXo3gyJbBVtm0GaDkwLlm
	k31l5yZp3yLMlJFLPsD6S0KYdg/pp+rm2ZwfsM3/yWD2dyAFr8KY+AdBCCxj3OoqewAL820ucox
	xrPo0pK0xnh1eRz3Is2Y29J1J3F3laDGl8ka/12DZm6V1g343eswtAxciwr90/k61P9OHjy00iw
	L5sP8Pp9DNdFIr2WHfhi/KdDAE7jbMjwJyI92/RGGSVSO5+K7MHURsAm6AmsAt7dqNYkGOMaLjh
	qIAs0I9D6aVk672e1UJAL/iUyfwtVZJsJu5HzdRcpcVAug==
X-Google-Smtp-Source: AGHT+IHCScF2wGcthzi8RvbG6PLfuyqdoIF+HqgV4YApsWpTOMSnCmNbv97g0NEyv7Y9dPN6HCdGng==
X-Received: by 2002:a17:907:3e04:b0:ad1:fa48:da0a with SMTP id a640c23a62f3a-adfad40bd10mr725699166b.35.1750067130090;
        Mon, 16 Jun 2025 02:45:30 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a3c1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec8159393sm629363266b.15.2025.06.16.02.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 02:45:29 -0700 (PDT)
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
Subject: [PATCH v5 4/5] io_uring: add mshot helper for posting CQE32
Date: Mon, 16 Jun 2025 10:46:28 +0100
Message-ID: <c29d7720c16e1f981cfaa903df187138baa3946b.1750065793.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750065793.git.asml.silence@gmail.com>
References: <cover.1750065793.git.asml.silence@gmail.com>
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


