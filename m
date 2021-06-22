Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D683B0D25
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 20:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhFVSr5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 14:47:57 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:51454 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbhFVSrz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 14:47:55 -0400
Received: from [173.237.58.148] (port=33330 helo=localhost)
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lvlOu-0002UE-Si; Tue, 22 Jun 2021 14:45:33 -0400
Date:   Tue, 22 Jun 2021 11:45:31 -0700
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Olivier Langlois <olivier@trillion01.com>
Message-Id: <c05f957a5b5675a0b401e211065e08255014232c.1624387080.git.olivier@trillion01.com>
In-Reply-To: <cover.1624387080.git.olivier@trillion01.com>
References: <cover.1624387080.git.olivier@trillion01.com>
Subject: [PATCH 2/2] io_uring: Create define to modify a SQPOLL parameter
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

The magic number used to cap the number of entries extracted from an
io_uring instance SQ before moving to the other instances is an
interesting parameter to experiment with.

A define has been created to make it easy to change its value from a
single location.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 02f789e07d4c..3f271bd7726b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -89,6 +89,7 @@
 
 #define IORING_MAX_ENTRIES	32768
 #define IORING_MAX_CQ_ENTRIES	(2 * IORING_MAX_ENTRIES)
+#define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
 
 /*
  * Shift of 9 is 512 entries, or exactly one page on 64-bit archs
@@ -6797,8 +6798,8 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 
 	to_submit = io_sqring_entries(ctx);
 	/* if we're handling multiple rings, cap submit size for fairness */
-	if (cap_entries && to_submit > 8)
-		to_submit = 8;
+	if (cap_entries && to_submit > IORING_SQPOLL_CAP_ENTRIES_VALUE)
+		to_submit = IORING_SQPOLL_CAP_ENTRIES_VALUE;
 
 	if (!list_empty(&ctx->iopoll_list) || to_submit) {
 		unsigned nr_events = 0;
-- 
2.32.0

