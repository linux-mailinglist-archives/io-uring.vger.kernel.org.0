Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5405928F1C8
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 14:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387627AbgJOMAX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 08:00:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34427 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730039AbgJOLzy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 07:55:54 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kT1rK-0004cr-Mt; Thu, 15 Oct 2020 11:55:50 +0000
From:   Colin King <colin.king@canonical.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] io_uring: fix flags check for the REQ_F_WORK_INITIALIZED setting
Date:   Thu, 15 Oct 2020 12:55:50 +0100
Message-Id: <20201015115550.485235-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the check for REQ_F_WORK_INITIALIZED is always true because
the | operator is being used. I believe this check should be checking
if the bit is set using the & operator.

Addresses-Coverity: ("Wrong operator used")
Fixes: 9c357fed168a ("io_uring: fix REQ_F_COMP_LOCKED by killing it")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 01d0b35415dc..5ef54df03d7c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1813,7 +1813,7 @@ static void __io_fail_links(struct io_kiocb *req)
 		 * but avoid REQ_F_WORK_INITIALIZED because it may deadlock on
 		 * work.fs->lock.
 		 */
-		if (link->flags | REQ_F_WORK_INITIALIZED)
+		if (link->flags & REQ_F_WORK_INITIALIZED)
 			io_put_req_deferred(link, 2);
 		else
 			io_double_put_req(link);
-- 
2.27.0

