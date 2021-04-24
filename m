Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA4036A398
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 01:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhDXX1m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 24 Apr 2021 19:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbhDXX1m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 24 Apr 2021 19:27:42 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C623C061574
        for <io-uring@vger.kernel.org>; Sat, 24 Apr 2021 16:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=2OuixULh4lQXL4ZjiBiRL9Oyqmt4DAv+NW69kjTcAUE=; b=KClWa+0BHMgbxpUROIr3oTwWX5
        rtgpKCQ6FtNt2jFfVOYL+sojSt6IoQIxc3GMOsge6ubBUD+5CkhTZr3Al32NSVyr7FVFfORYbhcyS
        HKrOE4lZTRnk1ZKbQfjiTm1AEgR11r8O8oZiQhgjB+0VKHo1USIhxmg/m4D5x6Kc0rmivjy424l7r
        dG7TYSrZ2KFZGO2bYcT/exyEetxRHL48kMFAj6SOB0WOqk8/2OQ9BVLUpL5mnnEHHqffnKVAwg3Zn
        18AJV9wQ7OPnZhmv5UZie+9qksvbVK9q2oGyd8pnJHb+iOAihW7MbOrIDo/FM3Q1c7TNJA2L9IwCH
        MdvsgKUz+K7MVZQMu70Tyh5bbWLlLNvnkgxyGzTdV3WU3I1d4Fh0VImNv2X6f3+fQkV3/gp9Wknr0
        JSIKdA7fuA7RY15n1MhFDspgKCQR2XLLizGMkDm8Up4iSCv5FYkG6rtNhSkgKi0AKkCb6pTaUqAuT
        CkQDyEKMvu9vC6EKXNiZt6HF;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1laRfx-0007X6-5S; Sat, 24 Apr 2021 23:27:01 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v3 5/6] io-wq: warn about future set_task_comm() overflows.
Date:   Sun, 25 Apr 2021 01:26:07 +0200
Message-Id: <94254f497b59e7fda85503c643ec5a2e25a30c0d.1619306115.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1619306115.git.metze@samba.org>
References: <cover.1619306115.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/io-wq.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index cd1af924c3d1..b80c5d905127 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -640,7 +640,19 @@ static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 		return;
 	}
 
-	snprintf(tsk_comm, sizeof(tsk_comm), "iou-wrk-%d", wq->task->pid);
+	/*
+	 * The limit value of pid_max_max/PID_MAX_LIMIT
+	 * is 4 * 1024 * 1024 = 4194304.
+	 *
+	 * TASK_COMM_LEN is 16, so we have 15 chars to fill.
+	 *
+	 * With "iou-wrk-4194304" we just fit into 15 chars.
+	 * If that ever changes we may better add some special
+	 * handling for PF_IO_WORKER in proc_task_name(), as that
+	 * allows up to 63 chars.
+	 */
+	WARN_ON(snprintf(tsk_comm, sizeof(tsk_comm),
+			 "iou-wrk-%d", wq->task->pid) >= sizeof(tsk_comm));
 	set_task_comm(tsk, tsk_comm);
 
 	tsk->pf_io_worker = worker;
-- 
2.25.1

