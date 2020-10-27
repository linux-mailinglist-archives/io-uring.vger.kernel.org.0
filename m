Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2FBD29CD3A
	for <lists+io-uring@lfdr.de>; Wed, 28 Oct 2020 02:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgJ1Bid (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Oct 2020 21:38:33 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39517 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1833003AbgJ0X2o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Oct 2020 19:28:44 -0400
Received: by mail-wr1-f66.google.com with SMTP id y12so3726963wrp.6
        for <io-uring@vger.kernel.org>; Tue, 27 Oct 2020 16:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=eulr9UegAcpyuLis+eHeChXXPq7eVgHWt3PXM53c18I=;
        b=WovSDkwmQgpQYeBnMBFBfRGKb+grnEv35tgnUmDPA3MdwKevrNM+ydaqgavB3UdD2H
         HpasIlQthbizxW0/Qr1rSVu0ZCZVJlvyo4ljCF59bzoo+ytKA+zThrQgNEKylXHLXzT3
         F4rV59h8/UbHMLFOVayJZ2retevHyFOzfgneiLzFoKSlI6H3c1iwYF5nqWkTVWjh9HZW
         iRFwVeVE4PzMsIYSqu04+tius8Dux56Pi+CjGw0MaawXn0bKB2H9JovcvdjBG4QUZjGb
         zSfyzGVHOKDn2cYlUnLymN5Bn8+juK1eH2oA11dwvHOCiXabITY0uG18qfPqZnMQbek7
         XcYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eulr9UegAcpyuLis+eHeChXXPq7eVgHWt3PXM53c18I=;
        b=NId1F35B/3yT25Z+FrrUTkEv0CACl9NpI07/4jWw5zBanAaB3d6WedBI/1G7GMto1k
         g88U7Bfc8B7kbStM/FW0hvuVYiZNsaqcgkWGleDTBmWR96ml2clnEh46R8ogF2UEwpCA
         FWQWN3ccDB4Bz9AsA4bUfdb54XrXnXYM5OdeOVmJRs+G7NIRIVauTH4LK0hjMa8sDtTN
         y7P8IIxcWlCjbApiuve31lvav3o5Mi2Mo6ymXMn7pAoB788pWJCXkMqHtcMp6bePwcjQ
         V2G72Ab/dIKlD/tdA62jEmEd1EChiZtIwRBOX3DpSguSbB8nwxLrdec+1ch7xQHxBrMM
         d4dg==
X-Gm-Message-State: AOAM5307spvyVXREauje2XncqFjli/0mv+unAazwGtWTlp5JuRxGbgFy
        NguK1uvMYph2NaAqWIiTqN8=
X-Google-Smtp-Source: ABdhPJytq2RCkVKDDZuntisgVhXhGn0j2W+M1OAZgirRY+JHYGKQBD1lK4jI7jTfUgwsjHDAI/p6JQ==
X-Received: by 2002:a5d:6345:: with SMTP id b5mr5653307wrw.288.1603841322061;
        Tue, 27 Oct 2020 16:28:42 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id a15sm4336990wrp.90.2020.10.27.16.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 16:28:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/4] io_uring: track link's head and tail during submit
Date:   Tue, 27 Oct 2020 23:25:35 +0000
Message-Id: <1173e72e5cbbbb7d4aeb4aba51127ca276c9add7.1603840701.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1603840701.git.asml.silence@gmail.com>
References: <cover.1603840701.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Explicitly save not only a link's head in io_submit_sqe[s]() but the
tail as well. That's in preparation for keeping linked requests in a
singly linked list.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3d244c61a5c3..ce092d6cab73 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6262,8 +6262,13 @@ static inline void io_queue_link_head(struct io_kiocb *req,
 		io_queue_sqe(req, NULL, cs);
 }
 
+struct io_submit_link {
+	struct io_kiocb *head;
+	struct io_kiocb *last;
+};
+
 static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			 struct io_kiocb **link, struct io_comp_state *cs)
+			 struct io_submit_link *link, struct io_comp_state *cs)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
@@ -6275,8 +6280,8 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	 * submitted sync once the chain is complete. If none of those
 	 * conditions are true (normal request), then just queue it.
 	 */
-	if (*link) {
-		struct io_kiocb *head = *link;
+	if (link->head) {
+		struct io_kiocb *head = link->head;
 
 		/*
 		 * Taking sequential execution of a link, draining both sides
@@ -6297,11 +6302,12 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 		trace_io_uring_link(ctx, req, head);
 		list_add_tail(&req->link_list, &head->link_list);
+		link->last = req;
 
 		/* last request of a link, enqueue the link */
 		if (!(req->flags & (REQ_F_LINK | REQ_F_HARDLINK))) {
 			io_queue_link_head(head, cs);
-			*link = NULL;
+			link->head = NULL;
 		}
 	} else {
 		if (unlikely(ctx->drain_next)) {
@@ -6315,7 +6321,8 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			ret = io_req_defer_prep(req, sqe);
 			if (unlikely(ret))
 				req->flags |= REQ_F_FAIL_LINK;
-			*link = req;
+			link->head = req;
+			link->last = req;
 		} else {
 			io_queue_sqe(req, sqe, cs);
 		}
@@ -6495,7 +6502,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 {
 	struct io_submit_state state;
-	struct io_kiocb *link = NULL;
+	struct io_submit_link link;
 	int i, submitted = 0;
 
 	/* if we have a backlog and couldn't flush it all, return BUSY */
@@ -6515,6 +6522,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	refcount_add(nr, &current->usage);
 
 	io_submit_state_start(&state, ctx, nr);
+	link.head = NULL;
 
 	for (i = 0; i < nr; i++) {
 		const struct io_uring_sqe *sqe;
@@ -6560,8 +6568,8 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		percpu_counter_sub(&tctx->inflight, unused);
 		put_task_struct_many(current, unused);
 	}
-	if (link)
-		io_queue_link_head(link, &state.comp);
+	if (link.head)
+		io_queue_link_head(link.head, &state.comp);
 	io_submit_state_end(&state);
 
 	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
-- 
2.24.0

