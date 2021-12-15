Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38ED4475D71
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 17:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244821AbhLOQaP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 11:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244802AbhLOQaP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 11:30:15 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5ED9C06173E
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 08:30:14 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id z18so31084930iof.5
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 08:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HW4tADXnsX1kVJEjzQB5GXTaWIqCwvQGXd7qCGVjzhI=;
        b=O85KNpfujxQLOdxylblhrkc8zk3n1koN9OsNgJlPq7LevN961C02fpa+6XpLLIW3hC
         y3dVMn81+0K4ZXpGOhC1XMbq5z+qb44VVhOJQRiZbl48MsH88hc+lV8lzxaFW984eMub
         W9FgnZpQjouEBrSZd0fJnCzHzcNXu50LYM5WTUYbu3GCghIJzvNXT+hXvHKZNxX2c29r
         uVszepdFCY/llkmKkskC77t7W62qBChEqQPpYC2djcrq2805dhWILmPsJyBoZOPU/7Ih
         xWlfDSOurSkunSbdizmeIBEpdy2qh8XrJ5fEgl3WnPp7yEeiaDNFTrEsO99cOXDJS2GQ
         tiNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HW4tADXnsX1kVJEjzQB5GXTaWIqCwvQGXd7qCGVjzhI=;
        b=U/iRsHxwEF/mlD+g5daaWSBwsYQI8Ixs5EyseUJEVOscKQ4yuIiAVFXEvDVqW7hgty
         xl41/AWn8bYe1OyuWPvRKwi8iu4XlSeUxWrY4uMA2yZyVoGbNsb8gFipd7WLG0JlwKqX
         AqtVqY5Gefx2USTeYqFiXT9r8F3oofqY5oWhofhx7lnSlqMrTKt7Q5nQJ8vx2PPG6jZS
         DdeLJVbYDbuiRh4C8dgJzuZ+rTNw4KW+j6LpP2A7bqqiec+9e27UZr/9COyb5vsSijoB
         WvXAbapuwYWRPWeyuWrXW/RT9u/2PYnGlnSFYfGfyRgw9kelbuR1T39JopA8dCsgO9+j
         uh3A==
X-Gm-Message-State: AOAM5300SqamXraCTorkqfR8cT1Bky3uzCgD5hVgC7LkK8GjzpcQFvRi
        aOKBH/wHdnXi1wdtMgnA6564KRhkJX3zOg==
X-Google-Smtp-Source: ABdhPJzyYNhwu8xstNuEkNMl45gwmrENShy1czSS1j1NmthJoo05l66107FZ5MPIvwfc4RnA9vXMeA==
X-Received: by 2002:a05:6638:1408:: with SMTP id k8mr7045204jad.301.1639585814032;
        Wed, 15 Dec 2021 08:30:14 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id d12sm1338528ilg.85.2021.12.15.08.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 08:30:13 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] block: enable bio allocation cache for IRQ driven IO
Date:   Wed, 15 Dec 2021 09:30:09 -0700
Message-Id: <20211215163009.15269-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215163009.15269-1-axboe@kernel.dk>
References: <20211215163009.15269-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We currently cannot use the bio recycling allocation cache for IRQ driven
IO, as the cache isn't IRQ safe (by design).

Add a way for the completion side to pass back a bio that needs freeing,
so we can do it from the io_uring side. io_uring completions always
run in task context.

This is good for about a 13% improvement in IRQ driven IO, taking us from
around 6.3M/core to 7.1M/core IOPS.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/fops.c       | 11 ++++++++---
 fs/io_uring.c      |  6 ++++++
 include/linux/fs.h |  4 ++++
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index bcf866b07edc..c7794d42be85 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -296,14 +296,19 @@ static void blkdev_bio_end_io_async(struct bio *bio)
 		ret = blk_status_to_errno(bio->bi_status);
 	}
 
-	iocb->ki_complete(iocb, ret);
-
 	if (dio->flags & DIO_SHOULD_DIRTY) {
 		bio_check_pages_dirty(bio);
 	} else {
 		bio_release_pages(bio, false);
-		bio_put(bio);
+		if (iocb->ki_flags & IOCB_BIO_PASSBACK) {
+			iocb->ki_flags |= IOCB_PRIV_IS_BIO;
+			iocb->private = bio;
+		} else {
+			bio_put(bio);
+		}
 	}
+
+	iocb->ki_complete(iocb, ret);
 }
 
 static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1a647a6a5add..b0302c0407e6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2828,6 +2828,11 @@ static void io_req_task_complete(struct io_kiocb *req, bool *locked)
 	unsigned int cflags = io_put_kbuf(req);
 	int res = req->result;
 
+#ifdef CONFIG_BLOCK
+	if (req->rw.kiocb.ki_flags & IOCB_PRIV_IS_BIO)
+		bio_put(req->rw.kiocb.private);
+#endif
+
 	if (*locked) {
 		io_req_complete_state(req, res, cflags);
 		io_req_add_compl_list(req);
@@ -3024,6 +3029,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	} else {
 		if (kiocb->ki_flags & IOCB_HIPRI)
 			return -EINVAL;
+		kiocb->ki_flags |= IOCB_ALLOC_CACHE | IOCB_BIO_PASSBACK;
 		kiocb->ki_complete = io_complete_rw;
 	}
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6b8dc1a78df6..bf7a76dfdc29 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -322,6 +322,10 @@ enum rw_hint {
 #define IOCB_NOIO		(1 << 20)
 /* can use bio alloc cache */
 #define IOCB_ALLOC_CACHE	(1 << 21)
+/* iocb supports bio passback */
+#define IOCB_BIO_PASSBACK	(1 << 22)
+/* iocb->private holds bio to put */
+#define IOCB_PRIV_IS_BIO	(1 << 23)
 
 struct kiocb {
 	struct file		*ki_filp;
-- 
2.34.1

