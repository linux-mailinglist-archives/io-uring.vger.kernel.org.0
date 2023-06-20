Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C80736B0C
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 13:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbjFTLcz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 07:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbjFTLcy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 07:32:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3796130
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 04:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=kRnpR4PaG/N3bQJf2yFh83PhIdYSL1lX09KSmTqGqW0=; b=MzQiFXKU9kUCDllA3kcVBpNxGg
        SlFOwfJO5dY634peO7cmL99qjCHwHbWZSsjWKOI8z9FB0nqGmnB/Pn3Eu2iIKmI6vWmaMSQDa9fI0
        rdxLaFRTUiTwe+AZIQn17LkaZdbolHi3qJQzzIClql6iaK1l0GOq4XK+xs6KJnpVqlH+ruwiL8fsa
        9vMDmzAMeiqC1wPtQ3S7gnFjO23c7PlZisRMeedlI+zqbp28aXR4NHBJm0gSmGda3JbGwn3R4jmlv
        VHARIK6i2WX4F/NeD/yzYs/jOIvhFeYUBXlXKWH+2uX5Mmy6goIMP8C8vxn7xJ61yT8+REJ+Rema0
        T5G0VyDA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qBZbQ-00B8ZK-1g;
        Tue, 20 Jun 2023 11:32:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Subject: [PATCH 4/8] io_uring: remove io_req_ffs_set
Date:   Tue, 20 Jun 2023 13:32:31 +0200
Message-Id: <20230620113235.920399-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230620113235.920399-1-hch@lst.de>
References: <20230620113235.920399-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just checking the flag directly makes it a lot more obvious what is
going on here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 io_uring/io_uring.c | 2 +-
 io_uring/io_uring.h | 5 -----
 io_uring/rw.c       | 2 +-
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 79f3cabec5b934..0e0bdb6ac9a202 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -424,7 +424,7 @@ static void io_prep_async_work(struct io_kiocb *req)
 	if (req->flags & REQ_F_FORCE_ASYNC)
 		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 
-	if (req->file && !io_req_ffs_set(req))
+	if (req->file && !(req->flags & REQ_F_FIXED_FILE))
 		req->flags |= io_file_get_flags(req->file) << REQ_F_SUPPORT_NOWAIT_BIT;
 
 	if (req->file && (req->flags & REQ_F_ISREG)) {
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index a937b4b75aee98..9718897133db59 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -57,11 +57,6 @@ struct file *io_file_get_normal(struct io_kiocb *req, int fd);
 struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 			       unsigned issue_flags);
 
-static inline bool io_req_ffs_set(struct io_kiocb *req)
-{
-	return req->flags & REQ_F_FIXED_FILE;
-}
-
 void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
 bool io_is_uring_fops(struct file *file);
 bool io_alloc_async_data(struct io_kiocb *req);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index c23d8baf028769..1cf5742f2ae9cb 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -666,7 +666,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 	if (unlikely(!file || !(file->f_mode & mode)))
 		return -EBADF;
 
-	if (!io_req_ffs_set(req))
+	if (!(req->flags & REQ_F_FIXED_FILE))
 		req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
 
 	kiocb->ki_flags = file->f_iocb_flags;
-- 
2.39.2

