Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F72A54611C
	for <lists+io-uring@lfdr.de>; Fri, 10 Jun 2022 11:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346452AbiFJJKm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jun 2022 05:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346754AbiFJJKB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jun 2022 05:10:01 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDE2289A1C
        for <io-uring@vger.kernel.org>; Fri, 10 Jun 2022 02:07:55 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654852073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mpp2p0ochQc/iLJwABzIvZ+1jToYJPYHhFnUDQIAQBE=;
        b=B94FBUnGvURpWSEETMO8LWLhNjqk3OOsnuaV8ZEjUYQyvATxX3q6w9J60iMVdMOs3vd+ch
        TL0PWLdPI6Zs0HMRc85OCcICSTt0JZSHIrWdegbKiuyHej22YwaERy+itH8h0Snh84u/Uw
        7Fgr7sF0ayRZjqjKrYcL/SnGnM+xTYI=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 4/5] io_uring: remove duplicate kbuf release
Date:   Fri, 10 Jun 2022 17:07:33 +0800
Message-Id: <20220610090734.857067-5-hao.xu@linux.dev>
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

__io_req_complete_put() is called by __io_req_complete_post, and before
that we already put kbuf, no need to do that in __io_req_complete_put()
again.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io_uring.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1572ebe3cff1..a94ddd0ba507 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1245,12 +1245,6 @@ static void __io_req_complete_put(struct io_kiocb *req)
 			}
 		}
 		io_req_put_rsrc(req);
-		/*
-		 * Selected buffer deallocation in io_clean_op() assumes that
-		 * we don't hold ->completion_lock. Clean them here to avoid
-		 * deadlocks.
-		 */
-		io_put_kbuf_comp(req);
 		io_dismantle_req(req);
 		io_put_task(req->task, 1);
 		wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
-- 
2.25.1

