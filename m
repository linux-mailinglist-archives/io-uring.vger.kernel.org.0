Return-Path: <io-uring+bounces-410-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B833582FE23
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 01:59:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF62B1C240E3
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 00:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3435B15B7;
	Wed, 17 Jan 2024 00:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lf2j/YOK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3F91364
	for <io-uring@vger.kernel.org>; Wed, 17 Jan 2024 00:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705453170; cv=none; b=iLVSYrpc9iq/xmc8B3S3p5Og300TgbNgeXGFAngr1Fy8zvtUTmMmD1IY64BpDFdnOdnxNrBPaxJKQZL6rQLWT9ajFsql2zXULm/WCThDhx0C/PGiUTGqzzik/YtQ0ptxenPCM1hc7HAK//PccTBaR+hISj6HlezwiKWbN5rWM8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705453170; c=relaxed/simple;
	bh=GZOtWT8RhrA8gP3IHGXdFKHEPDDMisYczZFB8QHXRbA=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding; b=Q0te20ZgBkHOCbG21tu96dHxXGOlMLs8ntyGiHeCPUxXuYL0Yn0sfFVci/VLfieQzQ7WtUnMHNpUQ/vV4ZGuM9K0SCWUonbHPmzLlsoOJXGZmPbuAWbOQ6TJChNRww7kPpM3liCWUG3snYu3szBZRmHBkYLidym/dCJdl4tJJec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lf2j/YOK; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-50e7c6e3c63so10877537e87.3
        for <io-uring@vger.kernel.org>; Tue, 16 Jan 2024 16:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705453166; x=1706057966; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QTWrBvavpdON3JOLMJEeULVf6rRDB6nv+5wcPW2bSRI=;
        b=Lf2j/YOKC7CfbjQs0/+cksM38oXSG2LsM3wyJy1Ctf+fGZp6UHVahFUpqP1oO5vDf8
         GpXceG0r01J1RfFO8Ew1lbKpyTqJdjzHDVZoFXbGL/vuNQmm7cT0Qiic4X7vcyH7kcON
         qjrH2do8DOl5HLeSuMgEqgjhj+EG8gto0OlzLR4osnHE4bz0axiWaour4uNHFBhLtiJm
         1BLRiSojNswzAbRJMqzIHJnHlqtTT+DiMB/bkcG4eDTTt/zD8wGqAf4i1VZp9oS9RSub
         mgTl3OwP8fTwjjgyZaC7usHpMWM4DfCtrSHpeCLwuBgXZM8iq350c0tnYay2LJDz7tBz
         X6cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705453166; x=1706057966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QTWrBvavpdON3JOLMJEeULVf6rRDB6nv+5wcPW2bSRI=;
        b=Sf5DEY6Rbt2CgjyKj3m+ppvH2EReYy4d4eQXr3k+PpzjBXSO57E5D5PVfKQ/iLqTjY
         gcbYlDBSbllFSpO6FV0XSq1zBs265fG8BAyqN9YPSkCOhbmgcpPjm6HO1Jr0L7i9gHye
         dWjLCXy4XFdIJwrVyknEkQEY07OaDSZZ2sSTtnm8Q96Im4Gvp78Q8Aed4Zl7aceyVBT8
         VVgkx7cn+8K6ezy1JUnj09UtdwEuoCjxHrDpYlaGhCE14Ing/xILRwf9t8ueZJDwRYdg
         n7nKVMFbTwVP9j7aSmyS9Te227ByE7f+dD5Oj05wAmDE/cAbdQvtmXGMu6q/kWwhiSic
         e7pQ==
X-Gm-Message-State: AOJu0YyLwKGZWLlds1Ei1doBooLS/2PlyxF/bDbYdiMUyHp12eI4i1ZV
	wFfVGgMQ0AgsXJkvuBg89nZ4sxq5Bcg=
X-Google-Smtp-Source: AGHT+IE8i20rvraovxuRj/c4/dDkPwEzPHW7RgfeCEoRwXafNYoXQSSvm1KVNxhvPbDrYV9PKbFgNQ==
X-Received: by 2002:ac2:4a8c:0:b0:50e:7f67:b669 with SMTP id l12-20020ac24a8c000000b0050e7f67b669mr1704452lfp.65.1705453165677;
        Tue, 16 Jan 2024 16:59:25 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.96])
        by smtp.gmail.com with ESMTPSA id t15-20020a17090605cf00b00a28aa4871c7sm7038982ejt.205.2024.01.16.16.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jan 2024 16:59:24 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 2/4] io_uring: clean up local tw add-wait sync
Date: Wed, 17 Jan 2024 00:57:27 +0000
Message-ID: <3007f3c2d53c72b61de56919ef56b53158b8276f.1705438669.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1705438669.git.asml.silence@gmail.com>
References: <cover.1705438669.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Kill a smp_mb__after_atomic() right before wake_up, it's useless, and
add a comment explaining implicit barriers from cmpxchg and
synchronsation around ->cq_wait_nr with the waiter.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d40c767a6216..3ab7e6a46149 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1332,6 +1332,14 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 	} while (!try_cmpxchg(&ctx->work_llist.first, &first,
 			      &req->io_task_work.node));
 
+	/*
+	 * cmpxchg implies a full barrier, which pairs with the barrier
+	 * in set_current_state() on the io_cqring_wait() side. It's used
+	 * to ensure that either we see updated ->cq_wait_nr, or waiters
+	 * going to sleep will observe the work added to the list, which
+	 * is similar to the wait/wawke task state sync.
+	 */
+
 	if (!first) {
 		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 			atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
@@ -1346,8 +1354,6 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 	/* either not enough or the previous add has already woken it up */
 	if (nr_wait > nr_tw || nr_tw_prev >= nr_wait)
 		return;
-	/* pairs with set_current_state() in io_cqring_wait() */
-	smp_mb__after_atomic();
 	wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
 }
 
-- 
2.43.0


