Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3740729A1C
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 14:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjFIMeH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 08:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239889AbjFIMeG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 08:34:06 -0400
Received: from out-20.mta0.migadu.com (out-20.mta0.migadu.com [IPv6:2001:41d0:1004:224b::14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6630D2D74
        for <io-uring@vger.kernel.org>; Fri,  9 Jun 2023 05:33:34 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686313247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7lBQguwOSNqTMHDu49k7jJ6U7XUSmaL2MWuon1bNrYI=;
        b=pW0zezHFuhSizOXJSgU9qqdjxlwEH8tCtCuhBQudYD5y/0wQKdvDtjzCLUQs8pSOjPfvgI
        J77gP4XhXBIseej7ddg5mIKh+cleNsnJOVZBx+FX1/OKwgyYVXZZUBUQ/JEZK4tp4nwVFm
        vAWsLK4aO8+HrAhW1m9i13XZTA97i0I=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 03/11] io-wq: add a new type io-wq worker
Date:   Fri,  9 Jun 2023 20:20:23 +0800
Message-Id: <20230609122031.183730-4-hao.xu@linux.dev>
In-Reply-To: <20230609122031.183730-1-hao.xu@linux.dev>
References: <20230609122031.183730-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add a new type io-wq worker IO_WORKER_F_FIXED, this type of worker
exists during the whole io-wq lifecycle.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 1717f1465613..7326fef58ca7 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -30,6 +30,7 @@ enum {
 	IO_WORKER_F_FREE	= 4,	/* worker on free list */
 	IO_WORKER_F_BOUND	= 8,	/* is doing bounded work */
 	IO_WORKER_F_EXIT	= 16,	/* worker is exiting */
+	IO_WORKER_F_FIXED	= 32,	/* is a fixed worker */
 };
 
 enum {
@@ -598,6 +599,11 @@ static bool is_worker_exiting(struct io_worker *worker)
 	return worker->flags & IO_WORKER_F_EXIT;
 }
 
+static bool is_fixed_worker(struct io_worker *worker)
+{
+	return worker->flags & IO_WORKER_F_FIXED;
+}
+
 static int io_wq_worker(void *data)
 {
 	struct io_worker *worker = data;
@@ -622,8 +628,13 @@ static int io_wq_worker(void *data)
 		/*
 		 * Last sleep timed out. Exit if we're not the last worker,
 		 * or if someone modified our affinity.
+		 * Note: fixed worker always have same lifecycle as io-wq
+		 * itself, and cpu affinity setting doesn't work well for
+		 * fixed worker, they can be manually reset to cpu other than
+		 * the cpuset indicated by io_wq_worker_affinity()
 		 */
-		if (last_timeout && (exit_mask || acct->nr_workers > 1)) {
+		if (!is_fixed_worker(worker) && last_timeout &&
+		    (exit_mask || acct->nr_workers > 1)) {
 			acct->nr_workers--;
 			raw_spin_unlock(&wq->lock);
 			__set_current_state(TASK_RUNNING);
-- 
2.25.1

