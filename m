Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB5A33C33C
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 18:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbhCORDa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 13:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235629AbhCORCh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 13:02:37 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F65C061762
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 10:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=n2Xur1N/HKHlKyn6q1FKLQVnUHqpHjLOBmiOeOZau8Y=; b=oqgin+H+nSaQylM+sAnZub/3lb
        GCyqaXYe3xEoKcrtUUrhWVvihLjaEa0b52I1GrwYGobXNMHH6irosl7KswDkt87QhXk6D0SXUZRQf
        WZuxN3Qt+Mm39x9SqK11G6KDmXam+Q6C/CMS4Abwp3q5SS88IouRqV9Rfcd5K+V258guM8zkg0B7O
        4dxprKyckpi4/iWSdMhsF5gwNIJlA1dZadbxSwd+jmGIQ9Tg+oHxivVOiMOqymPx18X02SICoZbTq
        JHStq7gtg0ANzUgVC6ShSW4boGDHzPYIujBXSx55IaXMlarkZPx6w5XIWL9mAl7nJRYlKZm5Vgoj3
        rcboXdV/oNelT5mq47e1HloFRD8j7UZojp1HqHS7noeuOw6Dsn5amzJAgKQx8mlsCrP6vvRM3bkiZ
        e/uYjtbbrA1zoCUXwwsYnx9VQS4D2ohKDCQdiw58K/io7JTc9f643/D0MKt2h027yjXqeA7jhzMMI
        UhzYKGNS2myOVsQ378dTer3q;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lLqbx-00057E-ON; Mon, 15 Mar 2021 17:02:33 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [RFC PATCH 05/10] io-wq: protect against future set_task_comm() overflows.
Date:   Mon, 15 Mar 2021 18:01:43 +0100
Message-Id: <5cee4815c85ea19bca3710e6e5e6a8ca5a72a4be.1615826736.git.metze@samba.org>
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
 fs/io-wq.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index d6b15a627f9a..5c7d2a8c112e 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -588,7 +588,19 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 		return false;
 	}
 
-	sprintf(tsk_comm, "iou-wrk-%d", wq->task_pid);
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
+			 "iou-wrk-%d", wq->task_pid) >= sizeof(tsk_comm));
 	set_task_comm(tsk, tsk_comm);
 
 	tsk->pf_io_worker = worker;
@@ -780,7 +792,19 @@ static int io_wq_fork_manager(struct io_wq *wq)
 	if (!IS_ERR(tsk)) {
 		char tsk_comm[TASK_COMM_LEN];
 
-		sprintf(tsk_comm, "iou-mgr-%d", wq->task_pid);
+		/*
+		 * The limit value of pid_max_max/PID_MAX_LIMIT
+		 * is 4 * 1024 * 1024 = 4194304.
+		 *
+		 * TASK_COMM_LEN is 16, so we have 15 chars to fill.
+		 *
+		 * With "iou-mgr-4194304" we just fit into 15 chars.
+		 * If that ever changes we may better add some special
+		 * handling for PF_IO_WORKER in proc_task_name(), as that
+		 * allows up to 63 chars.
+		 */
+		WARN_ON(snprintf(tsk_comm, sizeof(tsk_comm),
+				 "iou-mgr-%d", wq->task_pid) >= sizeof(tsk_comm));
 		set_task_comm(tsk, tsk_comm);
 
 		wq->manager = get_task_struct(tsk);
-- 
2.25.1

