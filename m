Return-Path: <io-uring+bounces-7757-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88007A9F16F
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 14:52:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 528167ADD2D
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 12:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9918926A0C5;
	Mon, 28 Apr 2025 12:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZH9hmUkO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9FA2690D0
	for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 12:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745844712; cv=none; b=th2/63biYQGRCLJORYjfzRwWfnm4l/yOGGgagHvbe2kR2U5PHNG6FF+XzIyjdFByNf7sq0sQnf9zCXv4Q23tzwSUHFdzx8yaUNhuW1OqT0NIQbIU/R1+//gnnpc12G/btxVP7b5Tk6paocn7iN5EoziK8AuHrHv79X6+IM6qVcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745844712; c=relaxed/simple;
	bh=hRNSmYBUpDj5oLGdybd3jIqy/zX62G3ra3LYik/3S48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAuxXRMI1M5Vhyt+JsrnoMxrdK8URBcWcqyQk8jZZb6vlDGyTtpwhv9vNJn6jfdYUIe7TOaHRXARfg9w6hxUU4iOJWMIbcBeAMn6vUZ7RfpIBiFML9OBvV+PLEEIgkXmX8XIc0XlaF9Tkk6PoSquYTqXtVsw4qk5MXDlTtMC3G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZH9hmUkO; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac2aeada833so925831666b.0
        for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 05:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745844708; x=1746449508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OrbZZcU3RaVziA+FuM33G7+4L1VQSPoKJwHN5GGuHD8=;
        b=ZH9hmUkO35oXd0YpXr1N/TqhlV5+G1g4wOxO6BGMYSpdNkINqNGJTOKcmI0+lyT36I
         DQy1wsntp/Ux1nLt6+03KrtCdYqJFjeW/KFRduFns2sldkGDaU7U3Mlmv6yjD3XW7EPr
         d2Nt8JJj46WMJJDnfgzy/EexvHLagA7sjDpwMk1JwgCVnNHbPDWOxFM7Eo/wJCjktozm
         StDyytbjR26iop5HeLVsTt2RxFCHFEVCUU1F4J1gRkIT7raRBWTq7kiebYXbknreifWv
         ykzMhqNav4Z843Mu4ZYHLRb8FoA/laztH2hhMMS5oWzgAnbRrI/BIUdQ2YvaaHkM2yLm
         9wIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745844708; x=1746449508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OrbZZcU3RaVziA+FuM33G7+4L1VQSPoKJwHN5GGuHD8=;
        b=ptMyZXVXm7gtNP7JwFCaN4SDpWi1ye2MZjpeiPhQK/EZcr3ME9+Pa8FxSIubs/9sGk
         4iU9Br7rn6u1A4y+UdS9QT57DZUFXY183PWPSVR2h4GYOPPxCyzSOOckyu3RZ3KzCWXJ
         RyZAkY9HcKEPcflUlaDQITVRNNFBC7LTUNcwKdAwxRhRcUBL2UKNOjQsVaLEhzVGxYqM
         WiTSUlqBKeWyCGaE/tZtbKvmWVXBhy11Haf3Ht3yPIzZl8CAYeIhl0xaDAzbH2krFVRJ
         MUXvhF2kXqzUYbKA7H+B/bfJzsWWWiE2YvJkwUlVcHOq6FHllQrIrNno4qCCAdZAnCuX
         3WSA==
X-Gm-Message-State: AOJu0Yx/KH9yBQbDzqX6qkKXtf9qsTYigkmsHe9nMfrHimZAUl3lFEpw
	fjGqCNNresdhV2JImUm/wMzy+akhLkuNGDJNLVrK/ZcAUUP6mEBQaKvhvg==
X-Gm-Gg: ASbGncsCxnHvA51NQ5hBmn2euCmOC8Ztmo0GHZQYCB7huisb708SyRR71I7w1fIBw/M
	+9dFoloMsJ4E5yIu8tRrL8s3rxHEZVAli39hUNyx8lIPXhrNzxHgzxmOi/XzjpjZr6DnkevWArk
	47oNPwisTRwhpBrtqEyWz372d5nZYz6DNxKmQV2Y4RGH8VlS4DrPYwWcefRQFgs+ietqMQnhQ4c
	WZFceHjZm/jPW2M5ol+yAP5DY2Z4z7m1VejtE20mZaey1pXtISP1Mo9b117fJRt2jSR8XVhjsd1
	5/bQAw56SiWPTKfpwGi083C+
X-Google-Smtp-Source: AGHT+IEqiKl6mu5DumOeyketX5BIktavFDRRe1xI9ahNPJel1PMBZp5euMgG+diPMJhvWUNpXmN57g==
X-Received: by 2002:a17:907:7255:b0:acb:aa43:e82d with SMTP id a640c23a62f3a-ace7339d48emr1115597166b.3.1745844708400;
        Mon, 28 Apr 2025 05:51:48 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:c92c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e58673dsm613010766b.76.2025.04.28.05.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 05:51:47 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>
Subject: [PATCH RFC 6/7] io_uring: add mshot helper for posting CQE32
Date: Mon, 28 Apr 2025 13:52:37 +0100
Message-ID: <0346e8e926c848d29eeb669422b24b621f30d10a.1745843119.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745843119.git.asml.silence@gmail.com>
References: <cover.1745843119.git.asml.silence@gmail.com>
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
 io_uring/io_uring.c  | 41 +++++++++++++++++++++++++++++++++++++++++
 io_uring/io_uring.h  |  1 +
 io_uring/uring_cmd.c | 11 +++++++++++
 io_uring/uring_cmd.h |  4 ++++
 4 files changed, 57 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index dc6dac544fe0..ca341f9d7b42 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -807,6 +807,22 @@ bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow)
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
+	ctx->cq_extra++;
+	memcpy(cqe, src_cqe, 2 * sizeof(*cqe));
+	trace_io_uring_complete(ctx, NULL, cqe);
+	return true;
+}
+
 static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 			      u32 cflags)
 {
@@ -880,6 +896,31 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
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
index e4050b2d0821..6a8e3c79805d 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -82,6 +82,7 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags);
+bool io_req_post_cqe32(struct io_kiocb *req, struct io_uring_cqe src_cqe[2]);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
 struct file *io_file_get_normal(struct io_kiocb *req, int fd);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 94246ba90e13..6bc84877d205 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -322,3 +322,14 @@ int io_cmd_poll_multishot(struct io_uring_cmd *cmd,
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
index 40305a7de038..d504b6b08a56 100644
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
 
 int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
-- 
2.48.1


