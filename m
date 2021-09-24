Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843984178DD
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343997AbhIXQh7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347545AbhIXQhc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:37:32 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919DFC0613B1
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:55 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g8so38219975edt.7
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ruvRk+DZIqJJI+n2l3D4uAy2ZGaf2Qy8bwYtD7Bu5oo=;
        b=ZqFoTZOkplU3V2DHpkUZiVYjH5BBt57aK0q2WOhQoqKzKPQDwiPWNPy/wNueDnvbOI
         wQLJtMaO3ygQsMS/F/zCGqPOt74bycmwuL+GZe1+cNMJ6XUEKMcKYJ3jsJJF31qjigst
         GpXvStDdcz7jkApISOfsIYzre15XYw0n5S2LCVp4HJEd6pM1B8FpBwPT8WBtBDL59/Q7
         OyyUDZNADE2TJLqBzm5isFI6H3+dv1YbpnZQ/XftfVR+o8Mab1ox07PtDiIEP4Tehcxb
         oepRzAT7H/p20trg42hRIacgym3MLuG+fL5sA7BwSltUI0igzsfx/dvJtBnYMkqvXlBB
         wV6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ruvRk+DZIqJJI+n2l3D4uAy2ZGaf2Qy8bwYtD7Bu5oo=;
        b=dYe9K1qPD6EdLXP1XtnlsL3PeYB6dDrdWaGAVDKrYM0RGJ2/Iq/DT24COmuMLa1yFk
         evbh5IPPXvXy43pUcSf4l1gUuB88zpjbXfYVDG5GciqJXeVm/HJaOSTJS6/ezxcCyPEZ
         GgJ+plEulHbs/pgJrfdsAphBcnZHiotQt66nd9jBemynPz6DKXpN+6iGxy0r6DsBAl9v
         XkW7kdFiJWq4V1ToJRIj5lF4ICrtXmfGjihGuOjyiAueOibWizhYtOetuPkJ9zOtxQ5n
         U8R/KiSQqV2kFn670yOmzuvbV6W7XA6/F0vz67/1nFoXDFwdaFHVuwGQWOoHx3JGgGPO
         5BuQ==
X-Gm-Message-State: AOAM533N+rtwPe4hGqf79tpWfse8ulFehatu0hKXhnJI9L77eV4zfsXP
        yHki4oSwZeuS+caYzwlgLMyKPgpqVS4=
X-Google-Smtp-Source: ABdhPJze8AwkjMGOwoAjwAkUG22IlyE8AHLnIMdLBGx+a7Ys6B5BB8hAPCCD8z+MxZyZSCd70c7SRw==
X-Received: by 2002:a50:d9c5:: with SMTP id x5mr5965651edj.37.1632501174051;
        Fri, 24 Sep 2021 09:32:54 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:32:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 08/23] io_uring: split iopoll loop
Date:   Fri, 24 Sep 2021 17:31:46 +0100
Message-Id: <7ebcd52c18f38c3c79db90b5c24f7ee2bdf428ed.1632500264.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The main loop of io_do_iopoll() iterates and does ->iopoll() until it
meets a first completed request, then it continues from that position
and splices requests to pass them through io_iopoll_complete().

Split the loop in two for clearness, iopolling and reaping completed
requests from the list.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 67390b131fb0..e0f897c3779d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2443,6 +2443,12 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, struct list_head *done)
 	io_req_free_batch_finish(ctx, &rb);
 }
 
+/* same as "continue" but starts from the pos, not next to it */
+#define list_for_each_entry_safe_resume(pos, n, head, member) 		\
+	for (n = list_next_entry(pos, member);				\
+	     !list_entry_is_head(pos, head, member);			\
+	     pos = n, n = list_next_entry(n, member))
+
 static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
 	struct io_kiocb *req, *tmp;
@@ -2456,7 +2462,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 	 */
 	spin = !ctx->poll_multi_queue && !force_nonspin;
 
-	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, inflight_entry) {
+	list_for_each_entry(req, &ctx->iopoll_list, inflight_entry) {
 		struct kiocb *kiocb = &req->rw.kiocb;
 		int ret;
 
@@ -2465,12 +2471,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		 * If we find a request that requires polling, break out
 		 * and complete those lists first, if we have entries there.
 		 */
-		if (READ_ONCE(req->iopoll_completed)) {
-			list_move_tail(&req->inflight_entry, &done);
-			nr_events++;
-			continue;
-		}
-		if (!list_empty(&done))
+		if (READ_ONCE(req->iopoll_completed))
 			break;
 
 		ret = kiocb->ki_filp->f_op->iopoll(kiocb, spin);
@@ -2480,15 +2481,20 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 			spin = false;
 
 		/* iopoll may have completed current req */
-		if (READ_ONCE(req->iopoll_completed)) {
-			list_move_tail(&req->inflight_entry, &done);
-			nr_events++;
-		}
+		if (READ_ONCE(req->iopoll_completed))
+			break;
 	}
 
-	if (!list_empty(&done))
-		io_iopoll_complete(ctx, &done);
+	list_for_each_entry_safe_resume(req, tmp, &ctx->iopoll_list,
+					inflight_entry) {
+		if (!READ_ONCE(req->iopoll_completed))
+			break;
+		list_move_tail(&req->inflight_entry, &done);
+		nr_events++;
+	}
 
+	if (nr_events)
+		io_iopoll_complete(ctx, &done);
 	return nr_events;
 }
 
-- 
2.33.0

