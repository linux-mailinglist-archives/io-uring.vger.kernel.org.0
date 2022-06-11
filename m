Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29C954747B
	for <lists+io-uring@lfdr.de>; Sat, 11 Jun 2022 14:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbiFKMWt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Jun 2022 08:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbiFKMWs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Jun 2022 08:22:48 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B85E167F3
        for <io-uring@vger.kernel.org>; Sat, 11 Jun 2022 05:22:48 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654950166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GoEGEMXuglk9x7fsQg2tGkCbYjjy8eCyCqhMokdQTi8=;
        b=G7icOufwvsb6oa19wZ8RDivlH5w7JKq3IVVpM26wkEzV925nlY33j8edSznCznW+jCIR6v
        x0FN/8BEkOvG1esTOR4yKXh2ydn0DmYhymec/mXv95hmAGBNzPPmZ9WczLt42ajErV51Mq
        xjWcI2RVRB2foVG9LBbIMvjassUKjhY=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH for-5.20 4/6] io_uring: openclose: support separate return value for IORING_CLOSE_FD_AND_FILE_SLOT
Date:   Sat, 11 Jun 2022 20:22:22 +0800
Message-Id: <20220611122224.941800-4-hao.xu@linux.dev>
In-Reply-To: <20220611122224.941800-1-hao.xu@linux.dev>
References: <20220611122224.941800-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

