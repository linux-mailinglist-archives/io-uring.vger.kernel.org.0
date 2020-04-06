Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8161A014C
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 00:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgDFWyn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Apr 2020 18:54:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50503 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgDFWym (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Apr 2020 18:54:42 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jLadc-0006Km-4Y; Mon, 06 Apr 2020 22:54:40 +0000
From:   Colin King <colin.king@canonical.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: remove redundant variable pointer nxt and io_wq_assign_next call
Date:   Mon,  6 Apr 2020 23:54:39 +0100
Message-Id: <20200406225439.654486-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

An earlier commit "io_uring: remove @nxt from handlers" removed the
setting of pointer nxt and now it is always null, hence the non-null
check and call to io_wq_assign_next is redundant and can be removed.

Addresses-Coverity: ("'Constant' variable guard")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/io_uring.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 14efcf0a3070..b594fa0bd210 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3509,14 +3509,11 @@ static void __io_sync_file_range(struct io_kiocb *req)
 static void io_sync_file_range_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 
 	if (io_req_cancelled(req))
 		return;
 	__io_sync_file_range(req);
 	io_put_req(req); /* put submission ref */
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
 }
 
 static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
-- 
2.25.1

