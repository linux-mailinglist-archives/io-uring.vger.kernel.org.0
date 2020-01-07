Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C46E71328C1
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2020 15:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgAGOXA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jan 2020 09:23:00 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8234 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727658AbgAGOXA (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 7 Jan 2020 09:23:00 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D9FF448D3211BFFB0D8B;
        Tue,  7 Jan 2020 22:22:55 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Tue, 7 Jan 2020
 22:22:47 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <viro@zeniv.linux.org.uk>, <axboe@kernel.dk>
CC:     <linux-fsdevel@vger.kernel.org>, <io-uring@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] io_uring: Remove unnecessary null check
Date:   Tue, 7 Jan 2020 22:22:44 +0800
Message-ID: <20200107142244.41260-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Null check kfree is redundant, so remove it.
This is detected by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 60ebdea..cb929e5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1157,8 +1157,7 @@ static void __io_req_aux_free(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (req->io)
-		kfree(req->io);
+	kfree(req->io);
 	if (req->file) {
 		if (req->flags & REQ_F_FIXED_FILE)
 			percpu_ref_put(&ctx->file_data->refs);
-- 
2.7.4


