Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2B15277BE
	for <lists+io-uring@lfdr.de>; Sun, 15 May 2022 15:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236847AbiEONNE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 May 2022 09:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236841AbiEONND (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 May 2022 09:13:03 -0400
Received: from pv50p00im-ztdg10022001.me.com (pv50p00im-ztdg10022001.me.com [17.58.6.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9BE13F55
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 06:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1652620382;
        bh=ONT5hvc4ak0dbvjGAMFJw+Jx/e6Ar6ZjDNAyJ2HnnT8=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=AK5IZKf2E23JO2CA1MeiopmI8brlBTIlQe2QPXRRS0OrV7jdYoIFQDh1gtBlc1ybc
         m5XbGKaxA48KnfBCQow680SeuqO0RMw1yRYf1vVqDc5MLUlamaK7OaQh8LKemuBBHe
         7Pcw83v9eP8jutkE6yx3qEJrxWgFpMfYH9ODHjpQFI6DzhNioCFDeQnSabyduGkuFn
         Iz1UjIF/5oEAU0MEXb/dbTkjDIaf+Bkxl2dx8pS8uYZGfs7Un3Pxi87eobw5dsslMQ
         IsnbFCfB6OvIPZrnnKbFTh+IKymUfw/f3GvyEecyJr9TApyrwW20Wl44QMHiEwqJxf
         ZrvFU1JOkskuA==
Received: from localhost.localdomain (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10022001.me.com (Postfix) with ESMTPSA id 8DE143E1F16;
        Sun, 15 May 2022 13:12:59 +0000 (UTC)
From:   Hao Xu <haoxu.linux@icloud.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 06/11] io-wq: fixed worker exit
Date:   Sun, 15 May 2022 21:12:25 +0800
Message-Id: <20220515131230.155267-7-haoxu.linux@icloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220515131230.155267-1-haoxu.linux@icloud.com>
References: <20220515131230.155267-1-haoxu.linux@icloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-15_07:2022-05-13,2022-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=983 adultscore=0 classifier=spam adjust=0 reason=mlx
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

Implement the fixed worker exit

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io-wq.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 329b3ff01545..c57920ad90a0 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -266,6 +266,29 @@ static bool io_task_worker_match(struct callback_head *cb, void *data)
 	return worker == data;
 }
 
+static void io_fixed_worker_exit(struct io_worker *worker)
+{
+	int *nr_fixed;
+	int index = worker->acct.index;
+	struct io_wqe *wqe = worker->wqe;
+	struct io_wqe_acct *acct = io_get_acct(wqe, index == 0, true);
+	struct io_worker **fixed_workers;
+
+	raw_spin_lock(&acct->lock);
+	fixed_workers = acct->fixed_workers;
+	if (!fixed_workers || worker->index == -1) {
+		raw_spin_unlock(&acct->lock);
+		return;
+	}
+	nr_fixed = &acct->nr_fixed;
+	/* reuse variable index to represent fixed worker index in its array */
+	index = worker->index;
+	fixed_workers[index] = fixed_workers[*nr_fixed - 1];
+	(*nr_fixed)--;
+	fixed_workers[index]->index = index;
+	raw_spin_unlock(&acct->lock);
+}
+
 static void io_worker_exit(struct io_worker *worker)
 {
 	struct io_wqe *wqe = worker->wqe;
@@ -689,6 +712,7 @@ static int io_wqe_worker(void *data)
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 	bool last_timeout = false;
+	bool fixed = worker->flags & IO_WORKER_F_FIXED;
 	char buf[TASK_COMM_LEN];
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
@@ -739,6 +763,8 @@ static int io_wqe_worker(void *data)
 
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
 		io_worker_handle_work(worker);
+	if (fixed)
+		io_fixed_worker_exit(worker);
 
 	audit_free(current);
 	io_worker_exit(worker);
-- 
2.25.1

