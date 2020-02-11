Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC70115942C
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 17:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbgBKQDC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 11:03:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51222 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728389AbgBKQDC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 11:03:02 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1j1Y03-0005vu-A1; Tue, 11 Feb 2020 16:02:59 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] io_uring: fix return of an uninitialized variable ret
Date:   Tue, 11 Feb 2020 16:02:59 +0000
Message-Id: <20200211160259.90660-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently variable ret is not initialized and this value is being
returned at the end of the function io_poll_double_wake.  Since
ret is not being used anywhere else remove it and just return 0.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: f6e84af0767f ("io_uring: allow POLL_ADD with double poll_wait() users")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 72bc378edebc..5c6a899b51d8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3707,7 +3707,6 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 	struct io_poll_iocb *poll = (void *) req->io;
 	__poll_t mask = key_to_poll(key);
 	bool done = true;
-	int ret;
 
 	/* for instances that support it check for an event match first: */
 	if (mask && !(mask & poll->events))
@@ -3725,7 +3724,7 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 	if (!done)
 		__io_poll_wake(req, poll, mask);
 	refcount_dec(&req->refs);
-	return ret;
+	return 0;
 }
 
 struct io_poll_table {
-- 
2.25.0

