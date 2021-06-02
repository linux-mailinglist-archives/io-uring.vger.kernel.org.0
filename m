Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9C9398139
	for <lists+io-uring@lfdr.de>; Wed,  2 Jun 2021 08:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhFBGmR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Jun 2021 02:42:17 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3502 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbhFBGmR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Jun 2021 02:42:17 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FvzqH1Sy9zYrs8;
        Wed,  2 Jun 2021 14:37:47 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 14:40:30 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <axboe@kernel.dk>, <io-uring@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <asml.silence@gmail.com>, Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH -next] io_uring: Remove unneeded if-null-free check
Date:   Wed, 2 Jun 2021 14:54:10 +0800
Message-ID: <20210602065410.104240-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Eliminate the following coccicheck warning:

fs/io_uring.c:6056:4-9: WARNING: NULL check before some freeing functions is not needed.
fs/io_uring.c:1744:2-7: WARNING: NULL check before some freeing functions is not needed.
fs/io_uring.c:3340:2-7: WARNING: NULL check before some freeing functions is not needed.
fs/io_uring.c:4612:2-7: WARNING: NULL check before some freeing functions is not needed.
fs/io_uring.c:4375:2-7: WARNING: NULL check before some freeing functions is not needed.
fs/io_uring.c:3441:2-7: WARNING: NULL check before some freeing functions is not needed.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 fs/io_uring.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5f82954004f6..6d0b3d09d92d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1740,8 +1740,7 @@ static void io_dismantle_req(struct io_kiocb *req)
 		io_put_file(req->file);
 	if (req->fixed_rsrc_refs)
 		percpu_ref_put(req->fixed_rsrc_refs);
-	if (req->async_data)
-		kfree(req->async_data);
+	kfree(req->async_data);
 	if (req->work.creds) {
 		put_cred(req->work.creds);
 		req->work.creds = NULL;
@@ -3336,8 +3335,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	kiocb_done(kiocb, ret, issue_flags);
 out_free:
 	/* it's faster to check here then delegate to kfree */
-	if (iovec)
-		kfree(iovec);
+	kfree(iovec);
 	return 0;
 }
 
@@ -3437,8 +3435,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	}
 out_free:
 	/* it's reportedly faster than delegating the null check to kfree() */
-	if (iovec)
-		kfree(iovec);
+	kfree(iovec);
 	return ret;
 }
 
@@ -4371,8 +4368,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		ret = -EINTR;
 
 	/* fast path, check for non-NULL to avoid function call */
-	if (kmsg->free_iov)
-		kfree(kmsg->free_iov);
+	kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < min_ret)
 		req_set_fail_links(req);
@@ -4608,8 +4604,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_recv_kbuf(req);
 	/* fast path, check for non-NULL to avoid function call */
-	if (kmsg->free_iov)
-		kfree(kmsg->free_iov);
+	kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < min_ret || ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))))
 		req_set_fail_links(req);
@@ -6052,8 +6047,7 @@ static void io_clean_op(struct io_kiocb *req)
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
2.25.1

