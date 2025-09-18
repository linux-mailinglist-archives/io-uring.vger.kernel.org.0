Return-Path: <io-uring+bounces-9834-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F3D07B86038
	for <lists+io-uring@lfdr.de>; Thu, 18 Sep 2025 18:26:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D4C394E35FF
	for <lists+io-uring@lfdr.de>; Thu, 18 Sep 2025 16:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B4FB262FDD;
	Thu, 18 Sep 2025 16:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="w2B8lHAu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BCE30FC1C
	for <io-uring@vger.kernel.org>; Thu, 18 Sep 2025 16:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758212737; cv=none; b=JB8NhUhwraYQSyXibk3dsNeA8jCaVMdo8Yagf1Mc8zHfOe4iHABNvHvoRchjyy6ZfgIOqqPqtBmvc6DH4fBD95Eqv6gf9yoDtUK9eyWiLGqX8mQ8QgdcIXkP3wCADVTiAe7NCfiUIGTS7ooyuUWYf+JYBx9uI1ctN7qm+3t3TTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758212737; c=relaxed/simple;
	bh=2B9XLPLtSBgBbReI2D2vzIUeYwft0IcekueUPDTkUqI=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=dWbklguSxFW+zfyuWhsfH+rmb6gEkaUsYO9z+u9wu2vlBq31v3Rlg2hopPVFuKlTVoOgfjZ28+LFc/jhzsack1E8dvP2x+vzLIGT0MrVPmnuXAYyPDNA7YlcyoqtVCY3c1raIdBbMVumht8ruPm+01WLDqyjtHc2ZyRoNzYenJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=w2B8lHAu; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-88cdb27571eso43447039f.0
        for <io-uring@vger.kernel.org>; Thu, 18 Sep 2025 09:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758212732; x=1758817532; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lruPCKH/pmDBjX1xu/ZdrZv9NQc5cRGWkBv249Jcr9c=;
        b=w2B8lHAu0K1RV24OB6Z3HFRne6k+9jvIbc90uUm1UFuV/lHKPqnjTC41jPQmA88/hs
         By6UgOkoycrj5Kmx3AbKSk8Rvr6mehbgifTkRSNMMXIDZXo/RqNQlpMG8AAuWN2PiT9M
         Fr44ExRTQJjqpG1XdhmmeJfW8HIbleLDALLmfPhc4l02jLXxPTDwv/mqGt2QdtjH6QGx
         s3BVEMbeuCZxK9yIkB2r/t7nNJnpIIfF/fC2MO0rNoh28Ay7jJQ+RjgGk/tlPGBPdZRZ
         bem3dzSJq+i4GR6cr17TNdBLlms+kCG0Ciqqc+RbLHrCpv+5blz8jH5sYwUC9pmg3KPW
         Jgpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758212732; x=1758817532;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lruPCKH/pmDBjX1xu/ZdrZv9NQc5cRGWkBv249Jcr9c=;
        b=kbCLi8koTScI2zyeJQI346bvfbkW+YyZdJq4SuUOyX41CakORA+Y2YnneJVgBVgd9h
         UEdrTy+w8fcemB8TW/Lc7cgu84DkxTBh0s2VBmYiuSic6vtnnjAodrEu8LA+oDkgsWHT
         Unqeuvdcm2JExcChn8xMWBmh4f6xroTHlHRzb5pJAPyXUjuNPTt57iLPZ94IsP7sgNrK
         7nQRF+giLSsqlmaFJJ5BruzMK4jaqsdWpQjTJc8g4LB6mhICs/g05yflC/ouZjOHoDY8
         fHwSs3i6oIBSvN3DH+dbEhrMw6QoyCG5DvV3TKsErm9wF98G2Umi9/j2CkoH40/QrYDC
         M+Cg==
X-Gm-Message-State: AOJu0YzjAxA/VBvaS6QplBQL7mUPFlZ4AkNhk9FprETlY47xT48N3izB
	Q5RZOEiZUy+Mt1NpQ6X6xwqCi6WUxgb5P4OT8F/YpCnnKSyXo+QiCIisnZd5sdrx1mLxyU+n8vT
	KV1LN
X-Gm-Gg: ASbGnctayDGIopdRK+7qs8QlaPUzVtHyxc5DioREyfnKb5Pm5Ws2WneH1262lYNI74q
	5W9U3dcJc78XIGiTr0cvmXSThphS88na3kpkHoXbbBanG9xmlKhYBVSkvVCEQqQSvWvZaIRutU7
	b13LJEsCEgDKRDOWu1lXYBPxp2TPZ98pMKT5Qy6Tdo9mdWZKzpTyzaoBPLws1d6XqON1Rjn2hRs
	TOSqszm3yDZe3MCPjTC2HSLdrOCsHOfYempryEk6C21pjmAMe6MhF1mDt241RPs4TyCqB55mAIH
	WF1JHjVuVSjpib9fMxeqYp3NKCZ/tQ7e6vQ72lPbcwaVeKtdVXWiCVhVvwoAYGKyMr57BgWQUlc
	mGtqA6VZFM88uyZ9HMj6Q+cqIIPVRb7v4Sz7iw7xzuxBDRy5s
X-Google-Smtp-Source: AGHT+IEEwkYHRZa/Cod1tFles0Tg5eNX+geh7Nx1VecYFHGE1qqTsfGLqQ7Y6a1BMWW1nTFtfoU6Yg==
X-Received: by 2002:a05:6e02:1a64:b0:424:f57:ef58 with SMTP id e9e14a558f8ab-42481911706mr3380425ab.3.1758212732115;
        Thu, 18 Sep 2025 09:25:32 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-53d3e337dd6sm1095701173.26.2025.09.18.09.25.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 09:25:31 -0700 (PDT)
Message-ID: <0d4ae690-320f-47af-b82c-6be6fe562e5b@kernel.dk>
Date: Thu, 18 Sep 2025 10:25:30 -0600
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
Subject: [PATCH] io_uring: include dying ring in task_work "should cancel"
 state
Cc: Benedek Thaler <thaler@thaler.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

When running task_work for an exiting task, rather than perform the
issue retry attempt, the task_work is canceled. However, this isn't
done for a ring that has been closed. This can lead to requests being
successfully completed post the ring being closed, which is somewhat
confusing and surprising to an application.

Rather than just check the task exit state, also include the ring
ref state in deciding whether or not to terminate a given request when
run from task_work.

Cc: stable@vger.kernel.org # 6.1+
Link: https://github.com/axboe/liburing/discussions/1459
Reported-by: Benedek Thaler <thaler@thaler.hu>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 93633613a165..bcec12256f34 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1406,8 +1406,10 @@ static void io_req_task_cancel(struct io_kiocb *req, io_tw_token_t tw)
 
 void io_req_task_submit(struct io_kiocb *req, io_tw_token_t tw)
 {
-	io_tw_lock(req->ctx, tw);
-	if (unlikely(io_should_terminate_tw()))
+	struct io_ring_ctx *ctx = req->ctx;
+
+	io_tw_lock(ctx, tw);
+	if (unlikely(io_should_terminate_tw(ctx)))
 		io_req_defer_failed(req, -EFAULT);
 	else if (req->flags & REQ_F_FORCE_ASYNC)
 		io_queue_iowq(req);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index abc6de227f74..1880902be6fd 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -476,9 +476,9 @@ static inline bool io_allowed_run_tw(struct io_ring_ctx *ctx)
  * 2) PF_KTHREAD is set, in which case the invoker of the task_work is
  *    our fallback task_work.
  */
-static inline bool io_should_terminate_tw(void)
+static inline bool io_should_terminate_tw(struct io_ring_ctx *ctx)
 {
-	return current->flags & (PF_KTHREAD | PF_EXITING);
+	return (current->flags & (PF_KTHREAD | PF_EXITING)) || percpu_ref_is_dying(&ctx->refs);
 }
 
 static inline void io_req_queue_tw_complete(struct io_kiocb *req, s32 res)
diff --git a/io_uring/poll.c b/io_uring/poll.c
index c786e587563b..6090a26975d4 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -224,7 +224,7 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 {
 	int v;
 
-	if (unlikely(io_should_terminate_tw()))
+	if (unlikely(io_should_terminate_tw(req->ctx)))
 		return -ECANCELED;
 
 	do {
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 7f13bfa9f2b6..17e3aab0af36 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -324,7 +324,7 @@ static void io_req_task_link_timeout(struct io_kiocb *req, io_tw_token_t tw)
 	int ret;
 
 	if (prev) {
-		if (!io_should_terminate_tw()) {
+		if (!io_should_terminate_tw(req->ctx)) {
 			struct io_cancel_data cd = {
 				.ctx		= req->ctx,
 				.data		= prev->cqe.user_data,
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 053bac89b6c0..213716e10d70 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -118,7 +118,7 @@ static void io_uring_cmd_work(struct io_kiocb *req, io_tw_token_t tw)
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	unsigned int flags = IO_URING_F_COMPLETE_DEFER;
 
-	if (io_should_terminate_tw())
+	if (io_should_terminate_tw(req->ctx))
 		flags |= IO_URING_F_TASK_DEAD;
 
 	/* task_work executor checks the deffered list completion */

-- 
Jens Axboe


