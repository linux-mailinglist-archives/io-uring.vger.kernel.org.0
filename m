Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED077602C2
	for <lists+io-uring@lfdr.de>; Tue, 25 Jul 2023 00:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjGXWzW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 18:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjGXWzV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 18:55:21 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC3AE5A
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 15:55:20 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1b7dfb95761so7039465ad.1
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 15:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690239319; x=1690844119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VaOldHsyTD5Hhzj5cIOnYQsnyuSsb37LHUEv6JZdWBU=;
        b=kWU+884CPmoOgYk3dplzwKBrvgeyCkYZpstecaAjynjjFeu99X4hes3fF3hrHaJ2FX
         rGITHDyrqLXX0tMIzib5aIHgvAftr79kYXMz6h7P3Lk6qts4qADy/KbcfHF6p3c7rn6n
         xV3k4ifjXdCkn9BoL4rdktFdkxY0NZ+YZ8SXtIK6y+IjY7O7+0orxvTQUdfZ1oY4jmqp
         fynnLQUHFMqv29FKcalYuBpmeRJNIVqB85yJTdTNGIYAt0M6nZwmJGKJw2Mo0i6c9Jw0
         giYGzlY5BORCLwoFsEkPsFfe+CnuhrEGttyKbPBmJlogLGS74OiiaZGOCHbn76uk5hv7
         CBmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690239319; x=1690844119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VaOldHsyTD5Hhzj5cIOnYQsnyuSsb37LHUEv6JZdWBU=;
        b=W2HTXVIZwpP1HR+EFy4IzVUM7UdYiXmlL9vFAkjm0cW1LgrcWJr9e3hdqOOlw4vmiG
         lG/U8vc3IV8JuvSu567fKhNyynOJGTUYAxZ6m6q7CPrLa5rTHiBgd1g7ctyrdTdUMR9b
         re9bhs03bOLKSVnus8bmTd2IJMv3iRl5sFa2VtYyRXlshKKB+r3Eet5xhrCsXt1U68Y7
         Q9wZBLLgw5h5FD4Rygyi/fIcBnJUjPY3Gj+oXPa9m0C4fw5TkeCw+KCnbA9yfTSX6FN9
         DwCLvsJJF03Dmjfjx2n5C/tH7tB7QfTq7g+kUJIK5fSZ8ZP9FpjpvBx0126Vnx+inwo+
         s2gg==
X-Gm-Message-State: ABy/qLbTzcC1nlMQjMlNgHBs4N+MFvWM7DydkcL8F437xWnENB4I+7fa
        QHColWKI+Y0y8MVaYSXTVH4dOXlMyitzH/ttIng=
X-Google-Smtp-Source: APBJJlFGDAl/BePiqiyq9kDB9ah5cnhnCYsm7+4fdelWpYWIzFjJjVVKnmUzN9oI637OpbfH7TDZyw==
X-Received: by 2002:a17:903:32c9:b0:1b8:5827:8763 with SMTP id i9-20020a17090332c900b001b858278763mr14369452plr.4.1690239319665;
        Mon, 24 Jul 2023 15:55:19 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p7-20020a1709026b8700b001acae9734c0sm9424733plk.266.2023.07.24.15.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 15:55:19 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/8] iomap: only set iocb->private for polled bio
Date:   Mon, 24 Jul 2023 16:55:07 -0600
Message-Id: <20230724225511.599870-5-axboe@kernel.dk>
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

iocb->private is only used for polled IO, where the completer will
find the bio to poll through that field.

Assign it when we're submitting a polled bio, and get rid of the
dio->poll_bio indirection.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 6b690fc22365..e4b9d9123b75 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -41,7 +41,6 @@ struct iomap_dio {
 		struct {
 			struct iov_iter		*iter;
 			struct task_struct	*waiter;
-			struct bio		*poll_bio;
 		} submit;
 
 		/* used for aio completion: */
@@ -63,12 +62,14 @@ static struct bio *iomap_dio_alloc_bio(const struct iomap_iter *iter,
 static void iomap_dio_submit_bio(const struct iomap_iter *iter,
 		struct iomap_dio *dio, struct bio *bio, loff_t pos)
 {
+	struct kiocb *iocb = dio->iocb;
+
 	atomic_inc(&dio->ref);
 
 	/* Sync dio can't be polled reliably */
-	if ((dio->iocb->ki_flags & IOCB_HIPRI) && !is_sync_kiocb(dio->iocb)) {
-		bio_set_polled(bio, dio->iocb);
-		dio->submit.poll_bio = bio;
+	if ((iocb->ki_flags & IOCB_HIPRI) && !is_sync_kiocb(iocb)) {
+		bio_set_polled(bio, iocb);
+		WRITE_ONCE(iocb->private, bio);
 	}
 
 	if (dio->dops && dio->dops->submit_io)
@@ -184,7 +185,6 @@ void iomap_dio_bio_end_io(struct bio *bio)
 	 * more IO to be issued to finalise filesystem metadata changes or
 	 * guarantee data integrity.
 	 */
-	WRITE_ONCE(iocb->private, NULL);
 	INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
 	queue_work(file_inode(iocb->ki_filp)->i_sb->s_dio_done_wq,
 			&dio->aio.work);
@@ -523,7 +523,6 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 
 	dio->submit.iter = iter;
 	dio->submit.waiter = current;
-	dio->submit.poll_bio = NULL;
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		iomi.flags |= IOMAP_NOWAIT;
@@ -633,8 +632,6 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (dio->flags & IOMAP_DIO_WRITE_THROUGH)
 		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
 
-	WRITE_ONCE(iocb->private, dio->submit.poll_bio);
-
 	/*
 	 * We are about to drop our additional submission reference, which
 	 * might be the last reference to the dio.  There are three different
-- 
2.40.1

