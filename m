Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60EAA4EE115
	for <lists+io-uring@lfdr.de>; Thu, 31 Mar 2022 20:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbiCaSvs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 31 Mar 2022 14:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiCaSvr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 31 Mar 2022 14:51:47 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B347716BF90
        for <io-uring@vger.kernel.org>; Thu, 31 Mar 2022 11:49:59 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id 125so544380iov.10
        for <io-uring@vger.kernel.org>; Thu, 31 Mar 2022 11:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=+nKKBKvFmJyFVF7mMdVmADUzHO5gStJfg3RWBsvmA9Y=;
        b=Rpzrv9USKnZoDXUPpiqaKjRnjCWk6r2lfmbjOX0RJu8wqsWYShRcSNNImG2f+E2caB
         i3eoHwR979SgUmDVdMGuqgrZW2Jr+STGReZpmnrTQMmWvtMFCVTS1RWZIT6LpyPsqkP8
         /AeVp1roWE/U8rpPB5JzdP7AsruJETNk5GQYl8UyWvKXGtVMFCAAIJhCH8hDfTwSu61u
         nAvpq52uv1gbCOMx7kZEFov30m0BJ7z6JLt1cm807sQP0TO6JzIqcPCcmGRMNIMUk/Xm
         UeN+QrXhbehwtqOdxYtbCPkUfHgTo0S8mSyJA3eXLx3rks4af8wQk7ECquOrlgXBIRXZ
         B+ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=+nKKBKvFmJyFVF7mMdVmADUzHO5gStJfg3RWBsvmA9Y=;
        b=GAJhXvFtMb8KKb1GJTSDd1G2SLonHL/3Cs++8nILFRfXCfpju0v/CzjwALKkeo0YdB
         xpLfwqKaWJZO3GmfXlqhYd7b69iH6bBCYhRdWBm2Fqx/rUfeOTedkii3sy07gYiL04lw
         URRxRoLVLbP2gVscr1ll2EZBtoTKH/5s+hEve1gTki1Bp3OvTqQD8qy59+HYghWLRiZz
         IEtx/CracSe19WMBhKv3GXGD28dyTOqzpfFwYt0KjDUE2dJrzfYZRc/NBCL7kL4PqujJ
         QTlT25suhRMTDF12BYPzv7DnRScprwivmsnWTnw3dNVTP4HumAhBgi/M1NrjbhiDw7mR
         asrw==
X-Gm-Message-State: AOAM5326v9+1pS5KNVcNoziI74vMs3DHahMh9yHd3T37NsuoGWkEPOTY
        v4wSfVqr1B5xOARbTphsQ81q4dgzoDvCnTeX
X-Google-Smtp-Source: ABdhPJxK3Ls6smfwrLwC4OZayMRfoI9wkjLBll0jAwLKK9GCmdjySSOfLoZ5ntuD9nqD58kLXmiaVw==
X-Received: by 2002:a02:224d:0:b0:321:370b:6d59 with SMTP id o74-20020a02224d000000b00321370b6d59mr3822179jao.104.1648752598743;
        Thu, 31 Mar 2022 11:49:58 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j4-20020a056e02218400b002c82f195e80sm113658ila.83.2022.03.31.11.49.58
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 11:49:58 -0700 (PDT)
Message-ID: <7bceb827-cea1-49c4-34dc-a03f457c96da@kernel.dk>
Date:   Thu, 31 Mar 2022 12:49:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: drop the old style inflight file tracking
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring tracks requests that are referencing an io_uring descriptor to
be able to cancel without worrying about loops in the references. Since
we now assign the file at execution time, the easier approach is to drop
a potentially problematic reference before we punt the request. This
eliminates the need to special case these types of files beyond just
marking them as such.

This also fixes a recent issue where an async punted tee operation would
with the io_uring descriptor as the output file would crash when
attempting to get a reference to the file from the io-wq worker. We
could have worked around that, but this is the much cleaner fix.

Fixes: 734a69489dd7 ("io_uring: defer file assignment")
Reported-by: syzbot+c4b9303500a21750b250@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 00bc123ab5e7..1b929ca181a0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -501,7 +501,6 @@ struct io_uring_task {
 	const struct io_ring_ctx *last;
 	struct io_wq		*io_wq;
 	struct percpu_counter	inflight;
-	atomic_t		inflight_tracked;
 	atomic_t		in_idle;
 
 	spinlock_t		task_lock;
@@ -1190,6 +1189,7 @@ static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 static void io_clean_op(struct io_kiocb *req);
 static struct file *io_file_get(struct io_ring_ctx *ctx,
 				struct io_kiocb *req, int fd, bool fixed);
+static void io_drop_inflight_file(struct io_kiocb *req);
 static void __io_queue_sqe(struct io_kiocb *req);
 static void io_rsrc_put_work(struct work_struct *work);
 
@@ -1642,14 +1642,6 @@ static inline bool io_req_ffs_set(struct io_kiocb *req)
 	return req->flags & REQ_F_FIXED_FILE;
 }
 
-static inline void io_req_track_inflight(struct io_kiocb *req)
-{
-	if (!(req->flags & REQ_F_INFLIGHT)) {
-		req->flags |= REQ_F_INFLIGHT;
-		atomic_inc(&current->io_uring->inflight_tracked);
-	}
-}
-
 static struct io_kiocb *__io_prep_linked_timeout(struct io_kiocb *req)
 {
 	if (WARN_ON_ONCE(!req->link))
@@ -2560,6 +2552,8 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 
 	WARN_ON_ONCE(!tctx);
 
+	io_drop_inflight_file(req);
+
 	spin_lock_irqsave(&tctx->task_lock, flags);
 	if (priority)
 		wq_list_add_tail(&req->io_task_work.node, &tctx->prior_task_list);
@@ -7198,11 +7192,6 @@ static void io_clean_op(struct io_kiocb *req)
 		kfree(req->apoll);
 		req->apoll = NULL;
 	}
-	if (req->flags & REQ_F_INFLIGHT) {
-		struct io_uring_task *tctx = req->task->io_uring;
-
-		atomic_dec(&tctx->inflight_tracked);
-	}
 	if (req->flags & REQ_F_CREDS)
 		put_cred(req->creds);
 	if (req->flags & REQ_F_ASYNC_DATA) {
@@ -7487,6 +7476,19 @@ static inline struct file *io_file_get_fixed(struct io_ring_ctx *ctx,
 	return file;
 }
 
+/*
+ * Drop the file for requeue operations. Only used of req->file is the
+ * io_uring descriptor itself.
+ */
+static void io_drop_inflight_file(struct io_kiocb *req)
+{
+	if (unlikely(req->flags & REQ_F_INFLIGHT)) {
+		fput(req->file);
+		req->file = NULL;
+		req->flags &= ~REQ_F_INFLIGHT;
+	}
+}
+
 static struct file *io_file_get_normal(struct io_ring_ctx *ctx,
 				       struct io_kiocb *req, int fd)
 {
@@ -7495,8 +7497,8 @@ static struct file *io_file_get_normal(struct io_ring_ctx *ctx,
 	trace_io_uring_file_get(ctx, req, req->user_data, fd);
 
 	/* we don't allow fixed io_uring files */
-	if (file && unlikely(file->f_op == &io_uring_fops))
-		io_req_track_inflight(req);
+	if (unlikely(file && unlikely(file->f_op == &io_uring_fops)))
+		req->flags |= REQ_F_INFLIGHT;
 	return file;
 }
 
@@ -9412,7 +9414,6 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
 	xa_init(&tctx->xa);
 	init_waitqueue_head(&tctx->wait);
 	atomic_set(&tctx->in_idle, 0);
-	atomic_set(&tctx->inflight_tracked, 0);
 	task->io_uring = tctx;
 	spin_lock_init(&tctx->task_lock);
 	INIT_WQ_LIST(&tctx->task_list);
@@ -10605,7 +10606,7 @@ static __cold void io_uring_clean_tctx(struct io_uring_task *tctx)
 static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 {
 	if (tracked)
-		return atomic_read(&tctx->inflight_tracked);
+		return 0;
 	return percpu_counter_sum(&tctx->inflight);
 }
 
-- 
Jens Axboe

