Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D566F55DC40
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 15:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbiF0Ng1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jun 2022 09:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235941AbiF0NgZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jun 2022 09:36:25 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3374A643A
        for <io-uring@vger.kernel.org>; Mon, 27 Jun 2022 06:36:25 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656336983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4rzKJ453Ym13+cBpJt6sKAiNar/paaU20aGoTw9WDQs=;
        b=lv4E6YksKcduIemt1A1711YcQ/6VbuKZpMJbSt2raP32qHU8CIcih0b745eXTmMSLH2GjQ
        6AKqC3bI9oAhVzhZcq16ZtPNEjDCRFOh7HoMr8K6foXHIVkqvEi+xpUBn+ja2KqovChInq
        hfBJ5PFaSr3dNyko8EcEf6Vf0kD6KRM=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 11/11] io_uring: cancel works in exec work list for fixed worker
Date:   Mon, 27 Jun 2022 21:35:41 +0800
Message-Id: <20220627133541.15223-12-hao.xu@linux.dev>
In-Reply-To: <20220627133541.15223-1-hao.xu@linux.dev>
References: <20220627133541.15223-1-hao.xu@linux.dev>
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

When users want to cancel a request, look into the exec work list of
fixed worker as well. It's not sane to ignore it.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c | 44 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 9 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 38d88da70a40..9e8ad7455373 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1285,32 +1285,44 @@ static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
 	return false;
 }
 
-static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
-				       struct io_cb_cancel_data *match)
+static void io_wqe_cancel_pending_work_normal(struct io_wqe *wqe,
+					      struct io_cb_cancel_data *match)
 {
-	int i, j;
-	struct io_wqe_acct *acct, *iw_acct;
+	int i;
+	struct io_wqe_acct *acct;
 
-retry_public:
+retry:
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
 		acct = io_get_acct(wqe, i == 0, false);
 		if (io_acct_cancel_pending_work(wqe, acct, match)) {
 			if (match->cancel_all)
-				goto retry_public;
+				goto retry;
 			return;
 		}
 	}
+}
+
+static void __io_wqe_cancel_pending_work_fixed(struct io_wqe *wqe,
+					       struct io_cb_cancel_data *match,
+					       bool exec)
+{
+	int i, j;
+	struct io_wqe_acct *acct, *iw_acct;
 
-retry_private:
+retry:
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
 		acct = io_get_acct(wqe, i == 0, true);
 		raw_spin_lock(&acct->lock);
 		for (j = 0; j < acct->nr_fixed; j++) {
-			iw_acct = &acct->fixed_workers[j]->acct;
+			if (exec)
+				iw_acct = &acct->fixed_workers[j]->acct;
+			else
+				iw_acct = &acct->fixed_workers[j]->exec_acct;
+
 			if (io_acct_cancel_pending_work(wqe, iw_acct, match)) {
 				if (match->cancel_all) {
 					raw_spin_unlock(&acct->lock);
-					goto retry_private;
+					goto retry;
 				}
 				break;
 			}
@@ -1319,6 +1331,20 @@ static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 	}
 }
 
+static void io_wqe_cancel_pending_work_fixed(struct io_wqe *wqe,
+					     struct io_cb_cancel_data *match)
+{
+	__io_wqe_cancel_pending_work_fixed(wqe, match, false);
+	__io_wqe_cancel_pending_work_fixed(wqe, match, true);
+}
+
+static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
+				       struct io_cb_cancel_data *match)
+{
+	io_wqe_cancel_pending_work_normal(wqe, match);
+	io_wqe_cancel_pending_work_fixed(wqe, match);
+}
+
 static void io_wqe_cancel_running_work(struct io_wqe *wqe,
 				       struct io_cb_cancel_data *match)
 {
-- 
2.25.1

