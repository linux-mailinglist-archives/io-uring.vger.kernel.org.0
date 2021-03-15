Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE4D33C33D
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 18:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbhCORDb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 13:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235670AbhCORCp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 13:02:45 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57DC2C06174A
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 10:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=LRixr3ZkyULLZar4TOdv9rzwDAS4f+pOQ2/q+ZjwEjc=; b=qANOHp2/M9OPlTi6GU7d9iko9T
        /wHBRhmnGJ3G/4ZZ1KiiM9kOml8rQ0WiCq5bqEj/ogqNNf7qLkv78kIwO3PA3mT/RcNSPeakisVbB
        sary6vpMzfsfBRg7jDYGbTdGrhckz2oJVZUr7oAJe7YWkfVjpg4cbSQN1YtqKQMSYV7RPy0lev8KS
        fZGZBG+QSUMZ3r81caJxn23Vmj4ByaL5c8lVF4lxV+OZZoSyPTICZgYoobwdAR681lMydFIuFyIlg
        qRiDTMbUOSEi0t64IcdZWfscnW91dGXx4qzUK18HhcmxZY13IOvFEergCe98/50JfmASd6nxYtCZq
        HNSs+5i0Uk5JiHx1kgnFXOxk6iSMfZeD7xN0pHdVCb5CfGC3pgF0nhAWAx5Ayu6m3m7IZ/UmPOxSW
        xadLJHa75BY25mqBa0IaIlYGro3sW8chPUUPCEGB5rfhbT7tj4/UEJK5QtRYLqKR0zOHGOeZlKr4e
        rbFlb2jCFkmijarpXtZ30Qi6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lLqc5-00057L-Dm; Mon, 15 Mar 2021 17:02:41 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [RFC PATCH 06/10] io_uring: protect against future set_task_comm() overflows.
Date:   Mon, 15 Mar 2021 18:01:44 +0100
Message-Id: <6fc10a3a30de9173a50d608edb576de4dbed1864.1615826736.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1615826736.git.metze@samba.org>
References: <cover.1615826736.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/io_uring.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e7e2d87cd9c1..e88d9f95d0aa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7905,7 +7905,19 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			goto err_sqpoll;
 		}
 
-		sprintf(tsk_comm, "iou-sqp-%d", sqd->task_pid);
+		/*
+		 * The limit value of pid_max_max/PID_MAX_LIMIT
+		 * is 4 * 1024 * 1024 = 4194304.
+		 *
+		 * TASK_COMM_LEN is 16, so we have 15 chars to fill.
+		 *
+		 * With "iou-sqp-4194304" we just fit into 15 chars.
+		 * If that ever changes we may better add some special
+		 * handling for PF_IO_WORKER in proc_task_name(), as that
+		 * allows up to 63 chars.
+		 */
+		WARN_ON(snprintf(tsk_comm, sizeof(tsk_comm),
+				 "iou-sqp-%d", sqd->task_pid) >= sizeof(tsk_comm));
 		set_task_comm(tsk, tsk_comm);
 
 		if (sqd->sq_cpu != -1)
-- 
2.25.1

