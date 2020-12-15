Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0AD2DA4BB
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 01:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgLOAY5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 19:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727535AbgLOAYs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 19:24:48 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F1DC0617A7;
        Mon, 14 Dec 2020 16:24:08 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id a12so18140478wrv.8;
        Mon, 14 Dec 2020 16:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jQVTvgGa1LjUWqvTxBIf73PGX5t0yWv/7jb/FOyHpnQ=;
        b=MNxOq+/uE7DIwyNRUYewGw+cHYV3pClHNKkFNyBIVdI3EmUW/iPsPfP7yyzvq8u6HW
         y+G5urnHOa4dHakH8fNwlven+K4tiRfbWXhhmxGgEeMzIgON/V/3KPvIIE1STFr4wlIj
         SgeoTLBn1XPnx5Gw54WO9Ail0Pbu+qn1ntWpDgf7sX2nl46zzOUPoASz3AKqbQTRe5C8
         qjhO3fZhfFlR+QPZhkUFrJzZojsifXm8XUJO1MGsQth6ATu4tYHY/Ma1viQrwsp2EP4o
         7pb0PcP510viQINAxb0x6SwFrTsMMbzg0xzT5YV55QJkl2tVrPkM8FYFuof/4cC/EixF
         gDtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jQVTvgGa1LjUWqvTxBIf73PGX5t0yWv/7jb/FOyHpnQ=;
        b=J7JY5rXW+LgkCyM9vmy8ceYE1Ie5zjb1QzLInwkdkQ+4mDT1CaZvWxLwroq6RuI+a4
         0fKrMddE6xUScoIbOKsAi/tPVR9D+R5n9gRNSavJCKmr0pXJ6Ui1d1Zx3bn5PEd0zx7A
         BVlcoB7J/vPV9VJaDBK4rB6hbY3++rFzlD3iXlBekc/LZBMMd8YrAAJSFf6KDxF83L7w
         VEFOzsOS6QhT2/VJCtRXU/YZH78GPViVz+axdSWlYey6S2hsZfHIsDb+Iogeuo1dwpKI
         ddzzZ8tlQXp4O9j3eFJlG0WXyiit/4PHCYGmVjpzHBJuazbvVuOVcKaliluycZTkCLkZ
         sv5A==
X-Gm-Message-State: AOAM5315zvBDRXh8mizkM+XJoT+Go0B8je2Qh7SnW8L9wzO1FOgzGUR1
        eP08cRZFgrI2xnY1e7gA+7jghzjQQ6OB0/ZV
X-Google-Smtp-Source: ABdhPJzkeBXbuB0e70wPSfv0YNEY+IY3u+FsW+X1sRWABcHyKLngnn7Dx2/0Lsq9Kl4ceWUMiJY3iQ==
X-Received: by 2002:adf:f590:: with SMTP id f16mr194470wro.40.1607991846606;
        Mon, 14 Dec 2020 16:24:06 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.163])
        by smtp.gmail.com with ESMTPSA id b19sm5362012wmj.37.2020.12.14.16.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 16:24:06 -0800 (PST)
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
Subject: [PATCH v1 3/6] bio: deduplicate adding a page into bio
Date:   Tue, 15 Dec 2020 00:20:22 +0000
Message-Id: <189cae47946fa49318f85678def738d358e8298b.1607976425.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1607976425.git.asml.silence@gmail.com>
References: <cover.1607976425.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Both bio_add_hw_page() mimics bio_add_page() and has a hand-coded
version of appending a page into bio's bvec. DRY

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/bio.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 1f2cc1fbe283..4a8f77bb3956 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -734,6 +734,22 @@ const char *bio_devname(struct bio *bio, char *buf)
 }
 EXPORT_SYMBOL(bio_devname);
 
+static void bio_add_page_noaccount(struct bio *bio, struct page *page,
+				   unsigned int len, unsigned int off)
+{
+	struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt];
+
+	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
+	WARN_ON_ONCE(bio_full(bio, len));
+
+	bv->bv_page = page;
+	bv->bv_offset = off;
+	bv->bv_len = len;
+
+	bio->bi_iter.bi_size += len;
+	bio->bi_vcnt++;
+}
+
 static inline bool page_is_mergeable(const struct bio_vec *bv,
 		struct page *page, unsigned int len, unsigned int off,
 		bool *same_page)
@@ -818,12 +834,7 @@ int bio_add_hw_page(struct request_queue *q, struct bio *bio,
 	if (bio->bi_vcnt >= queue_max_segments(q))
 		return 0;
 
-	bvec = &bio->bi_io_vec[bio->bi_vcnt];
-	bvec->bv_page = page;
-	bvec->bv_len = len;
-	bvec->bv_offset = offset;
-	bio->bi_vcnt++;
-	bio->bi_iter.bi_size += len;
+	bio_add_page_noaccount(bio, page, len, offset);
 	return len;
 }
 
@@ -903,18 +914,7 @@ EXPORT_SYMBOL_GPL(__bio_try_merge_page);
 void __bio_add_page(struct bio *bio, struct page *page,
 		unsigned int len, unsigned int off)
 {
-	struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt];
-
-	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
-	WARN_ON_ONCE(bio_full(bio, len));
-
-	bv->bv_page = page;
-	bv->bv_offset = off;
-	bv->bv_len = len;
-
-	bio->bi_iter.bi_size += len;
-	bio->bi_vcnt++;
-
+	bio_add_page_noaccount(bio, page, len, off);
 	if (!bio_flagged(bio, BIO_WORKINGSET) && unlikely(PageWorkingset(page)))
 		bio_set_flag(bio, BIO_WORKINGSET);
 }
-- 
2.24.0

