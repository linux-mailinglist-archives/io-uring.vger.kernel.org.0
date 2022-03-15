Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7CE4DA0A2
	for <lists+io-uring@lfdr.de>; Tue, 15 Mar 2022 17:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbiCOQ7x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Mar 2022 12:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349586AbiCOQ7w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Mar 2022 12:59:52 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EC157B27
        for <io-uring@vger.kernel.org>; Tue, 15 Mar 2022 09:58:40 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id p2so13740419ile.2
        for <io-uring@vger.kernel.org>; Tue, 15 Mar 2022 09:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=aFLoBpMpCKO43YcTK0w0pTlHlYQN5KpP7tSrrzp4CBE=;
        b=0JDxJWTHO4Zw2YnWfCco9pU0deETDgQGEqIsmbMqJGSrfDOIA/fIJFaepAy4GiM61E
         lWCkOg2HnuZrDDx9hjpWzi4NWFWEmj6kAoJlnM4NKrMQFMToKRVfyZnFo2OSH4VGRuWq
         vsp83OYF62UEgZdpT/wcb4HET2haxCpv9tvD27CAymMNHr7+YzAeVBLZN09ze1ag3cHR
         ikcPUgkFOux503Mraw0SOmSIV0h+Azs9dZisz9ts0eSB1s2F7313mJy/hjWWik9qbAlI
         liX0gzKI4BqmqRcHCYvUw28am+XceWEJibgWXxeRo0ky7z4MZqb3vj5BAAJhBLvMJ6FT
         zJhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=aFLoBpMpCKO43YcTK0w0pTlHlYQN5KpP7tSrrzp4CBE=;
        b=doGSLfCAXU5rll+SSGNOJ4vfIqj3WMrCWQzj2d6xEC0kvfj1m8DV7hzKeb2ti+Jg2c
         TetDfj63nHaCJyRmV9vPPl4KImy9PAUKCWvE6fWd/EzF2cMhF+nNO7u0ktTwu5ktATXF
         NaMxxboob+SUGUjHNsoBPfmGNht6crh4R8w/dctAzOmyIclG8LazwmV7msgOOFbnlnq5
         NzLue/p7U6byOxGF//+lbuXGQOu95ZSVXOuiigrGYUJikkbcQcaGbFXw+gJCqKcrFm/t
         X6IlfBdCA53e7xCyciPE73T6ShKhIAMLHDxldw+VKk69rY7D8iuKnNwm1BD5vqcTH8s5
         2O8A==
X-Gm-Message-State: AOAM530bGlAJx8vc0NiC42iDCA2HXhSMPQTTRG4dbX+dSW4IeoCcGdfD
        OZpyz3VHCiLqQHXVJTuS8ST7sR2vuOGSy0TP
X-Google-Smtp-Source: ABdhPJydXwzDQA7jlT4QX70zSuvv/qlWUyAY3GccbLw+udJGQDW4WhYKbkcgikhgjk5DQ8T6GMtcGg==
X-Received: by 2002:a05:6e02:4b0:b0:2c6:f4e:28bf with SMTP id e16-20020a056e0204b000b002c60f4e28bfmr23180444ils.317.1647363519306;
        Tue, 15 Mar 2022 09:58:39 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a6-20020a92c546000000b002c7a44bf1a5sm3555569ilj.48.2022.03.15.09.58.38
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 09:58:39 -0700 (PDT)
Message-ID: <ed1f5f0d-6ef2-c277-c465-a07513902c0e@kernel.dk>
Date:   Tue, 15 Mar 2022 10:58:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: recycle apoll_poll entries
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

Particularly for networked workloads, io_uring intensively uses its
poll based backend to get a notification when data/space is available.
Profiling workloads, we see 3-4% of alloc+free that is directly attributed
to just the apoll allocation and free (and the rest being skb alloc+free).

For the fast path, we have ctx->uring_lock held already for both issue
and the inline completions, and we can utilize that to avoid any extra
locking needed to have a basic recycling cache for the apoll entries on
both the alloc and free side.

Double poll still requires an allocation. But those are rare and not
a fast path item.

With the simple cache in place, we see a 3-4% reduction in overhead for
the workload.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 299154efcd8a..b17cf54653df 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -387,6 +387,7 @@ struct io_ring_ctx {
 		struct list_head	cq_overflow_list;
 		struct xarray		io_buffers;
 		struct list_head	io_buffers_cache;
+		struct list_head	apoll_cache;
 		struct xarray		personalities;
 		u32			pers_next;
 		unsigned		sq_thread_idle;
@@ -1528,6 +1529,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->sqd_list);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	INIT_LIST_HEAD(&ctx->io_buffers_cache);
+	INIT_LIST_HEAD(&ctx->apoll_cache);
 	init_completion(&ctx->ref_comp);
 	xa_init_flags(&ctx->io_buffers, XA_FLAGS_ALLOC1);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
@@ -2650,6 +2652,15 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 
 			if (!(req->flags & REQ_F_CQE_SKIP))
 				__io_fill_cqe(req, req->result, req->cflags);
+			if ((req->flags & REQ_F_POLLED) && req->apoll) {
+				struct async_poll *apoll = req->apoll;
+
+				if (apoll->double_poll)
+					kfree(apoll->double_poll);
+				list_add(&apoll->poll.wait.entry,
+						&ctx->apoll_cache);
+				req->flags &= ~REQ_F_POLLED;
+			}
 		}
 
 		io_commit_cqring(ctx);
@@ -6143,7 +6154,7 @@ enum {
 	IO_APOLL_READY
 };
 
-static int io_arm_poll_handler(struct io_kiocb *req)
+static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 	struct io_ring_ctx *ctx = req->ctx;
@@ -6168,9 +6179,16 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 		mask |= POLLOUT | POLLWRNORM;
 	}
 
-	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
-	if (unlikely(!apoll))
-		return IO_APOLL_ABORTED;
+	if (!(issue_flags & IO_URING_F_UNLOCKED) &&
+	    !list_empty(&ctx->apoll_cache)) {
+		apoll = list_first_entry(&ctx->apoll_cache, struct async_poll,
+						poll.wait.entry);
+		list_del_init(&apoll->poll.wait.entry);
+	} else {
+		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
+		if (unlikely(!apoll))
+			return IO_APOLL_ABORTED;
+	}
 	apoll->double_poll = NULL;
 	req->apoll = apoll;
 	req->flags |= REQ_F_POLLED;
@@ -7271,7 +7289,7 @@ static void io_wq_submit_work(struct io_wq_work *work)
 			continue;
 		}
 
-		if (io_arm_poll_handler(req) == IO_APOLL_OK)
+		if (io_arm_poll_handler(req, issue_flags) == IO_APOLL_OK)
 			return;
 		/* aborted or ready, in either case retry blocking */
 		needs_poll = false;
@@ -7417,7 +7435,7 @@ static void io_queue_sqe_arm_apoll(struct io_kiocb *req)
 {
 	struct io_kiocb *linked_timeout = io_prep_linked_timeout(req);
 
-	switch (io_arm_poll_handler(req)) {
+	switch (io_arm_poll_handler(req, 0)) {
 	case IO_APOLL_READY:
 		io_req_task_queue(req);
 		break;
@@ -9938,6 +9956,18 @@ static void io_wait_rsrc_data(struct io_rsrc_data *data)
 		wait_for_completion(&data->done);
 }
 
+static void io_flush_apoll_cache(struct io_ring_ctx *ctx)
+{
+	struct async_poll *apoll;
+
+	while (!list_empty(&ctx->apoll_cache)) {
+		apoll = list_first_entry(&ctx->apoll_cache, struct async_poll,
+						poll.wait.entry);
+		list_del(&apoll->poll.wait.entry);
+		kfree(apoll);
+	}
+}
+
 static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_sq_thread_finish(ctx);
@@ -9960,6 +9990,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	if (ctx->rings)
 		__io_cqring_overflow_flush(ctx, true);
 	io_eventfd_unregister(ctx);
+	io_flush_apoll_cache(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	io_destroy_buffers(ctx);
 	if (ctx->sq_creds)

-- 
Jens Axboe

