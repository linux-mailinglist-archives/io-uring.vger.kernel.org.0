Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A3D357941
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 02:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbhDHA7K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Apr 2021 20:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhDHA7J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Apr 2021 20:59:09 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FC4C061760
        for <io-uring@vger.kernel.org>; Wed,  7 Apr 2021 17:58:59 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id x7so227733wrw.10
        for <io-uring@vger.kernel.org>; Wed, 07 Apr 2021 17:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=NJFWCtSUTIX3Om34TUeDbdMgaO1alz798FcR0S1QSO4=;
        b=emNya+A4AOooPN966I+HMzlCaBETLYInvF/ePIxJYwmYPRFL92p1wvhy0fbSUWGEof
         ksf9WhEJMKcqpwLEanTy+erUpSK10nyI1oqcmgaNFa42YtBwL8AVHfgAA/MtPZLmltPf
         Mp303liYuQ2mJo7fUYOVYxOAshH3Awi/hbItP/WmBGnf7LxSniWMksXs5xDwI2XAejEP
         pMl4Nd8bq43uhiMTyh70VtNgkHGXSNG7q9YjtNPiXC6/xt69NmLaZMmw6zpZ/Vy+hjt/
         8jwk6DoE7N5yBHrDFmhmZZP1xp6/JbhotQITxqwGXtx8d2NwM85TbJN7E15TI8txkSJ2
         0+eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NJFWCtSUTIX3Om34TUeDbdMgaO1alz798FcR0S1QSO4=;
        b=XVrvPCMwyXozsoC04CEmY+DsqyZvInl3q890Q22fjRvR+Ha1UIdX2aPK91Hg26i1Ls
         wuRaWqSJsE2D8ERCa/x9chD7InkZOpjdS3AsqrEhuFMTmDYFsY6AA1nDsyQaGr4R+sE6
         4yFWeIK9vHOkGoxCMP4wIdDpAyA53yvz72tDkuiB1DCHbA/ZNCSJzTXwK2DQaoLWzthQ
         P/LnBXyJhepKgmVtV7IXxb0z7+B5v8fpG2hLdI3PZ45OJk6UxVcKL9mt14jTA4FaLYRO
         xwQi90CoiiLzyZ2m6l2aXoCQPQoSk7fp5RwKNIyY1ubjpYQBKOdopSMXiUW523SeWEnb
         eNVQ==
X-Gm-Message-State: AOAM530b5+s0P/8YPgKFL43L0hJ6U8A/kuP6lCvWkdcaTsDYRcGyZsh6
        O8a7IOxk5frkywRvU8BhUtc=
X-Google-Smtp-Source: ABdhPJwLyHrZNBfOWJMhj+kOIaV/lNjqHIH2pXmTLkfy4nYa8XWCVWZhNPrKJXid+LZ1K2jEZba2Cg==
X-Received: by 2002:adf:f883:: with SMTP id u3mr7475170wrp.405.1617843538329;
        Wed, 07 Apr 2021 17:58:58 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.202])
        by smtp.gmail.com with ESMTPSA id s9sm12219287wmh.31.2021.04.07.17.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 17:58:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/4] io-wq: cancel unbounded works on io-wq destroy
Date:   Thu,  8 Apr 2021 01:54:42 +0100
Message-Id: <cd4b543154154cba055cf86f351441c2174d7f71.1617842918.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617842918.git.asml.silence@gmail.com>
References: <cover.1617842918.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

WARNING: CPU: 5 PID: 227 at fs/io_uring.c:8578 io_ring_exit_work+0xe6/0x470
RIP: 0010:io_ring_exit_work+0xe6/0x470
Call Trace:
 process_one_work+0x206/0x400
 worker_thread+0x4a/0x3d0
 kthread+0x129/0x170
 ret_from_fork+0x22/0x30

INFO: task lfs-openat:2359 blocked for more than 245 seconds.
task:lfs-openat      state:D stack:    0 pid: 2359 ppid:     1 flags:0x00000004
Call Trace:
 ...
 wait_for_completion+0x8b/0xf0
 io_wq_destroy_manager+0x24/0x60
 io_wq_put_and_exit+0x18/0x30
 io_uring_clean_tctx+0x76/0xa0
 __io_uring_files_cancel+0x1b9/0x2e0
 do_exit+0xc0/0xb40
 ...

Even after io-wq destroy has been issued io-wq worker threads will
continue executing all left work items as usual, and may hang waiting
for I/O that won't ever complete (aka unbounded).

[<0>] pipe_read+0x306/0x450
[<0>] io_iter_do_read+0x1e/0x40
[<0>] io_read+0xd5/0x330
[<0>] io_issue_sqe+0xd21/0x18a0
[<0>] io_wq_submit_work+0x6c/0x140
[<0>] io_worker_handle_work+0x17d/0x400
[<0>] io_wqe_worker+0x2c0/0x330
[<0>] ret_from_fork+0x22/0x30

Cancel all unbounded I/O instead of executing them. This changes the
user visible behaviour, but that's inevitable as io-wq is not per task.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 433c4d3c3c1c..4eba531bea5a 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -415,6 +415,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 {
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
+	bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
 
 	do {
 		struct io_wq_work *work;
@@ -444,6 +445,9 @@ static void io_worker_handle_work(struct io_worker *worker)
 			unsigned int hash = io_get_work_hash(work);
 
 			next_hashed = wq_next_work(work);
+
+			if (unlikely(do_kill) && (work->flags & IO_WQ_WORK_UNBOUND))
+				work->flags |= IO_WQ_WORK_CANCEL;
 			wq->do_work(work);
 			io_assign_current_work(worker, NULL);
 
-- 
2.24.0

