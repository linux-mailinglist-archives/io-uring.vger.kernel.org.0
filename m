Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046071C51F9
	for <lists+io-uring@lfdr.de>; Tue,  5 May 2020 11:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgEEJdq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 May 2020 05:33:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44627 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728180AbgEEJdq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 May 2020 05:33:46 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jVtxP-0003YD-NN; Tue, 05 May 2020 09:33:43 +0000
From:   Colin King <colin.king@canonical.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH]i[next] io_uring: remove redundant check on force_nonblock
Date:   Tue,  5 May 2020 10:33:43 +0100
Message-Id: <20200505093343.41869-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The check on force_nonblock is redundant as this is performed
several statements earlier and also returns with -EAGAIN. Remove
the redundant check.

Addresses-Coverity: ("Logicall dead code")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e5dfbbd2aa34..4b1efb062f7f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2782,7 +2782,7 @@ static int io_splice(struct io_kiocb *req, bool force_nonblock)
 	poff_in = (sp->off_in == -1) ? NULL : &sp->off_in;
 	poff_out = (sp->off_out == -1) ? NULL : &sp->off_out;
 	ret = do_splice(in, poff_in, out, poff_out, sp->len, flags);
-	if (force_nonblock && ret == -EAGAIN)
+	if (ret == -EAGAIN)
 		return -EAGAIN;
 
 	io_put_file(req, in, (sp->flags & SPLICE_F_FD_IN_FIXED));
-- 
2.25.1

