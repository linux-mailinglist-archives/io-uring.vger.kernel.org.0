Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0660021E18B
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 22:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgGMUjX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 16:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgGMUjX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 16:39:23 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320BCC061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:39:23 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id dr13so18951546ejc.3
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=CUK4nmx2NSKZEvAFg+/nCLIUnFCYgVW5uCjT1Dzf6d4=;
        b=tyfyf7wY3CO7j3wBFzGf9l7A1rRwsODdCToeNQXecnpJ6HKHtZHH+Cd4MMFUSnc13o
         espdtptBJqn17SPyt3GUswMgPTojTTe0Yzf/TJdZLv2rlbXhYnWDZc+4einSW2g45usI
         flUfOOUIDJWdcWlLYDwLPNd4LtPaOLulm4m5BGylN7hKtjEBWd4awTm15EZtONcZtiEr
         vW9ZeI94ncHOeeoRwgDbC1cJqczPit3eKEUl0P/Sm9O0XbMcytXOsiVkCAR9MWU7MMyr
         iZkzevorgSUrGonV26Xq9KuMVt0ahMctY9m+cpAL2OclsxJtBlW/VFlFW6g9llctg720
         3e5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CUK4nmx2NSKZEvAFg+/nCLIUnFCYgVW5uCjT1Dzf6d4=;
        b=hLTkPDGIvV4NktbsnyKGzZutPh2pIHsLlpCxaWZyNVSN9eRjTHBB7NSRCt8zOHBMYh
         ldx7vVMyW6fR05TXeTzw4ImKTjDPqy6Vf2pxc4kY421Xsapej6QloVoxD9dAM2N7sOj3
         axYsYLAFmS0Q+7fXBVsuMmPrlmeSAl8xapqXzEUofHaod3ahtSnivnr5evgN/LIUQ5FZ
         Eco5/duqSqB5Xy10Abibid7YsaSwNevELnkiQ1vJSUB7NX/YavhguGZ73AOQiHls/LFE
         zR2taW352rckkEYZLNhTowgpWf4btS9ZejI4hfA0p8IOTG6ROZg3ELduDuwYIwAddeCX
         Itug==
X-Gm-Message-State: AOAM533I/y4tvml55dPUKLapedLOUkBTxM/tkE/EOmQhd1MvhzkWN5Jl
        x2rGio5GfHxtMvuwGUFx5J2C+6MH
X-Google-Smtp-Source: ABdhPJw7Vesn1oqnCJjJkLaW2kBo0rtv40qW4Dy9qduCUwXcmjDR1nBTMuv/B49mRNwBfnHK8PueJg==
X-Received: by 2002:a17:907:212b:: with SMTP id qo11mr1463339ejb.452.1594672761932;
        Mon, 13 Jul 2020 13:39:21 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id m14sm10491855ejx.80.2020.07.13.13.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 13:39:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 3/9] io_uring: use inflight_entry list for iopoll'ing
Date:   Mon, 13 Jul 2020 23:37:10 +0300
Message-Id: <58103f6547b39b20bd8594f0bf7afb6dd97a1798.1594670798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594670798.git.asml.silence@gmail.com>
References: <cover.1594670798.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->inflight_entry is used to track requests that grabbed files_struct.
Let's share it with iopoll list, because the only iopoll'ed ops are
reads and writes, which don't need a file table.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 03bb8a69d09c..1ad6d47a6223 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -650,6 +650,10 @@ struct io_kiocb {
 
 	struct list_head	link_list;
 
+	/*
+	 * 1. used with ctx->iopoll_list with reads/writes
+	 * 2. to track reqs with ->files (see io_op_def::file_table)
+	 */
 	struct list_head	inflight_entry;
 
 	struct percpu_ref	*fixed_file_refs;
@@ -1942,8 +1946,8 @@ static void io_iopoll_queue(struct list_head *again)
 	struct io_kiocb *req;
 
 	do {
-		req = list_first_entry(again, struct io_kiocb, list);
-		list_del(&req->list);
+		req = list_first_entry(again, struct io_kiocb, inflight_entry);
+		list_del(&req->inflight_entry);
 		if (!io_rw_reissue(req, -EAGAIN))
 			io_complete_rw_common(&req->rw.kiocb, -EAGAIN, NULL);
 	} while (!list_empty(again));
@@ -1966,13 +1970,13 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	while (!list_empty(done)) {
 		int cflags = 0;
 
-		req = list_first_entry(done, struct io_kiocb, list);
+		req = list_first_entry(done, struct io_kiocb, inflight_entry);
 		if (READ_ONCE(req->result) == -EAGAIN) {
 			req->iopoll_completed = 0;
-			list_move_tail(&req->list, &again);
+			list_move_tail(&req->inflight_entry, &again);
 			continue;
 		}
-		list_del(&req->list);
+		list_del(&req->inflight_entry);
 
 		if (req->flags & REQ_F_BUFFER_SELECTED)
 			cflags = io_put_kbuf(req);
@@ -2008,7 +2012,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	spin = !ctx->poll_multi_file && *nr_events < min;
 
 	ret = 0;
-	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, list) {
+	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, inflight_entry) {
 		struct kiocb *kiocb = &req->rw.kiocb;
 
 		/*
@@ -2017,7 +2021,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		 * and complete those lists first, if we have entries there.
 		 */
 		if (READ_ONCE(req->iopoll_completed)) {
-			list_move_tail(&req->list, &done);
+			list_move_tail(&req->inflight_entry, &done);
 			continue;
 		}
 		if (!list_empty(&done))
@@ -2029,7 +2033,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 
 		/* iopoll may have completed current req */
 		if (READ_ONCE(req->iopoll_completed))
-			list_move_tail(&req->list, &done);
+			list_move_tail(&req->inflight_entry, &done);
 
 		if (ret && spin)
 			spin = false;
@@ -2296,7 +2300,7 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 		struct io_kiocb *list_req;
 
 		list_req = list_first_entry(&ctx->iopoll_list, struct io_kiocb,
-						list);
+						inflight_entry);
 		if (list_req->file != req->file)
 			ctx->poll_multi_file = true;
 	}
@@ -2306,9 +2310,9 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 	 * it to the front so we find it first.
 	 */
 	if (READ_ONCE(req->iopoll_completed))
-		list_add(&req->list, &ctx->iopoll_list);
+		list_add(&req->inflight_entry, &ctx->iopoll_list);
 	else
-		list_add_tail(&req->list, &ctx->iopoll_list);
+		list_add_tail(&req->inflight_entry, &ctx->iopoll_list);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) &&
 	    wq_has_sleeper(&ctx->sqo_wait))
-- 
2.24.0

