Return-Path: <io-uring+bounces-7442-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96A52A82671
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 15:41:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E71429000B7
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 13:41:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F15A0264A85;
	Wed,  9 Apr 2025 13:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="g3mwdPSh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA8A2641CB
	for <io-uring@vger.kernel.org>; Wed,  9 Apr 2025 13:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744206068; cv=none; b=FOI3/bWLQsrk49iJKFmWO6aTVq4AVoXzAZyvZXs9O86vxnCqcKRqs2Yj/oiBInyobml2ov+g9YMapjS+rlQ5bhGPk7Kp3UJ/Ak/BNBIYDA0pBFY+hPud0jqj9WXgnbf128F4PaAyDlovn5BWiKEjv8DsHZbqD88IbYZViqdY70g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744206068; c=relaxed/simple;
	bh=27DHst1S12oqLMIhtZ9NLeDleZ1uTNSrSckCS8D3bdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MD775pKEWGAdKCIJpV6aUvM4HEY1yG8mMi7SccUWegSCmzXL9U+I1p/yu2doH5xFJsKwP5U/hujudYt+uGG7N+kzPsId50zHqieCvMaSh6KOlM+42M/6PdHH6lfoPOVAl1cFSVWj9XCzIEAl611sn8q/p5Eo8b2T5YNVeVIjQws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=g3mwdPSh; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-8616b7ad03bso1830839f.0
        for <io-uring@vger.kernel.org>; Wed, 09 Apr 2025 06:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744206066; x=1744810866; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Ez1BnkBDoh4P/XSdyZjO5+p/KT887tz530CwsgerFI=;
        b=g3mwdPSh3gffxljaZdwwAhV/99lm0jGV7XmCV8AP7OaL3+RJkUHf76Yserd8NTHUAJ
         Uh51e+tOOBzM/Xlso3o7VxNqNkfKov299R3DCa7gHhAyN/GuzZhpOl7M0C+7PVGDQZZ6
         tZXrIJE7P4KCei0CV9gSKVzB0LxavMTWESfKQoyS4j1mw0eYk8gwLvZUsVUU4TptvPZL
         VKWB5Awd6YhLn+OzhQ2LykKd3gPUGxuMyOUtvi6uISESbISQDV/Yj2lIy/Yim7UkfHCE
         0yE8CSJ5yqsH3MixguLWE72yBjzOBrfCVmmHnZh7WVZqoVZbM60UUPYA564M7gvAoOvl
         OxYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744206066; x=1744810866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Ez1BnkBDoh4P/XSdyZjO5+p/KT887tz530CwsgerFI=;
        b=GbiLKr2XQ4hEgq8wCmIr2Nn3G1/18D2SamDaISWw1cFPtWi2Ki2nTDDZG5gcsfKEDV
         btiCCQP+uJsOhMZzym2OAV1CHzivj+ip0mbsV834v/Ot7BI3x1ZTk9tuHXyVjm+4DI1H
         el7BfWFWKHAm+g+MtsEax5CaXnCbuISo3d0Ar1TZhikmLEPOcj/h/Xme2l1/ftzVXGGn
         oy6O+jznnZcEphDwwa1vEKNcYlRgCxaVJhbgh+LaSY0kZ7dDKQnJcHQ/nrt3Aq+1GQn7
         6FbargbBUUSvPwOJFOE7wD00lt6t19Xg8gwpzDpEAuM2qhODF4uMkV5T6TbFNaZOiBUL
         39Tw==
X-Gm-Message-State: AOJu0YxMKSRrmHZjg5817BbE7L258Y3r4Ar8Byr0w376YgmtH9CYxQvZ
	y8ggeAK3x9gdPiUNUQlycklxYV3ofkIlEaU/PcduCciy5K229I0XmEdiLWEdcz+TbM+B5uBoSII
	s
X-Gm-Gg: ASbGnctZEh8F+WvZz49WA0r4nnsVSnCZN4jzFNuNVY8x/EjyksCmFOQ9Pg78rRsOW9I
	wSxYfE9JMO+kpRkqDuz2YJYePOTxrlq6eJ7RkF4Vozky8eDl5oZ90gifdWANUp+D2OO9ziJbVgN
	HQsh+V51NQMZS7ItGQQTYvazS4HWhCWlTVql089eoZTyZ62IenUMfJW7y3JnctVxx/318epAh9O
	DLFUOrU80nO831UmRZPe6fF25ZXkq3Z2DVdJDQxtjwygL/TyRdueamDqCBKm0j+0WlKDKloXxoB
	jAaEtEEHzuMbFJJpIiRMA5dOx5A2aU3Want/RmIGof6dI2jWFsraae4=
X-Google-Smtp-Source: AGHT+IFW2Fyl8Ve7PRrc2IiSrj0fh4NJ12qB3srO6FA/0CYOgdkfnTwoGNdFBJf7eo1f/sG8hS25RA==
X-Received: by 2002:a05:6602:4019:b0:85b:46d7:1886 with SMTP id ca18e2360f4ac-86162828f69mr289311339f.7.1744206065750;
        Wed, 09 Apr 2025 06:41:05 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505e2eaeesm242546173.126.2025.04.09.06.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 06:41:04 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	brauner@kernel.org,
	linux-fsdevel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring: wait for cancelations on final ring put
Date: Wed,  9 Apr 2025 07:35:22 -0600
Message-ID: <20250409134057.198671-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250409134057.198671-1-axboe@kernel.dk>
References: <20250409134057.198671-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We still offload the cancelation to a workqueue, as not to introduce
dependencies between the exiting task waiting on cleanup, and that
task needing to run task_work to complete the process.

This means that once the final ring put is done, any request that was
inflight and needed cancelation will be done as well. Notably requests
that hold references to files - once the ring fd close is done, we will
have dropped any of those references too.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  2 ++
 io_uring/io_uring.c            | 17 +++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index b44d201520d8..4d26aef281fb 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -450,6 +450,8 @@ struct io_ring_ctx {
 	struct io_mapped_region		param_region;
 	/* just one zcrx per ring for now, will move to io_zcrx_ifq eventually */
 	struct io_mapped_region		zcrx_region;
+
+	struct completion		*exit_comp;
 };
 
 /*
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ce00b616e138..4b3e3ff774d6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2891,6 +2891,7 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
 	unsigned long timeout = jiffies + HZ * 60 * 5;
 	unsigned long interval = HZ / 20;
+	struct completion *exit_comp;
 	struct io_tctx_exit exit;
 	struct io_tctx_node *node;
 	int ret;
@@ -2955,6 +2956,10 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 
 	io_kworker_tw_end();
 
+	exit_comp = READ_ONCE(ctx->exit_comp);
+	if (exit_comp)
+		complete(exit_comp);
+
 	init_completion(&exit.completion);
 	init_task_work(&exit.task_work, io_tctx_exit_cb);
 	exit.ctx = ctx;
@@ -3017,9 +3022,21 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 static int io_uring_release(struct inode *inode, struct file *file)
 {
 	struct io_ring_ctx *ctx = file->private_data;
+	DECLARE_COMPLETION_ONSTACK(exit_comp);
 
 	file->private_data = NULL;
+	WRITE_ONCE(ctx->exit_comp, &exit_comp);
 	io_ring_ctx_wait_and_kill(ctx);
+
+	/*
+	 * Wait for cancel to run before exiting task
+	 */
+	do {
+		if (current->io_uring)
+			io_fallback_tw(current->io_uring, false);
+		cond_resched();
+	} while (wait_for_completion_interruptible(&exit_comp));
+
 	return 0;
 }
 
-- 
2.49.0


