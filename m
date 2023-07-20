Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D17575B63B
	for <lists+io-uring@lfdr.de>; Thu, 20 Jul 2023 20:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjGTSNT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 14:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjGTSNR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 14:13:17 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F50FC
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 11:13:17 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-345d2b936c2so1189745ab.0
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 11:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689876796; x=1690481596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zNCV/9UyhdagyTy8j9zaAfC1YSEjA868oZWehUYPc18=;
        b=4qN9kcWKtIHkZTeJ+QkMdqZGhivUbWNO2u1UIl3QwSNJZP2aVwNoHHTott6cJFLKIw
         1Ompc0zLAYZrLiHSnqyuVz2PZ44mqJnrMHYKBANXnGxIPW2q4iIeihWTFI619A7Z7n9K
         Lg7lmY6U3VEtA1gL+kwX0CPjICN2CqbeDkFALxDrtnZT8f1UxgKoVRALFwnqvAeQVOMk
         QPRi4DwBeRNVbjx3iE3VhffLhWkYrod0flBXkYR6cWoh6vO+ZQgrfCpIzhwe3NsrS0Hn
         a9SJAd30CTIRal+HdqKoDp8fOjTgJa7BW+DyzHFyEm54rQSCgG3rakK9s5tg36XU8MaK
         G6aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689876796; x=1690481596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zNCV/9UyhdagyTy8j9zaAfC1YSEjA868oZWehUYPc18=;
        b=UAxzChBKWQqn13ewHcnReovFhaCMKFiJotMLKa2s4N/gvYSu2iL3OCJvll8gku1Ywf
         AOcpW2K4kGX02oxOl5ekvveB41wzAZmOetr8EO59XHiGxBxXXNPBqgkjBOTNpuUAjnqA
         xMbJg2+gP/tqilw5Zn/rC3VPU3FosmRB+qKvd/TVxhNpMexIO+E0eVTeTnfk5ZWBDgvb
         CrOhjcCVeOM2xr4rHHGv2XBPHKyst20O9AR1W0XliBUXtC4ZOvq0N0oiDD1CRAynRm3t
         8L7bn+SEXQ0MYO0a0mxyOcqIMjhquTGVLbw/7WjkrAxdwIoE62gFV/bjF6mGOSMQ+Rbm
         tzfQ==
X-Gm-Message-State: ABy/qLYTyKHmYlkDf37SfiaMfy2esjpvZ1SdOKK47y2BwpLM/E4GDA4a
        o1ynMrHjqkpsrebGrJJh462lch+Sz1fwmINzIdE=
X-Google-Smtp-Source: APBJJlHiaFZvj/wo7rFRRLGQCApphYLMdD8Tr5+ePFq5J9BpVWtfJI92yHXy0swHFT+5VVo5jzsazg==
X-Received: by 2002:a05:6e02:17c8:b0:346:4eb9:9081 with SMTP id z8-20020a056e0217c800b003464eb99081mr12451688ilu.3.1689876795909;
        Thu, 20 Jul 2023 11:13:15 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v6-20020a92c6c6000000b003457e1daba8sm419171ilm.8.2023.07.20.11.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 11:13:14 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/8] iomap: cleanup up iomap_dio_bio_end_io()
Date:   Thu, 20 Jul 2023 12:13:03 -0600
Message-Id: <20230720181310.71589-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230720181310.71589-1-axboe@kernel.dk>
References: <20230720181310.71589-1-axboe@kernel.dk>
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

Make the logic a bit easier to follow:

1) Add a release_bio out path, as everybody needs to touch that, and
   have our bio ref check jump there if it's non-zero.
2) Add a kiocb local variable.
3) Add comments for each of the three conditions (sync, inline, or
   async workqueue punt).

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 46 +++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index ea3b868c8355..0ce60e80c901 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -152,27 +152,43 @@ void iomap_dio_bio_end_io(struct bio *bio)
 {
 	struct iomap_dio *dio = bio->bi_private;
 	bool should_dirty = (dio->flags & IOMAP_DIO_DIRTY);
+	struct kiocb *iocb = dio->iocb;
 
 	if (bio->bi_status)
 		iomap_dio_set_error(dio, blk_status_to_errno(bio->bi_status));
+	if (!atomic_dec_and_test(&dio->ref))
+		goto release_bio;
 
-	if (atomic_dec_and_test(&dio->ref)) {
-		if (dio->wait_for_completion) {
-			struct task_struct *waiter = dio->submit.waiter;
-			WRITE_ONCE(dio->submit.waiter, NULL);
-			blk_wake_io_task(waiter);
-		} else if (dio->flags & IOMAP_DIO_WRITE) {
-			struct inode *inode = file_inode(dio->iocb->ki_filp);
-
-			WRITE_ONCE(dio->iocb->private, NULL);
-			INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
-			queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
-		} else {
-			WRITE_ONCE(dio->iocb->private, NULL);
-			iomap_dio_complete_work(&dio->aio.work);
-		}
+	/*
+	 * Synchronous dio, task itself will handle any completion work
+	 * that needs after IO. All we need to do is wake the task.
+	 */
+	if (dio->wait_for_completion) {
+		struct task_struct *waiter = dio->submit.waiter;
+
+		WRITE_ONCE(dio->submit.waiter, NULL);
+		blk_wake_io_task(waiter);
+		goto release_bio;
+	}
+
+	/* Read completion can always complete inline. */
+	if (!(dio->flags & IOMAP_DIO_WRITE)) {
+		WRITE_ONCE(iocb->private, NULL);
+		iomap_dio_complete_work(&dio->aio.work);
+		goto release_bio;
 	}
 
+	/*
+	 * Async DIO completion that requires filesystem level completion work
+	 * gets punted to a work queue to complete as the operation may require
+	 * more IO to be issued to finalise filesystem metadata changes or
+	 * guarantee data integrity.
+	 */
+	WRITE_ONCE(iocb->private, NULL);
+	INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
+	queue_work(file_inode(iocb->ki_filp)->i_sb->s_dio_done_wq,
+			&dio->aio.work);
+release_bio:
 	if (should_dirty) {
 		bio_check_pages_dirty(bio);
 	} else {
-- 
2.40.1

