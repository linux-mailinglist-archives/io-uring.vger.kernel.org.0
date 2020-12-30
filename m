Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9737E2E7678
	for <lists+io-uring@lfdr.de>; Wed, 30 Dec 2020 07:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgL3GYC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Dec 2020 01:24:02 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:41890 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726161AbgL3GYB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Dec 2020 01:24:01 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UKCfTR5_1609309377;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UKCfTR5_1609309377)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 30 Dec 2020 14:23:07 +0800
From:   YANG LI <abaci-bugfix@linux.alibaba.com>
To:     axboe@kernel.dk
Cc:     viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        YANG LI <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] io_uring: style: redundant NULL check.
Date:   Wed, 30 Dec 2020 14:22:55 +0800
Message-Id: <1609309375-65129-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the pointer in kfree is empty, the function does nothing,
so remove the redundant NULL check.

Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci <abaci@linux.alibaba.com>
---
 fs/io_uring.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7e35283..105e188 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1934,8 +1934,8 @@ static void io_dismantle_req(struct io_kiocb *req)
 {
 	io_clean_op(req);
 
-	if (req->async_data)
-		kfree(req->async_data);
+	kfree(req->async_data);
+
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
 	if (req->fixed_file_refs)
@@ -3537,8 +3537,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	ret = 0;
 out_free:
 	/* it's reportedly faster than delegating the null check to kfree() */
-	if (iovec)
-		kfree(iovec);
+	kfree(iovec);
 	return ret;
 }
 
@@ -3644,8 +3643,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	}
 out_free:
 	/* it's reportedly faster than delegating the null check to kfree() */
-	if (iovec)
-		kfree(iovec);
+	kfree(iovec);
 	return ret;
 }
 
@@ -6133,8 +6131,7 @@ static void __io_clean_op(struct io_kiocb *req)
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
1.8.3.1

