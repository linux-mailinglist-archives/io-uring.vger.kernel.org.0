Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F8C1E0C1B
	for <lists+io-uring@lfdr.de>; Mon, 25 May 2020 12:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389522AbgEYKss (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 May 2020 06:48:48 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:49355 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389484AbgEYKss (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 May 2020 06:48:48 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01355;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0TzaHfUT_1590403724;
Received: from localhost(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0TzaHfUT_1590403724)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 May 2020 18:48:44 +0800
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH] io_uring: don't set REQ_F_NOWAIT if the file was opened O_NONBLOCK
Date:   Mon, 25 May 2020 18:48:44 +0800
Message-Id: <1590403724-57101-1-git-send-email-jiufei.xue@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When read from an ondisk file that was opened O_NONBLOCK, it will always
return EAGAIN to the user if the page is not cached. It is not
compatible with interfaces such as aio_read() and normal sys_read().

Files that care about this flag (eg. pipe, eventfd) will deal with it
on their own. So I don't think we should set REQ_F_NOWAIT in
io_prep_rw() to provent from queueing the async work.

Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bb25e39..65ae59b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2080,8 +2080,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		kiocb->ki_ioprio = get_current_ioprio();
 
 	/* don't allow async punt if RWF_NOWAIT was requested */
-	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
-	    (req->file->f_flags & O_NONBLOCK))
+	if (kiocb->ki_flags & IOCB_NOWAIT)
 		req->flags |= REQ_F_NOWAIT;
 
 	if (force_nonblock)
-- 
1.8.3.1

