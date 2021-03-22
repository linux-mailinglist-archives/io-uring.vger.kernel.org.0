Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49FF343684
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 03:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhCVCDV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 22:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhCVCCv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 22:02:51 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB8FC061574
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:50 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id m20-20020a7bcb940000b029010cab7e5a9fso10462106wmi.3
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=LM9p6XHohyaARt3j/TKYVSPQgbwK7z00ifMPX4x2EJI=;
        b=Hz+4JJKj6kaElAbknxE/ZmSC+tMBarYY4+4T2wjv61dqskyBkNUjwBfyGC9r9aZd1t
         vWtMAJPq93Cc3CU/gcdtkEW3j51zwDteQqKByZrcvqTzFa2gt90jXy60EYBUu66AzGnh
         /kCHruMQbXcNXOc1dI4Qkegq2kFAKb0BW9h3XW9FeTtCpw0ToKGU+Ir1cD7zCjaLQx7G
         JtybwcfjE3//7bUhrXHO+4d/1UhRswDV0SEtiUqby+uii8bXiR26xxSl412pxTXnEe7v
         Ed1ZsFcx2KTSf5PNU6XN49tztH/Fo0ZFTArFoUY/lcU/gvKriv/nPoomSGUzNx0L2kyz
         hL/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LM9p6XHohyaARt3j/TKYVSPQgbwK7z00ifMPX4x2EJI=;
        b=qtwYkyY6n3uU1UhfxNtgOSZvMUKGgWPm8QdWwBj2GgxAwc0zL1T3iHK8C5NkeA/HDi
         fAM+UNZhpys+uCK8sA8gLGRIHVeAn9cpDFYnjFRTpH9xQ/ufBOXhQGf3taAsGNs96DGL
         xd+eq4Ota1lJNLHw81JuBxiEfiGV97c4Wa/ODDkgrwywWOpY+hmxsZYLwXX15TmE3yz+
         OfED4C2nSYeFLJxUrzdQXBgYp8eU0WCGH/3wmKG5XxD+5otwTz0/dYPS8k72OmsNoA53
         eSypjrpphvJlllHFDYWlTZvkQBA10KHewiZ5zBmK7vufOgkcHmIMBiXnfovDBNVTFGrP
         8YKA==
X-Gm-Message-State: AOAM533qmEyGYdbaKDkTeaIoKQ5l+K8krwd6NatN0akV1MJ/6sKvol1E
        Kt7fPw6Ljiw7r7muHMlEJcOT5ZQfAfI0cg==
X-Google-Smtp-Source: ABdhPJw/HvqZKvI+XA6gnD279t7Db5LZS2ezzzM2X8X5MwowtYMiKVIQCLXbcVpO0QxY1rPSAOYGpA==
X-Received: by 2002:a05:600c:4844:: with SMTP id j4mr13716315wmo.179.1616378569599;
        Sun, 21 Mar 2021 19:02:49 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.202])
        by smtp.gmail.com with ESMTPSA id i8sm15066695wmi.6.2021.03.21.19.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 19:02:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 09/11] io_uring: don't alter iopoll reissue fail ret code
Date:   Mon, 22 Mar 2021 01:58:32 +0000
Message-Id: <1151b9a8f5a7aee8c93b4c20e7a68f8f22913db2.1616378197.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616378197.git.asml.silence@gmail.com>
References: <cover.1616378197.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When reissue_prep failed in io_complete_rw_iopoll(), we change return
code to -EIO to prevent io_iopoll_complete() from doing resubmission.
Mark requests with a new flag (i.e. REQ_F_DONT_REISSUE) instead and
retain the original return value.

It also removes io_rw_reissue() from io_iopoll_complete() that will be
used later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c81f2db0fee5..cccd5fd582f2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -696,6 +696,7 @@ enum {
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_LTIMEOUT_ACTIVE_BIT,
 	REQ_F_COMPLETE_INLINE_BIT,
+	REQ_F_DONT_REISSUE_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_ASYNC_READ_BIT,
 	REQ_F_ASYNC_WRITE_BIT,
@@ -739,6 +740,8 @@ enum {
 	REQ_F_LTIMEOUT_ACTIVE	= BIT(REQ_F_LTIMEOUT_ACTIVE_BIT),
 	/* completion is deferred through io_comp_state */
 	REQ_F_COMPLETE_INLINE	= BIT(REQ_F_COMPLETE_INLINE_BIT),
+	/* don't attempt request reissue, see io_rw_reissue() */
+	REQ_F_DONT_REISSUE	= BIT(REQ_F_DONT_REISSUE_BIT),
 	/* supports async reads */
 	REQ_F_ASYNC_READ	= BIT(REQ_F_ASYNC_READ_BIT),
 	/* supports async writes */
@@ -1014,7 +1017,6 @@ static struct fixed_rsrc_ref_node *alloc_fixed_rsrc_ref_node(
 			struct io_ring_ctx *ctx);
 static void io_ring_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc);
 
-static bool io_rw_reissue(struct io_kiocb *req);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req, int nr);
@@ -2283,10 +2285,12 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		req = list_first_entry(done, struct io_kiocb, inflight_entry);
 		list_del(&req->inflight_entry);
 
-		if (READ_ONCE(req->result) == -EAGAIN) {
+		if (READ_ONCE(req->result) == -EAGAIN &&
+		    !(req->flags & REQ_F_DONT_REISSUE)) {
 			req->iopoll_completed = 0;
-			if (io_rw_reissue(req))
-				continue;
+			req_ref_get(req);
+			io_queue_async_work(req);
+			continue;
 		}
 
 		if (req->flags & REQ_F_BUFFER_SELECTED)
@@ -2550,15 +2554,17 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 			iov_iter_revert(&rw->iter,
 					req->result - iov_iter_count(&rw->iter));
 		else if (!io_resubmit_prep(req))
-			res = -EIO;
+			req->flags |= REQ_F_DONT_REISSUE;
 	}
 #endif
 
 	if (kiocb->ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
 
-	if (res != -EAGAIN && res != req->result)
+	if (res != -EAGAIN && res != req->result) {
+		req->flags |= REQ_F_DONT_REISSUE;
 		req_set_fail_links(req);
+	}
 
 	WRITE_ONCE(req->result, res);
 	/* order with io_iopoll_complete() checking ->result */
-- 
2.24.0

