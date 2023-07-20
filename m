Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610C275B643
	for <lists+io-uring@lfdr.de>; Thu, 20 Jul 2023 20:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjGTSNY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 14:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjGTSNX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 14:13:23 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43291E6F
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 11:13:22 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-3461b58c61dso1579935ab.1
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 11:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689876801; x=1690481601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vkFdmhtuIxCFwZFIvMW05Nk5MCZjzgqa77O2M4w6Fac=;
        b=LWMqSi3R9agDnnB3ZDBuxXuQdEK0985PbGqifHai6o9g9UVb928jR3cHBDidCjDMaZ
         BqCGoAF2Y2UoWZKN5NxTzXGaNwbwxC1s7kxSnuRph+r1Lnf3J9QBbhin+PWEvh4khDSt
         3oGXC6pKOVRASPA69xnSSf18+TlNIJAPnNnnm8RJiUXD8zN+JW8WrHUvwg5UF+sEaNFW
         olStaXqnmEiSKkMWQ7CTlocDD/S7VdufYks0u28+Ltv0X/4CA8ld1UYJr4lKFQNG/1cl
         64RxwYTVaeeoNIhZU4jyGi33OUrD4UcsS8E3k9rIYUz1N3dPex+pNTPh69X82c7+YGO5
         fcIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689876801; x=1690481601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vkFdmhtuIxCFwZFIvMW05Nk5MCZjzgqa77O2M4w6Fac=;
        b=Mc+Tsb3eYEut7FuRhwN/KRM09HYi2jJMhkxH5kywM2ezMz5UtYatB9TClhr1Gh61vI
         GzKXEjXvCf2XLlWpOGh9cJj9hd25DlpnalIqe7MuYJa7gxW0OF1fu1Y6PekAA7JoXTDB
         zy1a4hbf25KzlsMpftazW7k6B0i8/Cy8cZJ2waXVEpPHD8npRzFJvBgF9H0KAl90X4e1
         2VayQpiw2dZas5hPDLSv1l5huERyrS0G4LuiSdEePGBWLuJo3L69ORMLl/pHbIlbpw7m
         tUApO7wo4gOlgFIlyPa3kvi/W8i/2FW3WgyR3OpGgPoZ/n6XxU11AWNm7qMyodfo+5uj
         0sYQ==
X-Gm-Message-State: ABy/qLbcjCnyXvmPtlSit5UU1Zz9Z13nuleIfD7Vf7onU2+kcg28wIZ7
        ntLXeQ4jrUXllpLWDdOsn6td62gllrjLe4g/5dI=
X-Google-Smtp-Source: APBJJlGwgRRJcWW8HC8ms5DLopDsZTENWKAh9pRaFUmDR8PV1ND1TzaaSs4gMEvH4qeTM74lkTmL9g==
X-Received: by 2002:a92:d985:0:b0:345:ad39:ff3 with SMTP id r5-20020a92d985000000b00345ad390ff3mr3407704iln.3.1689876801300;
        Thu, 20 Jul 2023 11:13:21 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v6-20020a92c6c6000000b003457e1daba8sm419171ilm.8.2023.07.20.11.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 11:13:20 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/8] iomap: only set iocb->private for polled bio
Date:   Thu, 20 Jul 2023 12:13:07 -0600
Message-Id: <20230720181310.71589-6-axboe@kernel.dk>
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

iocb->private is only used for polled IO, where the completer will
find the bio to poll through that field.

Assign it when we're submitting a polled bio, and get rid of the
dio->poll_bio indirection.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index c3ea1839628f..cce9af019705 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -42,7 +42,6 @@ struct iomap_dio {
 		struct {
 			struct iov_iter		*iter;
 			struct task_struct	*waiter;
-			struct bio		*poll_bio;
 		} submit;
 
 		/* used for aio completion: */
@@ -64,12 +63,14 @@ static struct bio *iomap_dio_alloc_bio(const struct iomap_iter *iter,
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
@@ -197,7 +198,6 @@ void iomap_dio_bio_end_io(struct bio *bio)
 	 * more IO to be issued to finalise filesystem metadata changes or
 	 * guarantee data integrity.
 	 */
-	WRITE_ONCE(iocb->private, NULL);
 	INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
 	queue_work(file_inode(iocb->ki_filp)->i_sb->s_dio_done_wq,
 			&dio->aio.work);
@@ -536,7 +536,6 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 
 	dio->submit.iter = iter;
 	dio->submit.waiter = current;
-	dio->submit.poll_bio = NULL;
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		iomi.flags |= IOMAP_NOWAIT;
@@ -648,8 +647,6 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (dio->flags & IOMAP_DIO_STABLE_WRITE)
 		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
 
-	WRITE_ONCE(iocb->private, dio->submit.poll_bio);
-
 	/*
 	 * We are about to drop our additional submission reference, which
 	 * might be the last reference to the dio.  There are three different
-- 
2.40.1

