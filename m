Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50504245587
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 05:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgHPDOQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 23:14:16 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:46584 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725919AbgHPDOQ (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 15 Aug 2020 23:14:16 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9E5EC6C3043121CAE5A0;
        Sat, 15 Aug 2020 11:13:54 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Sat, 15 Aug 2020
 11:13:46 +0800
From:   Wu Bo <wubo40@huawei.com>
To:     <axboe@kernel.dk>
CC:     <io-uring@vger.kernel.org>, <linfeilong@huawei.com>,
        <liuzhiqiang26@huawei.com>, <wubo40@huawei.com>
Subject: [PATCH] io_uring: NULL check before kfree() is not needed
Date:   Sat, 15 Aug 2020 11:25:12 +0800
Message-ID: <1597461912-262969-1-git-send-email-wubo40@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

NULL check before kfree() is not needed

Signed-off-by: Wu Bo <wubo40@huawei.com>
---
 fs/io_uring.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2a3af95..59c19c8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1537,8 +1537,7 @@ static void io_dismantle_req(struct io_kiocb *req)
 {
 	io_clean_op(req);
 
-	if (req->io)
-		kfree(req->io);
+	kfree(req->io);
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
 	io_req_clean_work(req);
@@ -3111,8 +3110,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		return -EAGAIN;
 	}
 out_free:
-	if (iovec)
-		kfree(iovec);
+	kfree(iovec);
 	return ret;
 }
 
@@ -3210,8 +3208,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 		return -EAGAIN;
 	}
 out_free:
-	if (iovec)
-		kfree(iovec);
+	kfree(iovec);
 	return ret;
 }
 
-- 
1.8.3.1

