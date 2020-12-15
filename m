Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440E42DA4D2
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 01:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbgLOA1w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 19:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728450AbgLOAZI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 19:25:08 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B547C06138C;
        Mon, 14 Dec 2020 16:24:10 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id k10so15342145wmi.3;
        Mon, 14 Dec 2020 16:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v0AauUnwA0hTGdBXNj6ZzKlUOrb4jF47iEjWqFK5L8s=;
        b=DmTQasMwcOvVC2HGyReHTCHsrRm49zPi6M3MRtAMOhqhX/MN7tDKz9tL+2pg6+QqYB
         CXap+KpU5xs24Y+WYCf1WmIMcbkqlrNyus789gDHv7ZcPFhHbkPbeOMS/zQtebq3NWL0
         g6sKVXm18j9BbKfBTXinHBaJ1rkacOcYlffL1aBWZLdVYiAedGshDJV8apYteChI1dp3
         kwkWBENwuxx4wSeb6aRKG2sPyMMMglhBwVrK8hYRjGz+bUIbsu2XwQ7RGM4HF38LI006
         yaGms8xc0u3XMms3xpgR52HhDX5ov0KL7K0BuvZS+UZXQZh49414R/7FwDK2hlXJMadg
         TuBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v0AauUnwA0hTGdBXNj6ZzKlUOrb4jF47iEjWqFK5L8s=;
        b=QyfMUBFuUm3Mfyzzb9fuP3ipEImcyr8tKELyi/+ZUCAPLuav8EL3G3tOKM6We2PZrY
         CDBzdgYzC9ahxAT08eTJvoIiwsvaUkBL+9cpE3J6H0OTXb9bK4d7ZC6UydHWeIH07MYH
         ieIy06LpjjGkc+9Uz5RsRbeoMUOIZwE4NXk87W6ONhfdcd2LyI5YyYzetneG8P59lxEF
         M/gHmyvOaKoo5Q6am/x0QUD6CSzlkusH1mIGRh/N4lGilN07WdrWGtMcSl0mV9jvdksi
         YfBU+SPPtRC+empqUcE2SSmUiFYFQCsuvcnoMihSj7tXGrC593wuEk0JOdJM9tjufmog
         vY7A==
X-Gm-Message-State: AOAM532MMyZUprFztZ57rCLu6/Q7N6PwiBCyihtG8e/hb0mRPbzNL51n
        zTDXQVeQXJgEW2pqcu7AGBXRcE4THF/DkzlL
X-Google-Smtp-Source: ABdhPJxINkanVy2QGQhY1u+YaY38qOJLZ6n+hZXE+kGwMf8ljRg3x4j8lZkvZFRa2g0tfnchLTq01Q==
X-Received: by 2002:a1c:64c4:: with SMTP id y187mr25944685wmb.165.1607991848997;
        Mon, 14 Dec 2020 16:24:08 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.163])
        by smtp.gmail.com with ESMTPSA id b19sm5362012wmj.37.2020.12.14.16.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 16:24:08 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     linux-block@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v1 5/6] bio: add a helper calculating nr segments to alloc
Date:   Tue, 15 Dec 2020 00:20:24 +0000
Message-Id: <94b6f76d2d47569742ee47caede1504926f9807a.1607976425.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1607976425.git.asml.silence@gmail.com>
References: <cover.1607976425.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A preparation patch. It adds a simple helper which abstracts out number
of segments we're allocating for a bio from iov_iter_npages().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/block_dev.c       | 7 ++++---
 fs/iomap/direct-io.c | 9 ++++-----
 include/linux/bio.h  | 6 ++++++
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 9e56ee1f2652..1cbbc794edc6 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -417,7 +417,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 		dio->size += bio->bi_iter.bi_size;
 		pos += bio->bi_iter.bi_size;
 
-		nr_pages = iov_iter_npages(iter, BIO_MAX_PAGES);
+		nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_PAGES);
 		if (!nr_pages) {
 			bool polled = false;
 
@@ -482,9 +482,10 @@ blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	int nr_pages;
 
-	nr_pages = iov_iter_npages(iter, BIO_MAX_PAGES + 1);
-	if (!nr_pages)
+	if (!iov_iter_count(iter))
 		return 0;
+
+	nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_PAGES + 1);
 	if (is_sync_kiocb(iocb) && nr_pages <= BIO_MAX_PAGES)
 		return __blkdev_direct_IO_simple(iocb, iter, nr_pages);
 
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 933f234d5bec..ea1e8f696076 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -250,11 +250,8 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 	orig_count = iov_iter_count(dio->submit.iter);
 	iov_iter_truncate(dio->submit.iter, length);
 
-	nr_pages = iov_iter_npages(dio->submit.iter, BIO_MAX_PAGES);
-	if (nr_pages <= 0) {
-		ret = nr_pages;
+	if (!iov_iter_count(dio->submit.iter))
 		goto out;
-	}
 
 	if (need_zeroout) {
 		/* zero out from the start of the block to the write offset */
@@ -263,6 +260,7 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 			iomap_dio_zero(dio, iomap, pos - pad, pad);
 	}
 
+	nr_pages = bio_iov_vecs_to_alloc(dio->submit.iter, BIO_MAX_PAGES);
 	do {
 		size_t n;
 		if (dio->error) {
@@ -308,7 +306,8 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 		dio->size += n;
 		copied += n;
 
-		nr_pages = iov_iter_npages(dio->submit.iter, BIO_MAX_PAGES);
+		nr_pages = bio_iov_vecs_to_alloc(dio->submit.iter,
+						 BIO_MAX_PAGES);
 		iomap_dio_submit_bio(dio, iomap, bio, pos);
 		pos += n;
 	} while (nr_pages);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 1edda614f7ce..2a9f3f0bbe0a 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -10,6 +10,7 @@
 #include <linux/ioprio.h>
 /* struct bio, bio_vec and BIO_* flags are defined in blk_types.h */
 #include <linux/blk_types.h>
+#include <linux/uio.h>
 
 #define BIO_DEBUG
 
@@ -441,6 +442,11 @@ static inline void bio_wouldblock_error(struct bio *bio)
 	bio_endio(bio);
 }
 
+static inline int bio_iov_vecs_to_alloc(struct iov_iter *iter, int max_segs)
+{
+	return iov_iter_npages(iter, max_segs);
+}
+
 struct request_queue;
 
 extern int submit_bio_wait(struct bio *bio);
-- 
2.24.0

