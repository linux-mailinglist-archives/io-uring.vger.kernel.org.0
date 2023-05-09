Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BABC06FCA1A
	for <lists+io-uring@lfdr.de>; Tue,  9 May 2023 17:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235749AbjEIPTU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 May 2023 11:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235638AbjEIPTT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 May 2023 11:19:19 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9963E49EA
        for <io-uring@vger.kernel.org>; Tue,  9 May 2023 08:19:18 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-760f040ecccso37630539f.1
        for <io-uring@vger.kernel.org>; Tue, 09 May 2023 08:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683645557; x=1686237557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YfjEIUkXnk7S+bBGuGh6z945jc8ADPHYNzGQJKoLLE4=;
        b=xtm+JSG+yQ7NVMIxUCcrzb9fqk6Pt8FnmmqYDMw5U7xs0/iGr4fHsdvWZZWRMP+Gtn
         Dde4/TsSgfHkwecQvvjSFsFXKzvZswFsCF4a2sWJlopmC70o8Jaew1S8wXExfuiBeRtX
         HnjzTHlpSalIrsFou2sutxX0Zug6r+pk/s6PcbksQWYBbu1Z583/E7ZOmreqA0QxoaHG
         mYXYtNIV0DWnrtyomR0vS5Y9Nw8hBYjf5BW55YG4TzbJYkSG28vHhcHHnUkJXcldgvQy
         g0IERh5yFFJCwUADWmIYYk0Rf59kt15CUykef6/R1AfSdJpLLA19a8zhI7xTRV5F9OrT
         pQBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683645557; x=1686237557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YfjEIUkXnk7S+bBGuGh6z945jc8ADPHYNzGQJKoLLE4=;
        b=RY0d5CLQLT62MpyY4FAkHmFSQDKbs/8S8JLl4st3IfCJKNH027+hQcyxAyGNIMfsUQ
         +LbPuioFzJTjvEzQIHpBTlgBnB5bNrp5cQt4t371CqLDET18MgO90V7HSnrmD3dZFnDi
         0LIovqzzkcU+dxFuJYuTvtQu4lrW2GChkuNICYU1uSZx/KuKqThDrSmDVU/4CnWKNik5
         CD3br6C4+/tCGVEh80bYAjaPPqB2ycVGZ+zAyriS5Vy1DtKc1JMbiL4zvV/x+nX2bu3A
         aSjf5KwFLKOxyAEbhy/2W0HlynzRn+Sa322nEnqpVfoSGkGBOqJc3z5I0RNdzFSTATqx
         GUOg==
X-Gm-Message-State: AC+VfDx2Oy/Ex8Z2hKckmXdH+Dmk4s+oBuYe63RSQUeiNYWnvEzhkiYN
        NY9TJF5ZeyH6/IN3ljlI2wp3TuASu5AlKQRgehw=
X-Google-Smtp-Source: ACHHUZ6OED0m3ebTV2zlg2XqKcDnD2rsB/yN4+mpqkX2/PX3Q+BpQogGknlPJLzvWafRYsBnEa2giQ==
X-Received: by 2002:a05:6602:2c81:b0:763:86b1:6111 with SMTP id i1-20020a0566022c8100b0076386b16111mr10151559iow.2.1683645557484;
        Tue, 09 May 2023 08:19:17 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z1-20020a056638240100b0041659b1e2afsm677390jat.14.2023.05.09.08.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 08:19:16 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: rely solely on FMODE_NOWAIT
Date:   Tue,  9 May 2023 09:19:10 -0600
Message-Id: <20230509151910.183637-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230509151910.183637-1-axboe@kernel.dk>
References: <20230509151910.183637-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now that we have both sockets and block devices setting FMODE_NOWAIT
appropriately, we can get rid of all the odd special casing in
__io_file_supports_nowait() and rely soley on FMODE_NOWAIT and
O_NONBLOCK rather than special case sockets and (in particular) bdevs.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3bca7a79efda..7c426584e35a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1758,11 +1758,6 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 	}
 }
 
-static bool io_bdev_nowait(struct block_device *bdev)
-{
-	return !bdev || bdev_nowait(bdev);
-}
-
 /*
  * If we tracked the file through the SCM inflight mechanism, we could support
  * any file. For now, just ensure that anything potentially problematic is done
@@ -1770,22 +1765,6 @@ static bool io_bdev_nowait(struct block_device *bdev)
  */
 static bool __io_file_supports_nowait(struct file *file, umode_t mode)
 {
-	if (S_ISBLK(mode)) {
-		if (IS_ENABLED(CONFIG_BLOCK) &&
-		    io_bdev_nowait(I_BDEV(file->f_mapping->host)))
-			return true;
-		return false;
-	}
-	if (S_ISSOCK(mode))
-		return true;
-	if (S_ISREG(mode)) {
-		if (IS_ENABLED(CONFIG_BLOCK) &&
-		    io_bdev_nowait(file->f_inode->i_sb->s_bdev) &&
-		    !io_is_uring_fops(file))
-			return true;
-		return false;
-	}
-
 	/* any ->read/write should understand O_NONBLOCK */
 	if (file->f_flags & O_NONBLOCK)
 		return true;
-- 
2.39.2

