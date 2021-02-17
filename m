Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8474331E105
	for <lists+io-uring@lfdr.de>; Wed, 17 Feb 2021 22:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhBQVHT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Feb 2021 16:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbhBQVHO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Feb 2021 16:07:14 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1645FC061756
        for <io-uring@vger.kernel.org>; Wed, 17 Feb 2021 13:06:34 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id b3so18854713wrj.5
        for <io-uring@vger.kernel.org>; Wed, 17 Feb 2021 13:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mcONm0R7eYvX7EFL+z7/6X2lZhoV/pDZDjgZxgQg3CM=;
        b=YfqCC/f21AhGXZbEBtFuDwOE81wA6t9tbgxDQyGv73iJdSG6VUarTJCYPSl9IWqJx9
         GIUgsJ0XBsq5Z8gbegvNg44RTcUrwMCr0YVIT4I8zUxofSb/JJG8AyInlGEX22K+OWkq
         cVMPT7JO5bi+2/PEEl9/a4wooWU2y3k/DTZkbZOz+njvHcRbM3MrqRLI7K7qUEDs2IWb
         bpAOLJIkbdr7wslib8yQ3fP6eoJFGzwewuZ1sQkFhhUX7RQ8o/tFZJIZxSU7Eg2lcf5o
         Mn20kOOWeiRiUSmCjQFsYUNXtGtGABrIqEoVj2xdfyNJWHLpExjdwooUFeRKsd7F/svL
         FmfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mcONm0R7eYvX7EFL+z7/6X2lZhoV/pDZDjgZxgQg3CM=;
        b=Zif5V+w2IbB+cAi+lpQDSjm9umUdEnsrb3CXqGSiz0+OyNsev3cBrJlJoSKPi6ItJs
         6s04zk8JbF1xg89ifhIQIFOSBX366WBWaghbaEZon9rIoTt91ijS8SAn7ZOe89vdhMfK
         NmQ36tIUVKwAph6Z58Ay3SrbgezqbikiXm/LxAiR0+FZP1XVreionqsPTaGFIV7Vihwa
         xAF0Im/MoQGCo94lYPUymGYuPCd4xbbOUsGS1TYcyktblAFgUedo/wfGAW9YL1KAIA/z
         qTvDuFvqzxP30Fl8Bt051h8pkN5TZ1oKIweQ/VTPYYRuRcQlwVa5XuM8wrLOSyqb8IdL
         87wg==
X-Gm-Message-State: AOAM530+mianmIsnuIgcxoQnnF0fKZqDr/N/hoFz5mLaPqzn3hZYQpBW
        5DYxV/kdl4agv6+CUUW5kMlzJ4butKk=
X-Google-Smtp-Source: ABdhPJzSbFNOtz8blV8M5zRwnAMjCT/LOxM8cK5QbQ7Tj8akkBb4FCU1uMSa1WQELm8dPhX3ZUlTrA==
X-Received: by 2002:adf:ea12:: with SMTP id q18mr965509wrm.79.1613595992774;
        Wed, 17 Feb 2021 13:06:32 -0800 (PST)
Received: from localhost.localdomain ([85.255.235.13])
        by smtp.gmail.com with ESMTPSA id d23sm4805442wmd.11.2021.02.17.13.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 13:06:32 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/1] io_uring: fix read memory leaks
Date:   Wed, 17 Feb 2021 21:02:36 +0000
Message-Id: <b7fcc06fb191fe9f3ce90d4613985f04b8fa2304.1613595724.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't forget to free iovec read inline completion and bunch of other
cases that do "goto done" before setting up an async context.

Fixes: 5ea5dd45844d1 ("io_uring: inline io_read()'s iovec freeing")
Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 58dd10481106..4352bcea3d9d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3602,10 +3602,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	ret = io_iter_do_read(req, iter);
 
 	if (ret == -EIOCBQUEUED) {
-		/* it's faster to check here then delegate to kfree */
-		if (iovec)
-			kfree(iovec);
-		return 0;
+		goto out_free;
 	} else if (ret == -EAGAIN) {
 		/* IOPOLL retry should happen for io-wq threads */
 		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
@@ -3626,6 +3623,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret2)
 		return ret2;
 
+	iovec = NULL;
 	rw = req->async_data;
 	/* now use our persistent iterator, if we aren't already */
 	iter = &rw->iter;
@@ -3652,6 +3650,10 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	} while (ret > 0 && ret < io_size);
 done:
 	kiocb_done(kiocb, ret, issue_flags);
+out_free:
+	/* it's faster to check here then delegate to kfree */
+	if (iovec)
+		kfree(iovec);
 	return 0;
 }
 
-- 
2.24.0

