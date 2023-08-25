Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84630788322
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 11:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235349AbjHYJLx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 05:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244152AbjHYJLc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 05:11:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA53D1BF0
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 02:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692954646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UtgAsF0Pt8uZv/RBVLuSugJDghoD4rbxrgGsATEZ6x0=;
        b=UK0ofPd7TTGXfIIkB9hCYhfBsSflNZejcBQzjhUzgNqvNWzZcIn7xTohsnah9Ul0RRCN83
        F0Zp+5b3/7bRpXC9cfZr1PFtegWDC47OGwW5Haw1nHyOyiu2K05/qu0F3QP2GMaYkJ/sXQ
        9wmdtHmSZMXFq9fHePjVyfzulpCmLnE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-527-HusiOG7eOZm_s60xlNxCYA-1; Fri, 25 Aug 2023 05:10:39 -0400
X-MC-Unique: HusiOG7eOZm_s60xlNxCYA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BD29108BEF3;
        Fri, 25 Aug 2023 09:10:38 +0000 (UTC)
Received: from localhost (unknown [10.72.120.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 366AE2026D68;
        Fri, 25 Aug 2023 09:10:36 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 2/2] io_uring: reap iopoll events before exiting io wq
Date:   Fri, 25 Aug 2023 17:09:59 +0800
Message-Id: <20230825090959.1866771-3-ming.lei@redhat.com>
In-Reply-To: <20230825090959.1866771-1-ming.lei@redhat.com>
References: <20230825090959.1866771-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring delays reaping iopoll events into exit work, which is scheduled
in io_uring_release(). But io wq is exited inside do_exit(), and wq code
path may share resource with iopoll code path, such as request. If iopoll
events aren't reaped, io wq exit can't be done, and cause IO hang.

The issue can be triggered when terminating 't/io_uring -n4 /dev/nullb0' with
default null_blk parameters.

Fix it by reaping iopoll events in io_uring_clean_tctx() and moving io wq
exit into workqueue context.

Closes: https://lore.kernel.org/linux-block/3893581.1691785261@warthog.procyon.org.uk/
Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/io_uring.c |  2 +-
 io_uring/io_uring.h |  1 +
 io_uring/tctx.c     | 60 +++++++++++++++++++++++++++++++++++++++------
 3 files changed, 54 insertions(+), 9 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c4adb44f1aa4..ab7844c3380c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3214,7 +3214,7 @@ static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 	return ret;
 }
 
-static bool iopoll_reap_events(struct io_ring_ctx *ctx, bool reap_all)
+bool iopoll_reap_events(struct io_ring_ctx *ctx, bool reap_all)
 {
 	bool reapped = false;
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 547c30582fb8..f1556666a064 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -63,6 +63,7 @@ void io_req_task_queue_fail(struct io_kiocb *req, int ret);
 void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts);
 void tctx_task_work(struct callback_head *cb);
 __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
+bool iopoll_reap_events(struct io_ring_ctx *ctx, bool reap_all);
 int io_uring_alloc_task_context(struct task_struct *task,
 				struct io_ring_ctx *ctx);
 
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index c043fe93a3f2..582b9149bab1 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -6,6 +6,7 @@
 #include <linux/slab.h>
 #include <linux/nospec.h>
 #include <linux/io_uring.h>
+#include <linux/delay.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -175,24 +176,67 @@ __cold void io_uring_del_tctx_node(unsigned long index)
 	kfree(node);
 }
 
+struct wq_exit_work {
+	struct work_struct work;
+	struct io_wq *wq;
+	bool done;
+};
+
+static void io_uring_wq_exit_work(struct work_struct *work)
+{
+	struct wq_exit_work *wq_work =
+                  container_of(work, struct wq_exit_work, work);
+	struct io_wq *wq = wq_work->wq;
+
+	/*
+	 * Must be after io_uring_del_tctx_node() (removes nodes under
+	 * uring_lock) to avoid race with io_uring_try_cancel_iowq().
+	 */
+	io_wq_put_and_exit(wq);
+	wq_work->done = true;
+}
+
 __cold void io_uring_clean_tctx(struct io_uring_task *tctx)
 {
 	struct io_wq *wq = tctx->io_wq;
+	struct wq_exit_work work = {
+		.wq = wq,
+		.done = true,
+	};
 	struct io_tctx_node *node;
 	unsigned long index;
 
-	xa_for_each(&tctx->xa, index, node) {
-		io_uring_del_tctx_node(index);
-		cond_resched();
-	}
+	/*
+	 * io_wq may depend on reaping iopoll events because pending
+	 * requests in io_wq may share resource with polled requests,
+	 * meantime new polled IO may be submitted from io_wq after
+	 * getting resource.
+	 *
+	 * So io_wq has to be exited from workqueue context for avoiding
+	 * IO hang.
+	 */
 	if (wq) {
+		work.done = false;
+		INIT_WORK(&work.work, io_uring_wq_exit_work);
+		queue_work(system_unbound_wq, &work.work);
+	}
+
+	while (!work.done) {
+		xa_for_each(&tctx->xa, index, node)
+			iopoll_reap_events(node->ctx, true);
+
 		/*
-		 * Must be after io_uring_del_tctx_node() (removes nodes under
-		 * uring_lock) to avoid race with io_uring_try_cancel_iowq().
+		 * Wait a little while and reap again since new polled
+		 * IO may get resource from io_wq and be submitted.
 		 */
-		io_wq_put_and_exit(wq);
-		tctx->io_wq = NULL;
+		msleep(10);
+	}
+
+	xa_for_each(&tctx->xa, index, node) {
+		io_uring_del_tctx_node(index);
+		cond_resched();
 	}
+	tctx->io_wq = NULL;
 }
 
 void io_uring_unreg_ringfd(void)
-- 
2.40.1

