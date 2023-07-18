Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182597585CE
	for <lists+io-uring@lfdr.de>; Tue, 18 Jul 2023 21:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbjGRTtd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jul 2023 15:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbjGRTtc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jul 2023 15:49:32 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FB4199A
        for <io-uring@vger.kernel.org>; Tue, 18 Jul 2023 12:49:31 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-77dcff76e35so55785939f.1
        for <io-uring@vger.kernel.org>; Tue, 18 Jul 2023 12:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689709770; x=1692301770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J26GveNzN3vnRUoz11F2mi8E7fquCj+ZYxoQryvAmE8=;
        b=xphtAXKMDXOJ9QPgbjRMoJ+8ODPEqI+DnKqdVe8DCR3COUUW8MjAAwVvGxjLWeCoa2
         pMkpL0qvCf5xvTBsGH7ViXZH8KXqenPdhjWrFoFW+yK9n0O7LHaU+9LqJVPh/K2+fCTe
         VlRE/2kWeqAeOiMViILQ0yLnhQHSrH/XQ7GcEbZywSnJHXnJHgmkBvf2j9IExlz0hvNO
         iGY2Phm95CLvi1cvPOMS9WyUrzP7j33UqfKeG+Rv3XG08x3jES/37z72+FPSAV06Tlev
         kemJ9x43fWNSJkszHF2PsyIuqg2bM1uy6GbrTUEfxBdFXEYxq0HPjr//l6EtsO4tX/MM
         ECUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689709770; x=1692301770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J26GveNzN3vnRUoz11F2mi8E7fquCj+ZYxoQryvAmE8=;
        b=e+9kGvp2mDMqzX2yYVITwW33oZsONkTXZRVCptJbCFH5kuOo8yFzsXmQP+FyYmyKCX
         /iMapg/8k2gIm2Oel1DJBZ9IuL8KbNxIpAMzl6WCTvMAWaNpx7ZkppcOocxD+iG8m1t/
         zQXjO6tU5qk/voKx1ct075foyrHpt1mqCJjqyXcVGSjdhAWQKtBLXGPvbw7ACkjIadra
         Clmb/0W0QrbNVRqLuiftua/iAaDBptzHeEUT7qCj3RGblUVXHErJqDPDxaoJX5eULId0
         8b5swjRGwDZ9w+pi7FVTuxSdrzMR8K0zewAuVFC/9LapDoBCX7oPwFmg/zXuRCOWPjEF
         CBUQ==
X-Gm-Message-State: ABy/qLbSlEHQQmAd4TmSvx6Dy/qKNN3vJ9v56SYBFnblxJrSoIUVZCWm
        IdZAtwUKdrMkcqcy53ifx9L6S5oeo6FIu8iyTEE=
X-Google-Smtp-Source: APBJJlH/cHKNq5jol565/7foeVIkNajJ8mIGx1SHa+z5r1S2bOcQL8NEsSxra8I5OMxlP9onhHXTPw==
X-Received: by 2002:a05:6e02:220f:b0:345:db9a:be2c with SMTP id j15-20020a056e02220f00b00345db9abe2cmr2320311ilf.1.1689709770277;
        Tue, 18 Jul 2023 12:49:30 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v18-20020a92d252000000b00345e3a04f2dsm897463ilg.62.2023.07.18.12.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 12:49:29 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] iomap: add local 'iocb' variable in iomap_dio_bio_end_io()
Date:   Tue, 18 Jul 2023 13:49:19 -0600
Message-Id: <20230718194920.1472184-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230718194920.1472184-1-axboe@kernel.dk>
References: <20230718194920.1472184-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We use this multiple times, add a local variable for the kiocb.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 6fa77094cf0a..92b9b9db8b67 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -158,6 +158,8 @@ void iomap_dio_bio_end_io(struct bio *bio)
 		iomap_dio_set_error(dio, blk_status_to_errno(bio->bi_status));
 
 	if (atomic_dec_and_test(&dio->ref)) {
+		struct kiocb *iocb = dio->iocb;
+
 		if (dio->wait_for_completion) {
 			struct task_struct *waiter = dio->submit.waiter;
 			WRITE_ONCE(dio->submit.waiter, NULL);
@@ -166,9 +168,9 @@ void iomap_dio_bio_end_io(struct bio *bio)
 			WRITE_ONCE(dio->iocb->private, NULL);
 			iomap_dio_complete_work(&dio->aio.work);
 		} else {
-			struct inode *inode = file_inode(dio->iocb->ki_filp);
+			struct inode *inode = file_inode(iocb->ki_filp);
 
-			WRITE_ONCE(dio->iocb->private, NULL);
+			WRITE_ONCE(iocb->private, NULL);
 			INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
 			queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
 		}
-- 
2.40.1

