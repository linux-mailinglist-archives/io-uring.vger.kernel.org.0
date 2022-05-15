Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF985277B9
	for <lists+io-uring@lfdr.de>; Sun, 15 May 2022 15:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236835AbiEONMp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 May 2022 09:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236816AbiEONMp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 May 2022 09:12:45 -0400
Received: from pv50p00im-ztdg10022001.me.com (pv50p00im-ztdg10022001.me.com [17.58.6.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09D2DF86
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 06:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1652620364;
        bh=kxtyT4v3y7eBOPoFyfuhFFHTGOnQN8ILhgOcq6JGNUQ=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=eE24tBBDWSlJ5e7i/FU/ox4di9IXhw2YSH0yFXbqiRmxGnJQl96wfNWN4/ntNAJ3N
         iRCK0vMI8ODUAlqRFixahuU3AiuTzgBQFj+55+nJvkAfMOEm+mtjoiHO15B6f23A1p
         5xamA2mpIErqUe6YFSZtG6c8yUJVFxFIYMpX83WnqkNXA9eFK1xkFxTJO9i1kE6XlC
         xvQjvjV9/kWrS2x5Xpu/4BVCVXvcocLR7qSC7gTZIpOv55yyzVurG26XGMG+YEVwT8
         +iIlX3znumBIA/m6sb8dUaUwL1SPxzGD4zfHg48Szr/u/WBuf3aGEfqJl5fXTVvDrT
         EVpEpgq2q9naQ==
Received: from localhost.localdomain (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10022001.me.com (Postfix) with ESMTPSA id 382B83E1F20;
        Sun, 15 May 2022 13:12:40 +0000 (UTC)
From:   Hao Xu <haoxu.linux@icloud.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 01/11] io-wq: add a worker flag for individual exit
Date:   Sun, 15 May 2022 21:12:20 +0800
Message-Id: <20220515131230.155267-2-haoxu.linux@icloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220515131230.155267-1-haoxu.linux@icloud.com>
References: <20220515131230.155267-1-haoxu.linux@icloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-15_07:2022-05-13,2022-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=544 adultscore=0 classifier=spam adjust=0 reason=mlx
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

Add a worker flag to control exit of an individual worker, this is
needed for fixed worker in the next patches but also as a generic
functionality.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io-wq.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 824623bcf1a5..0c26805ca6de 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -26,6 +26,7 @@ enum {
 	IO_WORKER_F_RUNNING	= 2,	/* account as running */
 	IO_WORKER_F_FREE	= 4,	/* worker on free list */
 	IO_WORKER_F_BOUND	= 8,	/* is doing bounded work */
+	IO_WORKER_F_EXIT	= 32,	/* worker is exiting */
 };
 
 enum {
@@ -639,8 +640,12 @@ static int io_wqe_worker(void *data)
 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
 		long ret;
 
+		if (worker->flags & IO_WORKER_F_EXIT)
+			break;
+
 		set_current_state(TASK_INTERRUPTIBLE);
-		while (io_acct_run_queue(acct))
+		while (!(worker->flags & IO_WORKER_F_EXIT) &&
+		       io_acct_run_queue(acct))
 			io_worker_handle_work(worker);
 
 		raw_spin_lock(&wqe->lock);
@@ -656,6 +661,10 @@ static int io_wqe_worker(void *data)
 		raw_spin_unlock(&wqe->lock);
 		if (io_flush_signals())
 			continue;
+		if (worker->flags & IO_WORKER_F_EXIT) {
+			__set_current_state(TASK_RUNNING);
+			break;
+		}
 		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
 		if (signal_pending(current)) {
 			struct ksignal ksig;
-- 
2.25.1

