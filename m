Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788182765D9
	for <lists+io-uring@lfdr.de>; Thu, 24 Sep 2020 03:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgIXB3Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Sep 2020 21:29:24 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51190 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725273AbgIXB3Y (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 23 Sep 2020 21:29:24 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 356281B3AF01F3B73C0D;
        Thu, 24 Sep 2020 09:29:22 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Thu, 24 Sep 2020
 09:29:15 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <axboe@kernel.dk>, <io-uring@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>
Subject: [PATCH] io_uring: Remove unneeded NULL check before free
Date:   Thu, 24 Sep 2020 09:36:06 +0800
Message-ID: <20200924013606.93616-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.16.2.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fixes coccicheck warnig:
fs//io_uring.c:5775:4-9: WARNING: NULL check before some freeing
functions is not needed.
fs//io_uring.c:1617:2-7: WARNING: NULL check before some freeing
functions is not needed.
fs//io_uring.c:3291:2-7: WARNING: NULL check before some freeing
functions is not needed.
fs//io_uring.c:3398:2-7: WARNING: NULL check before some freeing
functions is not needed.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/io_uring.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 815be15c2aee..23f99ffbb480 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1613,8 +1613,7 @@ static bool io_dismantle_req(struct io_kiocb *req)
 {
 	io_clean_op(req);
 
-	if (req->async_data)
-		kfree(req->async_data);
+	kfree(req->async_data);
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
 
@@ -3287,8 +3286,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	ret = 0;
 out_free:
 	/* it's reportedly faster than delegating the null check to kfree() */
-	if (iovec)
-		kfree(iovec);
+	kfree(iovec);
 	return ret;
 }
 
@@ -3394,8 +3392,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	}
 out_free:
 	/* it's reportedly faster than delegating the null check to kfree() */
-	if (iovec)
-		kfree(iovec);
+	kfree(iovec);
 	return ret;
 }
 
@@ -5771,8 +5768,7 @@ static void __io_clean_op(struct io_kiocb *req)
 		case IORING_OP_WRITE_FIXED:
 		case IORING_OP_WRITE: {
 			struct io_async_rw *io = req->async_data;
-			if (io->free_iovec)
-				kfree(io->free_iovec);
+			kfree(io->free_iovec);
 			break;
 			}
 		case IORING_OP_RECVMSG:
-- 
2.16.2.dirty

