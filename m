Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C835E599E2F
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 17:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349457AbiHSPaB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 11:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349346AbiHSPaB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 11:30:01 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E490E190F
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 08:30:00 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660922998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+YsntrCxlmtQqRERzu/3Vp4m/8M9+TB2udMIBj6/Xpk=;
        b=R2VLhr8kTQoRMeW3knzwqBu5KNW+rO/K2pzok6EeVvjQMtNyzkpFmzF7lzw+9wJjCe6OEb
        K9et+WVp7mbeJN6LnCjxGvCD5Fj8nNEmrMfjvenJvANGqnlRciKCtHBRK8wXBH+yWPCq2x
        ZxezT4kXDsdB2MMbjqgdhMg7gGbZMgI=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 12/19] io_uring: add uringlet worker cancellation function
Date:   Fri, 19 Aug 2022 23:27:31 +0800
Message-Id: <20220819152738.1111255-13-hao.xu@linux.dev>
In-Reply-To: <20220819152738.1111255-1-hao.xu@linux.dev>
References: <20220819152738.1111255-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

uringlet worker submits sqes, so we need to do some cancellation work
before it exits.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io_uring.c | 6 ++++++
 io_uring/io_uring.h | 1 +
 io_uring/tctx.c     | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a5fb6fa02ded..67d02dc16ea5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2922,6 +2922,12 @@ void __io_uring_cancel(bool cancel_all)
 	io_uring_cancel_generic(cancel_all, NULL);
 }
 
+struct io_wq_work *io_uringlet_cancel(struct io_wq_work *work)
+{
+	__io_uring_cancel(true);
+	return NULL;
+}
+
 static void *io_uring_validate_mmap_request(struct file *file,
 					    loff_t pgoff, size_t sz)
 {
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index b95d92619607..011d0beb33bf 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -71,6 +71,7 @@ int io_req_prep_async(struct io_kiocb *req);
 void io_uringlet_end(struct io_ring_ctx *ctx);
 
 struct io_wq_work *io_wq_free_work(struct io_wq_work *work);
+struct io_wq_work *io_uringlet_cancel(struct io_wq_work *work);
 int io_wq_submit_work(struct io_wq_work *work);
 
 void io_free_req(struct io_kiocb *req);
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index b04d361bcf34..e10b20725066 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -41,9 +41,11 @@ struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 	if (ctx->flags & IORING_SETUP_URINGLET) {
 		data.private = ctx;
 		data.do_work = io_submit_sqes_let;
+		data.free_work = io_uringlet_cancel;
 	} else {
 		data.private = NULL;
 		data.do_work = io_wq_submit_work;
+		data.free_work = io_wq_free_work;
 	}
 
 	/* Do QD, or 4 * CPUS, whatever is smallest */
-- 
2.25.1

