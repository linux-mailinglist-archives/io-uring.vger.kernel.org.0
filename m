Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA033B209E
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 20:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhFWSwc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 14:52:32 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:41016 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWSwc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 14:52:32 -0400
Received: from [173.237.58.148] (port=33336 helo=localhost)
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lw7wy-0008Hi-MX; Wed, 23 Jun 2021 14:50:12 -0400
Date:   Wed, 23 Jun 2021 11:50:11 -0700
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Olivier Langlois <olivier@trillion01.com>
Message-Id: <d1419dc32ec6a97b453bee34dc03fa6a02797142.1624473200.git.olivier@trillion01.com>
In-Reply-To: <cover.1624473200.git.olivier@trillion01.com>
References: <cover.1624473200.git.olivier@trillion01.com>
Subject: [PATCH v2 1/2] io_uring: Fix race condition when sqp thread goes to
 sleep
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If an asynchronous completion happens before the task is preparing
itself to wait and set its state to TASK_INTERRUPTIBLE, the completion
will not wake up the sqp thread.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fc8637f591a6..7c545fa66f31 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6902,7 +6902,7 @@ static int io_sq_thread(void *data)
 		}
 
 		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
-		if (!io_sqd_events_pending(sqd)) {
+		if (!io_sqd_events_pending(sqd) && !io_run_task_work()) {
 			needs_sched = true;
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 				io_ring_set_wakeup_flag(ctx);
-- 
2.32.0

