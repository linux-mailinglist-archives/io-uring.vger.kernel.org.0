Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A904B53F7D3
	for <lists+io-uring@lfdr.de>; Tue,  7 Jun 2022 10:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237880AbiFGIGh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jun 2022 04:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiFGIGf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jun 2022 04:06:35 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9E6B82CB;
        Tue,  7 Jun 2022 01:06:34 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654589193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uIx0SLPeGNO2+cSM+ls+SeNXYoun+BONGh4wyuQHRtw=;
        b=a3HBkxlRlqMQTfPlckGvdhrBmFUX2Z/pzhR3IJlxhZX6Us0tFj7Jf/MwBh2Pb+KsdLpcTj
        ZICu6pbPegedOfJnnWJa6M83Tc40sC64UPF2b5p9izJBswggIJh5AOUAIfuxmXehfC+EnB
        tyqHrzauiJEvuN7d3nhr6XZ9poH2BUw=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Subject: [PATCH 1/5] io_uring: move sp->len check up for splice and tee
Date:   Tue,  7 Jun 2022 16:06:15 +0800
Message-Id: <20220607080619.513187-2-hao.xu@linux.dev>
In-Reply-To: <20220607080619.513187-1-hao.xu@linux.dev>
References: <20220607080619.513187-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

The traditional sync splice code return 0 if len is 0 at the beginning
of syscall, similar thing for tee. So move up sp->len zero check so that
it reaches quick ending when len is 0.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/splice.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/io_uring/splice.c b/io_uring/splice.c
index 0e19d6330345..b2cd1044c3ee 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -53,6 +53,9 @@ int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *in;
 	long ret = 0;
 
+	if (unlikely(!sp->len))
+		goto done;
+
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
@@ -65,8 +68,7 @@ int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 		goto done;
 	}
 
-	if (sp->len)
-		ret = do_tee(in, out, sp->len, flags);
+	ret = do_tee(in, out, sp->len, flags);
 
 	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
 		io_put_file(in);
@@ -95,6 +97,9 @@ int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *in;
 	long ret = 0;
 
+	if (unlikely(!sp->len))
+		goto done;
+
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
@@ -110,8 +115,7 @@ int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 	poff_in = (sp->off_in == -1) ? NULL : &sp->off_in;
 	poff_out = (sp->off_out == -1) ? NULL : &sp->off_out;
 
-	if (sp->len)
-		ret = do_splice(in, poff_in, out, poff_out, sp->len, flags);
+	ret = do_splice(in, poff_in, out, poff_out, sp->len, flags);
 
 	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
 		io_put_file(in);
-- 
2.25.1

