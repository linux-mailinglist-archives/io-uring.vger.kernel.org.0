Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E42F1F1EBA
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2020 20:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725979AbgFHSJ7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Jun 2020 14:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgFHSJz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Jun 2020 14:09:55 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D3AC08C5C3;
        Mon,  8 Jun 2020 11:09:53 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id m21so14184799eds.13;
        Mon, 08 Jun 2020 11:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X+SvlkZ0oJQusvz3cLXFNfNpl7D8IGGlX2QqZLIzUyA=;
        b=XVFmSUtOkMpnFeJis8nnK0zL1cN3DvDDM5IdjUzKtyQulU0bnmiQCdVuZo+LS4t5e7
         neowaw4h2kVHb+R6O42sN41JfRkM6OnRL85m39cmp47P9FWxvu1m25zVQeB0CfG7dlRC
         u0AeaD0yfZbqYFIyzIwyLZu+77j9b9qIkQE+euMkVXoWUSXBxslXRi6IxrFgadPmQTtA
         aQlsui0mudUD0NtqQi5iXTZ4intC1Sk+10JCH4/q8gOkTPexJHNIx+p8HawtfXWqq++B
         1xjxrvAZF3RkHVcIYoUGzFGwoW24uIlOkeRiYbQAOA00P6sxBD7/dwx9RYLCJLSDOHZb
         jblw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X+SvlkZ0oJQusvz3cLXFNfNpl7D8IGGlX2QqZLIzUyA=;
        b=dkCJOKVQNZ/0bQ7pWn9jpCW+wClaFdb8lzJ0eVchvyCjRsferx+Hry3dvFfopBcN4Y
         DIqbRG3COvtcfAL4SWc2zP1XhhX5x6NqeTHjWqDZOxR6eD0mL/cTpCKyOd5utfAuwunG
         pZ1hKjHoxk49qvx0yeAfFZ4yh6VbVYMK7H3FMH1HAsCg1Kwnh+9ctxuUAyeyDkV+An/G
         gsCJtrQUJ/l0G09YbN10lVMMEnXegBm+jduxFger+/weSc5M7UgcopqsFoiottzS9FCB
         c+O32cH9XhFC51CEuDfDhC3C3fz5cRyuJhVsZOf2e1C9PbIaSP3XGR8aCrBWxSy9zMzJ
         wT9g==
X-Gm-Message-State: AOAM531fISe/YztGlwrQuLL2bZjcYOwVZBYBNzMLZPMowJ7qsxlmca54
        QCQ2QUH39qBhcONWZhZjhUydGu04
X-Google-Smtp-Source: ABdhPJxtOMEvO+kIP0MdcyngDlxt1iQThAafRfcoSwxzgTRaWHwruU9kCpcbwSrjxGUHlcOmIx5kqw==
X-Received: by 2002:a50:b2a1:: with SMTP id p30mr23805070edd.199.1591639792419;
        Mon, 08 Jun 2020 11:09:52 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id ok21sm10515029ejb.82.2020.06.08.11.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 11:09:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, xiaoguang.wang@linux.alibaba.com
Subject: [PATCH 3/4] io_uring: don't arm a timeout through work.func
Date:   Mon,  8 Jun 2020 21:08:19 +0300
Message-Id: <d910e433d0c9466faf3fcd9f02e864ca5bad9f1b.1591637070.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1591637070.git.asml.silence@gmail.com>
References: <cover.1591637070.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove io_link_work_cb() -- the last custom work.func.
Not the prettiest thing, but works. Instead of queueing a linked timeout
in io_link_work_cb() mark a request with REQ_F_QUEUE_TIMEOUT and do
enqueueing based on the flag in io_wq_submit_work().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ce7f815658a3..adf18ff9fdb9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -541,6 +541,7 @@ enum {
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_NO_FILE_TABLE_BIT,
+	REQ_F_QUEUE_TIMEOUT_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -596,6 +597,8 @@ enum {
 	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
 	/* doesn't need file table for this request */
 	REQ_F_NO_FILE_TABLE	= BIT(REQ_F_NO_FILE_TABLE_BIT),
+	/* needs to queue linked timeout */
+	REQ_F_QUEUE_TIMEOUT	= BIT(REQ_F_QUEUE_TIMEOUT_BIT),
 };
 
 struct async_poll {
@@ -1579,16 +1582,6 @@ static void io_free_req(struct io_kiocb *req)
 		io_queue_async_work(nxt);
 }
 
-static void io_link_work_cb(struct io_wq_work **workptr)
-{
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *link;
-
-	link = list_first_entry(&req->link_list, struct io_kiocb, link_list);
-	io_queue_linked_timeout(link);
-	io_wq_submit_work(workptr);
-}
-
 static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
 {
 	struct io_kiocb *link;
@@ -1600,7 +1593,7 @@ static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
 	*workptr = &nxt->work;
 	link = io_prep_linked_timeout(nxt);
 	if (link)
-		nxt->work.func = io_link_work_cb;
+		nxt->flags |= REQ_F_QUEUE_TIMEOUT;
 }
 
 /*
@@ -5333,12 +5326,26 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
+static void io_arm_async_linked_timeout(struct io_kiocb *req)
+{
+	struct io_kiocb *link;
+
+	/* link head's timeout is queued in io_queue_async_work() */
+	if (!(req->flags & REQ_F_QUEUE_TIMEOUT))
+		return;
+
+	link = list_first_entry(&req->link_list, struct io_kiocb, link_list);
+	io_queue_linked_timeout(link);
+}
+
 static void io_wq_submit_work(struct io_wq_work **workptr)
 {
 	struct io_wq_work *work = *workptr;
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	int ret = 0;
 
+	io_arm_async_linked_timeout(req);
+
 	/* if NO_CANCEL is set, we must still run the work */
 	if ((work->flags & (IO_WQ_WORK_CANCEL|IO_WQ_WORK_NO_CANCEL)) ==
 				IO_WQ_WORK_CANCEL) {
-- 
2.24.0

