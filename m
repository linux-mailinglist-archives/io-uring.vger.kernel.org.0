Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343D73EF2A5
	for <lists+io-uring@lfdr.de>; Tue, 17 Aug 2021 21:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbhHQT3Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Aug 2021 15:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbhHQT3Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Aug 2021 15:29:24 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79234C061764
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 12:28:50 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id z9so30132645wrh.10
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 12:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=cEp4Yf2ELrvrEmzuPsZ3qDRDVkISHMCco4yo/Au3/g8=;
        b=K6g6j5y2PZ47nebh2sBSYMD3JYAM7Ld7+3UxcDmWFOYSjbAkiEeE7NtUN8vaaTpqAR
         MkahSRV5xTuTfJLc0YnMGHZKJZ7QIusu4hWmp/7rd5u2DSSV0Eh6S+dpG6d81LLX/M4T
         dsCvgzyjIsLxtVtWWK1+9JNUAL+kpSxVen6tBm/mJh/0LVnL2S5gPgA/JKcFPLh7x2ZA
         pp+e6GkuM5XQQgQsh8nS34Oo8EJbntgXWeteAj1W+lOQA2kIDY6riqZjBkaZ5/CGHcFg
         A/lylE805yBulM9271qEsVXjN23he0P20IRTV+xAXiptHKCtYzEqsuJ28vLybyrssrR5
         a9qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cEp4Yf2ELrvrEmzuPsZ3qDRDVkISHMCco4yo/Au3/g8=;
        b=swUeCgKIO8rNyG9EeJa/po2UoA9YsUeD0a7IRM1tljChtfrUuxnwp4IOuJU6ltCHh6
         T2rGef1M5bs0Frl9rS065sXwXHDDsCFItDFhkoxz1sAoHKQKahz083FX75PIcqhdR1nm
         S6nYQLHjSH05h+lV7qopXBI8l9VsVA7yTUgnY1n1S0oYBH9zSj0MRB1OIGSHnv3hfVUd
         6wWIZqNJ9OfFfYhTN6labUNn1BN8znICFP5qzXJy1GgeCVUWBeRqpZAonE4/1eLybXPa
         0OB2NpD36oeN76/2MN0mAltSq2LmTHhlOJmdIKFfbtjjtHzeZ2+1lUhcurwxA1BBUjjh
         3mZw==
X-Gm-Message-State: AOAM532wIyk7Cr3TSnPOP3KStaR0j4iUU/x5UGgUaw/5gqmkrJRdTRSG
        1VKQ8qt4U2kLEoM3AbLyP8M=
X-Google-Smtp-Source: ABdhPJzga8xBGhM5Uk22VXVj1lW6l92vHevRlmuus8L9Q/MQ+rDPizkNGRwNE/fbd7SAZ4AhGmNlmw==
X-Received: by 2002:a5d:6090:: with SMTP id w16mr6272826wrt.38.1629228529132;
        Tue, 17 Aug 2021 12:28:49 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.12])
        by smtp.gmail.com with ESMTPSA id e6sm3120388wme.6.2021.08.17.12.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 12:28:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/4] io_uring: better encapsulate buffer select for rw
Date:   Tue, 17 Aug 2021 20:28:08 +0100
Message-Id: <3df3919e5e7efe03420c44ab4d9317a81a9cf398.1629228203.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629228203.git.asml.silence@gmail.com>
References: <cover.1629228203.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make io_put_rw_kbuf() to do the REQ_F_BUFFER_SELECTED check, so all the
callers don't need to hand code it. The number of places where we call
io_put_rw_kbuf() is growing, so saves some pain.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2d76ca0c7218..29e3ec6e9dbf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2284,6 +2284,8 @@ static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
 {
 	struct io_buffer *kbuf;
 
+	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
+		return 0;
 	kbuf = (struct io_buffer *) (unsigned long) req->rw.addr;
 	return io_put_kbuf(req, kbuf);
 }
@@ -2313,8 +2315,6 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 
 	io_init_req_batch(&rb);
 	while (!list_empty(done)) {
-		int cflags = 0;
-
 		req = list_first_entry(done, struct io_kiocb, inflight_entry);
 		list_del(&req->inflight_entry);
 
@@ -2325,10 +2325,8 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 			continue;
 		}
 
-		if (req->flags & REQ_F_BUFFER_SELECTED)
-			cflags = io_put_rw_kbuf(req);
-
-		__io_cqring_fill_event(ctx, req->user_data, req->result, cflags);
+		__io_cqring_fill_event(ctx, req->user_data, req->result,
+					io_put_rw_kbuf(req));
 		(*nr_events)++;
 
 		if (req_ref_put_and_test(req))
@@ -2548,11 +2546,7 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 
 static void io_req_task_complete(struct io_kiocb *req)
 {
-	int cflags = 0;
-
-	if (req->flags & REQ_F_BUFFER_SELECTED)
-		cflags = io_put_rw_kbuf(req);
-	__io_req_complete(req, 0, req->result, cflags);
+	__io_req_complete(req, 0, req->result, io_put_rw_kbuf(req));
 }
 
 static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
@@ -2820,12 +2814,9 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 		if (io_resubmit_prep(req)) {
 			io_req_task_queue_reissue(req);
 		} else {
-			int cflags = 0;
-
 			req_set_fail(req);
-			if (req->flags & REQ_F_BUFFER_SELECTED)
-				cflags = io_put_rw_kbuf(req);
-			__io_req_complete(req, issue_flags, ret, cflags);
+			__io_req_complete(req, issue_flags, ret,
+					  io_put_rw_kbuf(req));
 		}
 	}
 }
-- 
2.32.0

