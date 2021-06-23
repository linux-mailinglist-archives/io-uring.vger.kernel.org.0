Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB003B20A1
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 20:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhFWSwj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 14:52:39 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:41170 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWSwi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 14:52:38 -0400
Received: from [173.237.58.148] (port=33338 helo=localhost)
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lw7x5-0008I4-MG; Wed, 23 Jun 2021 14:50:19 -0400
Date:   Wed, 23 Jun 2021 11:50:18 -0700
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Olivier Langlois <olivier@trillion01.com>
Message-Id: <b401640063e77ad3e9f921e09c9b3ac10a8bb923.1624473200.git.olivier@trillion01.com>
In-Reply-To: <cover.1624473200.git.olivier@trillion01.com>
References: <cover.1624473200.git.olivier@trillion01.com>
Subject: [PATCH v2 2/2] io_uring: Create define to modify a SQPOLL parameter
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
index 7c545fa66f31..e7997f9bf879 100644
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

