Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02803331D33
	for <lists+io-uring@lfdr.de>; Tue,  9 Mar 2021 03:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhCIC6z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 21:58:55 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13074 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhCIC60 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 21:58:26 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Dvfwj0zDgzMkpH;
        Tue,  9 Mar 2021 10:56:05 +0800 (CST)
Received: from code-website.localdomain (10.175.127.227) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Mar 2021 10:58:08 +0800
From:   yangerkun <yangerkun@huawei.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <yi.zhang@huawei.com>,
        <yangerkun@huawei.com>
Subject: [PATCH] io-wq: fix ref leak for req
Date:   Tue, 9 Mar 2021 11:05:08 +0800
Message-ID: <20210309030508.3294675-1-yangerkun@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

do_work such as io_wq_submit_work that cancel the work will leave ref of
req as 1. Fix it by call io_run_cancel.

Fixes: 4fb6ac326204 ("io-wq: improve manager/worker handling over exec")
Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 fs/io-wq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 28868eb4cd09..0229fed33b99 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -794,8 +794,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	/* Can only happen if manager creation fails after exec */
 	if (io_wq_fork_manager(wqe->wq) ||
 	    test_bit(IO_WQ_BIT_EXIT, &wqe->wq->state)) {
-		work->flags |= IO_WQ_WORK_CANCEL;
-		wqe->wq->do_work(work);
+		io_run_cancel(work, wqe);
 		return;
 	}
 
-- 
2.25.4

