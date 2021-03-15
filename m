Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB2433C4E7
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 18:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhCOR4G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 13:56:06 -0400
Received: from h4.fbrelay.privateemail.com ([131.153.2.45]:38211 "EHLO
        h4.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229460AbhCORzg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 13:55:36 -0400
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Mar 2021 13:55:35 EDT
Received: from MTA-11-4.privateemail.com (mta-11.privateemail.com [198.54.118.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h3.fbrelay.privateemail.com (Postfix) with ESMTPS id 2B6A48142D;
        Mon, 15 Mar 2021 13:47:30 -0400 (EDT)
Received: from mta-11.privateemail.com (localhost [127.0.0.1])
        by mta-11.privateemail.com (Postfix) with ESMTP id 56C998008C;
        Mon, 15 Mar 2021 13:46:29 -0400 (EDT)
Received: from pwning.systems.github.io (unknown [10.20.151.213])
        by mta-11.privateemail.com (Postfix) with ESMTPA id 0F5288004A;
        Mon, 15 Mar 2021 13:46:27 -0400 (EDT)
From:   Jordy Zomer <jordy@pwning.systems>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jordy Zomer <jordy@pwning.systems>
Subject: [PATCH] Fix use-after-free in io_wqe_inc_running() due to wq already being free'd
Date:   Mon, 15 Mar 2021 18:44:26 +0100
Message-Id: <20210315174425.2201225-1-jordy@pwning.systems>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

My syzkaller instance reported a use-after-free bug in io_wqe_inc_running.
I tried fixing this by checking if wq isn't NULL in io_wqe_worker.
If it does; return an -EFAULT. This because create_io_worker() will clean-up the worker if there's an error.

If you want I could send you the syzkaller reproducer and crash-logs :)

Best Regards,

Jordy Zomer

Signed-off-by: Jordy Zomer <jordy@pwning.systems>
---
 fs/io-wq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 0ae9ecadf295..9ed92d88a088 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -482,6 +482,10 @@ static int io_wqe_worker(void *data)
 	char buf[TASK_COMM_LEN];
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
+
+	if (wq == NULL)
+		return -EFAULT;
+
 	io_wqe_inc_running(worker);
 
 	sprintf(buf, "iou-wrk-%d", wq->task_pid);
-- 
2.25.1

