Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338C7508856
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 14:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237767AbiDTMoX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 08:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353706AbiDTMoW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 08:44:22 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D6C1FA6F
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 05:41:35 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id x3so1102627wmj.5
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 05:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hZaqkOYN8V4/tygHN+VWNlDrUZU7vl+4ZOM0cYCufok=;
        b=WocsgN7m9tRhwSBPxWqJPTrQqO8qPjTL7i21Pvf7wh1L64yI3wYOcKV1m+jq0iH2Fs
         plqjjyJOeaiN5hh52tasf1JjI1pzKDbv7uHS4uUZfRa7EExZih9jjaq6UO++iXmTIinx
         sV7qIy+0BZnkJE+PR2OVppZihxvqfw5XyNDHaaz5u/QgnXtO4C1rdjsnGkWxKUGVfHzF
         pregCR+kpmrFAVeTOmA+AeX4hj36IVANNYUI5WZoXzOLy2q0dDQPit+blLh+bnVIwlOH
         KwsaRV9bwL6hMaSjYXFjUwxa9PvPVcu7ftodnZmbrbmyaVX6Kg8rqIyaewp1dy0WIxwE
         x6tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hZaqkOYN8V4/tygHN+VWNlDrUZU7vl+4ZOM0cYCufok=;
        b=rQadbWb5/WnB6Re2AdnEvJY4y0LBB+s3ewX/Mf5nJcc/vM+SJILCb8quX5j81gU1iB
         k7nkrkPzRgcmxnax9jYAvezSo9cRyElEN0YsAKDlB3II1U4VfwROfxYNH13rkSOAwR0z
         NFka/HoTd7uvSOhUbyTQnueFpb77gwgxCe5ktYZgjUzvqLzaUIh36XjhIx++/otu8FmW
         NbQkgyBilOUkT2sH4DA920B5oRBy5P/MhkSqMDA6E9tjRCHGxZ28N60AcRegl9zO87b6
         l31ZOAJXQIe8F+aX27mIqiGhNAMxR3n7Cgpg8PHb7B6Tc6ZmC6AF+yWQs0y7yLydYYXT
         KtzQ==
X-Gm-Message-State: AOAM5325Wri2y4ADHv1MNizeI4oSJ2Asshndmx8TejSpTbj0j9RmMuqp
        O9MWW+JL4X9yd5suPxfus7QOlnujrAQ=
X-Google-Smtp-Source: ABdhPJyKdeLL55yZPCwUEVzIpOC4dWaF57JKrn1q/KvOMtz+519yUy/C1Qvj2oDBJGonbKtbTKMOPg==
X-Received: by 2002:a7b:c0d5:0:b0:38e:ca29:f40 with SMTP id s21-20020a7bc0d5000000b0038eca290f40mr3511153wmh.205.1650458493767;
        Wed, 20 Apr 2022 05:41:33 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-244-154.dab.02.net. [82.132.244.154])
        by smtp.gmail.com with ESMTPSA id v11-20020adfa1cb000000b0020ab21e1e61sm971322wrv.51.2022.04.20.05.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 05:41:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        syzbot+57e67273f92d7f5f1931@syzkaller.appspotmail.com
Subject: [PATCH 1/3] io_uring: fix nested timeout locking on disarming
Date:   Wed, 20 Apr 2022 13:40:53 +0100
Message-Id: <6fe65900e689b8f5b8d60ba3fa95108138b9fb9f.1650458197.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1650458197.git.asml.silence@gmail.com>
References: <cover.1650458197.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

WARNING: possible recursive locking detected

syz-executor162/3588 is trying to acquire lock:
ffff888011a453d8 (&ctx->timeout_lock){....}-{2:2}, at: spin_lock_irq include/linux/spinlock.h:379 [inline]
ffff888011a453d8 (&ctx->timeout_lock){....}-{2:2}, at: io_disarm_next+0x545/0xaa0 fs/io_uring.c:2452
but task is already holding lock:
ffff888011a453d8 (&ctx->timeout_lock){....}-{2:2}, at: spin_lock_irq include/linux/spinlock.h:379 [inline]
ffff888011a453d8 (&ctx->timeout_lock){....}-{2:2}, at: io_kill_timeouts+0x4c/0x227 fs/io_uring.c:10432

Call Trace:
 <TASK>
...
 spin_lock_irq include/linux/spinlock.h:379 [inline]
 io_disarm_next+0x545/0xaa0 fs/io_uring.c:2452
 __io_req_complete_post+0x794/0xd90 fs/io_uring.c:2200
 io_kill_timeout fs/io_uring.c:1815 [inline]
 io_kill_timeout+0x210/0x21d fs/io_uring.c:1803
 io_kill_timeouts+0xe2/0x227 fs/io_uring.c:10435
 io_ring_ctx_wait_and_kill+0x1eb/0x360 fs/io_uring.c:10462
 io_uring_release+0x42/0x46 fs/io_uring.c:10483
 __fput+0x277/0x9d0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
...

Return tw deferred putting back, it's easier than looking after all
potential nested locking. However, instead of filling an CQE on the spot
as it was before delay it as well by io_req_complete_post() via tw.

Reported-by: syzbot+57e67273f92d7f5f1931@syzkaller.appspotmail.com
Fixes: 78bfbdd1a497 ("io_uring: kill io_put_req_deferred()")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3905b3ec87b8..2b9a3af9ff42 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1214,6 +1214,7 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags);
 
 static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer);
 static void io_eventfd_signal(struct io_ring_ctx *ctx);
+static void io_req_tw_post_queue(struct io_kiocb *req, s32 res, u32 cflags);
 
 static struct kmem_cache *req_cachep;
 
@@ -1782,7 +1783,7 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
-		__io_req_complete_post(req, status, 0);
+		io_req_tw_post_queue(req, status, 0);
 	}
 }
 
@@ -2367,7 +2368,7 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
 		link->timeout.head = NULL;
 		if (hrtimer_try_to_cancel(&io->timer) != -1) {
 			list_del(&link->timeout.list);
-			__io_req_complete_post(link, -ECANCELED, 0);
+			io_req_tw_post_queue(link, -ECANCELED, 0);
 			return true;
 		}
 	}
@@ -2413,7 +2414,7 @@ static bool io_disarm_next(struct io_kiocb *req)
 		req->flags &= ~REQ_F_ARM_LTIMEOUT;
 		if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
 			io_remove_next_linked(req);
-			__io_req_complete_post(link, -ECANCELED, 0);
+			io_req_tw_post_queue(link, -ECANCELED, 0);
 			posted = true;
 		}
 	} else if (req->flags & REQ_F_LINK_TIMEOUT) {
@@ -2632,6 +2633,19 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 	}
 }
 
+static void io_req_tw_post(struct io_kiocb *req, bool *locked)
+{
+	io_req_complete_post(req, req->cqe.res, req->cqe.flags);
+}
+
+static void io_req_tw_post_queue(struct io_kiocb *req, s32 res, u32 cflags)
+{
+	req->cqe.res = res;
+	req->cqe.flags = cflags;
+	req->io_task_work.func = io_req_tw_post;
+	io_req_task_work_add(req, false);
+}
+
 static void io_req_task_cancel(struct io_kiocb *req, bool *locked)
 {
 	/* not needed for normal modes, but SQPOLL depends on it */
-- 
2.36.0

