Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB0A5BB400
	for <lists+io-uring@lfdr.de>; Fri, 16 Sep 2022 23:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiIPVio (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Sep 2022 17:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiIPVin (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Sep 2022 17:38:43 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4B1AB430
        for <io-uring@vger.kernel.org>; Fri, 16 Sep 2022 14:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=5+4hNpMItLNugz0oZGYnGAzDfersrmpF1YEyKQa/3/4=; b=R3uQkQT8jt27VsilIotg/xryuj
        rZ7ZoM4s6YCDXFWLBvoqqas4fu7EmTE40dQGtgaGpg+sEjWI+KzeFc/8avodtDNgeZzw8CRhons/D
        rsdZexw0QzUU6+DVKay1sZbZzbUl3brL3gpuGHGkxRSqEz6bmP+wqZMIHk8TSo4W6U4TWm4SMb3qG
        SrlZ34oIdBHjeqqTgEa1IuPolX3q+ayPyB11Q8xuXBKss+VMnqRfWLwdhOdN7/SPpZgLSWSr54FrD
        /XhoUQrm6asy1dGCx/FkH6IJ98hC79j0B9/QpjURzs7zIzf4zMbqmvCu4vvZI/bTpuGNy/CJRlzHo
        ebg7f3szVBRJkqCxKmHdohLtPyZuG4SfCBg+GM5bSrJZ16pDxWL5fXTmWzaxyz7CbAOWr9CpKscPm
        VpOBTKXb9/8bl6Zp4yzmR81UTAjkG2wKFdYFqLqF7krpsoBQS+Toxw85CFvgBt9Vb2Jw9Mbvhk6ef
        t/Ng42UK82JfntZWOo3gC/xo;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oZJ2l-000j6T-RB; Fri, 16 Sep 2022 21:38:40 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 2/5] io_uring/core: move io_cqe->fd over from io_cqe->flags to io_cqe->res
Date:   Fri, 16 Sep 2022 23:36:26 +0200
Message-Id: <c4a5afc7fec8314032074cc60b9f27b6e0af9f39.1663363798.git.metze@samba.org>
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

Both flags and res have the same lifetime currently.
io_req_set_res() sets both of them.

Callers of io_req_set_res() like req_fail_link_node(),
io_req_complete_failed() and io_req_task_queue_fail()
set io_cqe->res to their callers value and force flags to 0.

The motivation for this change is the next commit,
it will let us keep io_cqe->flags even on error.
For IORING_OP_SEND_ZC it is needed to keep IORING_CQE_F_MORE
even on a generic failure, userspace needs to know that
a IORING_CQE_F_NOTIF will follow. Otherwise the buffers
might be reused too early.

Fixes: b48c312be05e8 ("io_uring/net: simplify zerocopy send user API")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
---
 include/linux/io_uring_types.h |  6 +++---
 io_uring/io_uring.c            | 10 ++++++++--
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 677a25d44d7f..37925db42ae9 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -473,12 +473,12 @@ struct io_task_work {
 
 struct io_cqe {
 	__u64	user_data;
-	__s32	res;
-	/* fd initially, then cflags for completion */
+	/* fd initially, then res for completion */
 	union {
-		__u32	flags;
 		int	fd;
+		__s32	res;
 	};
+	__u32	flags;
 };
 
 /*
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b9640ad5069f..ae69cff94664 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -837,8 +837,6 @@ static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
 	req->ctx = ctx;
 	req->link = NULL;
 	req->async_data = NULL;
-	/* not necessary, but safer to zero */
-	req->cqe.res = 0;
 }
 
 static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
@@ -1574,6 +1572,12 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	if (!def->audit_skip)
 		audit_uring_entry(req->opcode);
 
+	/*
+	 * req->cqe.fd was resolved by io_assign_file
+	 * now make sure its alias req->cqe.res is reset,
+	 * so we don't use that value by accident.
+	 */
+	req->cqe.res = -1;
 	ret = def->issue(req, issue_flags);
 
 	if (!def->audit_skip)
@@ -1902,6 +1906,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			state->need_plug = false;
 			blk_start_plug_nr_ios(&state->plug, state->submit_nr);
 		}
+	} else {
+		req->cqe.fd = -1;
 	}
 
 	personality = READ_ONCE(sqe->personality);
-- 
2.34.1

