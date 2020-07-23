Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F9B22A5F0
	for <lists+io-uring@lfdr.de>; Thu, 23 Jul 2020 05:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731405AbgGWDRp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jul 2020 23:17:45 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8254 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728902AbgGWDRo (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 22 Jul 2020 23:17:44 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id F226415FB4F193D458E8;
        Thu, 23 Jul 2020 11:17:40 +0800 (CST)
Received: from huawei.com (10.175.104.57) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Thu, 23 Jul 2020
 11:17:37 +0800
From:   Li Heng <liheng40@huawei.com>
To:     <axboe@kernel.dk>, <viro@zeniv.linux.org.uk>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] io_uring: Remove redundant NULL check
Date:   Thu, 23 Jul 2020 11:19:10 +0800
Message-ID: <1595474350-10039-1-git-send-email-liheng40@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.104.57]
X-CFilter-Loop: Reflected
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fix below warnings reported by coccicheck:
./fs/io_uring.c:1544:2-7: WARNING: NULL check before some freeing functions is not needed.
./fs/io_uring.c:3095:2-7: WARNING: NULL check before some freeing functions is not needed.
./fs/io_uring.c:3195:2-7: WARNING: NULL check before some freeing functions is not needed.

Signed-off-by: Li Heng <liheng40@huawei.com>
---
 fs/io_uring.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6587935..71ac3f7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1540,8 +1540,7 @@ static void io_dismantle_req(struct io_kiocb *req)
 {
 	io_clean_op(req);
 
-	if (req->io)
-		kfree(req->io);
+	kfree(req->io);
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
 	io_req_clean_work(req);
@@ -3091,8 +3090,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		}
 	}
 out_free:
-	if (iovec)
-		kfree(iovec);
+	kfree(iovec);
 	return ret;
 }
 
@@ -3191,8 +3189,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 		}
 	}
 out_free:
-	if (iovec)
-		kfree(iovec);
+	kfree(iovec);
 	return ret;
 }
 
-- 
2.7.4

