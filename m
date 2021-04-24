Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CFA36A399
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 01:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhDXX1t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 24 Apr 2021 19:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbhDXX1t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 24 Apr 2021 19:27:49 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8EF7C061574
        for <io-uring@vger.kernel.org>; Sat, 24 Apr 2021 16:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=JDlyLBAXYb24r8TzVjtzv4ixia6JJkHE2lBbOkTwT94=; b=d3MvO3CItDrMEHmNDiuAiFkcQ3
        XrmDpZaN0jQw4Bx+QdoPT3YvDVBhjWrFIaXogc0OCb0wr/XKpzty7QvWoUlIXSwY7YU8XJHiu/A1L
        bTfFjwde8FlfDbg4fhm15efhYbF8OFB98eLGF6Y4guQnx+2qRyOuXrmQHuQ68RQ8l3AcIbuBk9NH+
        lEMOyc96MrBZ/sUCaWEukdoNHRYI25t8gCSB97VlG7w3WXBx1FwitbtIT3OZpkNmQZxyrZuD7DZH3
        WQitsr3gA3WmTCO8LNapXHCloCI5jRYdokVHJWtCogQKj1jpyRozYxuIXCxNdg/YSwrwSYE0RiXIL
        izENlhF9wibBXgqYLCmCiX048f+89b0vPv2RqCLHCSacgHl0svZAIGdA0s3Phn6LrC68+vWSbqF6J
        M6MyhsKIqlRWix/0LwG8Jei6rne+tZTEMdiPywefZ7Lf1IGNT5G8DFSsa9Q1tgxIgU6yvzM7waEvc
        FcVTnRO+f6THqk/gmllAR/5D;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1laRg3-0007XR-Lr; Sat, 24 Apr 2021 23:27:07 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v3 6/6] io_uring: warn about future set_task_comm() overflows.
Date:   Sun, 25 Apr 2021 01:26:08 +0200
Message-Id: <fb22d3363c90c73702128897dd087f7e937ccd81.1619306115.git.metze@samba.org>
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
 fs/io_uring.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 856289b13488..dba4ceea80ee 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7932,7 +7932,19 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			goto err_sqpoll;
 		}
 
-		snprintf(tsk_comm, sizeof(tsk_comm), "iou-sqp-%d", sqd->task_pid);
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

