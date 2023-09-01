Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C86778FE9A
	for <lists+io-uring@lfdr.de>; Fri,  1 Sep 2023 15:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239265AbjIANud (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Sep 2023 09:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238764AbjIANud (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Sep 2023 09:50:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC32FE77
        for <io-uring@vger.kernel.org>; Fri,  1 Sep 2023 06:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693576184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Z24PZDN6ru0TVORNHrW6hru4yPU6KUQBQaeDmzMdlL8=;
        b=MNBx5PnCpvSFms2x7EQl4SS/5KPKTuARvCHCBm2lpznqfTtQmnMeNRFt2lai++GBGqpo//
        08BKkHjl/sNysCGCalzcIGUut6bGtMbevxGGTSvPEtOeCPPXbvPdkBilOTP9X2ThHakVPR
        kLmZ8I2zD7kVnFjEbOM7JQ0AzY7COcI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-6Qs2l5ZYPEeV0j2bHRMTmA-1; Fri, 01 Sep 2023 09:49:41 -0400
X-MC-Unique: 6Qs2l5ZYPEeV0j2bHRMTmA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F83E800193;
        Fri,  1 Sep 2023 13:49:40 +0000 (UTC)
Received: from localhost (unknown [10.72.120.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7AE95412F2CE;
        Fri,  1 Sep 2023 13:49:38 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2] io_uring: fix IO hang in io_wq_put_and_exit from do_exit()
Date:   Fri,  1 Sep 2023 21:49:16 +0800
Message-Id: <20230901134916.2415386-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_wq_put_and_exit() is called from do_exit(), but all FIXED_FILE requests
in io_wq aren't canceled in io_uring_cancel_generic() called from do_exit().
Meantime io_wq IO code path may share resource with normal iopoll code
path.

So if any HIPRI request is submittd via io_wq, this request may not get resouce
for moving on, given iopoll isn't possible in io_wq_put_and_exit().

The issue can be triggered when terminating 't/io_uring -n4 /dev/nullb0'
with default null_blk parameters.

Fix it by always cancelling all requests in io_wq by adding helper of
io_uring_cancel_wq(), and this way is reasonable because io_wq destroying
follows canceling requests immediately.

Closes: https://lore.kernel.org/linux-block/3893581.1691785261@warthog.procyon.org.uk/
Reported-by: David Howells <dhowells@redhat.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>,
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
V2:
	- avoid to mess up io_uring_cancel_generic() by adding one new
	  helper for canceling io_wq requests

 io_uring/io_uring.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f4591b912ea8..7b3518f96c3b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3298,6 +3298,37 @@ static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 	return percpu_counter_sum(&tctx->inflight);
 }
 
+static void io_uring_cancel_wq(struct io_uring_task *tctx)
+{
+	int ret;
+
+	if (!tctx->io_wq)
+		return;
+
+	/*
+	 * FIXED_FILE request isn't tracked in do_exit(), and these
+	 * requests may be submitted to our io_wq as iopoll, so have to
+	 * cancel them before destroying io_wq for avoiding IO hang
+	 */
+	do {
+		struct io_tctx_node *node;
+		unsigned long index;
+
+		ret = 0;
+		xa_for_each(&tctx->xa, index, node) {
+			struct io_ring_ctx *ctx = node->ctx;
+			struct io_task_cancel cancel = { .task = current, .all = true, };
+			enum io_wq_cancel cret;
+
+			io_iopoll_try_reap_events(ctx);
+			cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_task_cb,
+				       &cancel, true);
+			ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
+			cond_resched();
+		}
+	} while (ret);
+}
+
 /*
  * Find any io_uring ctx that this task has registered or done IO on, and cancel
  * requests. @sqd should be not-null IFF it's an SQPOLL thread cancellation.
@@ -3369,6 +3400,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
 
+	io_uring_cancel_wq(tctx);
 	io_uring_clean_tctx(tctx);
 	if (cancel_all) {
 		/*
-- 
2.41.0

