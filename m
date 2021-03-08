Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6E4330876
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 07:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235100AbhCHGwZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 01:52:25 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13479 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235099AbhCHGwQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 01:52:16 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Dv89X6tdkzrSLr;
        Mon,  8 Mar 2021 14:50:24 +0800 (CST)
Received: from code-website.localdomain (10.175.127.227) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Mar 2021 14:52:01 +0800
From:   yangerkun <yangerkun@huawei.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <yi.zhang@huawei.com>,
        <yangerkun@huawei.com>
Subject: [PATCH 2/2] io_uring: fix UAF for io_buffer_idr
Date:   Mon, 8 Mar 2021 14:59:03 +0800
Message-ID: <20210308065903.2228332-2-yangerkun@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210308065903.2228332-1-yangerkun@huawei.com>
References: <20210308065903.2228332-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The same as personality_idr, stop call idr_remove in idr_for_each.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 fs/io_uring.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b462c2bf0f2c..7c3011756994 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3850,8 +3850,8 @@ static int io_remove_buffers_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int __io_remove_buffers(struct io_ring_ctx *ctx, struct io_buffer *buf,
-			       int bgid, unsigned nbufs)
+static int __io_free_buffers(struct io_ring_ctx *ctx, struct io_buffer *buf,
+			       int bgid, unsigned int nbufs)
 {
 	unsigned i = 0;
 
@@ -3871,11 +3871,16 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx, struct io_buffer *buf,
 	}
 	i++;
 	kfree(buf);
-	idr_remove(&ctx->io_buffer_idr, bgid);
-
 	return i;
 }
 
+static int __io_remove_buffers(struct io_ring_ctx *ctx, struct io_buffer *buf,
+			       int bgid, unsigned int nbufs)
+{
+	idr_remove(&ctx->io_buffer_idr, bgid);
+	return __io_free_buffers(ctx, buf, bgid, nbufs);
+}
+
 static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_provide_buf *p = &req->pbuf;
@@ -8345,18 +8350,18 @@ static int io_eventfd_unregister(struct io_ring_ctx *ctx)
 	return -ENXIO;
 }
 
-static int __io_destroy_buffers(int id, void *p, void *data)
+static int io_free_buffers(int id, void *p, void *data)
 {
 	struct io_ring_ctx *ctx = data;
 	struct io_buffer *buf = p;
 
-	__io_remove_buffers(ctx, buf, id, -1U);
+	__io_free_buffers(ctx, buf, id, -1U);
 	return 0;
 }
 
 static void io_destroy_buffers(struct io_ring_ctx *ctx)
 {
-	idr_for_each(&ctx->io_buffer_idr, __io_destroy_buffers, ctx);
+	idr_for_each(&ctx->io_buffer_idr, io_free_buffers, ctx);
 	idr_destroy(&ctx->io_buffer_idr);
 }
 
-- 
2.25.4

