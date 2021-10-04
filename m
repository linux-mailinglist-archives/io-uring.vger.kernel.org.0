Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232F64216EB
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 21:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbhJDTFm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 15:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237495AbhJDTFl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 15:05:41 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A388C061745
        for <io-uring@vger.kernel.org>; Mon,  4 Oct 2021 12:03:52 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id v18so67626471edc.11
        for <io-uring@vger.kernel.org>; Mon, 04 Oct 2021 12:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7JjUiiLqaB1bzhWKdRfbCnbQd3MuZg14phk558dNSLA=;
        b=nnlkWS/guJkiFinhumK6pmlHsBmO3aO43Vxjd5Uw/BMFgX664BekPuKfigj10Nu5bR
         ZqVMBsXaQOYsIwO2g/ZaeCnIbOKCoxtQoH8W/Ook0iSiTEsse6VpbsKa3yv/tJRQVUbX
         X8ERnMKarVSK/4guArriUnIH4e4/VOYCLNP6ONeIQZVt47bLjFL2azFvbcAcPez53b7R
         F2b44WNVjWE7VUvwvq6b/MTkEuoncuG9Oqor4InCzGz0uuskPmh8iDKKbGdaTcYMGXpG
         hSGGypUCcuURRq9KwRBtNO2AXBMmjSWObs1ypiSGOGieRNTf7LpdHFGvQznHkbjMjjv6
         7hZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7JjUiiLqaB1bzhWKdRfbCnbQd3MuZg14phk558dNSLA=;
        b=iaSxuurLas/5FBKS9Wqr9xcF1pl9BK1hZJH0SZoqvm/WAbW78rutjT+awKrMAd+Jhe
         IhRrwX8P/kPqqh4TKjEPKEZALOVx0CIseVyGxDbMB9SF5w7w8/OLpQ2o4DQVYvEfMyCg
         JLWuSzNtgbBwW/6Nn1JMzkleL+txCyYTu8iBVvqAUK6WkVLR9FCkN5nXpbqit7AV6cIY
         eP3Zn4sMBeKXUmCSR7qg2EGFs1Kyj2Rg+NsSNy3IWJkcf6y8Vc6Ymufi3SGl7/pNXFIg
         HxMiZEg1ckVa0tLSX9pwD2L3taxkY8porO11bho5uCdB1XbY3mqbo4UXkKEixB38IPdf
         OHFg==
X-Gm-Message-State: AOAM5330+ghSphRyf8q4lr9xx88/MedcKkv0pBTsZiC1Jrn4oAfWSw+U
        DkkLAsKUdl/PoFHAezr8V9ruj9cr6Cc=
X-Google-Smtp-Source: ABdhPJykb8aA70vuHYgZKKUsVeXLIwFat+AQq4Fxjd2zQDbKDDuvETEiqiIhmbvHSgD64S1A+q+V8A==
X-Received: by 2002:a05:6402:1cbb:: with SMTP id cz27mr19867566edb.376.1633374230578;
        Mon, 04 Oct 2021 12:03:50 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id k12sm6855045ejk.63.2021.10.04.12.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 12:03:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 03/16] io_uring: delay req queueing into compl-batch list
Date:   Mon,  4 Oct 2021 20:02:48 +0100
Message-Id: <4afca4e11abfd4cc8e99777fdcaf4d34cf4d022d.1633373302.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633373302.git.asml.silence@gmail.com>
References: <cover.1633373302.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_req_complete_state() is inlined and used in lots of places, so we
want to keep it concise. Move adding a request into a completion batch
list from io_req_complete_state() into the consumer, i.e.
__io_queue_sqe().

before vs after
   text    data     bss     dec     hex filename
  91894   14002       8  105904   19db0 ./fs/io_uring.o
  91046   14002       8  105056   19a60 ./fs/io_uring.o

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b09b267247f5..54850696ab6d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1446,6 +1446,13 @@ static void io_prep_async_link(struct io_kiocb *req)
 	}
 }
 
+static inline void io_req_add_compl_list(struct io_kiocb *req)
+{
+	struct io_submit_state *state = &req->ctx->submit_state;
+
+	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
+}
+
 static void io_queue_async_work(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1820,20 +1827,15 @@ static inline bool io_req_needs_clean(struct io_kiocb *req)
 	return req->flags & IO_REQ_CLEAN_FLAGS;
 }
 
-static void io_req_complete_state(struct io_kiocb *req, long res,
-				  unsigned int cflags)
+static inline void io_req_complete_state(struct io_kiocb *req, long res,
+					 unsigned int cflags)
 {
-	struct io_submit_state *state;
-
 	/* clean per-opcode space, because req->compl is aliased with it */
 	if (io_req_needs_clean(req))
 		io_clean_op(req);
 	req->result = res;
 	req->compl.cflags = cflags;
 	req->flags |= REQ_F_COMPLETE_INLINE;
-
-	state = &req->ctx->submit_state;
-	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
 }
 
 static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
@@ -2621,10 +2623,12 @@ static void io_req_task_complete(struct io_kiocb *req, bool *locked)
 	unsigned int cflags = io_put_rw_kbuf(req);
 	long res = req->result;
 
-	if (*locked)
+	if (*locked) {
 		io_req_complete_state(req, res, cflags);
-	else
+		io_req_add_compl_list(req);
+	} else {
 		io_req_complete_post(req, res, cflags);
+	}
 }
 
 static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
@@ -6889,8 +6893,10 @@ static inline void __io_queue_sqe(struct io_kiocb *req)
 
 	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
 
-	if (req->flags & REQ_F_COMPLETE_INLINE)
+	if (req->flags & REQ_F_COMPLETE_INLINE) {
+		io_req_add_compl_list(req);
 		return;
+	}
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
 	 * doesn't support non-blocking read/write attempts
-- 
2.33.0

