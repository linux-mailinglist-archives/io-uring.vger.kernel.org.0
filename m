Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8AA36E8AA
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 12:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240459AbhD2K1n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 06:27:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40618 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240398AbhD2K1m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 06:27:42 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lc3sk-0006jF-EW; Thu, 29 Apr 2021 10:26:54 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] io_uring: Fix memory leak on error return path.
Date:   Thu, 29 Apr 2021 11:26:54 +0100
Message-Id: <20210429102654.58943-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the -EINVAL error return path is leaking memory allocated
to data. Fix this by kfree'ing data before the return.

Addresses-Coverity: ("Resource leak")
Fixes: c3a40789f6ba ("io_uring: allow empty slots for reg buffers")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 47c2f126f885..beeb477e4f6a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8417,8 +8417,10 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		ret = io_buffer_validate(&iov);
 		if (ret)
 			break;
-		if (!iov.iov_base && tag)
+		if (!iov.iov_base && tag) {
+			kfree(data);
 			return -EINVAL;
+		}
 
 		ret = io_sqe_buffer_register(ctx, &iov, &ctx->user_bufs[i],
 					     &last_hpage);
-- 
2.30.2

