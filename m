Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B5B759F06
	for <lists+io-uring@lfdr.de>; Wed, 19 Jul 2023 21:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjGSTy3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Jul 2023 15:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjGSTy2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Jul 2023 15:54:28 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C59E92
        for <io-uring@vger.kernel.org>; Wed, 19 Jul 2023 12:54:25 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-345d2b936c2so151515ab.0
        for <io-uring@vger.kernel.org>; Wed, 19 Jul 2023 12:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689796464; x=1690401264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jpHtyM71rycbGzxm88J44jHtqMHJstO4/q8wpN7wJCA=;
        b=FNlYw+GmMeqZJ1fUIFhKyYLPOtHct1s9GU3dXBrGMfiPuHhz1RMtma4KEybGDZVewv
         +yLSdH4uw/auwxtOERf6D1LE0rQDTThqOkasvglSvnELfGwkO5f3ARhMwiKM2+O4MK/B
         YL29w+OunBD+ljYgIXYQiYmaHMCr4HJXB5cHgtF+zd4XO1o6L0WuEAafd9JPycncWuU3
         BF02i9/sA8lPl2md/yIWvmPCtprJGPF8XAxRMJsTuNi2yGA/llqePQaB50AhxlCgSm2I
         wLMdhFC3HfZFB/lk1SZ13yJk8Xr0Vl4WWfodSGkxFwQj9nW+7uCVY886kGQzy/l6dcGV
         sCaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689796464; x=1690401264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jpHtyM71rycbGzxm88J44jHtqMHJstO4/q8wpN7wJCA=;
        b=dbuGZcxpJGqjQ2DmIq9u8Xw/Rt5M03QC1Qm9lERaHFpbPsFDzPFJXjzCydkio9djlJ
         DpMXn8HyUdGsQ4b31TNh0FyMscD/mA7rkg3smVricms25rl/hOATNs5UVzSQYb+uDAh0
         pg66AmILlwqNOGAhQkhJxpKFWew1kwg1W5YKlEaUO/nKhfNaNWszAH1CNBtB8CAtb3XP
         +47FJhXISUCQwdX0/DwSTI1Qy+g/zciGO3aASCDAj3eoW20XXUqdTLlee77wuQDV9u8+
         qdLS5yPMrmLxcMZEitnAiXdg2AR9UKHrLJIqN2AUSZpk4lAVJL6sNz4cp7MxNzTr9VjI
         A3hA==
X-Gm-Message-State: ABy/qLa1PMmwiWdnVizG0HRc9WPEvXwjqaXAGR5LosRfzeOagTKeSds8
        dKFammStSsygsFLW2ak4ZozRB6kZ17It8eltlew=
X-Google-Smtp-Source: APBJJlGCrp8uJatS31bBDATPPWJD65ZxrfZJ395iuU0Uxn4EkwUvcftEqKlHKsbRMKYfjuQZrGl8zQ==
X-Received: by 2002:a92:c243:0:b0:346:1919:7cb1 with SMTP id k3-20020a92c243000000b0034619197cb1mr9293382ilo.2.1689796464315;
        Wed, 19 Jul 2023 12:54:24 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j21-20020a02a695000000b0042bb13cb80fsm1471893jam.120.2023.07.19.12.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 12:54:23 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] iomap: cleanup up iomap_dio_bio_end_io()
Date:   Wed, 19 Jul 2023 13:54:12 -0600
Message-Id: <20230719195417.1704513-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230719195417.1704513-1-axboe@kernel.dk>
References: <20230719195417.1704513-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
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
 fs/iomap/direct-io.c | 43 ++++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index ea3b868c8355..1c32f734c767 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -152,27 +152,40 @@ void iomap_dio_bio_end_io(struct bio *bio)
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
+		WRITE_ONCE(dio->submit.waiter, NULL);
+		blk_wake_io_task(waiter);
+		goto release_bio;
+	}
+
+	/*
+	 * If this dio is an async write, queue completion work for async
+	 * handling. Reads can always complete inline.
+	 */
+	if (dio->flags & IOMAP_DIO_WRITE) {
+		struct inode *inode = file_inode(iocb->ki_filp);
+
+		WRITE_ONCE(iocb->private, NULL);
+		INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
+		queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
+	} else {
+		WRITE_ONCE(iocb->private, NULL);
+		iomap_dio_complete_work(&dio->aio.work);
 	}
 
+release_bio:
 	if (should_dirty) {
 		bio_check_pages_dirty(bio);
 	} else {
-- 
2.40.1

