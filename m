Return-Path: <io-uring+bounces-2096-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 74D808FBC5A
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 21:13:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A564D1C21C20
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 19:13:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 433F214AD30;
	Tue,  4 Jun 2024 19:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VRjvKcN/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F7314AD20
	for <io-uring@vger.kernel.org>; Tue,  4 Jun 2024 19:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717528403; cv=none; b=m+66zIYIafuwXO1PMitSFie3hOrWJ7GMb3//B2L99cFHCDktavW9vngH4Spfz4WK5D1N+pSxEhJRE1VFgON0Au7UuzlAgjjB+kGkPc0RBzoAmJdsfPaQ9uDpS5tYDm6CmN6ybkuNZ9dksIfh60BiPGjlsbtFNnx8y3EiVQrj0uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717528403; c=relaxed/simple;
	bh=fj/cklpDzlPmnDR7MsY0pfzqzUBbRWjrpXtpK3wWDMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XqOJjbTXCy2JY8SHEvX0BcE11WW5h/tbtzE1x92/q03jfXM8DGpwuZyTg/dvZS8MBhWVdVC5PmP8CklOu+FeHZbR7jpHko9JRPa/phf29Z1bYuFTraOIbcq9OHirM1Gkn4ff/J91k42T468uLshwXYhqpXbXVpXAV0XlJhMHoE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VRjvKcN/; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2bfae86f1ffso775776a91.0
        for <io-uring@vger.kernel.org>; Tue, 04 Jun 2024 12:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717528399; x=1718133199; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jM0+32GUsyvMsyazGkgmuEhBi1SKTIjEAt7QjYFovOI=;
        b=VRjvKcN/8uqYK4G5TBtTdJa6lCSDyyoCS4tWZYrgFVGZg200nj5b9YMJswQgi5YLge
         vZ79qiVS6e4dJqyVPvMbYYQBYCCBudKAFdCWJpE7ghPPnIM77glAuIiD+yKp2kLRKeZS
         kHvixPU1IjeV0gScY5d/NLNBjphxsB0ecNwvDyujRG71/dP9drdJkciZ3mKSoh6qnbRY
         r5VjgqZTg/Uzknz2wsSLi12JhSxVtwsspbdkg1Lgvq4rrvBgFFU+t/WXPgYWo66rsJOH
         vVg35wTBC+BguLx2BWBSGNaZnANFh40iJ6P8BGgSrfn6TFRirssaKljEMKUM5agcdbld
         GTDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717528399; x=1718133199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jM0+32GUsyvMsyazGkgmuEhBi1SKTIjEAt7QjYFovOI=;
        b=cGn8pNvb9dFyloetDpEq9zXamztMH/NbII9nNQgobsZFzTM04VnHX6PEXwt5Hnf4nK
         UZWdutLp5bx8Lgt0sY8KaEdzza3/V09CjZewc+lkj6rfocrcqBUA6G8eBf+Fwa9mS93+
         TpuPiW/2qmrliB7O/ymSpft7zmfg03o26VZSvszYDel+t7+YEneYoDmfJbALcN/20rds
         /IEWWDoY2cpq8BkxaLEjSn86JA0VYs+hqsfy7gWFT9q2J0ohlxNRtycWHvz1so7P+qgY
         1KUZxekH6xc9xrBDEnTiTIwTtzg7kqC/xjNje6vcMaNRp+sL9qVHnuFqsvmLach7B6bK
         Ljxw==
X-Gm-Message-State: AOJu0YwyE7LGl3UnEtfeB761ZHsAvZr3Jk1kN9MCuzZKEupkDn9UFKqq
	RDpJ/cTPEA9byYR1NWu1OFcAERgvJDkhK8VaEGKRq7jPHEzgseQgjs23wU/9kXncf/T3v0soa76
	y
X-Google-Smtp-Source: AGHT+IERAhvTaLC21BqRpXi4xBBNj41yhtdOdhTh2EK24iWJb6/gW95DIvQeQuzmS4sy7qaDlvuZ8g==
X-Received: by 2002:a17:90b:1052:b0:2bd:f770:f95e with SMTP id 98e67ed59e1d1-2c27da3e17cmr407488a91.0.1717528399248;
        Tue, 04 Jun 2024 12:13:19 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c1c283164fsm8960265a91.37.2024.06.04.12.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 12:13:18 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] fs: gate final fput task_work on PF_NO_TASKWORK
Date: Tue,  4 Jun 2024 13:01:28 -0600
Message-ID: <20240604191314.454554-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240604191314.454554-1-axboe@kernel.dk>
References: <20240604191314.454554-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than hardwire this to kernel threads, add a task flag that tells
us whether the task in question runs task_work or not. At fork time,
this flag is set for kernel threads. This is in preparation for allowing
kernel threads to signal that they will run deferred task_work.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/file_table.c       | 2 +-
 include/linux/sched.h | 2 +-
 kernel/fork.c         | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 4f03beed4737..d7c6685afbcb 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -477,7 +477,7 @@ void fput(struct file *file)
 			file_free(file);
 			return;
 		}
-		if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
+		if (likely(!in_interrupt() && !(task->flags & PF_NO_TASKWORK))) {
 			init_task_work(&file->f_task_work, ____fput);
 			if (!task_work_add(task, &file->f_task_work, TWA_RESUME))
 				return;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 61591ac6eab6..1393d557f05e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1635,7 +1635,7 @@ extern struct pid *cad_pid;
 #define PF_USED_MATH		0x00002000	/* If unset the fpu must be initialized before use */
 #define PF_USER_WORKER		0x00004000	/* Kernel thread cloned from userspace thread */
 #define PF_NOFREEZE		0x00008000	/* This thread should not be frozen */
-#define PF__HOLE__00010000	0x00010000
+#define PF_NO_TASKWORK		0x00010000	/* task doesn't run task_work */
 #define PF_KSWAPD		0x00020000	/* I am kswapd */
 #define PF_MEMALLOC_NOFS	0x00040000	/* All allocations inherit GFP_NOFS. See memalloc_nfs_save() */
 #define PF_MEMALLOC_NOIO	0x00080000	/* All allocations inherit GFP_NOIO. See memalloc_noio_save() */
diff --git a/kernel/fork.c b/kernel/fork.c
index 99076dbe27d8..156bf8778d18 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2222,7 +2222,7 @@ __latent_entropy struct task_struct *copy_process(
 		goto fork_out;
 	p->flags &= ~PF_KTHREAD;
 	if (args->kthread)
-		p->flags |= PF_KTHREAD;
+		p->flags |= PF_KTHREAD | PF_NO_TASKWORK;
 	if (args->user_worker) {
 		/*
 		 * Mark us a user worker, and block any signal that isn't
-- 
2.43.0


