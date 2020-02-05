Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF711538C1
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2020 20:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgBETIc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Feb 2020 14:08:32 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51141 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727104AbgBETIb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Feb 2020 14:08:31 -0500
Received: by mail-wm1-f66.google.com with SMTP id a5so3690448wmb.0;
        Wed, 05 Feb 2020 11:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=g6L+rbiNcdTBVsL6kM+kxRr5RcsPRbao2r368VHF3VU=;
        b=P8wu2z5+bnBUNwlbxEku7azWnc176dPXBpkEd7UYdgv01rNRdvlokB/3y08YelaRPh
         k6mLAfop46KJc4Xwsr/5Zz+ZYLn9SC1NTlT9FQiI/H38eQxi0oB+AZcDCG3QNdilx7Qu
         eMaCe+TJLMrRNQUtL+OQztH2eovFh7wbK8aka1Cd0BgGX9Apq7Zs440iMK9moeFf0jI6
         D3zAxRTbCxcX2jCnJ7VXlxaSyA4w+Ok8W9JDWO1Snn+W94tgVIW1qXRoHMs8gMjxUgy0
         I1G2a5TZol0RNAG6aB2zf3dSww8lUHad/R0h4EbTdYKE4SDuPVMMbugGjC1OZ093O/Q7
         xDUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g6L+rbiNcdTBVsL6kM+kxRr5RcsPRbao2r368VHF3VU=;
        b=cXq479zVgE4KtnkTU/bF/CjAB6d5SdMjAESBrlsxt4oQy0eR+vs8PitXolZ3wyIxlB
         ZOiPqfqU0TgGSBHdgPFkSSsrQ3Qm3hUetdBPRloE+Rc87DyfX1JPzHuXQ09iaIUeUj/W
         BR9Jx2IxLaYDumYuCQuFF54WdhQp8FGLB+Tby97AnsO2GX5QMEK5SD/1ASVgwckWYyxn
         kc/AKlaPt8a6I28VhNqJUYZOzR0RxcQ4UVOT2DdzHhpvUME/5idYDK2DQgzxgzqHo0Jv
         RREIc5AVY+4A1dQVLC0Ml75Yw9Fbxq0gaQJcxFOwkn4viYstFi2wQElAzRZ4JbKScwpI
         a43w==
X-Gm-Message-State: APjAAAVym8WK32arTTJ4KpRT0fH9Dt9KbQ26yMfqzlAjCVoX9T/mPrAx
        gzWympLN3QXt0gGPtRcloMw=
X-Google-Smtp-Source: APXvYqy3SpASx381GST6MjPbT70uWHMQXmjK3127CWOOJp2tMv2TPJKN+epcZsx4qG9h34ix0mYsRA==
X-Received: by 2002:a1c:bb82:: with SMTP id l124mr7140850wmf.176.1580929708758;
        Wed, 05 Feb 2020 11:08:28 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id b10sm915568wrw.61.2020.02.05.11.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 11:08:28 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] io_uring: pass sqe for link head
Date:   Wed,  5 Feb 2020 22:07:31 +0300
Message-Id: <c9654d6a79898d5f8aa8b9dabcb76d9f23faa149.1580928112.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1580928112.git.asml.silence@gmail.com>
References: <cover.1580928112.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Save an sqe for a head of a link, so it doesn't go through switch in
io_req_defer_prep() nor allocating an async context in advance.

Also, it's fixes potenial memleak for double-preparing head requests.
E.g. prep in io_submit_sqe() and then prep in io_req_defer(),
which leaks iovec for vectored read/writes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f00c2c9c67c0..e18056af5672 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4721,20 +4721,22 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	}
 }
 
-static inline void io_queue_link_head(struct io_kiocb *req)
+static inline void io_queue_link_head(struct io_kiocb *req,
+				      const struct io_uring_sqe *sqe)
 {
 	if (unlikely(req->flags & REQ_F_FAIL_LINK)) {
 		io_cqring_add_event(req, -ECANCELED);
 		io_double_put_req(req);
 	} else
-		io_queue_sqe(req, NULL);
+		io_queue_sqe(req, sqe);
 }
 
 #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
 				IOSQE_IO_HARDLINK | IOSQE_ASYNC)
 
 static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			  struct io_submit_state *state, struct io_kiocb **link)
+			  struct io_submit_state *state, struct io_kiocb **link,
+			  const struct io_uring_sqe **link_sqe)
 {
 	const struct cred *old_creds = NULL;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -4812,7 +4814,7 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 		/* last request of a link, enqueue the link */
 		if (!(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK))) {
-			io_queue_link_head(head);
+			io_queue_link_head(head, *link_sqe);
 			*link = NULL;
 		}
 	} else {
@@ -4823,10 +4825,8 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		if (sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
 			req->flags |= REQ_F_LINK;
 			INIT_LIST_HEAD(&req->link_list);
-			ret = io_req_defer_prep(req, sqe);
-			if (ret)
-				req->flags |= REQ_F_FAIL_LINK;
 			*link = req;
+			*link_sqe = sqe;
 		} else {
 			io_queue_sqe(req, sqe);
 		}
@@ -4924,6 +4924,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	struct io_kiocb *link = NULL;
 	int i, submitted = 0;
 	bool mm_fault = false;
+	const struct io_uring_sqe *link_sqe = NULL;
 
 	/* if we have a backlog and couldn't flush it all, return BUSY */
 	if (test_bit(0, &ctx->sq_check_overflow)) {
@@ -4983,7 +4984,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		req->needs_fixed_file = async;
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
 						true, async);
-		if (!io_submit_sqe(req, sqe, statep, &link))
+		if (!io_submit_sqe(req, sqe, statep, &link, &link_sqe))
 			break;
 	}
 
@@ -4993,7 +4994,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		percpu_ref_put_many(&ctx->refs, nr - ref_used);
 	}
 	if (link)
-		io_queue_link_head(link);
+		io_queue_link_head(link, link_sqe);
 	if (statep)
 		io_submit_state_end(&state);
 
-- 
2.24.0

