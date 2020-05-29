Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2951E7679
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2020 09:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgE2HSd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 May 2020 03:18:33 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:34671 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725959AbgE2HSc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 May 2020 03:18:32 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0Tzy5XVq_1590736708;
Received: from localhost(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0Tzy5XVq_1590736708)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 29 May 2020 15:18:29 +0800
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH] io_uring: don't set REQ_F_NOWAIT for regular files opend O_NONBLOCK
Date:   Fri, 29 May 2020 15:18:28 +0800
Message-Id: <1590736708-99812-1-git-send-email-jiufei.xue@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When read from a regular file that was opened O_NONBLOCK, it will
return EAGAIN if the page is not cached, which is not expected and
fails the application.

Applications written before expect that the open flag O_NONBLOCK has
no effect on a regular file.

Fix this by not setting REQ_F_NOWAIT for regular files.

Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 95df63b..69db8bb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2107,7 +2107,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	/* don't allow async punt if RWF_NOWAIT was requested */
 	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
-	    (req->file->f_flags & O_NONBLOCK))
+	    (!(req->flags & REQ_F_ISREG) && (req->file->f_flags & O_NONBLOCK)))
 		req->flags |= REQ_F_NOWAIT;
 
 	if (force_nonblock)
-- 
1.8.3.1

