Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B45E1A240C
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 16:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgDHOaM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 10:30:12 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:20023 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726774AbgDHOaM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 10:30:12 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04397;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TuzqgCr_1586356204;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TuzqgCr_1586356204)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 08 Apr 2020 22:30:10 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring: do not always copy iovec in io_req_map_rw()
Date:   Wed,  8 Apr 2020 22:29:58 +0800
Message-Id: <20200408142958.17240-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In io_read_prep() or io_write_prep(), io_req_map_rw() takes
struct io_async_rw's fast_iov as argument to call io_import_iovec(),
and if io_import_iovec() uses struct io_async_rw's fast_iov as
valid iovec array, later indeed io_req_map_rw() does not need
to do the memcpy operation, because they are same pointers.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6ac830b2b4fb..5eeac5b8ccc6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2493,8 +2493,9 @@ static void io_req_map_rw(struct io_kiocb *req, ssize_t io_size,
 	req->io->rw.iov = iovec;
 	if (!req->io->rw.iov) {
 		req->io->rw.iov = req->io->rw.fast_iov;
-		memcpy(req->io->rw.iov, fast_iov,
-			sizeof(struct iovec) * iter->nr_segs);
+		if (req->io->rw.iov != fast_iov)
+			memcpy(req->io->rw.iov, fast_iov,
+			       sizeof(struct iovec) * iter->nr_segs);
 	} else {
 		req->flags |= REQ_F_NEED_CLEANUP;
 	}
-- 
2.17.2

