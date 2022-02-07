Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDC6E4ABF32
	for <lists+io-uring@lfdr.de>; Mon,  7 Feb 2022 14:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbiBGNGh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Feb 2022 08:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391445AbiBGMBt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Feb 2022 07:01:49 -0500
X-Greylist: delayed 210 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 03:59:31 PST
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E917C03E921;
        Mon,  7 Feb 2022 03:59:30 -0800 (PST)
Received: from integral2.. (unknown [36.72.213.52])
        by gnuweeb.org (Postfix) with ESMTPSA id A50E97E258;
        Mon,  7 Feb 2022 11:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1644234255;
        bh=UC+l746d+ctD97nNi+ogzS1mPkamtQDrniJtWWP4aXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M8RxUq8vBDKlrMWCk6tUjzExD87kUWg+ChDGFxXP4ig7iMkkzz389ytZoZG/In1i4
         DCDMeFvvZ5/7fp3IEuf/wupbvmAyPfAJnwWXpqChxyndNjM5l1PHI7QqLsyU4PJUfT
         V+oS8oNUo5UBy9TohgSER7tI1yEoSAaE+vBxnyiV8z5nM9ORVnG6A5ie3Wpl8BSF8Q
         W8G9PqVd8o+MnyfPP4LOs9iLhpUx35UfMPvADdyW1Q/bDrpkz8Sq6PW+AftCLixJBY
         w1S5zJ0TH8NPIOMvZfYp44I+b0XSPt4W7i4W4Zalm6M0UHJI7HN2xx23T2w+JEcGv3
         rAS4mnNqq3ERQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     GNU/Weeb Mailing List <gwml@gnuweeb.org>,
        io-uring Mailing list <io-uring@vger.kernel.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Chen, Rong A" <rong.a.chen@intel.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH io_uring-5.17] io_uring: Fix build error potential reading uninitialized value
Date:   Mon,  7 Feb 2022 18:43:15 +0700
Message-Id: <20220207114315.555413-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <d33bb5a9-8173-f65b-f653-51fc0681c6d6@intel.com>
References: <d33bb5a9-8173-f65b-f653-51fc0681c6d6@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>

In io_recv() if import_single_range() fails, the @flags variable is
uninitialized, then it will goto out_free.

After the goto, the compiler doesn't know that (ret < min_ret) is
always true, so it thinks the "if ((flags & MSG_WAITALL) ..."  path
could be taken.

The complaint comes from gcc-9 (Debian 9.3.0-22) 9.3.0:
```
  fs/io_uring.c:5238 io_recvfrom() error: uninitialized symbol 'flags'
```
Fix this by bypassing the @ret and @flags check when
import_single_range() fails.

Reasons:
 1. import_single_range() only returns -EFAULT when it fails.
 2. At that point @flags is uninitialized and shouldn't be read.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: "Chen, Rong A" <rong.a.chen@intel.com>
Link: https://lore.gnuweeb.org/timl/d33bb5a9-8173-f65b-f653-51fc0681c6d6@intel.com/
Cc: Pavel Begunkov <asml.silence@gmail.com>
Suggested-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Fixes: 7297ce3d59449de49d3c9e1f64ae25488750a1fc ("io_uring: improve send/recv error handling")
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2e04f718319d..3445c4da0153 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5228,7 +5228,6 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		min_ret = iov_iter_count(&msg.msg_iter);
 
 	ret = sock_recvmsg(sock, &msg, flags);
-out_free:
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock)
 			return -EAGAIN;
@@ -5236,9 +5235,9 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 			ret = -EINTR;
 		req_set_fail(req);
 	} else if ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
+out_free:
 		req_set_fail(req);
 	}
-
 	__io_req_complete(req, issue_flags, ret, io_put_kbuf(req));
 	return 0;
 }

base-commit: f6133fbd373811066c8441737e65f384c8f31974
-- 
2.32.0

