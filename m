Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69595546119
	for <lists+io-uring@lfdr.de>; Fri, 10 Jun 2022 11:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348330AbiFJJKi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jun 2022 05:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243365AbiFJJJ7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jun 2022 05:09:59 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527F3279E42
        for <io-uring@vger.kernel.org>; Fri, 10 Jun 2022 02:07:47 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654852066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CvrJD9gksnnXOee+F5KF9tGQ2m10atYyWkwTq+1fegY=;
        b=Zht1Rg9viAqdmUNmueW8Ugz5q3VzWg8vEVIfzjDAyi2hbEdSfme2p27JpEmJ0dFo3xkz13
        f6YBluOMSoT0ZnrURIcBQIe7Udu9Lu7ZJk8J8E72yFvRUyQcBrYqMZOCq4VhUKynlCTyFt
        2F51KmVa5KjipMJ8LjxphsZeFkdvrU8=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 1/5] io_uring: openclose: fix bug of closing wrong fixed file
Date:   Fri, 10 Jun 2022 17:07:30 +0800
Message-Id: <20220610090734.857067-2-hao.xu@linux.dev>
In-Reply-To: <20220610090734.857067-1-hao.xu@linux.dev>
References: <20220610090734.857067-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Don't update ret until fixed file is closed, otherwise the file slot
becomes the error code.

Fixes: a7c41b4687f5 ("io_uring: let IORING_OP_FILES_UPDATE support choosing fixed file slots")
Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/rsrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d78e7f2ea91f..cf8c85d1fb59 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -705,8 +705,8 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
 		if (ret < 0)
 			break;
 		if (copy_to_user(&fds[done], &ret, sizeof(ret))) {
-			ret = -EFAULT;
 			__io_close_fixed(req, issue_flags, ret);
+			ret = -EFAULT;
 			break;
 		}
 	}
-- 
2.25.1

