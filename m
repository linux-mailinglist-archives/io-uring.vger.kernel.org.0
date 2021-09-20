Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D08741140C
	for <lists+io-uring@lfdr.de>; Mon, 20 Sep 2021 14:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbhITMPW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Sep 2021 08:15:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233150AbhITMPW (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 20 Sep 2021 08:15:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1F2F60F9D;
        Mon, 20 Sep 2021 12:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632140035;
        bh=XwUrIj5+6nOT5dCt/z9etZTa1PDih4x2UqcmzigtlRg=;
        h=From:To:Cc:Subject:Date:From;
        b=tzfxz8THzOv1RAPbtUlPLWfsTB3ciEj2j4ZJdD3ISt+LF9ZuJJGxNzfQPbcr0sh/Y
         qmZChtSUVjqv5KJRGS6CNnyKjUvKh3iz1pdJoi9tXkHVuAcrelEL9XQpDhOeJAxljz
         dnjkqApXxHyK/dYPG+bXlBwz+XBQxJxtdZELjuBEq65DZeJIATI0AZozd1Rh2bRTrb
         W2t2rUoEZykpMU+jjvKJ48wS2iWK6OBKN6tUg5aHopQY8BS5uj5ZbGZSrDuQinIoXe
         355Ib2R5xXysol1MLFZR1MlZSKW6MqGW18apRHKre1+4+mv+12KZxF4PteLwZyMheL
         kiyG7bcYMp7WA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [RFC] io_uring: warning about unused-but-set parameter
Date:   Mon, 20 Sep 2021 14:13:44 +0200
Message-Id: <20210920121352.93063-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When enabling -Wunused warnings by building with W=1, I get an
instance of the -Wunused-but-set-parameter warning in the io_uring code:

fs/io_uring.c: In function 'io_queue_async_work':
fs/io_uring.c:1445:61: error: parameter 'locked' set but not used [-Werror=unused-but-set-parameter]
 1445 | static void io_queue_async_work(struct io_kiocb *req, bool *locked)
      |                                                       ~~~~~~^~~~~~

There are very few warnings of this type, so it would be nice to enable
this by default and fix all the existing instances. I was almost
done, but this was added recently as a precaution to prevent code
from using the parameter, which could be done by either removing
the initialization, or by adding a (fake) use of the variable, which
I do here with the cast to void.

Fixes: f237c30a5610 ("io_uring: batch task work locking")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 63b0425d6a32..36fbc7f06f5e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1450,6 +1450,7 @@ static void io_queue_async_work(struct io_kiocb *req, bool *locked)
 
 	/* must not take the lock, NULL it as a precaution */
 	locked = NULL;
+	(void)locked;
 
 	BUG_ON(!tctx);
 	BUG_ON(!tctx->io_wq);
-- 
2.29.2

