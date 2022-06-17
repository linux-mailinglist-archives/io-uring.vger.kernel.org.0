Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0584454F8F3
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 16:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382636AbiFQOMT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 10:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381543AbiFQOMS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 10:12:18 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E604517E0
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 07:12:17 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655475134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=i94yrDtVe3P2u6fk6b19j92cFKb5MiYnbjWw8kHaPyI=;
        b=O25PqHyrO12qJd0CUx/3hVGdFlFINUMbVvDt2Z62hCyhRNvRbksRKyFixCLIdrGbTzBWZw
        fYs0Yl+DrHr/t/ANZgbxa19yR2E8/UNoKAT+5uoMxLq6uQFlHg5SkN7ojuNCTUJPU8jMR/
        q59PTLv0n4rsnvkG2QabwAHvragTAOs=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH] io_uring: net: fix bug of completing multishot accept twice
Date:   Fri, 17 Jun 2022 22:12:01 +0800
Message-Id: <20220617141201.170314-1-hao.xu@linux.dev>
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

Now that we use centralized completion in io_issue_sqe, we should skip
that for multishot accept requests since we complete them in the
specific op function.

Fixes: 34106529422e ("io_uring: never defer-complete multi-apoll")
Signed-off-by: Hao Xu <howeyxu@tencent.com>
---

I retrieved the history:

in 4e86a2c98013 ("io_uring: implement multishot mode for accept")
we add the multishot accept, it repeatly completes cqe in io_accept()
until get -EAGAIN [1], then it returns 0 to io_issue_sqe().
io_issue_sqe() does nothing to it then.

in 09eaa49e078c ("io_uring: handle completions in the core")
we add __io_req_complete() for IOU_OK in io_issue_sqe(). This causes at
[1], we do call __io_req_complete().But since IO_URING_F_COMPLETE_DEFER
is set, it does nothing.

in 34106529422e ("io_uring: never defer-complete multi-apoll")
we remove IO_URING_F_COMPLETE_DEFER, but unluckily the multishot accept
test is broken, we didn't find the error.

So it just has infuence to for-5.20, I'll update the liburing test
today.

 io_uring/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 207803758222..5097df5b2c46 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -630,7 +630,7 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 			 */
 			if ((req->flags & IO_APOLL_MULTI_POLLED) ==
 			    IO_APOLL_MULTI_POLLED)
-				ret = 0;
+				ret = IOU_ISSUE_SKIP_COMPLETE;
 			return ret;
 		}
 		if (ret == -ERESTARTSYS)

base-commit: 0efaf0d19e9e1271f2275393e62f709907cd40e2
-- 
2.25.1

