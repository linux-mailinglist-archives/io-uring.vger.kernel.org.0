Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF942599E46
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 17:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349286AbiHSP3n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 11:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348832AbiHSP3m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 11:29:42 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D476C889F
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 08:29:41 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660922980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IGSA/9LIwmVlni7oicB/oQoyBnCtVKkHk456vzjz0Tk=;
        b=pZoi7C7KMgLrSno9WX2Wk1TlQ1KcSn5k0B+fH1pvWQgTsvgibCi2P6mgJR3UEgmEV+edVY
        RKIKO9zQnogsSLmChu0b8HmVBlFkYDaAQPTs3My0ta1C+b8YTsBaRBb6KlijjfVvE7DeFD
        Tw6xSf9CN23wTUMLtpjmc0AT7PPshwE=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 07/19] io-wq: move worker state flags to io-wq.h
Date:   Fri, 19 Aug 2022 23:27:26 +0800
Message-Id: <20220819152738.1111255-8-hao.xu@linux.dev>
In-Reply-To: <20220819152738.1111255-1-hao.xu@linux.dev>
References: <20220819152738.1111255-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Move worker state flags to io-wq.h so that we can levarage them later.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c | 7 -------
 io_uring/io-wq.h | 8 ++++++++
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 5f54af7579a4..55f1063f24c7 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -24,13 +24,6 @@
 
 #define WORKER_IDLE_TIMEOUT	(5 * HZ)
 
-enum {
-	IO_WORKER_F_UP		= 1,	/* up and active */
-	IO_WORKER_F_RUNNING	= 2,	/* account as running */
-	IO_WORKER_F_FREE	= 4,	/* worker on free list */
-	IO_WORKER_F_BOUND	= 8,	/* is doing bounded work */
-};
-
 enum {
 	IO_WQ_BIT_EXIT		= 0,	/* wq exiting */
 };
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index 66d2aeb17951..504a8a8e3fd8 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -27,6 +27,14 @@ enum io_uringlet_state {
 	IO_URINGLET_SCHEDULED,
 };
 
+enum {
+	IO_WORKER_F_UP		= 1,	/* up and active */
+	IO_WORKER_F_RUNNING	= 2,	/* account as running */
+	IO_WORKER_F_FREE	= 4,	/* worker on free list */
+	IO_WORKER_F_BOUND	= 8,	/* is doing bounded work */
+	IO_WORKER_F_SCHEDULED	= 16,	/* worker had been scheduled out before */
+};
+
 typedef struct io_wq_work *(free_work_fn)(struct io_wq_work *);
 typedef int (io_wq_work_fn)(struct io_wq_work *);
 
-- 
2.25.1

