Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E645277C2
	for <lists+io-uring@lfdr.de>; Sun, 15 May 2022 15:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236859AbiEONNU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 May 2022 09:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236858AbiEONNU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 May 2022 09:13:20 -0400
Received: from pv50p00im-ztdg10022001.me.com (pv50p00im-ztdg10022001.me.com [17.58.6.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E603E13F5C
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 06:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1652620398;
        bh=rJGAPD/Ui8BYsy9qFK5mTIpUdBqNqsK4aBpwJj9KTRI=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=zl4ZQ8qLKs38wIQP/UnOluQa4Et8jGq6/NWQjUtiax8RI5I0atFbewJr5gUnrOZxk
         49Kit4gGc33Jo88AvWY3LVXVYw50yDQXfQXRUzZ2jy1g3sOpBjaYWbYFPN8hLnqDTa
         Lpwmhl38dioNWdVnFrqB/62ZePzkwje87Du0jxftB2qv+lr9MuhWAq0fWOHC/2E5ns
         nZ6ZkFgHocPVqvZgMVJMRsPZZkJVsmF7j4KhLHeSLPUKPBLmDS3NeW7vNZsXVt81DA
         RzMhcWXZW3hUIkFq5w1VIGC3mQjBfjxAE7xtP7YRhFsb7mB56HC4OhN+0tNDJA9EvS
         jBIyN+j++xWiw==
Received: from localhost.localdomain (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10022001.me.com (Postfix) with ESMTPSA id CD2E33E1D0E;
        Sun, 15 May 2022 13:13:15 +0000 (UTC)
From:   Hao Xu <haoxu.linux@icloud.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 10/11] io-wq: add an work list for fixed worker
Date:   Sun, 15 May 2022 21:12:29 +0800
Message-Id: <20220515131230.155267-11-haoxu.linux@icloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220515131230.155267-1-haoxu.linux@icloud.com>
References: <20220515131230.155267-1-haoxu.linux@icloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-15_07:2022-05-13,2022-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=861 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2205150069
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

From: Hao Xu <howeyxu@tencent.com>

Previously when a fixed worker handles its private works, it get all of
them from worker->acct.work_list to a temporary acct->work_list. This
prevents work cancellation since the cancellation process cannot find
works from this temporary work list. Thus add a new acct so to address
it.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io-wq.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 66d3c741613f..c6e4179a9961 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -128,6 +128,7 @@ struct io_worker {
 	};
 	int index;
 	struct io_wqe_acct acct;
+	struct io_wqe_acct exec_acct;
 };
 
 #if BITS_PER_LONG == 64
@@ -725,14 +726,17 @@ static void io_worker_handle_work(struct io_worker *worker,
 
 static inline void io_worker_handle_private_work(struct io_worker *worker)
 {
-	struct io_wqe_acct acct;
+	struct io_wqe_acct *acct = &worker->acct;
+	struct io_wqe_acct *exec_acct = &worker->exec_acct;
 
-	raw_spin_lock(&worker->acct.lock);
-	acct = worker->acct;
-	wq_list_clean(&worker->acct.work_list);
-	worker->acct.nr_works = 0;
-	raw_spin_unlock(&worker->acct.lock);
-	io_worker_handle_work(worker, &acct, false);
+	raw_spin_lock(&acct->lock);
+	exec_acct->nr_works = acct->nr_works;
+	exec_acct->max_works = acct->max_works;
+	exec_acct->work_list = acct->work_list;
+	wq_list_clean(&acct->work_list);
+	acct->nr_works = 0;
+	raw_spin_unlock(&acct->lock);
+	io_worker_handle_work(worker, exec_acct, false);
 }
 
 static inline void io_worker_handle_public_work(struct io_worker *worker)
@@ -868,6 +872,7 @@ static void io_init_new_fixed_worker(struct io_wqe *wqe,
 {
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe_acct *iw_acct = &worker->acct;
+	struct io_wqe_acct *exec_acct = &worker->exec_acct;
 	unsigned index = acct->index;
 	unsigned *nr_fixed;
 
@@ -880,6 +885,7 @@ static void io_init_new_fixed_worker(struct io_wqe *wqe,
 	iw_acct->index = index;
 	INIT_WQ_LIST(&iw_acct->work_list);
 	raw_spin_lock_init(&iw_acct->lock);
+	raw_spin_lock_init(&exec_acct->lock);
 	raw_spin_unlock(&acct->lock);
 }
 
-- 
2.25.1

