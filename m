Return-Path: <io-uring+bounces-7831-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CBC1AA86A1
	for <lists+io-uring@lfdr.de>; Sun,  4 May 2025 16:11:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6FD13A9D28
	for <lists+io-uring@lfdr.de>; Sun,  4 May 2025 14:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 590691865EB;
	Sun,  4 May 2025 14:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nEWeXHCl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD0815CD55
	for <io-uring@vger.kernel.org>; Sun,  4 May 2025 14:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746367882; cv=none; b=rsALkL5g6dcIH81sYhBvf9ZBp2OpWFRZc9hjrb/yTCx+FKvuFmi0VOre907bg25VEC8v5mAspSj7xT4JvaIOMOgmXzxxO3WUN4gMZ3jgTzeQEn4lk+vFJxGtq2hLNLLsxyxXU1bwX3tjXqOi+oNuDEUUW6msno1Aa7+O6vjlOew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746367882; c=relaxed/simple;
	bh=DWqOOkDY1AYTzjUgkDIIvfpQsv+AmPDkcC1QS6W9f/s=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=Y2BcVOsTS4+qcbZ0vxTF47niao7NDN6ITtwuixTn3Mm2oUxjISFCksZSW5mgi4lEPMw7hib0dOohh43ynhle7fqM5gPcyCeeTo+huNZmuhG8gxE50LN4aPIvWY6mdKCu+au6TiXsI7AkS7k03mUqu6O9+G68fHlxkAzWByoydJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nEWeXHCl; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-85b3f92c8dfso122978139f.2
        for <io-uring@vger.kernel.org>; Sun, 04 May 2025 07:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746367877; x=1746972677; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fLI6qT9QwV4QlyXapg2ZA8Q3CuVPsGI3I7EmfdUAfBI=;
        b=nEWeXHClQgc0ckhADchrmTWkKGSKpiV2dYIA4hB4hF7T9IiuODZT/qWnsHnQxU9yVh
         wN3cePcbtCmcK6yW65mCllu2ywK+8etpZG7i7iZ06M8cZB1haVCgHquxQkBPPgMgTgsu
         MtIwJzhUQcbDPM2L+0CslPPgq3mjWgg4JptZcap/uN6VrXdVAY4BHw+KoXbeUCxNVQWY
         d0uCDCemubhMtWi8MCYketBnk53vvGBwlZvsuFZ4D5O0LVZb0nYKmKSLvSSe56kQHyX8
         +8709NwP8J5jNScvDFclGHWnEYO0vp4xkAInl0YzJIFMEdOJEQkBrM1AIDQGeUL2XSnt
         IblA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746367877; x=1746972677;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fLI6qT9QwV4QlyXapg2ZA8Q3CuVPsGI3I7EmfdUAfBI=;
        b=I+zUh58osXnyXnmKkqSoHOtR2RMa7pRr3b1ozKtbHZTcimquXwDKE0pqBddUeZIIWm
         IehXVnnZAKvg0P2ZguBJDna1C+Kd0P5JSIghmjugyv+aXjuA8iaoG0x8PcKuoCjJVZnH
         LMNfOEBSDW0ztaE9r4gnm1ANvJaziNviNZNC5YdPjWMWD34WIGzxr0GaFEpUGWcoxWqa
         nQ919SaIwy3h5/Kv0GAcAzs56BA9km34CMAmK8Tp/GKEyvWiH1n3R7DqTdPu1xJZf9iD
         TVrB+Rc2aVrPp3BsiwLsg0C+JmIk7jd2h+r8m/qQKT4JR4WMo5Q6zXyRvu4EpUqoojFU
         GENg==
X-Gm-Message-State: AOJu0Yy/FrfnlTydxjo/VyspZNcRLr8XM1dh7zih4FB8/Eoj6S5XfuoM
	HOYLklU+XvvD90NORoXqOmPbAnjoMcCizzVOQPV7Tfi18sRIJRQVcWs9McDb9lKB+ffwVYAkPSS
	W
X-Gm-Gg: ASbGnct3DXFahtzpqq6jg8lTHgGSZLGgRLN5UUJeSgUlPCoK9cRx+/+nFvlTyBCzOy5
	0oitQR6/e55N6R/hA6h34FGg59OEopc0YccIFe4sLryZT/cXSK360df8Ozm0dRTrN2HSlxnb3W1
	7v+Ql84ySIJGQroJrNFBVZlhhc2R6TIqD6lo+GomMGMO9bKmUZqcIOvH3OhRQRwgD1Gvhg8nF3D
	GxuwrWjMoIjcXhKhEkMyCAVgXnhDnQ8sLK/AMHcyOs2lzJI5MjP+ROiUMu69BseZ6Ash0VLd8FP
	uy5jhuoJhmqWzPgiNVcpw6vc6xLxSx06DmxK4A==
X-Google-Smtp-Source: AGHT+IFgYYrPjvjFfR6wf4/OnBBhwBvoaYe8outjfnhPtFPSMGSzd9fZ2hVXnvwXO+bVStwi11cmQA==
X-Received: by 2002:a05:6e02:1f87:b0:3d4:2a4e:1272 with SMTP id e9e14a558f8ab-3da5b344880mr37072555ab.19.1746367876808;
        Sun, 04 May 2025 07:11:16 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88a915d2dsm1307634173.48.2025.05.04.07.11.16
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 May 2025 07:11:16 -0700 (PDT)
Message-ID: <cab9674b-4a5a-4091-9b77-59f5127286da@kernel.dk>
Date: Sun, 4 May 2025 08:11:15 -0600
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
Subject: [PATCH] io_uring: always arm linked timeouts prior to issue
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

There are a few spots where linked timeouts are armed, and not all of
them adhere to the pre-arm, attempt issue, post-arm pattern. This can
be problematic if the linked request returns that it will trigger a
callback later, and does so before the linked timeout is fully armed.

Consolidate all the linked timeout handling into __io_issue_sqe(),
rather than have it spread throughout the various issue entry points.

Cc: stable@vger.kernel.org
Link: https://github.com/axboe/liburing/issues/1390
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a2b256e96d5d..769814d71153 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -448,24 +448,6 @@ static struct io_kiocb *__io_prep_linked_timeout(struct io_kiocb *req)
 	return req->link;
 }
 
-static inline struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
-{
-	if (likely(!(req->flags & REQ_F_ARM_LTIMEOUT)))
-		return NULL;
-	return __io_prep_linked_timeout(req);
-}
-
-static noinline void __io_arm_ltimeout(struct io_kiocb *req)
-{
-	io_queue_linked_timeout(__io_prep_linked_timeout(req));
-}
-
-static inline void io_arm_ltimeout(struct io_kiocb *req)
-{
-	if (unlikely(req->flags & REQ_F_ARM_LTIMEOUT))
-		__io_arm_ltimeout(req);
-}
-
 static void io_prep_async_work(struct io_kiocb *req)
 {
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
@@ -518,7 +500,6 @@ static void io_prep_async_link(struct io_kiocb *req)
 
 static void io_queue_iowq(struct io_kiocb *req)
 {
-	struct io_kiocb *link = io_prep_linked_timeout(req);
 	struct io_uring_task *tctx = req->tctx;
 
 	BUG_ON(!tctx);
@@ -543,8 +524,6 @@ static void io_queue_iowq(struct io_kiocb *req)
 
 	trace_io_uring_queue_async_work(req, io_wq_is_hashed(&req->work));
 	io_wq_enqueue(tctx->io_wq, &req->work);
-	if (link)
-		io_queue_linked_timeout(link);
 }
 
 static void io_req_queue_iowq_tw(struct io_kiocb *req, io_tw_token_t tw)
@@ -1724,15 +1703,22 @@ static bool io_assign_file(struct io_kiocb *req, const struct io_issue_def *def,
 	return !!req->file;
 }
 
+#define REQ_ISSUE_SLOW_FLAGS	(REQ_F_CREDS | REQ_F_ARM_LTIMEOUT)
+
 static inline int __io_issue_sqe(struct io_kiocb *req,
 				 unsigned int issue_flags,
 				 const struct io_issue_def *def)
 {
 	const struct cred *creds = NULL;
+	struct io_kiocb *link = NULL;
 	int ret;
 
-	if (unlikely((req->flags & REQ_F_CREDS) && req->creds != current_cred()))
-		creds = override_creds(req->creds);
+	if (unlikely(req->flags & REQ_ISSUE_SLOW_FLAGS)) {
+		if ((req->flags & REQ_F_CREDS) && req->creds != current_cred())
+			creds = override_creds(req->creds);
+		if (req->flags & REQ_F_ARM_LTIMEOUT)
+			link = __io_prep_linked_timeout(req);
+	}
 
 	if (!def->audit_skip)
 		audit_uring_entry(req->opcode);
@@ -1742,8 +1728,12 @@ static inline int __io_issue_sqe(struct io_kiocb *req,
 	if (!def->audit_skip)
 		audit_uring_exit(!ret, ret);
 
-	if (creds)
-		revert_creds(creds);
+	if (unlikely(creds || link)) {
+		if (creds)
+			revert_creds(creds);
+		if (link)
+			io_queue_linked_timeout(link);
+	}
 
 	return ret;
 }
@@ -1769,7 +1759,6 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (ret == IOU_ISSUE_SKIP_COMPLETE) {
 		ret = 0;
-		io_arm_ltimeout(req);
 
 		/* If the op doesn't have a file, we're not polling for it */
 		if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
@@ -1824,8 +1813,6 @@ void io_wq_submit_work(struct io_wq_work *work)
 	else
 		req_ref_get(req);
 
-	io_arm_ltimeout(req);
-
 	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
 	if (atomic_read(&work->flags) & IO_WQ_WORK_CANCEL) {
 fail:
@@ -1941,15 +1928,11 @@ struct file *io_file_get_normal(struct io_kiocb *req, int fd)
 static void io_queue_async(struct io_kiocb *req, int ret)
 	__must_hold(&req->ctx->uring_lock)
 {
-	struct io_kiocb *linked_timeout;
-
 	if (ret != -EAGAIN || (req->flags & REQ_F_NOWAIT)) {
 		io_req_defer_failed(req, ret);
 		return;
 	}
 
-	linked_timeout = io_prep_linked_timeout(req);
-
 	switch (io_arm_poll_handler(req, 0)) {
 	case IO_APOLL_READY:
 		io_kbuf_recycle(req, 0);
@@ -1962,9 +1945,6 @@ static void io_queue_async(struct io_kiocb *req, int ret)
 	case IO_APOLL_OK:
 		break;
 	}
-
-	if (linked_timeout)
-		io_queue_linked_timeout(linked_timeout);
 }
 
 static inline void io_queue_sqe(struct io_kiocb *req)

-- 
Jens Axboe


