Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FECB75CE2D
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 18:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbjGUQSm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 12:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbjGUQSJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 12:18:09 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAAF4224
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:17:06 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-78706966220so20986539f.1
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689956222; x=1690561022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oy9lAbgIR3CkabfYbdlhMEs1+yC10+0lr3pYvZ/QmXg=;
        b=yA33Zd9ldVZY9NhyqqsuksHoALn2lUyr0D0f/gixUZQWH8C4+c1CVBC4l8R43ZFLP2
         N5gTPBqbYIOmh5fV+DUWjJo7f+HfJN8yZOboqOMTi4xZRiR0X1NqYFlRM3rDImIkb2b4
         kRLj3GWIe/RSi9MZ1LCewwZsIg7T3DVHX+DbHVpMPrUb7LxxsiAGoH0S0d7OWiYn7Quf
         EyjnR+KLkNRR9cW7N8FaN3ifEglDPAept1S+foWG7lqtQgj1c5I8jhfq5aICdN/EQP9l
         LTyHQbZ2dmJC58eS4d2WoIbmXg8C/pqPZWC1PGOlylsmG9cZJrcM/PovfSmPdSH70JTl
         Lm9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689956222; x=1690561022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oy9lAbgIR3CkabfYbdlhMEs1+yC10+0lr3pYvZ/QmXg=;
        b=TrSNC75tdngMYyfJG68bhCPhWAVxwU2nbRkuck8JQwnUqR013KCpU2AXLzHEc9iXBm
         Ie6lTB1ADRO5OOeFxKyL9DAjnVXIG8tEFhajcUMXdgvCAp9LIQz6bfEteGpxG8J/txk5
         JbWNMoza5qO4xt5RkEa4Tvrpa7m2NsWYBEHWy7u8R9v3y0ll0UPUMa6AeUftn/+MBOvA
         yuOme/re+6mNGE1bxv9uj90p6wkfdjD/DLj2L75QF5Yv1o4/Faw2nRRM0yTA2FWLQoIE
         Dvo7qck/JuYmlEVOl523VOmYX/sxbugg2ZsYT1zJbtpDGFVaxfVZ3cU3ub176xx/uxBj
         XVfQ==
X-Gm-Message-State: ABy/qLbH9veTr+Swm+xU81Gg5AepJZReUOmV3zXTw8Ja7jukjFF87+4x
        h7+hASRJjWuwyi8Je75RIl+qge5QlLK7DSjVR/Q=
X-Google-Smtp-Source: APBJJlFEmx3jVQR75X1RQwVd/oXQyZs3MLao8dRJtepXvYv9avdnDUd6eEC7lVQbGsW6gWOVuwrHfA==
X-Received: by 2002:a05:6602:4809:b0:77a:ee79:652 with SMTP id ed9-20020a056602480900b0077aee790652mr2360499iob.1.1689956222242;
        Fri, 21 Jul 2023 09:17:02 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l7-20020a02a887000000b0042b599b224bsm1150450jam.121.2023.07.21.09.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:17:01 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/9] iomap: only set iocb->private for polled bio
Date:   Fri, 21 Jul 2023 10:16:46 -0600
Message-Id: <20230721161650.319414-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230721161650.319414-1-axboe@kernel.dk>
References: <20230721161650.319414-1-axboe@kernel.dk>
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
index 2b453e12dc16..6ffa1b1ebe90 100644
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
 	if (dio->flags & IOMAP_DIO_WRITE_THROUGH)
 		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
 
-	WRITE_ONCE(iocb->private, dio->submit.poll_bio);
-
 	/*
 	 * We are about to drop our additional submission reference, which
 	 * might be the last reference to the dio.  There are three different
-- 
2.40.1

