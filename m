Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69AF936B0C1
	for <lists+io-uring@lfdr.de>; Mon, 26 Apr 2021 11:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbhDZJjR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Apr 2021 05:39:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43817 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbhDZJjF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Apr 2021 05:39:05 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1laxgN-0000HD-Vx; Mon, 26 Apr 2021 09:37:36 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] io_uring: fix incorrect check for kvmalloc failure
Date:   Mon, 26 Apr 2021 10:37:35 +0100
Message-Id: <20210426093735.7932-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently imu is being allocated but the kvmalloc failure is checking
imu->bvec instead of imu.  Fix this by checking imu for null.

Addresses-Coverity: ("Array compared against 0")
Fixes: 41edf1a5ec96 ("io_uring: keep table of pointers to ubufs")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 57a64c7e0e69..f4ec092c23f4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8269,7 +8269,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		goto done;
 
 	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
-	if (!imu->bvec)
+	if (!imu)
 		goto done;
 
 	ret = 0;
-- 
2.30.2

