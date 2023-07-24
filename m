Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B787602BC
	for <lists+io-uring@lfdr.de>; Tue, 25 Jul 2023 00:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjGXWzT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 18:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjGXWzS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 18:55:18 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625C610E3
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 15:55:17 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1bbadf9ed37so1478695ad.0
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 15:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690239316; x=1690844116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A/R5UlJihGOa6+mEJqx8lHR7UM+4ST5J1wIdWJwVmsw=;
        b=Z4eRb4Fg/xOnz5US0iHTMZBP+UrWEINLRqVJiwIiQi93n/tGr8LMLJ/dLP9suWM6Vc
         H3R6uihOBZu+zqp0XHp7ZojMRFSEEebl65nWOjnpr87DSi19vDBEabDIGH1LseWpNxxW
         h9vWvqKHN1wm+O7wX8/EwV+2h1MLvdu6LEFk8NE42dpYCbwGYO/Uln6J67rhbhwK4NcB
         EoPwQF7DJFTHlRxM8ge98xdW6DLAiYpRWB7peB6narKkDKCEMvJUaoaV1JBycx57pXop
         n/zCosM6xzHK2S9yv2F4TEtP6qlzNxZPrY3h6wD8BE4hYCRcJh6GdOXKs30/oW1K8D9k
         en8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690239316; x=1690844116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A/R5UlJihGOa6+mEJqx8lHR7UM+4ST5J1wIdWJwVmsw=;
        b=Dhg3nRt6zk5e2xOAtZt8PoXzblRNMRmko6x7rTlZAEGFEY8Yy+zAUoQmfK8mXXAlko
         iZpVQ0D8bM0K1chSFBi1OP6XIHEXDnvVM6RIEFw4fSEbL+G++vud7HJ3avjghFKTRxYt
         55uLmNtvPEe8ssFZMeXsTjKT6j91Clxv3Nbs25z98zaDD7LLTQTafF3jGr/GSpJPbfgZ
         WIz0afWVXJR0PGW9lGYwlaGlxW5E5f78u+RtS11o+1oxCYMgwlj1mTQncFErWrn2jyf5
         fVQGHTAMgpuuMrh5GcQouXvQkymHUI17CaG+XNE32r0oR24TZh18SkazIgUiOTUzDJLN
         +5jA==
X-Gm-Message-State: ABy/qLbAPJ7vSudaMOzLJxvfK5MrI5oEBbTyWUEoaK32+5nkPlvxI+CA
        JreOya2Zw6+5Isd2TLwGzjNldfW4WpWBECTvslk=
X-Google-Smtp-Source: APBJJlFmb5w7Cf5UsiJZA1gyKD5FHUU0imdizY6mcFZDEw4ad1e0VV2drsmrNPcbUJTLy5v1L2O9sA==
X-Received: by 2002:a17:903:41cd:b0:1bb:9e6e:a9f3 with SMTP id u13-20020a17090341cd00b001bb9e6ea9f3mr6381477ple.4.1690239316678;
        Mon, 24 Jul 2023 15:55:16 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p7-20020a1709026b8700b001acae9734c0sm9424733plk.266.2023.07.24.15.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 15:55:16 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/8] iomap: cleanup up iomap_dio_bio_end_io()
Date:   Mon, 24 Jul 2023 16:55:04 -0600
Message-Id: <20230724225511.599870-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230724225511.599870-1-axboe@kernel.dk>
References: <20230724225511.599870-1-axboe@kernel.dk>
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

