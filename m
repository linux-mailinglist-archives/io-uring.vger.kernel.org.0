Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129655BB404
	for <lists+io-uring@lfdr.de>; Fri, 16 Sep 2022 23:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiIPVjT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Sep 2022 17:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiIPVjS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Sep 2022 17:39:18 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67677AB430
        for <io-uring@vger.kernel.org>; Fri, 16 Sep 2022 14:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=ZoSZ9iwEKr6Q7TA8DRWCeyki7nGJWBiXI/c3WJ2ARhY=; b=vN42wpXoAlXhPDNFUEd5tHK9ng
        /lwuQjv2E7CTfKS8RyjQFkS8Vki0XZBJtQsxMDrBetJ/HvOiPlUb+LoRX7djzDkXv/YGbBchN8vwW
        1K2ImtxtZN52mEM6jH2f4WuZ+Dazsj6IpjCbIErvBdthT/XdS/Y6VTDG+/fHgt2xmu9TwUiITy3tV
        nhPoZ8IBstLOSyaxgG3ip5vAnArqxIQoinl76lRAQTDKtA5eE3brE/KiZMx4rIf8WXRzvNz5Fh6LI
        Gp2bg8ne81hVYN2nunE1rCDP7X4hWbtrqzT+i1TbTNgM89xHfX4g22rtKCOrx2pZIaYrqZ1kdBvET
        h6T9/9lH8BOv9qC6CLsF6d2J6bJpIjTNrNBVxBQKLKun0hkpWqxgSa65BPUdZ1lxThJQ/SMZB6fw7
        uZmurOGTBW1OUYHghh+wOOCP1rg/HdEMVFicPNXiQ05w4p71HQjj5oUCT5dLQ7vXBf5Sri5FTU5j9
        dEjGkQhY3HNd44B8qMYbZqM6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oZJ3K-000j7J-VW; Fri, 16 Sep 2022 21:39:15 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 3/5] io_uring/core: keep req->cqe.flags on generic errors
Date:   Fri, 16 Sep 2022 23:36:27 +0200
Message-Id: <5df304b3cb6eeb412b758ce638a5e129c4d6f6da.1663363798.git.metze@samba.org>
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

Soon we'll have the case where IORING_OP_SEND_ZC will
add IORING_CQE_F_MORE to req->cqe.flags before calling
into sock_sendmsg() and once we did that we have to
keep that flag even if we will hit some generic error
later, e.g. in the partial io retry case.

Hopefully passing req->cqe.flags to inline io_req_set_res(),
allows the compiler to optimize out the effective
req->cqe.flags = req->cqe.flags.

Fixes: b48c312be05e8 ("io_uring/net: simplify zerocopy send user API")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
---
 io_uring/io_uring.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ae69cff94664..062edbc04168 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -212,7 +212,7 @@ bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 static inline void req_fail_link_node(struct io_kiocb *req, int res)
 {
 	req_set_fail(req);
-	io_req_set_res(req, res, 0);
+	io_req_set_res(req, res, req->cqe.flags);
 }
 
 static inline void io_req_add_to_cache(struct io_kiocb *req, struct io_ring_ctx *ctx)
@@ -824,7 +824,8 @@ inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags)
 void io_req_complete_failed(struct io_kiocb *req, s32 res)
 {
 	req_set_fail(req);
-	io_req_set_res(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
+	req->cqe.flags |= io_put_kbuf(req, IO_URING_F_UNLOCKED);
+	io_req_set_res(req, res, req->cqe.flags);
 	io_req_complete_post(req);
 }
 
@@ -1106,7 +1107,7 @@ void io_req_task_submit(struct io_kiocb *req, bool *locked)
 
 void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 {
-	io_req_set_res(req, ret, 0);
+	io_req_set_res(req, ret, req->cqe.flags);
 	req->io_task_work.func = io_req_task_cancel;
 	io_req_task_work_add(req);
 }
@@ -1847,6 +1848,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	req->flags = sqe_flags = READ_ONCE(sqe->flags);
 	req->cqe.user_data = READ_ONCE(sqe->user_data);
+	req->cqe.flags = 0;
 	req->file = NULL;
 	req->rsrc_node = NULL;
 	req->task = current;
-- 
2.34.1

