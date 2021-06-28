Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081523B5740
	for <lists+io-uring@lfdr.de>; Mon, 28 Jun 2021 04:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhF1CjY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 27 Jun 2021 22:39:24 -0400
Received: from m12-15.163.com ([220.181.12.15]:47464 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231678AbhF1CjY (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 27 Jun 2021 22:39:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=lH+g5
        dAa60zOcy4HJrlwgQJ1cYsTMiKFncwaYVK7ow8=; b=UZ7kQjAbEpdK2CDpKHHyc
        TCY4CCAoxnlA57jFfClWGaLvcWHYS6YbeeI36QqQB8CzzQfBhCQfknsTCfLjBKVc
        YYcstR8V48glVZhdr6xQ/wjZnvt4LVrXTGVeIv6kzM6pG5rOz/C1oiNrYnuU+zUq
        Av6p18R+qI6p35sAusuCEw=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp11 (Coremail) with SMTP id D8CowACnzhFoNdlg30x_Ag--.50S2;
        Mon, 28 Jun 2021 10:36:31 +0800 (CST)
From:   13145886936@163.com
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>,
        gushengxian <13145886936@163.com>
Subject: [PATCH] io_uring: Remove NULL test before kfree
Date:   Sun, 27 Jun 2021 19:35:18 -0700
Message-Id: <20210628023518.1508987-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: D8CowACnzhFoNdlg30x_Ag--.50S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kw4DJr13Zr1rAr43tr1DKFg_yoW8urW8pF
        47KrW5KFWDXrWxuan3Ar4rZ3WrGrWvyrWUurWak3y3Xry3Zrnag3W09ryrWFy0grWkAw1Y
        ya1vqanxXF1UAa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jxEf5UUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/1tbiGg+-g1aD+QqJlwAAsR
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

NULL check before kree() function is not needed.
Reported by Coccinelle.

Signed-off-by: gushengxian <13145886936@163.com>
Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 fs/io_uring.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 23c51786708b..17eb77d3b784 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1781,8 +1781,7 @@ static void io_dismantle_req(struct io_kiocb *req)
 		io_put_file(req->file);
 	if (req->fixed_rsrc_refs)
 		percpu_ref_put(req->fixed_rsrc_refs);
-	if (req->async_data)
-		kfree(req->async_data);
+	kfree(req->async_data);
 }
 
 /* must to be called somewhat shortly after putting a request */
@@ -3380,8 +3379,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	kiocb_done(kiocb, ret, issue_flags);
 out_free:
 	/* it's faster to check here then delegate to kfree */
-	if (iovec)
-		kfree(iovec);
+	kfree(iovec);
 	return 0;
 }
 
@@ -3481,8 +3479,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	}
 out_free:
 	/* it's reportedly faster than delegating the null check to kfree() */
-	if (iovec)
-		kfree(iovec);
+	kfree(iovec);
 	return ret;
 }
 
@@ -4563,8 +4560,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		ret = -EINTR;
 
 	/* fast path, check for non-NULL to avoid function call */
-	if (kmsg->free_iov)
-		kfree(kmsg->free_iov);
+	kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < min_ret)
 		req_set_fail(req);
@@ -4800,8 +4796,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_recv_kbuf(req);
 	/* fast path, check for non-NULL to avoid function call */
-	if (kmsg->free_iov)
-		kfree(kmsg->free_iov);
+	kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < min_ret || ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))))
 		req_set_fail(req);
-- 
2.25.1

