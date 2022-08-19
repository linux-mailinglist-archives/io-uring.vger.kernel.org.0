Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0B8599E4F
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 17:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349599AbiHSPaO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 11:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349507AbiHSPaN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 11:30:13 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71702E725B
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 08:30:12 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660923010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lfVJrGZWAV/CxAj15pj4d9hqcvYN2cySKDv1KGRNM08=;
        b=htF3glim5whu2JDXAWgyvooctoBS8y7YJkmTV4m4JVqD+qM94fSMKvwuua8YPgpiCc1y8Z
        uVo5olDsyn5S5G2uTUPzoj7aDERj89NbkBxlELzTQBKPX+xZsTE1S34771tFLC7Kb3b7My
        peayBE07ucLFqI6PkcVAVaT4seAXYXQ=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 15/19] io_uring: don't use inline completion cache if scheduled
Date:   Fri, 19 Aug 2022 23:27:34 +0800
Message-Id: <20220819152738.1111255-16-hao.xu@linux.dev>
In-Reply-To: <20220819152738.1111255-1-hao.xu@linux.dev>
References: <20220819152738.1111255-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

In uringlet mode, if a worker has been scheduled out during sqe
submission, we cannot use inline completion for that sqe.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io_uring.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0c14b90b8b47..a109dcb48702 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1582,7 +1582,14 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		revert_creds(creds);
 
 	if (ret == IOU_OK) {
-		if (issue_flags & IO_URING_F_COMPLETE_DEFER)
+		bool uringlet = req->ctx->flags & IORING_SETUP_URINGLET;
+		bool scheduled = false;
+
+		if (uringlet)
+			scheduled =
+				io_worker_test_scheduled(current->worker_private);
+
+		if ((issue_flags & IO_URING_F_COMPLETE_DEFER) && !scheduled)
 			io_req_complete_defer(req);
 		else
 			io_req_complete_post(req);
-- 
2.25.1

