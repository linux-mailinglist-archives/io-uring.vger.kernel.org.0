Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7EE7984D4
	for <lists+io-uring@lfdr.de>; Fri,  8 Sep 2023 11:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbjIHJbm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Sep 2023 05:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjIHJbk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Sep 2023 05:31:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8921BF6
        for <io-uring@vger.kernel.org>; Fri,  8 Sep 2023 02:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694165451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OdlUhZR0tBIomm2EXUPWjllXJOhjCMA2kWLNGo39Dlg=;
        b=Fc14odbJgBNMYMHQ3im+dLLM2sPhb1uV3gJlI9PFf2dHVNp2YmiCE4U2srMcMkd6c7Iylw
        loMDLK9RFZy++cua9K1V26/rEK9ouWJVfX/PS2zQb2x705gfAonLfmDLq76i5lU6vVcQmN
        eI6U7kUKi1LQjlL5EjZ7jm+VtRB631k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-jd4mE8OTPu-loGezocNyGw-1; Fri, 08 Sep 2023 05:30:47 -0400
X-MC-Unique: jd4mE8OTPu-loGezocNyGw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7CED101CA84;
        Fri,  8 Sep 2023 09:30:46 +0000 (UTC)
Received: from localhost (unknown [10.72.120.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA77BC03295;
        Fri,  8 Sep 2023 09:30:45 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
Subject: [PATCH V3] io_uring: fix IO hang in io_wq_put_and_exit from do_exit()
Date:   Fri,  8 Sep 2023 17:30:09 +0800
Message-Id: <20230908093009.540763-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_wq_put_and_exit() is called from do_exit(), but all FIXED_FILE requests
in io_wq aren't canceled in io_uring_cancel_generic() called from do_exit().
Meantime io_wq IO code path may share resource with normal iopoll code
path.

So if any HIPRI request is submitted via io_wq, this request may not get
resource for moving on, given iopoll isn't possible in io_wq_put_and_exit().

The issue can be triggered when terminating 't/io_uring -n4 /dev/nullb0'
with default null_blk parameters.

Fix it by the following approaches:

- switch to IO_URING_F_NONBLOCK for submitting POLLED IO from io_wq, so
that requests can be canceled when submitting from exiting io_wq

- reap completed events before exiting io wq, so that these completed
requests won't hold resource and prevent other contexts from moving on

Closes: https://lore.kernel.org/linux-block/3893581.1691785261@warthog.procyon.org.uk/
Reported-by: David Howells <dhowells@redhat.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
V3:
	- take new approach and fix regression on thread_exit in liburing
	  tests
	- pass liburing tests(make runtests)
V2:
	- avoid to mess up io_uring_cancel_generic() by adding one new
    helper for canceling io_wq requests

 io_uring/io_uring.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ad636954abae..95a3d31a1ef1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1930,6 +1930,10 @@ void io_wq_submit_work(struct io_wq_work *work)
 		}
 	}
 
+	/* It is fragile to block POLLED IO, so switch to NON_BLOCK */
+	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
+		issue_flags |= IO_URING_F_NONBLOCK;
+
 	do {
 		ret = io_issue_sqe(req, issue_flags);
 		if (ret != -EAGAIN)
@@ -3363,6 +3367,12 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
 
+	/*
+	 * Reap events from each ctx, otherwise these requests may take
+	 * resources and prevent other contexts from being moved on.
+	 */
+	xa_for_each(&tctx->xa, index, node)
+		io_iopoll_try_reap_events(node->ctx);
 	io_uring_clean_tctx(tctx);
 	if (cancel_all) {
 		/*
-- 
2.40.1

