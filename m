Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD7B4C8CEB
	for <lists+io-uring@lfdr.de>; Tue,  1 Mar 2022 14:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbiCANsK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Mar 2022 08:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235094AbiCANsH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Mar 2022 08:48:07 -0500
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8C06350;
        Tue,  1 Mar 2022 05:47:26 -0800 (PST)
Received: from [45.44.224.220] (port=56378 helo=localhost)
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1nP2qa-0002Gr-Rf; Tue, 01 Mar 2022 08:47:24 -0500
Date:   Tue, 01 Mar 2022 08:47:24 -0500
Message-Id: <84513f7cc1b1fb31d8f4cb910aee033391d036b4.1646142288.git.olivier@trillion01.com>
In-Reply-To: <cover.1646142288.git.olivier@trillion01.com>
References: <cover.1646142288.git.olivier@trillion01.com>
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Hao Xu <haoxu@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 1/2] io_uring: minor io_cqring_wait() optimization
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move up the block manipulating the sig variable to execute code
that may encounter an error and exit first before continuing
exectuing the rest of the function and avoid useless computations

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 fs/io_uring.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4715980e9015..f7b8df79a02b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7732,14 +7732,6 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			break;
 	} while (1);
 
-	if (uts) {
-		struct timespec64 ts;
-
-		if (get_timespec64(&ts, uts))
-			return -EFAULT;
-		timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
-	}
-
 	if (sig) {
 #ifdef CONFIG_COMPAT
 		if (in_compat_syscall())
@@ -7753,6 +7745,14 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			return ret;
 	}
 
+	if (uts) {
+		struct timespec64 ts;
+
+		if (get_timespec64(&ts, uts))
+			return -EFAULT;
+		timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
+	}
+
 	init_waitqueue_func_entry(&iowq.wq, io_wake_function);
 	iowq.wq.private = current;
 	INIT_LIST_HEAD(&iowq.wq.entry);
-- 
2.35.1

