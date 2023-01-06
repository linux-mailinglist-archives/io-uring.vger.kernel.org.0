Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4D2265FD6E
	for <lists+io-uring@lfdr.de>; Fri,  6 Jan 2023 10:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbjAFJSM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Jan 2023 04:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbjAFJSB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Jan 2023 04:18:01 -0500
X-Greylist: delayed 267 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 06 Jan 2023 01:18:00 PST
Received: from mail.nfschina.com (unknown [42.101.60.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D10D63188;
        Fri,  6 Jan 2023 01:17:59 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id D14BC1A00A04;
        Fri,  6 Jan 2023 17:13:41 +0800 (CST)
X-Virus-Scanned: amavisd-new at nfschina.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (localhost.localdomain [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id VsiXbWKBOZnm; Fri,  6 Jan 2023 17:13:41 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: yuzhe@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 930E01A009FF;
        Fri,  6 Jan 2023 17:13:40 +0800 (CST)
From:   Yu Zhe <yuzhe@nfschina.com>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, liqiong@nfschina.com,
        Yu Zhe <yuzhe@nfschina.com>
Subject: [PATCH] io_uring: fix some spelling mistakes in comment
Date:   Fri,  6 Jan 2023 17:12:42 +0800
Message-Id: <20230106091242.20288-1-yuzhe@nfschina.com>
X-Mailer: git-send-email 2.11.0
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fix typos in comment.

Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
---
 io_uring/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 58ac13b69dc8..99074d5fe195 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -557,7 +557,7 @@ static void io_eventfd_flush_signal(struct io_ring_ctx *ctx)
 	 * Eventfd should only get triggered when at least one event has been
 	 * posted. Some applications rely on the eventfd notification count
 	 * only changing IFF a new CQE has been added to the CQ ring. There's
-	 * no depedency on 1:1 relationship between how many times this
+	 * no dependency on 1:1 relationship between how many times this
 	 * function is called (and hence the eventfd count) and number of CQEs
 	 * posted to the CQ ring.
 	 */
@@ -2822,7 +2822,7 @@ static __cold void io_tctx_exit_cb(struct callback_head *cb)
 	 * When @in_idle, we're in cancellation and it's racy to remove the
 	 * node. It'll be removed by the end of cancellation, just ignore it.
 	 * tctx can be NULL if the queueing of this task_work raced with
-	 * work cancelation off the exec path.
+	 * work cancellation off the exec path.
 	 */
 	if (tctx && !atomic_read(&tctx->in_idle))
 		io_uring_del_tctx_node((unsigned long)work->ctx);
@@ -3095,7 +3095,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		bool loop = false;
 
 		io_uring_drop_tctx_refs(current);
-		/* read completions before cancelations */
+		/* read completions before cancellations */
 		inflight = tctx_inflight(tctx, !cancel_all);
 		if (!inflight)
 			break;
-- 
2.11.0

