Return-Path: <io-uring+bounces-10591-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A27C574DA
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 13:00:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9F1EC4E5031
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 12:00:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A252A34DCCE;
	Thu, 13 Nov 2025 12:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QhXYipQy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA6B34CFCE
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 12:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763035204; cv=none; b=UpOOAYPEyOXwcCk+I44otv99TkBsHmUbK+4X01jwo6DZ9jI2GRWstAEayq8PGAvvj8vBbMFpUYfuUigT8lLZn/37LvXBj4gdixJ6uIlhuwXTpsaLxMZn3ETzJqhHnAgqp5pNyD5ksDvMUUiMbkHvPb12jAWfCqHEI85wHXMw+74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763035204; c=relaxed/simple;
	bh=kw+rVJKSmgWfFnXW2IBb8LLqAYI+Y/DTjTNveNmy0nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1ybLED7dl0GcYzFaqG61IquEubjj1lE5DU0qvgVUWnSvtauLhoq7nh17KSprjHo8kn/5vcKsf03hKWNAjJ+Jw0CBGQcwyzZG/2yMLEG6tZxqulMwBOiday3i5e1Ahv2yz97bCnpBwtvTjC8mOW6EaYMqkG3Zc7QXH6r2RRKfR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QhXYipQy; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-42b566859ecso299646f8f.2
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 04:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763035201; x=1763640001; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5GOu542yEgcZSs1qDZY2K7/DpB7JFIE7JTD2LB7sRzc=;
        b=QhXYipQyRH/U38a0eMDInNRUHyG9fwVajNgvArJJVNNt0d9LKpijNNgGsGus3k+THu
         r7FUDfSOW0ZIM9gdPdMtg1ZNGQ6rT9PJmk9LTfHXSJY7KIesCJXufuaLiMXIyfwpjNHV
         f2cjk3sgnTCa9bA5Xs07izQUrj5C7oc0mhX3+gS0/HJ24ENWUc/n6fsIDQGckkwiBlYY
         z4Ayl3c7OwJubeFPC2jprvS1BPDWUoHW+RILfiSIFLY3U7CR/dAsz6VtZqRCIlHVH1d3
         Oz0iLW43vT2aE/zQIma+ZYP0AU/g7GCZwG5DY3Dp/ASSqSAikye0PDlBZAQ+fejiLCFW
         +VaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763035201; x=1763640001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5GOu542yEgcZSs1qDZY2K7/DpB7JFIE7JTD2LB7sRzc=;
        b=cagbhDhZZyDahMDB2uBG21bPswAq174qGrq1XLUz6yqxH1QwoBm4CHkdOEcYxwNaFk
         byRLtbC34zWTJLnF/jArhCOc2Z7OnApe+pUnkYcY2y0p2Q/mwtGB5xVOR0CaDPTI+ZVs
         5o7beRxwzZFR0lcw3XH7fHPQqBQPA2UGLh9+x/SYi79WUkeDscXBau4VV99j4FlVLCFc
         3V93IhwZszZHoalZIddqyT8IfYrAJLWZ3EeSwnrseDnidK+cHjba6Vj0MAifcC/2hsI/
         HWj4VDpPqv4e5FcH3XXYtdWHaXzasCIhSLNWwgpn6wr1GS6V3ks0ognU/leiQmWHroB+
         giNQ==
X-Gm-Message-State: AOJu0YxzEwMZfwfB6w2DvtwMRyrw6Z+tLJwbOQt6F/hdONnOHLIiNaDG
	x718y0YZNTtTMOmudDViZhXvA+JIBKiDMPXv5fZhZOcNZpgvzx5E03ouhoeVFQ==
X-Gm-Gg: ASbGnctcj87p4yRXwkN6vuGs94X6hF6XE3m/cmwkWBuc+5SKPVY2YZmQkui8GN0VgCQ
	WCsqG3T/TeZ0MnzK+wWVsGGNfdE0EJNmhMYGHx8INAuq7rkbs3xvlH9fdOww8Ck92X3TjEUknQ4
	pyDtTaAEvkvMyCDadbIj3ImPEH91L3VZUJcZo4WOQrL+a+iB3f2UPHIU5P3ejPAXlTtnOH/h9hp
	ySMLUcTTg+5izfnlNNcJr8UpKmFBNLr8RkaoPUfu5UaD/uEhw+/mY+WtuAu1fwG7tRmFcT8Lyxz
	DN09K+NSUQeW3OpCXtRzQzgwrEp3W/dCuppTWC/+TYBp4k+BviOGtI+Qk1ZneRKx1X5PC2tWMmx
	6chYDcRYfDuidexRZyfGytCZiIadgDDmhlZV1VeQkLyeqI5DDi1lnQuItCLE=
X-Google-Smtp-Source: AGHT+IG7VDOdf4WuH5vCO4d4EJGl73lrKneKoixpCYuTVy/wzv2Nj6HjPkEPsRbWfrkZQ44v6Kt+pQ==
X-Received: by 2002:a5d:5f87:0:b0:42b:3a1b:f71a with SMTP id ffacd0b85a97d-42b4bb98a4amr5934332f8f.23.1763035200695;
        Thu, 13 Nov 2025 04:00:00 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e85e6fsm3686816f8f.18.2025.11.13.03.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 04:00:00 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	Martin KaFai Lau <martin.lau@linux.dev>,
	bpf@vger.kernel.org,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	ming.lei@redhat.com
Subject: [PATCH v3 01/10] io_uring: rename the wait queue entry field
Date: Thu, 13 Nov 2025 11:59:38 +0000
Message-ID: <b5491d87c899bc001560a074a1dc11683f8ecacb.1763031077.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1763031077.git.asml.silence@gmail.com>
References: <cover.1763031077.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

"wq" usually stands for wait queue and not for entries. Rename the
wait_queue_entry field in struct io_wait_queue to "wqe" to avoid
confusion. It's just a cosmetic change.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 14 +++++++-------
 io_uring/io_uring.h |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d11d0e9723a1..3eb4c9200bb2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2453,7 +2453,7 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
 			    int wake_flags, void *key)
 {
-	struct io_wait_queue *iowq = container_of(curr, struct io_wait_queue, wq);
+	struct io_wait_queue *iowq = container_of(curr, struct io_wait_queue, wqe);
 
 	/*
 	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
@@ -2493,7 +2493,7 @@ static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
 
 	WRITE_ONCE(iowq->hit_timeout, 1);
 	iowq->min_timeout = 0;
-	wake_up_process(iowq->wq.private);
+	wake_up_process(iowq->wqe.private);
 	return HRTIMER_NORESTART;
 }
 
@@ -2646,9 +2646,9 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	if (__io_cqring_events_user(ctx) >= min_events)
 		return 0;
 
-	init_waitqueue_func_entry(&iowq.wq, io_wake_function);
-	iowq.wq.private = current;
-	INIT_LIST_HEAD(&iowq.wq.entry);
+	init_waitqueue_func_entry(&iowq.wqe, io_wake_function);
+	iowq.wqe.private = current;
+	INIT_LIST_HEAD(&iowq.wqe.entry);
 	iowq.ctx = ctx;
 	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
 	iowq.cq_min_tail = READ_ONCE(ctx->rings->cq.tail);
@@ -2695,7 +2695,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 			atomic_set(&ctx->cq_wait_nr, nr_wait);
 			set_current_state(TASK_INTERRUPTIBLE);
 		} else {
-			prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
+			prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wqe,
 							TASK_INTERRUPTIBLE);
 		}
 
@@ -2743,7 +2743,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	} while (1);
 
 	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
-		finish_wait(&ctx->cq_wait, &iowq.wq);
+		finish_wait(&ctx->cq_wait, &iowq.wqe);
 	restore_saved_sigmask_unless(ret == -EINTR);
 
 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 23c268ab1c8f..53bc3ef14f9e 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -102,7 +102,7 @@ struct io_defer_entry {
 };
 
 struct io_wait_queue {
-	struct wait_queue_entry wq;
+	struct wait_queue_entry wqe;
 	struct io_ring_ctx *ctx;
 	unsigned cq_tail;
 	unsigned cq_min_tail;
-- 
2.49.0


