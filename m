Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD2521C852
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 11:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbgGLJnM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 05:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgGLJnM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jul 2020 05:43:12 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB22C061794
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 02:43:12 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id dg28so8163975edb.3
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 02:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BpPNJvn1yFuMPXTdbq86yNvr+CG7WeGoR2coY4fNqJs=;
        b=QtzkCtDCiEpsYPualnY5qAFOiZ55i3HEuxR3VaXHjh9FCh+Z2JOCxd/SWTgr8qtkaA
         X7hfKSdfWIxDoxrvmlz0BXFcj1MOrTfXWpI7ccpP2eJ5feVVaLqRH60O8oCN5EWO0NjT
         Dv8LXtNrxTzARjGSN25W4/956/bQPwM6dTWY921KJ8rxpDt6RoRmaiaksLC1CR6XEYHH
         +NHPWOeQaaaJufvBIohIbRJXWheZ5tfSO+3r7D1Fpo6R5JXEZwir0Ho6Cw9Qbkvpm2Jr
         Bhe5Kqu4xYLSRbpNfHR3niGCo/8MlLCT5tKWv1JyFQwwDEj/N/EVpXFaQzRowN/ErlCm
         cAFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BpPNJvn1yFuMPXTdbq86yNvr+CG7WeGoR2coY4fNqJs=;
        b=Pj+UtKpBDKtRvTFk4VZKX2BleccpQgAef5NljFstoSmhk9ZxUCMHjIvRb3f41aSy8P
         F5skcgl8bsWnz02lYRoNOGVv/NYGK9icQWI6MNNPZvrgoHjVMXeOqjIcGWf3W27gS7mH
         GEAvoERTUh0UPw4Spi7PmYePyCPMSXI7jrxJyOfj1+m9SPzdgzsWJPq3WVbq15srJ6Fx
         e+6PtOP7rAc9c4o7gBtsGGKBsB6TeDbkeYGu28Bcsu6jTKYRmqTEVtVG3d0VzOehvp7u
         RTA66UW3Prmta1ozbylDDbUuFzJm1O4cfiXUnvJ30btNmichOSFkloE7wMe/8qsMRbXy
         59TA==
X-Gm-Message-State: AOAM531PGVN7ASSMrXudkKDqATBCOkX2EQx5NFsC4TSR8L9tL8sv/OPL
        s8sYNZLBKGH2cYOH58giyI8=
X-Google-Smtp-Source: ABdhPJyqtC76X98aBvOCexO+WkH4zWGOK+4CueY7xSLDYYSogb2nr+ATDc5YS9U+RFJmqwliI+Brgw==
X-Received: by 2002:aa7:d04e:: with SMTP id n14mr63608196edo.161.1594546990951;
        Sun, 12 Jul 2020 02:43:10 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id a8sm7283718ejp.51.2020.07.12.02.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 02:43:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/9] io_uring: use inflight_entry list for iopolling
Date:   Sun, 12 Jul 2020 12:41:09 +0300
Message-Id: <cacce7513f73e617bbdfebd847b5ea9741ed6485.1594546078.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594546078.git.asml.silence@gmail.com>
References: <cover.1594546078.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->inflight_entry is used to track requests with ->files, and the
only iopoll'ed requests (i.e. read/write) don't have it. Use
req->inflight_entry for iopoll path, btw aliasing it in union
with a more proper name for clarity.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 669a131c22ec..bb92cc736afe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -651,7 +651,14 @@ struct io_kiocb {
 
 	struct list_head	link_list;
 
-	struct list_head	inflight_entry;
+	/*
+	 * @inflight_entry is for reqs with ->files (see io_op_def::file_table)
+	 * @iopoll_list is for read/write requests
+	 */
+	union {
+		struct list_head	inflight_entry;
+		struct list_head	iopoll_list;
+	};
 
 	struct percpu_ref	*fixed_file_refs;
 
@@ -1937,8 +1944,8 @@ static void io_iopoll_queue(struct list_head *again)
 	struct io_kiocb *req;
 
 	do {
-		req = list_first_entry(again, struct io_kiocb, list);
-		list_del(&req->list);
+		req = list_first_entry(again, struct io_kiocb, iopoll_list);
+		list_del(&req->iopoll_list);
 		if (!io_rw_reissue(req, -EAGAIN))
 			io_complete_rw_common(&req->rw.kiocb, -EAGAIN, NULL);
 	} while (!list_empty(again));
@@ -1961,13 +1968,13 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	while (!list_empty(done)) {
 		int cflags = 0;
 
-		req = list_first_entry(done, struct io_kiocb, list);
+		req = list_first_entry(done, struct io_kiocb, iopoll_list);
 		if (READ_ONCE(req->result) == -EAGAIN) {
 			req->iopoll_completed = 0;
-			list_move_tail(&req->list, &again);
+			list_move_tail(&req->iopoll_list, &again);
 			continue;
 		}
-		list_del(&req->list);
+		list_del(&req->iopoll_list);
 
 		if (req->flags & REQ_F_BUFFER_SELECTED)
 			cflags = io_put_kbuf(req);
@@ -2003,7 +2010,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	spin = !ctx->poll_multi_file && *nr_events < min;
 
 	ret = 0;
-	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, list) {
+	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, iopoll_list) {
 		struct kiocb *kiocb = &req->rw.kiocb;
 
 		/*
@@ -2012,7 +2019,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		 * and complete those lists first, if we have entries there.
 		 */
 		if (READ_ONCE(req->iopoll_completed)) {
-			list_move_tail(&req->list, &done);
+			list_move_tail(&req->iopoll_list, &done);
 			continue;
 		}
 		if (!list_empty(&done))
@@ -2024,7 +2031,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 
 		/* iopoll may have completed current req */
 		if (READ_ONCE(req->iopoll_completed))
-			list_move_tail(&req->list, &done);
+			list_move_tail(&req->iopoll_list, &done);
 
 		if (ret && spin)
 			spin = false;
@@ -2291,7 +2298,7 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 		struct io_kiocb *list_req;
 
 		list_req = list_first_entry(&ctx->iopoll_list, struct io_kiocb,
-						list);
+						iopoll_list);
 		if (list_req->file != req->file)
 			ctx->poll_multi_file = true;
 	}
@@ -2301,9 +2308,9 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 	 * it to the front so we find it first.
 	 */
 	if (READ_ONCE(req->iopoll_completed))
-		list_add(&req->list, &ctx->iopoll_list);
+		list_add(&req->iopoll_list, &ctx->iopoll_list);
 	else
-		list_add_tail(&req->list, &ctx->iopoll_list);
+		list_add_tail(&req->iopoll_list, &ctx->iopoll_list);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) &&
 	    wq_has_sleeper(&ctx->sqo_wait))
-- 
2.24.0

