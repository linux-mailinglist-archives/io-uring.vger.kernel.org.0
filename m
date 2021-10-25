Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E920B439978
	for <lists+io-uring@lfdr.de>; Mon, 25 Oct 2021 16:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbhJYPBm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Oct 2021 11:01:42 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:47359 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbhJYPBl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Oct 2021 11:01:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1635173959; x=1666709959;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=v47IaqsvJy1lQ8q9u0DtWPDOnaJsL9/27Uf8oPYRiQI=;
  b=hBh+NJWqMZcH+n0qzubSzjro3JpoDx79laZeS1fZfuMVXEV6LP7R8blO
   Kffd5GeufMM35pZj1rnvzThG2JCrDwvljwEnz1OYC7b6tlXfNaqTAyvZY
   qkZPzv79pyAGSNUuE2YUPxluUoMzD+XRaRz0F/dHLLk5HNuuuGtNEO0e0
   w=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 25 Oct 2021 07:59:19 -0700
X-QCInternal: smtphost
Received: from nalasex01a.na.qualcomm.com ([10.47.209.196])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2021 07:59:18 -0700
Received: from qian-HP-Z2-SFF-G5-Workstation.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7;
 Mon, 25 Oct 2021 07:59:17 -0700
From:   Qian Cai <quic_qiancai@quicinc.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Qian Cai <quic_qiancai@quicinc.com>
Subject: [PATCH] io_uring: fix a GCC warning in wq_list_for_each()
Date:   Mon, 25 Oct 2021 10:59:06 -0400
Message-ID: <20211025145906.71955-1-quic_qiancai@quicinc.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

fs/io_uring.c: In function '__io_submit_flush_completions':
fs/io_uring.c:2367:33: warning: variable 'prev' set but not used
[-Wunused-but-set-variable]
 2367 |  struct io_wq_work_node *node, *prev;
      |                                 ^~~~

Fixed it by open-coded the wq_list_for_each() without an unused previous
node pointer.

Fixes: 6f33b0bc4ea4 ("io_uring: use slist for completion batching")
Signed-off-by: Qian Cai <quic_qiancai@quicinc.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 23641d9e0871..b8968bd43e3f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2361,11 +2361,11 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
-	struct io_wq_work_node *node, *prev;
+	struct io_wq_work_node *node;
 	struct io_submit_state *state = &ctx->submit_state;
 
 	spin_lock(&ctx->completion_lock);
-	wq_list_for_each(node, prev, &state->compl_reqs) {
+	for (node = state->compl_reqs.first; node; node = node->next) {
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    comp_list);
 
-- 
2.30.2

