Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47E85277BA
	for <lists+io-uring@lfdr.de>; Sun, 15 May 2022 15:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236816AbiEONMv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 May 2022 09:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiEONMu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 May 2022 09:12:50 -0400
Received: from pv50p00im-ztdg10022001.me.com (pv50p00im-ztdg10022001.me.com [17.58.6.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379D113F4D
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 06:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1652620368;
        bh=uJ0pqWWpnuc7GJRogOjjyoIXjcnFfu3jefX0WElOP9s=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=T78zuiDWrecsG4+3X45ts7Q7/qgdqgA5pYoLCQTiZ3Z6NspafRXfJ5VKGrlxF30GN
         t+F5X5MEi5/Sn1muKjNrrrqxFz3XTg6uVFYP8xvz5dVT7iRGf6XPa1CH7A59Pz+IrQ
         csou1pKTrTzw+0cJRVoBanT6HRFALVs9VzW+wTdZfGjQ/f7UViZt2iRDZNq4PxzJ4/
         WJxiK1BEmZZJWpMiUlILNNWw3PqP1v4GonpjvZe3DA1d1R97oeus+72AD9GY/RTtrH
         xgyy2wqyB0a4u6eRP5NNvHWYPKc2Bk8LvqdSz/G1mVJQsddVlr0j8AWx6KG/GDlETv
         ryPxXX3FbCeZQ==
Received: from localhost.localdomain (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10022001.me.com (Postfix) with ESMTPSA id 35FE03E1F13;
        Sun, 15 May 2022 13:12:44 +0000 (UTC)
From:   Hao Xu <haoxu.linux@icloud.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 02/11] io-wq: change argument of create_io_worker() for convienence
Date:   Sun, 15 May 2022 21:12:21 +0800
Message-Id: <20220515131230.155267-3-haoxu.linux@icloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220515131230.155267-1-haoxu.linux@icloud.com>
References: <20220515131230.155267-1-haoxu.linux@icloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-15_07:2022-05-13,2022-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=800 adultscore=0 classifier=spam adjust=0 reason=mlx
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

From: Hao Xu <haoxu.linux@gmail.com>

From: Hao Xu <howeyxu@tencent.com>

Change index to acct itself for create_io_worker() for convienence in
the next patches.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io-wq.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 0c26805ca6de..35ce622f77ba 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -139,7 +139,8 @@ struct io_cb_cancel_data {
 	bool cancel_all;
 };
 
-static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index);
+static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe,
+			     struct io_wqe_acct *acct);
 static void io_wqe_dec_running(struct io_worker *worker);
 static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
 					struct io_wqe_acct *acct,
@@ -306,7 +307,7 @@ static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 	raw_spin_unlock(&wqe->lock);
 	atomic_inc(&acct->nr_running);
 	atomic_inc(&wqe->wq->worker_refs);
-	return create_io_worker(wqe->wq, wqe, acct->index);
+	return create_io_worker(wqe->wq, wqe, acct);
 }
 
 static void io_wqe_inc_running(struct io_worker *worker)
@@ -335,7 +336,7 @@ static void create_worker_cb(struct callback_head *cb)
 	}
 	raw_spin_unlock(&wqe->lock);
 	if (do_create) {
-		create_io_worker(wq, wqe, worker->create_index);
+		create_io_worker(wq, wqe, acct);
 	} else {
 		atomic_dec(&acct->nr_running);
 		io_worker_ref_put(wq);
@@ -812,9 +813,10 @@ static void io_workqueue_create(struct work_struct *work)
 		kfree(worker);
 }
 
-static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
+static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe,
+			     struct io_wqe_acct *acct)
 {
-	struct io_wqe_acct *acct = &wqe->acct[index];
+	int index = acct->index;
 	struct io_worker *worker;
 	struct task_struct *tsk;
 
-- 
2.25.1

