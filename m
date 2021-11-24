Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D519745B39F
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 05:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbhKXEuH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 23:50:07 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:56248 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229714AbhKXEuG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 23:50:06 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uy45oE2_1637729208;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uy45oE2_1637729208)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Nov 2021 12:46:56 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 4/9] io-wq: use IO_WQ_ACCT_NR rather than hardcoded number
Date:   Wed, 24 Nov 2021 12:46:43 +0800
Message-Id: <20211124044648.142416-5-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211124044648.142416-1-haoxu@linux.alibaba.com>
References: <20211124044648.142416-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 443c34d9b326..dce365013bd5 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -90,7 +90,7 @@ enum {
  */
 struct io_wqe {
 	raw_spinlock_t lock;
-	struct io_wqe_acct acct[2];
+	struct io_wqe_acct acct[IO_WQ_ACCT_NR];
 
 	int node;
 
@@ -1317,7 +1317,7 @@ int io_wq_max_workers(struct io_wq *wq, int *new_count)
 	BUILD_BUG_ON((int) IO_WQ_ACCT_UNBOUND != (int) IO_WQ_UNBOUND);
 	BUILD_BUG_ON((int) IO_WQ_ACCT_NR      != 2);
 
-	for (i = 0; i < 2; i++) {
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
 		if (new_count[i] > task_rlimit(current, RLIMIT_NPROC))
 			new_count[i] = task_rlimit(current, RLIMIT_NPROC);
 	}
-- 
2.24.4

