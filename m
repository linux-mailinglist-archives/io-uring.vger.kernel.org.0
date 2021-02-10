Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A246F3170D5
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 21:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbhBJUAx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Feb 2021 15:00:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54801 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbhBJUAv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Feb 2021 15:00:51 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1l9veh-0003kO-Hl; Wed, 10 Feb 2021 20:00:07 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] io_uring: remove redundant initialization of variable ret
Date:   Wed, 10 Feb 2021 20:00:07 +0000
Message-Id: <20210210200007.149248-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable ret is being initialized with a value that is never read
and it is being updated later with a new value.  The initialization is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Fixes: b63534c41e20 ("io_uring: re-issue block requests that failed because of resources")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 909b3169d74e..eff58a967822 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2785,7 +2785,7 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res,
 static bool io_resubmit_prep(struct io_kiocb *req)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
-	int rw, ret = -ECANCELED;
+	int rw, ret;
 	struct iov_iter iter;
 
 	/* already prepared */
-- 
2.30.0

