Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A743536570C
	for <lists+io-uring@lfdr.de>; Tue, 20 Apr 2021 13:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbhDTLEP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Apr 2021 07:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbhDTLEP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Apr 2021 07:04:15 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B94C06174A
        for <io-uring@vger.kernel.org>; Tue, 20 Apr 2021 04:03:43 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id x7so37118674wrw.10
        for <io-uring@vger.kernel.org>; Tue, 20 Apr 2021 04:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=2n8Bw+GJrsKMq0xRAMeekZMzycwxVfRm/zXtxVjravw=;
        b=a9TFVK8vWvCP4wzea7ITuGoWBohKhjM/+f/n0B1ngLwdYhBtac87HS4svlDvr8RE7Y
         /fefOgzttD3WbWPK2vjHZHplNa3RA4WKiV3YrHZ05WppOM8rzRz19GOlc4nl0NwVHujc
         LI1x4MSA833lgsmCTRK0H1GtKbfUanToRfRrHdENmyRuyRyQl/CzWxDtqwATJt0slxJR
         YbMgxTnUFOEXrulsSL1xhXNDZK+XAGAFmZmuebZfnUuCHwAblLo2gWNMu/jpWyuZgC7i
         SYH2kv61O5kl2PvGftBXKHVdRB/zgNO9SJwzrj8UDJxhlxFl1PMPPqOmrLC0Sz/Z8Mqn
         PNTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2n8Bw+GJrsKMq0xRAMeekZMzycwxVfRm/zXtxVjravw=;
        b=lNjLeyrVszuHp0xvxh4spDv7R6ETVXIx/vWslVSUrCSf12g4lMaOdbWSxsPs3Hqjlx
         huDWzLXx/crwNE0/zaAEJGHLoUJ51dC5xHCNGzB2drCZnKg23Pmqkfj9qy9et+C9y3Kh
         SyzwTBAI1NziyrSwshQQceDtGbdAoPsGOZfVm5Iso7rZmaC371P742+SdHMpbD2ijusS
         yKc5P5bpcdlXjls8hW0Wt6/7ZXzKTtV5Tf88IjHEs+o8pySXIz9HG8WKk5GbYTo5/GYs
         MATIszaV0OFECV6FcWimnqXTQkZPTM7xLKjnu80A0v8wf20c38sUPyEUskZeLn8KL2vR
         ZOoA==
X-Gm-Message-State: AOAM531UqRyAgFvGoH+5ElgaR9fAMbmVlRASt4Pi0nmL8wEAIQxX9lb2
        17uQsKQh6C9KGuuAbdvndgNocoItEQ6opQ==
X-Google-Smtp-Source: ABdhPJx3I53VeeSWwmF4GvHIa/fttwuSW1cbSmXivzpyqoH0C8t6Iv6mmtNkju1WIrJPiUVS9ecxWg==
X-Received: by 2002:a5d:654e:: with SMTP id z14mr19918317wrv.414.1618916622689;
        Tue, 20 Apr 2021 04:03:42 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.116])
        by smtp.gmail.com with ESMTPSA id y8sm12899486wru.27.2021.04.20.04.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 04:03:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/3] io_uring: move inflight un-tracking into cleanup
Date:   Tue, 20 Apr 2021 12:03:31 +0100
Message-Id: <90653a3a5de4107e3a00536fa4c2ea5f2c38a4ac.1618916549.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1618916549.git.asml.silence@gmail.com>
References: <cover.1618916549.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

REQ_F_INFLIGHT deaccounting doesn't do any spinlocking or resource
freeing anymore, so it's safe to move it into the normal cleanup flow,
i.e. into io_clean_op(), so making it cleaner.

Also move io_req_needs_clean() to be first in io_dismantle_req() so it
doesn't reload req->flags.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d3c2387b4629..f8b2fb553410 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1601,7 +1601,7 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 static inline bool io_req_needs_clean(struct io_kiocb *req)
 {
 	return req->flags & (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP |
-				REQ_F_POLLED);
+				REQ_F_POLLED | REQ_F_INFLIGHT);
 }
 
 static void io_req_complete_state(struct io_kiocb *req, long res,
@@ -1717,17 +1717,10 @@ static void io_dismantle_req(struct io_kiocb *req)
 {
 	unsigned int flags = req->flags;
 
+	if (io_req_needs_clean(req))
+		io_clean_op(req);
 	if (!(flags & REQ_F_FIXED_FILE))
 		io_put_file(req->file);
-	if (io_req_needs_clean(req) || (req->flags & REQ_F_INFLIGHT)) {
-		io_clean_op(req);
-		if (req->flags & REQ_F_INFLIGHT) {
-			struct io_uring_task *tctx = req->task->io_uring;
-
-			atomic_dec(&tctx->inflight_tracked);
-			req->flags &= ~REQ_F_INFLIGHT;
-		}
-	}
 	if (req->fixed_rsrc_refs)
 		percpu_ref_put(req->fixed_rsrc_refs);
 	if (req->async_data)
@@ -6051,6 +6044,12 @@ static void io_clean_op(struct io_kiocb *req)
 		kfree(req->apoll);
 		req->apoll = NULL;
 	}
+	if (req->flags & REQ_F_INFLIGHT) {
+		struct io_uring_task *tctx = req->task->io_uring;
+
+		atomic_dec(&tctx->inflight_tracked);
+		req->flags &= ~REQ_F_INFLIGHT;
+	}
 }
 
 static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
-- 
2.31.1

