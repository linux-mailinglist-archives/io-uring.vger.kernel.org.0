Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D9333C341
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 18:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbhCORDb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 13:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbhCORCw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 13:02:52 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2D8C061763
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 10:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=I8/e2LSz/iZT2C/Twx5FSD5vKUDjCWsGcRorMTUpzvU=; b=EnX4s5zqLa0dM58hcVdZn8yGah
        CWhsUPtnU6aMQHi6QZnsTfrn38r43vV13Wo/dr0WBMOa+Idwh23sL1U+53GHDedgDGvfpa+I2A4Mn
        u34t9LG9lU4/s+XiwrZ9RIVwfeNDEHrei7C3Sja1hWnpTSwRR+4F70V6O3U5BbbSlfIBVts3pke+d
        5+qFUg9VnH/iD2t1yjEPjmVNnB4OoDrHYnAD5OSvA/Qe7WiABE2ug3yd14lp48eRnQ46X17UV7Z9c
        oYVBIaIDfNnS/wGsQmC5phMx5lAeEqBjedT9a8sIs1zBsWYUgNq4DkQGSpGzGV4KAafh4bX6vuCY+
        +G3X0vX+T1xn0ehKdB1GetTfRoT8o2TjkeuxFGdpVtHkZ516iNTfnG50GcDqdV3iGTxRRB+yj7uQu
        3kI8wyxLykynh9LKe3HMtljhdBlLE8OSrCvk9+pDSDEH8cWPauVygjcszZHQD4SoD12CrBexeYKhF
        TnrV7I9cC2++wSQyqZYhEBU6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lLqcC-00057S-6l; Mon, 15 Mar 2021 17:02:48 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [RFC PATCH 07/10] fs/proc: hide PF_IO_WORKER in get_task_cmdline()
Date:   Mon, 15 Mar 2021 18:01:45 +0100
Message-Id: <5b4b96871fe0c21ba7fea2d0b8207ba85be0af08.1615826736.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1615826736.git.metze@samba.org>
References: <cover.1615826736.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We should not return the userspace cmdline for io_worker threads.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/proc/base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 3851bfcdba56..6e04278de582 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -344,6 +344,9 @@ static ssize_t get_task_cmdline(struct task_struct *tsk, char __user *buf,
 	struct mm_struct *mm;
 	ssize_t ret;
 
+	if (tsk->flags & PF_IO_WORKER)
+		return 0;
+
 	mm = get_task_mm(tsk);
 	if (!mm)
 		return 0;
-- 
2.25.1

