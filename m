Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A9175CE21
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 18:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbjGUQSh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 12:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbjGUQSD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 12:18:03 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449544203
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:17:01 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-760dff4b701so30950239f.0
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689956217; x=1690561017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A/R5UlJihGOa6+mEJqx8lHR7UM+4ST5J1wIdWJwVmsw=;
        b=A7DoNGrfaYn++dwRA606+rOPTEW3O5nyCKrQ3PA16H7RWwMk15a8TV/rL+a97766FS
         y59U3Zo/XrwDvrmNmZGUm38ljXOmxpzQBIIGPVPTiuy2YwiZzNNp+mUdP6RkWi5G5j09
         BUaBuFHj6ZkGVwgIz93hFvlswj5WI+ffRJksgS/ZyQ9pKpJlQYNK4nea6guTCpJh5btx
         RQIdFU+3Hmm7d4gIRKA1YP/2m+y3HhHf9x3ZM/DnA0tlFATPD5FeOPHhdtS3xVC2Bikg
         cISPDlji3YfONNX0D1UORBioMP4a1eVUMBGkmEhiyCvoRBTafsho1xWFcIgHpjr4M3BK
         ETbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689956217; x=1690561017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A/R5UlJihGOa6+mEJqx8lHR7UM+4ST5J1wIdWJwVmsw=;
        b=fX14mkj/2tA7jWJQE7qnkpzNlC2qKXDtn+FxNiDUqGAuG3x2t9z3J2Q4o72SKVeg1H
         CKMPgExWEQD5d71jlBCWvKRKQjXmxL/c2yw7Y1C3BRjXQODjKeoeukuSF7nLh3VDAf4E
         MS/AxPxk6eM79u7Jw8QjqxUtEzHMbs7HNpsB/p+sTfh9Qj6Ql/U30Gzo/TIRF/eXULOF
         BdP8y+Sju2/+298uqp6HWBcLMP5xF2/z2qNzk2c11fWFmY34rhLwZxOgq+gvVz91RmUJ
         ueoOxeZGnEx3U0PSNoppnT7nyWrZrLhQ8LjNdLCMzRXd0cueCIVZMPGifM+JYWeUlx4A
         FjWw==
X-Gm-Message-State: ABy/qLaNdTieMYxmGnmr5OZV5zpdpi8v5cqZ/4EWzg0pJ+xAogj03zNI
        KGxENN15VhZSddhu0DK7Y/QDLR2ZJ54BCrIYzZk=
X-Google-Smtp-Source: APBJJlFmGzYXgGwW2LQkQ8zflowHIynCLKdVI0QGFj2fbBlV54fx+DvZA6RCMFC99YzFwY5rRC+Utg==
X-Received: by 2002:a05:6602:3815:b0:783:63e8:3bfc with SMTP id bb21-20020a056602381500b0078363e83bfcmr2601369iob.0.1689956216834;
        Fri, 21 Jul 2023 09:16:56 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l7-20020a02a887000000b0042b599b224bsm1150450jam.121.2023.07.21.09.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:16:55 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/9] iomap: cleanup up iomap_dio_bio_end_io()
Date:   Fri, 21 Jul 2023 10:16:42 -0600
Message-Id: <20230721161650.319414-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230721161650.319414-1-axboe@kernel.dk>
References: <20230721161650.319414-1-axboe@kernel.dk>
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

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

