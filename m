Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF184AAEB5
	for <lists+io-uring@lfdr.de>; Sun,  6 Feb 2022 10:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbiBFJwy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Feb 2022 04:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbiBFJwx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Feb 2022 04:52:53 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A13C06109E
        for <io-uring@vger.kernel.org>; Sun,  6 Feb 2022 01:52:52 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V3fxVZ8_1644141170;
Received: from localhost.localdomain(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V3fxVZ8_1644141170)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 06 Feb 2022 17:52:50 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 3/3] io-wq: use IO_WQ_ACCT_NR rather than hardcoded number
Date:   Sun,  6 Feb 2022 17:52:41 +0800
Message-Id: <20220206095241.121485-4-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220206095241.121485-1-haoxu@linux.alibaba.com>
References: <20220206095241.121485-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's better to use the defined enum stuff not the hardcoded number to
define array.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index f7b7fa396faf..5b93fa67d346 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -92,7 +92,7 @@ enum {
  */
 struct io_wqe {
 	raw_spinlock_t lock;
-	struct io_wqe_acct acct[2];
+	struct io_wqe_acct acct[IO_WQ_ACCT_NR];
 
 	int node;
 
@@ -1376,7 +1376,7 @@ int io_wq_max_workers(struct io_wq *wq, int *new_count)
 	BUILD_BUG_ON((int) IO_WQ_ACCT_UNBOUND != (int) IO_WQ_UNBOUND);
 	BUILD_BUG_ON((int) IO_WQ_ACCT_NR      != 2);
 
-	for (i = 0; i < 2; i++) {
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
 		if (new_count[i] > task_rlimit(current, RLIMIT_NPROC))
 			new_count[i] = task_rlimit(current, RLIMIT_NPROC);
 	}
-- 
2.25.1

