Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D643F54611A
	for <lists+io-uring@lfdr.de>; Fri, 10 Jun 2022 11:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346847AbiFJJKk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jun 2022 05:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346452AbiFJJKB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jun 2022 05:10:01 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B297F279E74
        for <io-uring@vger.kernel.org>; Fri, 10 Jun 2022 02:07:52 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654852071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GoEGEMXuglk9x7fsQg2tGkCbYjjy8eCyCqhMokdQTi8=;
        b=bAzJfloxeG/+eEuQ7Ch+D6cuT45ZtBGxoaqvCPjIqY+nrE5MqxBbdVg4ZDFRQmYiHXMpyy
        254OeWRsQmvu1ffzEEizkhaoQBVwaP0/Q4rv1eOOl7bcwhSMMeW6Oqe/9v1M0mrVW9qxZA
        uRVJjo11HKTEcO9s3WtCDWkqHRC8qxE=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 3/5] io_uring: openclose: support separate return value for IORING_CLOSE_FD_AND_FILE_SLOT
Date:   Fri, 10 Jun 2022 17:07:32 +0800
Message-Id: <20220610090734.857067-4-hao.xu@linux.dev>
In-Reply-To: <20220610090734.857067-1-hao.xu@linux.dev>
References: <20220610090734.857067-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

In IORING_CLOSE_FD_AND_FILE_SLOT mode, we just stop and return error
code if either of fixed or normal file close fails. But we can actually
continue to do the close even one of them fails. What we need to do is
put the two result in two place: for normal file close, put the result
in cqe->res like the previous behaviour, while for fixed file close,
put it in cqe->flags. Users should check both member to get the status
of fixed and normal file close.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/openclose.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index 4eb1f23e028a..da930081c03c 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -248,12 +248,15 @@ int io_close(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_close *close = io_kiocb_to_cmd(req);
 	struct fdtable *fdt;
 	struct file *file;
-	int ret;
+	int ret, ret2;
 
 	if (close->file_slot) {
 		ret = io_close_fixed(req, issue_flags);
-		if (ret || !(close->flags & IORING_CLOSE_FD_AND_FILE_SLOT))
+		if (!(close->flags & IORING_CLOSE_FD_AND_FILE_SLOT))
 			goto err;
+		else
+			ret2 = ret;
+
 	}
 
 	ret = -EBADF;
@@ -286,6 +289,6 @@ int io_close(struct io_kiocb *req, unsigned int issue_flags)
 err:
 	if (ret < 0)
 		req_set_fail(req);
-	io_req_set_res(req, ret, 0);
+	io_req_set_res(req, ret, ret2);
 	return IOU_OK;
 }
-- 
2.25.1

