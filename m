Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1B332E4E7
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 10:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhCEJdH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 04:33:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48290 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbhCEJcl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 04:32:41 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lI6p5-0003KX-B2; Fri, 05 Mar 2021 09:32:39 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] io_uring: Fix error returns when create_io_thread fails
Date:   Fri,  5 Mar 2021 09:32:38 +0000
Message-Id: <20210305093238.60818-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The error return when create_io_thread calls fail is not using the
error return code from the returned pointer. Fix this by using
the error code in PTR_ERR(tsk).

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: c3c9a3194bd0 ("io_uring: move to using create_io_thread()")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b52ef6df4aac..59b024dba4dc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7787,7 +7787,7 @@ static int io_sq_thread_fork(struct io_sq_data *sqd, struct io_ring_ctx *ctx)
 	sqd->task_pid = current->pid;
 	tsk = create_io_thread(io_sq_thread, sqd, NUMA_NO_NODE);
 	if (IS_ERR(tsk))
-		return ret;
+		return PTR_ERR(tsk);
 	ret = io_uring_alloc_task_context(tsk, ctx);
 	if (ret)
 		set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
@@ -7859,8 +7859,10 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 
 		sqd->task_pid = current->pid;
 		tsk = create_io_thread(io_sq_thread, sqd, NUMA_NO_NODE);
-		if (IS_ERR(tsk))
+		if (IS_ERR(tsk)) {
+			ret = PTR_ERR(tsk);
 			goto err;
+		}
 		ret = io_uring_alloc_task_context(tsk, ctx);
 		if (ret)
 			set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
-- 
2.30.0

