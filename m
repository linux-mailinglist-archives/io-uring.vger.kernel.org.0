Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7F33EA7D3
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 17:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238266AbhHLPmX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 11:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238257AbhHLPmX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 11:42:23 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC77C0613D9
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 08:41:57 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id bj40so10996178oib.6
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 08:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KGh3DHNk1Pecrp3DYsOdrKTAPnauoq0TCqYdAequptQ=;
        b=DoiXWpYd2RHBJtHUgUh4Sg78Sfmx9ShUnUChmtkfLaqByRc92ip3oxNL7yYQexaD/C
         JD4pI0eg2qtQ7FKB9ZwvqN7KtRjvhEB9cOONFqlamaahBTI8tpXX7x+lVm9zJk8A2jqh
         349Qb3zWWDWc7QG3Li16aSaaNFnNU7T1EQQwyFsJDPqsloZOG4x/3pLzEVNGHf8jC5NN
         B3P2VIfL0MaB1StYr/72pS3HUHoTg78KkAh1blNi0uyYWp1qHJPLVTB9daT/ejJvD9nI
         ETNjPm/CtGeBH/CN8To+Mxo6zIF3cFO9XWv4huH0PzMN0wgg1hv8lZc+wJIWTgCifjgj
         aSoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KGh3DHNk1Pecrp3DYsOdrKTAPnauoq0TCqYdAequptQ=;
        b=pZMS8VnxFIItfCPBVZ4NA7U/ySMf3CzGnTCZt+0exdMiApGHnbotYNs1b5pAr9rLrR
         4xzE+tqaWGJMGgzguqcNPtHgukkOrw1jfk9klDZeXK3LM9Ca4Nhj95+o/AoLLaaLc1Vf
         erkuETMgBFQ0Cl6RQY+FNPo453tbmLxIJUUhVcs9QzEAa4wMvfcTLphulKHpLjEZLWpI
         Oq+8NNimnyzJu22SqmW3onaf2WtoC4CyN3VZyK5KxfbtxgtZu601eVQF3/q1WnMoGJxf
         DcQ/UJ84oqorBtUCoSYJ/lziQTiBQoGckxRgGhlB07CHZHqW/JxQAawnXGVbAEhBHXmy
         dBdg==
X-Gm-Message-State: AOAM533ILYvHiLcfuk7uyXeDHT1vkCRlcpc7Q7bwFJThLvIBnB64Phyr
        y6At3rt0NKVTGaq7enmkUbnD1UoD4N+YoZel
X-Google-Smtp-Source: ABdhPJx9b5fJYV9wguO/TCBrHRqtklbv/5xdkxNojagYy4U/38VaU5evI1UFOdIYrEs7Mxo2EDhWnw==
X-Received: by 2002:aca:230e:: with SMTP id e14mr3673238oie.93.1628782917172;
        Thu, 12 Aug 2021 08:41:57 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w16sm690973oih.19.2021.08.12.08.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 08:41:56 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/6] block: use the percpu bio cache in __blkdev_direct_IO
Date:   Thu, 12 Aug 2021 09:41:49 -0600
Message-Id: <20210812154149.1061502-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210812154149.1061502-1-axboe@kernel.dk>
References: <20210812154149.1061502-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Use bio_alloc_kiocb to dip into the percpu cache of bios when the
caller asks for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/block_dev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 9ef4f1fc2cb0..3c7fb7106713 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -385,7 +385,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	    (bdev_logical_block_size(bdev) - 1))
 		return -EINVAL;
 
-	bio = bio_alloc_bioset(GFP_KERNEL, nr_pages, &blkdev_dio_pool);
+	bio = bio_alloc_kiocb(iocb, nr_pages, &blkdev_dio_pool);
 
 	dio = container_of(bio, struct blkdev_dio, bio);
 	dio->is_sync = is_sync = is_sync_kiocb(iocb);
@@ -513,7 +513,9 @@ blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 
 static __init int blkdev_init(void)
 {
-	return bioset_init(&blkdev_dio_pool, 4, offsetof(struct blkdev_dio, bio), BIOSET_NEED_BVECS);
+	return bioset_init(&blkdev_dio_pool, 4,
+				offsetof(struct blkdev_dio, bio),
+				BIOSET_NEED_BVECS|BIOSET_PERCPU_CACHE);
 }
 module_init(blkdev_init);
 
-- 
2.32.0

