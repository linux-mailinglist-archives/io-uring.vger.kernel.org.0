Return-Path: <io-uring+bounces-7892-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 49EFEAAE87E
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 20:08:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1AD54C83C9
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 18:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFFAB28A735;
	Wed,  7 May 2025 18:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="POMkNVtL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406F21EBFE3
	for <io-uring@vger.kernel.org>; Wed,  7 May 2025 18:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746641311; cv=none; b=TdYlykPPIxv7hdHM1pYpuU8czCgLKKOgmYvkkVJlrq++K4z9/jC32C18EJECvBZ7x1RlZduRIDz1ei6t5y2BzwL7gduV9KxtjV1Hig1X1IWTouLqfmb2u2dDamV9wcwNSK+TQG1NN/jKcMzgH7/vJR4iY/gcEAPgkLwqkR/Aq68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746641311; c=relaxed/simple;
	bh=D1WPrEWJ5f/jCGtl/QHb7CewQRKJbVHg7DUTp7Yb8Gk=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=TfFj6EnUjj69Tq0U1nOuUq7bMMsNbF3VYzBCS3MniE1V3aCMmIDNPZ+Bn5Iq5v3mzH32Dkgljj7CL3OSoxcUMV2LUOXQUkRAqAeWa+xO1pwjd7Zps5+EJbadYknXeT8y4I4UaSsd/2DTULAwf6raCdoS0yLEkO13WhO7RwiDJgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=POMkNVtL; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3d9327d0720so459155ab.3
        for <io-uring@vger.kernel.org>; Wed, 07 May 2025 11:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746641302; x=1747246102; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oImhlmygSRWQ1tCCyTvLlrDCi42+sHZErRlta14HFeA=;
        b=POMkNVtL3cx/ws4rwg+jYC5RaP2JogGYlYFDct9qhr7PiEnyEtZri4aeshJ+xlaB+J
         CmSV18M6IaoboEl3jswYceVZsr9f15Av3M8EPe5lyMobC7Z7tk9wB5fgXla/qV1Oo9pg
         BR0Y3rIgPLfzX6Q9rorQndchg7FsWElnCO5CJE+dwT+kr9FSknJ8u5Gx6FmEic8Z+XoP
         Gir0tb4B38oNKDX/XKsRf8TKNxdI9gY6iVtnUfBs+0uhyLrgohxiWyNEkApSBLk8gU1A
         NFKjqAeDAR7J8AWIApHDXsuEHIjBCL/1O2GEJYcEFj8O+MqwBbN4W02PTPadGBhdSyzM
         ryHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746641302; x=1747246102;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oImhlmygSRWQ1tCCyTvLlrDCi42+sHZErRlta14HFeA=;
        b=G4exsu+rnkx0cUU6yMjOSMhkhb99iEMy/j+/JXCCop4gqgY0aigeghzYYqJdnfkulg
         FaYVDRWX41XZYCOOP07klHng07PP7rcmeyably5Gz9TXElJh4dJUGycHQJd1p/1MTbVg
         wJTvSlMwoO9PzfG/BJ0dzgs7IGpLIAotJ/M9kpZsxHmXbnpa1jTwf1LCaoVCFlmqa0gm
         MsKT1CRguDcJo2VbXdY/jhTZE7gcFWKcV2mIl5xp/6MSvDQJsF/7mzGSighaG/fklgyD
         tqtDCbFcM3r1152vwEt+BYr2cLU5yUL6WtWqdswxoHuIANl7WzOKkjvHQ6joinSb4PZs
         Wi9g==
X-Gm-Message-State: AOJu0YxWywKRSLnhSHfB3XqcPhsN6kMm7MvbjwYgnypbO6YzMSQTxUqW
	PhEBBei4qN1kQWakCFkCpoq3dh3xVZg4HUirQOfJ1nRREZD2FvM4ZYYyaD2ClCMgww5T+utkdgL
	G
X-Gm-Gg: ASbGncscFDfOtBeFRwk46DGI2OuydroMQCCCn/XH6oRvgsBQO2u6n5FVEgil2V92EdH
	+1CsFOSZn1ZvcGnRaCZp/xrmtDjdMuUyrkGV5R3FscVR2DOWe14zYRSWBv1kJMguaxqmYGqNj6O
	d6qdMR21zIaf9mqn0fb2AKSSCWv1XfH+Rngiw9I9lN9HExzr26Df0H0o9QjXS9LR12Tb4q0Iq+Y
	cKs+T2M63dLS3XGMtwOvJacExA7Oopd0tyyuSWo/Yh8kaqKhYEvStqvOPBWQnhRa87vOToPTdh2
	kripoJ9QJhX9c77N8/RUYM4q0YqXPMcDQ4cj
X-Google-Smtp-Source: AGHT+IG1pJzpZRm9vRRWUGX0EXlxeOUhPPvBhdIchrnK6sMh2oqdfB8aqhJwUwe6/T7lCH5olhHzeg==
X-Received: by 2002:a05:6e02:2503:b0:3d3:d823:5402 with SMTP id e9e14a558f8ab-3da738fa959mr53839715ab.7.1746641301759;
        Wed, 07 May 2025 11:08:21 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88a8cda89sm2845324173.13.2025.05.07.11.08.21
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 11:08:21 -0700 (PDT)
Message-ID: <e837d840-4ff7-423a-a7a9-2196a7d44d26@kernel.dk>
Date: Wed, 7 May 2025 12:08:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/poll: use regular CQE posting for multishot
 termination
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A previous patch avoided reordering of multiple multishot requests
getting their CQEs potentiall reordered when one of them terminates, as
that last termination CQE is posted as a deferred completion rather than
directly as a CQE. This can reduce the efficiency of the batched
posting, hence was not ideal.

Provide a basic helper that poll can use for this kind of termination,
which does a normal CQE posting rather than a deferred one. With that,
the work-around where io_req_post_cqe() needs to flush deferred
completions can be removed.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

This removes the io_req_post_cqe() flushing, and instead puts the honus
on the poll side to provide the ordering. I've verified that this also
fixes the reported issue. The previous patch can be easily backported to
stable, so makes sense to keep that one.

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 541e65a1eebf..505959fc2de0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -848,14 +848,6 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	struct io_ring_ctx *ctx = req->ctx;
 	bool posted;
 
-	/*
-	 * If multishot has already posted deferred completions, ensure that
-	 * those are flushed first before posting this one. If not, CQEs
-	 * could get reordered.
-	 */
-	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
-		__io_submit_flush_completions(ctx);
-
 	lockdep_assert(!io_wq_current_is_worker());
 	lockdep_assert_held(&ctx->uring_lock);
 
@@ -871,6 +863,23 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	return posted;
 }
 
+bool io_req_post_cqe_overflow(struct io_kiocb *req)
+{
+	bool filled;
+
+	filled = io_req_post_cqe(req, req->cqe.res, req->cqe.flags);
+	if (unlikely(!filled)) {
+		struct io_ring_ctx *ctx = req->ctx;
+
+		spin_lock(&ctx->completion_lock);
+		filled = io_cqring_event_overflow(ctx, req->cqe.user_data,
+					req->cqe.res, req->cqe.flags, 0, 0);
+		spin_unlock(&ctx->completion_lock);
+	}
+
+	return filled;
+}
+
 static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e4050b2d0821..d2d4bf7c3b29 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -82,6 +82,7 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags);
+bool io_req_post_cqe_overflow(struct io_kiocb *req);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
 struct file *io_file_get_normal(struct io_kiocb *req, int fd);
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 8eb744eb9f4c..af8e3d4f6f1f 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -312,6 +312,13 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 	return IOU_POLL_NO_ACTION;
 }
 
+static void io_poll_req_complete(struct io_kiocb *req, io_tw_token_t tw)
+{
+	if (io_req_post_cqe_overflow(req))
+		req->flags |= REQ_F_CQE_SKIP;
+	io_req_task_complete(req, tw);
+}
+
 void io_poll_task_func(struct io_kiocb *req, io_tw_token_t tw)
 {
 	int ret;
@@ -349,7 +356,7 @@ void io_poll_task_func(struct io_kiocb *req, io_tw_token_t tw)
 		io_tw_lock(req->ctx, tw);
 
 		if (ret == IOU_POLL_REMOVE_POLL_USE_RES)
-			io_req_task_complete(req, tw);
+			io_poll_req_complete(req, tw);
 		else if (ret == IOU_POLL_DONE || ret == IOU_POLL_REISSUE)
 			io_req_task_submit(req, tw);
 		else
-- 
Jens Axboe


