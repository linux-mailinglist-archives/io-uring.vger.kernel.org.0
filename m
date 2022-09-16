Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4B15BB3FE
	for <lists+io-uring@lfdr.de>; Fri, 16 Sep 2022 23:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiIPViK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Sep 2022 17:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiIPViJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Sep 2022 17:38:09 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BC0BB00C
        for <io-uring@vger.kernel.org>; Fri, 16 Sep 2022 14:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=0SwHugQVIVz/sTe+HezYfVSXyJOfkEsY28doul00OeI=; b=GEI6pWdKyA82hSpBHvvbVY6rmo
        5sY2aXjBYhutRpMmr9XY/R+4A4K4jbiANCxwo8LBMrIEIykEdwFJBgDujlnqvgbdZ/v8/+T/0Y/MX
        cR/9d3bXMAz5sqJ+rZxlvS8r/X8aOmq9gnt0JksnYUwHGuezKU0rORCGy5hJXycERiBOpTGOtdVCP
        kEYQ0b8nrjXG4+lbbalkC1HWrwwqpAwCqNAuDbrTvljBLJbfB89zGwR5HjxJHkWfrDO1j/P6ZVgWm
        K5BM73Ph/SxIF1uad3J0sK9DuDuVEFSccb0X3K5Fd3SR7/P5JhKVYa9ynZN+vMz2fOcGSj1OCc23k
        p4mt7MKNMzg7uXnHcj5C2kqaTKcsoYoSzWFNPS2Qta1Yx9dYeSMiNc46M3m+ELczDW+yvQBIFG4E/
        udKwTX1AElVvgZi96sJAYfi+2WCGtdQK+DEFThsG430KzDaEHYMsrxVdoUQSOUCbt51m3KuqnibDG
        FhKsfmm7/e153G5gVGIArf5K;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oZJ2E-000j67-9S; Fri, 16 Sep 2022 21:38:06 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 1/5] io_uring/opdef: rename SENDZC_NOTIF to SEND_ZC
Date:   Fri, 16 Sep 2022 23:36:25 +0200
Message-Id: <8e5cd8616919c92b6c3c7b6ea419fdffd5b97f3c.1663363798.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1663363798.git.metze@samba.org>
References: <cover.1663363798.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's confusing to see the string SENDZC_NOTIF in ftrace output
when using IORING_OP_SEND_ZC.

Fixes: b48c312be05e8 ("io_uring/net: simplify zerocopy send user API")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
---
 io_uring/opdef.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index c61494e0a602..c4dddd0fd709 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -471,7 +471,7 @@ const struct io_op_def io_op_defs[] = {
 		.prep_async		= io_uring_cmd_prep_async,
 	},
 	[IORING_OP_SEND_ZC] = {
-		.name			= "SENDZC_NOTIF",
+		.name			= "SEND_ZC",
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
-- 
2.34.1

