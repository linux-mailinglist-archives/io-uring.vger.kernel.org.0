Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A65A36E8FF
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 12:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbhD2Kqu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 06:46:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41312 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbhD2Kqu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 06:46:50 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lc4BG-00084q-EX; Thu, 29 Apr 2021 10:46:02 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next][V2] io_uring: Fix premature return from loop and memory leak
Date:   Thu, 29 Apr 2021 11:46:02 +0100
Message-Id: <20210429104602.62676-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the -EINVAL error return path is leaking memory allocated
to data. Fix this by not returning immediately but instead setting
the error return variable to -EINVAL and breaking out of the loop.

Kudos to Pavel Begunkov for suggesting a correct fix.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---

V2: set ret/err to -EINVAL and break rather than kfree and return,
    fix both occurrences of this issue.

---
 fs/io_uring.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 47c2f126f885..c783ad83f220 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8417,8 +8417,10 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		ret = io_buffer_validate(&iov);
 		if (ret)
 			break;
-		if (!iov.iov_base && tag)
-			return -EINVAL;
+		if (!iov.iov_base && tag) {
+			ret = -EINVAL;
+			break;
+		}
 
 		ret = io_sqe_buffer_register(ctx, &iov, &ctx->user_bufs[i],
 					     &last_hpage);
@@ -8468,8 +8470,10 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		err = io_buffer_validate(&iov);
 		if (err)
 			break;
-		if (!iov.iov_base && tag)
-			return -EINVAL;
+		if (!iov.iov_base && tag) {
+			err = -EINVAL;
+			break;
+		}
 		err = io_sqe_buffer_register(ctx, &iov, &imu, &last_hpage);
 		if (err)
 			break;
-- 
2.30.2

