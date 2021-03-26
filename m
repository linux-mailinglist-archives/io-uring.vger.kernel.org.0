Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B8634AFA2
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 20:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhCZTxR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 15:53:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49014 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbhCZTwx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 15:52:53 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lPsVn-0007uY-8d; Fri, 26 Mar 2021 19:52:51 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: remove unsued assignment to pointer io
Date:   Fri, 26 Mar 2021 19:52:51 +0000
Message-Id: <20210326195251.624139-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is an assignment to io that is never read after the assignment,
the assignment is redundant and can be removed.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 046216c1b7d5..17a8adec47f0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4787,7 +4787,6 @@ static int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 			ret = -ENOMEM;
 			goto out;
 		}
-		io = req->async_data;
 		memcpy(req->async_data, &__io, sizeof(__io));
 		return -EAGAIN;
 	}
-- 
2.30.2

