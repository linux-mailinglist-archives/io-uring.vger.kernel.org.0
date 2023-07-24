Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE00C7602C8
	for <lists+io-uring@lfdr.de>; Tue, 25 Jul 2023 00:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjGXWzZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 18:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjGXWzY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 18:55:24 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B14510FA
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 15:55:23 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1b89b0c73d7so8121275ad.1
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 15:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690239322; x=1690844122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pjL6qHDAMp43y83zcgUBo4WIWL310kwBcjaLigNwC5o=;
        b=RZaFqrVRlaMJTDgYZnV9ei7uQv6WyNsF/3oHK39dfgfrQoSoiKZx5Eu+nfPbPxcnju
         L3aVKbpb1Y5giwjoeiuVFNhnQLpERXvLpjLO1BhHxqW/Fuj/ACjJfp03hGxwK03xwng9
         WtxNwN9MAuHT8Xs7Foteb3OuO35pLd8D5rAbvOizr7LQg1uaBmTAmGDklYfWDvofnpj/
         bTyhlSDrLjTDzfZXQU9RRR2RAYarRUxb2yFbuwUz4izvkyIdwKLTZ3HLT+bcAUPfY3va
         sJJ8oopd5mxkNnfQ8xT6GxZPRTwsOlRa44PI7r14X6sIMRlG/wbdqDbDub+Ea6x/mnh/
         XJlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690239322; x=1690844122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pjL6qHDAMp43y83zcgUBo4WIWL310kwBcjaLigNwC5o=;
        b=cz/ywgjphhyLShgo6Fh5nmlHi5kvecq6LMNZRggU0kl8WqlTfOBAIKN+gQSpmP4HNh
         7tG4wwQ2HmAxOI5wqEske7rTasGIOheoQQcl9JbhINeqWNzbf8DSa/eweih5aRQHE2y0
         3fTNiin4BD8KgtKob8ILSdbE/XZFzMtEAlWGnmQUFJJuTsZbQ1X5vIjFZf8UcXInamhr
         iTX5QJlolsJeBXKkrzat8RKARpghtPXN72UEH0Jd+nJgvaCfWCqov6/xF9NgPYdCj5X6
         3iAvdaNxY7eXOhJr6TBnQTbjlTdSIH4MQr6Fkc4cUC7IU5s8q/AYvKKB3glXu+ZfHn49
         W9Gw==
X-Gm-Message-State: ABy/qLYlN0nlOVt80wbdpl61Ps4GBYK9i/p3SPfNilSGLfsZRrS5pcD2
        MF0onZLftyoa3wILYqzqKQYY/mIyB+kwpxvbuk0=
X-Google-Smtp-Source: APBJJlGqVaFhkrrW+NY3IBwC4JQe4MjPRh7n5pVFU87+M8pw/bZU9P+wACt1FrfPaWZfwkFAMEgi+A==
X-Received: by 2002:a17:902:d4c6:b0:1b8:85c4:48f5 with SMTP id o6-20020a170902d4c600b001b885c448f5mr15164040plg.2.1690239322608;
        Mon, 24 Jul 2023 15:55:22 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p7-20020a1709026b8700b001acae9734c0sm9424733plk.266.2023.07.24.15.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 15:55:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/8] io_uring/rw: add write support for IOCB_DIO_CALLER_COMP
Date:   Mon, 24 Jul 2023 16:55:10 -0600
Message-Id: <20230724225511.599870-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230724225511.599870-1-axboe@kernel.dk>
References: <20230724225511.599870-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the filesystem dio handler understands IOCB_DIO_CALLER_COMP, we'll
get a kiocb->ki_complete() callback with kiocb->dio_complete set. In
that case, rather than complete the IO directly through task_work, queue
up an intermediate task_work handler that first processes this callback
and then immediately completes the request.

For XFS, this avoids a punt through a workqueue, which is a lot less
efficient and adds latency to lower queue depth (or sync) O_DIRECT
writes.

Only do this for non-polled IO, as polled IO doesn't need this kind
of deferral as it always completes within the task itself. This then
avoids a check for deferral in the polled IO completion handler.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1bce2208b65c..f19f65b3f0ee 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -105,6 +105,7 @@ int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	} else {
 		rw->kiocb.ki_ioprio = get_current_ioprio();
 	}
+	rw->kiocb.dio_complete = NULL;
 
 	rw->addr = READ_ONCE(sqe->addr);
 	rw->len = READ_ONCE(sqe->len);
@@ -285,6 +286,14 @@ static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 
 void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts)
 {
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+
+	if (rw->kiocb.dio_complete) {
+		long res = rw->kiocb.dio_complete(rw->kiocb.private);
+
+		io_req_set_res(req, io_fixup_rw_res(req, res), 0);
+	}
+
 	io_req_io_end(req);
 
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)) {
@@ -300,9 +309,11 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
 	struct io_kiocb *req = cmd_to_io_kiocb(rw);
 
-	if (__io_complete_rw_common(req, res))
-		return;
-	io_req_set_res(req, io_fixup_rw_res(req, res), 0);
+	if (!rw->kiocb.dio_complete) {
+		if (__io_complete_rw_common(req, res))
+			return;
+		io_req_set_res(req, io_fixup_rw_res(req, res), 0);
+	}
 	req->io_task_work.func = io_req_rw_complete;
 	__io_req_task_work_add(req, IOU_F_TWQ_LAZY_WAKE);
 }
@@ -916,6 +927,15 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	}
 	kiocb->ki_flags |= IOCB_WRITE;
 
+	/*
+	 * For non-polled IO, set IOCB_DIO_CALLER_COMP, stating that our handler
+	 * groks deferring the completion to task context. This isn't
+	 * necessary and useful for polled IO as that can always complete
+	 * directly.
+	 */
+	if (!(kiocb->ki_flags & IOCB_HIPRI))
+		kiocb->ki_flags |= IOCB_DIO_CALLER_COMP;
+
 	if (likely(req->file->f_op->write_iter))
 		ret2 = call_write_iter(req->file, kiocb, &s->iter);
 	else if (req->file->f_op->write)
-- 
2.40.1

