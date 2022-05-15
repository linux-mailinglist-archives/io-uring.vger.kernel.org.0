Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724AA5277BD
	for <lists+io-uring@lfdr.de>; Sun, 15 May 2022 15:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236856AbiEONNB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 May 2022 09:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236841AbiEONNA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 May 2022 09:13:00 -0400
Received: from pv50p00im-ztdg10022001.me.com (pv50p00im-ztdg10022001.me.com [17.58.6.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C49C13F4C
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 06:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1652620378;
        bh=LbSTszaxwSmnz3KA0tGezW5v1AbO2VnrRtfC3UGgb0Y=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=ITEFtRA3ytQh84H9rk/z4ehAhtOGfvRwwKa4GhcGL/21gRoHtP0cUvtYp++NHXeot
         WZLGZ5UzlDtCGf/JZ9JSx9TDrQBAiPE5R8azB4aogtrQ7AxHDBoKhK69YCl1GLEwgi
         80QqFtnavhehVORlDUCXtOChXtlBbWmJLwiBIlvvkbzmuxMN2gfcZhjHmbVYRdXbb/
         7izuBOkwVSQdpeXxakx0my/0ZI762zv2QJpPSlzlG24UwaiJoteJi7t5Yx+ekaLDJ2
         b9HbjRlQCD8Wfd2tspzBPoIZsMC5mO373Rbv1d+UZFzq624iYjwxmVAUE/iUvwX1TK
         rFD9BYI2pycsA==
Received: from localhost.localdomain (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10022001.me.com (Postfix) with ESMTPSA id 1A1653E1F17;
        Sun, 15 May 2022 13:12:55 +0000 (UTC)
From:   Hao Xu <haoxu.linux@icloud.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 05/11] io-wq: fixed worker initialization
Date:   Sun, 15 May 2022 21:12:24 +0800
Message-Id: <20220515131230.155267-6-haoxu.linux@icloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220515131230.155267-1-haoxu.linux@icloud.com>
References: <20220515131230.155267-1-haoxu.linux@icloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-15_07:2022-05-13,2022-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=821 adultscore=0 classifier=spam adjust=0 reason=mlx
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

Implementation of the fixed worker initialization.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io-wq.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 8db3132dc3a1..329b3ff01545 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -781,6 +781,26 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 	io_wqe_dec_running(worker);
 }
 
+static void io_init_new_fixed_worker(struct io_wqe *wqe,
+				     struct io_worker *worker)
+{
+	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+	struct io_wqe_acct *iw_acct = &worker->acct;
+	unsigned index = acct->index;
+	unsigned *nr_fixed;
+
+	raw_spin_lock(&acct->lock);
+	nr_fixed = &acct->nr_fixed;
+	acct->fixed_workers[*nr_fixed] = worker;
+	worker->index = (*nr_fixed)++;
+	iw_acct->nr_works = 0;
+	iw_acct->max_works = acct->max_works;
+	iw_acct->index = index;
+	INIT_WQ_LIST(&iw_acct->work_list);
+	raw_spin_lock_init(&iw_acct->lock);
+	raw_spin_unlock(&acct->lock);
+}
+
 static void io_init_new_worker(struct io_wqe *wqe, struct io_worker *worker,
 			       struct task_struct *tsk)
 {
@@ -794,6 +814,8 @@ static void io_init_new_worker(struct io_wqe *wqe, struct io_worker *worker,
 	list_add_tail_rcu(&worker->all_list, &wqe->all_list);
 	worker->flags |= IO_WORKER_F_FREE;
 	raw_spin_unlock(&wqe->lock);
+	if (worker->flags & IO_WORKER_F_FIXED)
+		io_init_new_fixed_worker(wqe, worker);
 	wake_up_new_task(tsk);
 }
 
@@ -900,6 +922,8 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe,
 
 	if (index == IO_WQ_ACCT_BOUND)
 		worker->flags |= IO_WORKER_F_BOUND;
+	if (&wqe->fixed_acct[index] == acct)
+		worker->flags |= IO_WORKER_F_FIXED;
 
 	tsk = create_io_thread(io_wqe_worker, worker, wqe->node);
 	if (!IS_ERR(tsk)) {
-- 
2.25.1

