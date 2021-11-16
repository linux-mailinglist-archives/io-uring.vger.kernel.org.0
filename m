Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D024538F2
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 18:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239214AbhKPR6e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 12:58:34 -0500
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:59064
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239188AbhKPR6d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Nov 2021 12:58:33 -0500
Received: from ascalon (unknown [192.188.8.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 45B0F3F1BA;
        Tue, 16 Nov 2021 17:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1637085334;
        bh=m8b9gnevWtiIUOy82hPVgZJ2g/XYbyastJRt0yGRV4c=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=mAQFaTxm4McWkqEatHV946SPTqP4sDiF0Nmoh4yVZEel5ok0Qig6ejMPfCaA+xUK8
         Y4yjgtguHiyN/LRfcPua6BlG9+yhj+yQUMtm8dI1FSminbQUHrJALok6tUErR+z7vV
         dBBTW0pY0BZKaqBisY6Xp19VyWu2xW1eaugjoC/N1/9iTvqCrOpiD+ya2sySvhBQow
         ELXba1YpV11GQ/JrpmHOghs4nIu5dXwwR02Mb1MaeH6L7G609s6h18JRsNrWi/Q0yw
         7FZZjWnY4ZVf5seNS4ehnF6eXGSkL2IqxeBvr/5MfUdxzhwpZz9i8k9K7aKVki2osX
         PNqNxF0BFyH+Q==
Received: from kamal by ascalon with local (Exim 4.90_1)
        (envelope-from <kamal@ascalon>)
        id 1mn2g8-0008K2-Mh; Tue, 16 Nov 2021 09:55:32 -0800
From:   Kamal Mostafa <kamal@canonical.com>
To:     io-uring@vger.kernel.org
Cc:     Kamal Mostafa <kamal@canonical.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: fix missed comment from *task_file rename
Date:   Tue, 16 Nov 2021 09:55:30 -0800
Message-Id: <20211116175530.31608-1-kamal@canonical.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fix comment referring to function "io_uring_del_task_file()", now called
"io_uring_del_tctx_node()".

Fixes: eef51daa72f7 ("io_uring: rename function *task_file")
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b07196b4511c..e98e7ce3dc39 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9764,7 +9764,7 @@ static __cold void io_uring_clean_tctx(struct io_uring_task *tctx)
 	}
 	if (wq) {
 		/*
-		 * Must be after io_uring_del_task_file() (removes nodes under
+		 * Must be after io_uring_del_tctx_node() (removes nodes under
 		 * uring_lock) to avoid race with io_uring_try_cancel_iowq().
 		 */
 		io_wq_put_and_exit(wq);
-- 
2.17.1

