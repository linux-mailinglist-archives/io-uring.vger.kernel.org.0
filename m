Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0947629670D
	for <lists+io-uring@lfdr.de>; Fri, 23 Oct 2020 00:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369606AbgJVWXE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 18:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S369533AbgJVWXE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 18:23:04 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78458C0613CE
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 15:23:02 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id w11so1715033pll.8
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 15:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p1PEjZMi5EYWA6YIE+BLpOzIq2ss5gn1qcCP5TXuptw=;
        b=VKlmkksdoQ1EQ8Je0GrwveIDQfkAOVobqgO6EuXBK70/Y1lhBmTOJ/15I5j7fWXoZv
         nILudrpoJs4kdD0XVcB6yH9AWIP7yT+glGH+L5nyuJFPb+6UMhW/1sTIpYslSArKk/7u
         ZOnNgJgZ8mQwzULvFsbPmkVXv4c6rq2hkSjNG5Pj4nc6QT9Gg0t7W8sB1zNLr91wAC/+
         J0xnKx0NdknHAq1YUUyr1FKYlnlbH1frHFH2JQMIZjwBHd33o0TffmznXKJTw7yMdSC2
         mw+QBe9h6L3VB1N4GXgm66WwAyOWPS8qUOtWFJLqrVDOo6P4fJZA+9VKbi6E23A84W6q
         5Bcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p1PEjZMi5EYWA6YIE+BLpOzIq2ss5gn1qcCP5TXuptw=;
        b=fjugnxpAKib63UbPOktZQ3Fg7QlEfLUKNr5ffedWRAQGnujX5oDFxbt6v7GelgsW5V
         g1r9RgFjvfMMcMxUEA+74vaccMgxkYoj9QrRsYS6dG684vVcL8TqB3SUSsaTYhNczvbl
         e6uxrFFeeNqlnZh95919gD9HQ5C3JSuyaHaMh/IJDlZgo4EbIdv3P2qYtAMAQ4BtoNoY
         +KU0Vkg7Ci+U/IxJSyetxGrb5TP+6nF5WuE6mNmSrHCMvVwTb3w/CB1c672KNG7UJaU3
         JxTJ75JFc3K6kBJVFh5DoU9w+CkNAi0jKCgKRHxBUj9mk1cEH295MzXF26NpJnzU/EBY
         XKLA==
X-Gm-Message-State: AOAM531vn/5oO9/g4SI0BW8VJb0kZ/I629sBw875mEmDX249RMxx5Qzh
        i1hvYaRo7tTrYCOtmqNTgq8Y58o5gssRsQ==
X-Google-Smtp-Source: ABdhPJzUAXppavTRgGtE7CDeiengTaZW311X4hBy6gX0f7u93p94CjdiMLwLRmSU4NZ/bqMaBPVGTw==
X-Received: by 2002:a17:902:8a8b:b029:d5:f871:92bd with SMTP id p11-20020a1709028a8bb02900d5f87192bdmr4621748plo.10.1603405381795;
        Thu, 22 Oct 2020 15:23:01 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id w205sm3332194pfc.78.2020.10.22.15.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 15:23:01 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: unify fsize with def->work_flags
Date:   Thu, 22 Oct 2020 16:22:55 -0600
Message-Id: <20201022222258.61124-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201022222258.61124-1-axboe@kernel.dk>
References: <20201022222258.61124-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This one was missed in the earlier conversion, should be included like
any of the other IO identity flags. Make sure we restore to RLIM_INIFITY
when dropping the personality again.

Fixes: 98447d65b4a7 ("io_uring: move io identity items into separate struct")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c    |  8 ++++++--
 fs/io-wq.h    |  1 +
 fs/io_uring.c | 23 +++++++++++------------
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 7cb3b4cb9b11..4012ff541b7b 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -187,7 +187,8 @@ static bool __io_worker_unuse(struct io_wqe *wqe, struct io_worker *worker)
 		worker->blkcg_css = NULL;
 	}
 #endif
-
+	if (current->signal->rlim[RLIMIT_FSIZE].rlim_cur != RLIM_INFINITY)
+		current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
 	return dropped_lock;
 }
 
@@ -483,7 +484,10 @@ static void io_impersonate_work(struct io_worker *worker,
 	if ((work->flags & IO_WQ_WORK_CREDS) &&
 	    worker->cur_creds != work->identity->creds)
 		io_wq_switch_creds(worker, work);
-	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = work->identity->fsize;
+	if (work->flags & IO_WQ_WORK_FSIZE)
+		current->signal->rlim[RLIMIT_FSIZE].rlim_cur = work->identity->fsize;
+	else if (current->signal->rlim[RLIMIT_FSIZE].rlim_cur != RLIM_INFINITY)
+		current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
 	io_wq_switch_blkcg(worker, work);
 #ifdef CONFIG_AUDIT
 	current->loginuid = work->identity->loginuid;
diff --git a/fs/io-wq.h b/fs/io-wq.h
index be21c500c925..cba36f03c355 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -17,6 +17,7 @@ enum {
 	IO_WQ_WORK_MM		= 128,
 	IO_WQ_WORK_CREDS	= 256,
 	IO_WQ_WORK_BLKCG	= 512,
+	IO_WQ_WORK_FSIZE	= 1024,
 
 	IO_WQ_HASH_SHIFT	= 24,	/* upper 8 bits are used for hash key */
 };
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 09e7a5f20060..aeef02b0cf12 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -753,8 +753,6 @@ struct io_op_def {
 	unsigned		pollout : 1;
 	/* op supports buffer selection */
 	unsigned		buffer_select : 1;
-	/* needs rlimit(RLIMIT_FSIZE) assigned */
-	unsigned		needs_fsize : 1;
 	/* must always have async data allocated */
 	unsigned		needs_async_data : 1;
 	/* size of async data needed, if any */
@@ -778,10 +776,10 @@ static const struct io_op_def io_op_defs[] = {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
-		.needs_fsize		= 1,
 		.needs_async_data	= 1,
 		.async_size		= sizeof(struct io_async_rw),
-		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
+		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG |
+						IO_WQ_WORK_FSIZE,
 	},
 	[IORING_OP_FSYNC] = {
 		.needs_file		= 1,
@@ -799,9 +797,8 @@ static const struct io_op_def io_op_defs[] = {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
-		.needs_fsize		= 1,
 		.async_size		= sizeof(struct io_async_rw),
-		.work_flags		= IO_WQ_WORK_BLKCG,
+		.work_flags		= IO_WQ_WORK_BLKCG | IO_WQ_WORK_FSIZE,
 	},
 	[IORING_OP_POLL_ADD] = {
 		.needs_file		= 1,
@@ -859,8 +856,7 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_FALLOCATE] = {
 		.needs_file		= 1,
-		.needs_fsize		= 1,
-		.work_flags		= IO_WQ_WORK_BLKCG,
+		.work_flags		= IO_WQ_WORK_BLKCG | IO_WQ_WORK_FSIZE,
 	},
 	[IORING_OP_OPENAT] = {
 		.work_flags		= IO_WQ_WORK_FILES | IO_WQ_WORK_BLKCG |
@@ -890,9 +886,9 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
-		.needs_fsize		= 1,
 		.async_size		= sizeof(struct io_async_rw),
-		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
+		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG |
+						IO_WQ_WORK_FSIZE,
 	},
 	[IORING_OP_FADVISE] = {
 		.needs_file		= 1,
@@ -1293,8 +1289,11 @@ static bool io_grab_identity(struct io_kiocb *req)
 	struct io_identity *id = req->work.identity;
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (def->needs_fsize && id->fsize != rlimit(RLIMIT_FSIZE))
-		return false;
+	if (def->work_flags & IO_WQ_WORK_FSIZE) {
+		if (id->fsize != rlimit(RLIMIT_FSIZE))
+			return false;
+		req->work.flags |= IO_WQ_WORK_FSIZE;
+	}
 
 	if (!(req->work.flags & IO_WQ_WORK_FILES) &&
 	    (def->work_flags & IO_WQ_WORK_FILES) &&
-- 
2.29.0

