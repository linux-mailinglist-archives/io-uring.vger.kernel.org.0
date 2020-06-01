Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC011EA582
	for <lists+io-uring@lfdr.de>; Mon,  1 Jun 2020 16:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgFAOEp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Jun 2020 10:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgFAOEo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Jun 2020 10:04:44 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32C1C03E96F
        for <io-uring@vger.kernel.org>; Mon,  1 Jun 2020 07:04:42 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id q16so4320064plr.2
        for <io-uring@vger.kernel.org>; Mon, 01 Jun 2020 07:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=fc1S5/Galwcq4iWKCaHRcXhonFnrBoSFl1V2Dellax8=;
        b=fIa5+IMzTTTK9lRMy6byh/1Rq4LrJDHiECg3xfWur221k6nF+6fsMH+7/gcL/WFYC5
         JD9U0m4CEDXomcq85MhI+wPrvv3xNo6ks7jq6qbHWH8EVcuRJHAkG9mDmpjTWhnTzqXq
         F87OGjuLLAdIdNkShAsBuSfc56YaonA9dhfyopBKCWWCkoCHX9jBwqp0gp6zfie299GI
         nUl+QVyU9bO3I/DE4zyp+Jba4QkmFx6oh1oSc9pXiEnL+mPgb8ghi/XBUc1XxNBRbdP4
         AEWRaEQ7jQ6dfaupEjlzmVRAme/wrJ9pSZ4TMjB2rRUUaBVX1WojAS91x1xWN8NuF/a+
         6o3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=fc1S5/Galwcq4iWKCaHRcXhonFnrBoSFl1V2Dellax8=;
        b=krHlGw5mhTWgCn3fvcpObCyB9E+sP4BRdbhW12MqBWEAGUj8IF0u6PNKZlB/myGerG
         JinZ9/fL0LdNS17Cj4Bve0hD9US99o3OGoZRGhVIce2imeeNQF578n6VIXxg4u+qkHoB
         taYHJw0dCnPydqcD/SvbXSR89JA0z1k1okLJeelscS8dC+8hzGysInwSRMhG2pXIuoVf
         7iVK5yobGuZ8ukhdwmjT2cocpQj5EKUFTGlGXC5g1slLsDJSEaQwH4NuNJiL7k41LjwN
         79YJ4mquFj0p7mWoTq42yTfNF6MSw0UTMph3LYxWhQ9VlDmNXRWrkrr2EhCQrb8fI6sf
         ke+w==
X-Gm-Message-State: AOAM532dGbpkM6d4opp4MDNDpG0PRptmJP3EUevDhhiYTM8M7ovpYhFZ
        ySuNDsJGGXrOwBzC3tpYyfM7CQ==
X-Google-Smtp-Source: ABdhPJzCBGCiR/gygXpIFmAqH2/kG/X9C/6vSSm+pBLpHPsrs85BmyXncXjXjXqYavDcMY0W7iqG2Q==
X-Received: by 2002:a17:90b:245:: with SMTP id fz5mr10926407pjb.138.1591020281875;
        Mon, 01 Jun 2020 07:04:41 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u1sm14343697pfu.151.2020.06.01.07.04.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 07:04:40 -0700 (PDT)
Subject: Re: [PATCHSET v5 0/12] Add support for async buffered reads
To:     sedat.dilek@gmail.com
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
References: <20200526195123.29053-1-axboe@kernel.dk>
 <CA+icZUWfX+QmroE6j74C7o-BdfMF5=6PdYrA=5W_JCKddqkJgQ@mail.gmail.com>
 <bab2d6f8-4c65-be21-6a8e-29b76c06807d@kernel.dk>
 <CA+icZUUgazqLRwnbQgFPhCa5vAsAvJhjCGMYs7KYBZgA04mSyw@mail.gmail.com>
 <CA+icZUUwz5TPpT_zS=P4MZBDzzrAcFvZMUce8mJu8M1C7KNO5A@mail.gmail.com>
 <CA+icZUVJT8X3zyafrgbkJppsp4nJEKaLjYNs1kX8H+aY1Y10Qw@mail.gmail.com>
 <CA+icZUWHOYcGUpw4gfT7xP2Twr15YbyXiWA_=Mc+f7NgzZCETw@mail.gmail.com>
 <230d3380-0269-d113-2c32-6e4fb94b79b8@kernel.dk>
 <CA+icZUXxmOA-5+dukCgxfSp4eVHB+QaAHO6tsgq0iioQs3Af-w@mail.gmail.com>
 <CA+icZUV4iSjL8=wLA3qd1c5OQHX2s1M5VKj2CmJoy2rHmzSVbQ@mail.gmail.com>
 <CA+icZUXkWG=08rz9Lp1-ZaRCs+GMTwEiUaFLze9xpL2SpZbdsQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cdb3ac15-0c41-6147-35f1-41b2a3be1c33@kernel.dk>
Date:   Mon, 1 Jun 2020 08:04:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CA+icZUXkWG=08rz9Lp1-ZaRCs+GMTwEiUaFLze9xpL2SpZbdsQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------3ADB41F72EDDDE21CDE7CE18"
Content-Language: en-US
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------3ADB41F72EDDDE21CDE7CE18
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 6/1/20 7:35 AM, Sedat Dilek wrote:
> Hi Jens,
> 
> with Linux v5.7 final I switched to linux-block.git/for-next and reverted...
> 
> "block: read-ahead submission should imply no-wait as well"
> 
> ...and see no boot-slowdowns.

Can you try with these patches applied instead? Or pull my async-readahead
branch from the same location.

-- 
Jens Axboe


--------------3ADB41F72EDDDE21CDE7CE18
Content-Type: text/x-patch; charset=UTF-8;
 name="0006-Revert-block-read-ahead-submission-should-imply-no-w.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0006-Revert-block-read-ahead-submission-should-imply-no-w.pa";
 filename*1="tch"

From 297f4d794780f7f55180fb0de6692bd1a1d81c58 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sun, 31 May 2020 21:31:08 -0600
Subject: [PATCH 6/6] Revert "block: read-ahead submission should imply no-wait
 as well"

This reverts commit 381000ebbf4fed96c206571a04511c0667e38e18.
---
 include/linux/blk_types.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index c296463c15eb..ccb895f911b1 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -374,8 +374,7 @@ enum req_flag_bits {
 #define REQ_INTEGRITY		(1ULL << __REQ_INTEGRITY)
 #define REQ_FUA			(1ULL << __REQ_FUA)
 #define REQ_PREFLUSH		(1ULL << __REQ_PREFLUSH)
-#define REQ_RAHEAD		\
-	((1ULL << __REQ_RAHEAD) | (1ULL << __REQ_NOWAIT))
+#define REQ_RAHEAD		(1ULL << __REQ_RAHEAD)
 #define REQ_BACKGROUND		(1ULL << __REQ_BACKGROUND)
 #define REQ_NOWAIT		(1ULL << __REQ_NOWAIT)
 #define REQ_CGROUP_PUNT		(1ULL << __REQ_CGROUP_PUNT)
-- 
2.26.2


--------------3ADB41F72EDDDE21CDE7CE18
Content-Type: text/x-patch; charset=UTF-8;
 name="0005-fs-make-mpage_readpages-take-a-struct-kiocb-argument.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0005-fs-make-mpage_readpages-take-a-struct-kiocb-argument.pa";
 filename*1="tch"

From ffbf3c623a4835c388296d52d82ee7abe75535cf Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sun, 31 May 2020 20:53:26 -0600
Subject: [PATCH 5/6] fs: make mpage_readpages() take a struct kiocb argument

The callers already have it, so just pass it in. Have mpage_readpages()
set REQ_NOWAIT, if IOCB_NOWAIT is set in the iocb.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/block_dev.c        |  2 +-
 fs/exfat/inode.c      |  2 +-
 fs/ext2/inode.c       |  2 +-
 fs/fat/inode.c        |  2 +-
 fs/gfs2/aops.c        |  2 +-
 fs/hpfs/file.c        |  2 +-
 fs/isofs/inode.c      |  2 +-
 fs/jfs/inode.c        |  2 +-
 fs/mpage.c            | 17 +++++++++++++----
 fs/nilfs2/inode.c     |  2 +-
 fs/ocfs2/aops.c       |  2 +-
 fs/omfs/file.c        |  2 +-
 fs/qnx6/inode.c       |  2 +-
 fs/reiserfs/inode.c   |  2 +-
 fs/udf/inode.c        |  2 +-
 include/linux/mpage.h |  5 +++--
 16 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 87a540b42fa7..bbc1bd8078d6 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -617,7 +617,7 @@ static int blkdev_readpage(struct file * file, struct page * page)
 static int blkdev_readpages(struct kiocb *kiocb, struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages)
 {
-	return mpage_readpages(mapping, pages, nr_pages, blkdev_get_block);
+	return mpage_readpages(mapping, kiocb, pages, nr_pages, blkdev_get_block);
 }
 
 static int blkdev_write_begin(struct file *file, struct address_space *mapping,
diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
index 9905307dfba2..a7757edf5534 100644
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -375,7 +375,7 @@ static int exfat_readpage(struct file *file, struct page *page)
 static int exfat_readpages(struct kiocb *kiocb, struct address_space *mapping,
 		struct list_head *pages, unsigned int nr_pages)
 {
-	return mpage_readpages(mapping, pages, nr_pages, exfat_get_block);
+	return mpage_readpages(mapping, kiocb, pages, nr_pages, exfat_get_block);
 }
 
 static int exfat_writepage(struct page *page, struct writeback_control *wbc)
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 3843900d6251..706fc2628a3a 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -881,7 +881,7 @@ static int
 ext2_readpages(struct kiocb *kiocb, struct address_space *mapping,
 		struct list_head *pages, unsigned nr_pages)
 {
-	return mpage_readpages(mapping, pages, nr_pages, ext2_get_block);
+	return mpage_readpages(mapping, kiocb, pages, nr_pages, ext2_get_block);
 }
 
 static int
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index ab9dfcbf1bd3..3c47485d7f83 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -213,7 +213,7 @@ static int fat_readpage(struct file *file, struct page *page)
 static int fat_readpages(struct kiocb *kiocb, struct address_space *mapping,
 			 struct list_head *pages, unsigned nr_pages)
 {
-	return mpage_readpages(mapping, pages, nr_pages, fat_get_block);
+	return mpage_readpages(mapping, kiocb, pages, nr_pages, fat_get_block);
 }
 
 static void fat_write_failed(struct address_space *mapping, loff_t to)
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 37d18f82e5a1..3e26ca463ca3 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -608,7 +608,7 @@ static int gfs2_readpages(struct kiocb *kiocb, struct address_space *mapping,
 	if (unlikely(ret))
 		goto out_uninit;
 	if (!gfs2_is_stuffed(ip))
-		ret = mpage_readpages(mapping, pages, nr_pages, gfs2_block_map);
+		ret = mpage_readpages(mapping, kiocb, pages, nr_pages, gfs2_block_map);
 	gfs2_glock_dq(&gh);
 out_uninit:
 	gfs2_holder_uninit(&gh);
diff --git a/fs/hpfs/file.c b/fs/hpfs/file.c
index 5b9c537d011c..21df02964219 100644
--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -128,7 +128,7 @@ static int hpfs_writepage(struct page *page, struct writeback_control *wbc)
 static int hpfs_readpages(struct kiocb *kiocb, struct address_space *mapping,
 			  struct list_head *pages, unsigned nr_pages)
 {
-	return mpage_readpages(mapping, pages, nr_pages, hpfs_get_block);
+	return mpage_readpages(mapping, kiocb, pages, nr_pages, hpfs_get_block);
 }
 
 static int hpfs_writepages(struct address_space *mapping,
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 071da59b7266..060e8dfbe1a2 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -1186,7 +1186,7 @@ static int isofs_readpage(struct file *file, struct page *page)
 static int isofs_readpages(struct kiocb *kiocb, struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages)
 {
-	return mpage_readpages(mapping, pages, nr_pages, isofs_get_block);
+	return mpage_readpages(mapping, kiocb, pages, nr_pages, isofs_get_block);
 }
 
 static sector_t _isofs_bmap(struct address_space *mapping, sector_t block)
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 503e2e5cb79d..569e4f4123dd 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -299,7 +299,7 @@ static int jfs_readpage(struct file *file, struct page *page)
 static int jfs_readpages(struct kiocb *kiocb, struct address_space *mapping,
 		struct list_head *pages, unsigned nr_pages)
 {
-	return mpage_readpages(mapping, pages, nr_pages, jfs_get_block);
+	return mpage_readpages(mapping, kiocb, pages, nr_pages, jfs_get_block);
 }
 
 static void jfs_write_failed(struct address_space *mapping, loff_t to)
diff --git a/fs/mpage.c b/fs/mpage.c
index ccba3c4c4479..9148d1eae8ff 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -138,6 +138,7 @@ struct mpage_readpage_args {
 	struct page *page;
 	unsigned int nr_pages;
 	bool is_readahead;
+	bool nowait;
 	sector_t last_block_in_bio;
 	struct buffer_head map_bh;
 	unsigned long first_logical_block;
@@ -182,6 +183,8 @@ static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
 		op_flags = 0;
 		gfp = mapping_gfp_constraint(page->mapping, GFP_KERNEL);
 	}
+	if (args->nowait)
+		op_flags |= REQ_NOWAIT;
 
 	if (page_has_buffers(page))
 		goto confused;
@@ -382,12 +385,14 @@ static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
  * This all causes the disk requests to be issued in the correct order.
  */
 int
-mpage_readpages(struct address_space *mapping, struct list_head *pages,
-				unsigned nr_pages, get_block_t get_block)
+mpage_readpages(struct address_space *mapping, struct kiocb *kiocb,
+		struct list_head *pages, unsigned nr_pages,
+		get_block_t get_block)
 {
 	struct mpage_readpage_args args = {
 		.get_block = get_block,
 		.is_readahead = true,
+		.nowait = kiocb->ki_flags & IOCB_NOWAIT,
 	};
 	unsigned page_idx;
 
@@ -406,8 +411,12 @@ mpage_readpages(struct address_space *mapping, struct list_head *pages,
 		put_page(page);
 	}
 	BUG_ON(!list_empty(pages));
-	if (args.bio)
-		mpage_bio_submit(REQ_OP_READ, REQ_RAHEAD, args.bio);
+	if (args.bio) {
+		int op = REQ_RAHEAD;
+		if (args.nowait)
+			op |= REQ_NOWAIT;
+		mpage_bio_submit(REQ_OP_READ, op, args.bio);
+	}
 	return 0;
 }
 EXPORT_SYMBOL(mpage_readpages);
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index a981c9404fbc..3cbc8b7284a4 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -156,7 +156,7 @@ static int nilfs_readpage(struct file *file, struct page *page)
 static int nilfs_readpages(struct kiocb *kiocb, struct address_space *mapping,
 			   struct list_head *pages, unsigned int nr_pages)
 {
-	return mpage_readpages(mapping, pages, nr_pages, nilfs_get_block);
+	return mpage_readpages(mapping, kiocb, pages, nr_pages, nilfs_get_block);
 }
 
 static int nilfs_writepages(struct address_space *mapping,
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index aa54b0d0d4a1..50ed84f53b20 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -388,7 +388,7 @@ static int ocfs2_readpages(struct kiocb *kiocb, struct address_space *mapping,
 	if (start >= i_size_read(inode))
 		goto out_unlock;
 
-	err = mpage_readpages(mapping, pages, nr_pages, ocfs2_get_block);
+	err = mpage_readpages(mapping, kiocb, pages, nr_pages, ocfs2_get_block);
 
 out_unlock:
 	up_read(&oi->ip_alloc_sem);
diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index 195bb390ba24..384e8c99fc4f 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -292,7 +292,7 @@ static int omfs_readpage(struct file *file, struct page *page)
 static int omfs_readpages(struct kiocb *kiocb, struct address_space *mapping,
 		struct list_head *pages, unsigned nr_pages)
 {
-	return mpage_readpages(mapping, pages, nr_pages, omfs_get_block);
+	return mpage_readpages(mapping, kiocb, pages, nr_pages, omfs_get_block);
 }
 
 static int omfs_writepage(struct page *page, struct writeback_control *wbc)
diff --git a/fs/qnx6/inode.c b/fs/qnx6/inode.c
index c964fd63d4a5..ef603636ca2d 100644
--- a/fs/qnx6/inode.c
+++ b/fs/qnx6/inode.c
@@ -102,7 +102,7 @@ static int qnx6_readpage(struct file *file, struct page *page)
 static int qnx6_readpages(struct kiocb *kiocb, struct address_space *mapping,
 		   struct list_head *pages, unsigned nr_pages)
 {
-	return mpage_readpages(mapping, pages, nr_pages, qnx6_get_block);
+	return mpage_readpages(mapping, kiocb, pages, nr_pages, qnx6_get_block);
 }
 
 /*
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 01d5ccdaa5b4..50c93c526557 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1164,7 +1164,7 @@ static int
 reiserfs_readpages(struct kiocb *kiocb, struct address_space *mapping,
 		   struct list_head *pages, unsigned nr_pages)
 {
-	return mpage_readpages(mapping, pages, nr_pages, reiserfs_get_block);
+	return mpage_readpages(mapping, kiocb, pages, nr_pages, reiserfs_get_block);
 }
 
 /*
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index c541ca95f851..c45d4da5e707 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -198,7 +198,7 @@ static int udf_readpage(struct file *file, struct page *page)
 static int udf_readpages(struct kiocb *kiocb, struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages)
 {
-	return mpage_readpages(mapping, pages, nr_pages, udf_get_block);
+	return mpage_readpages(mapping, kiocb, pages, nr_pages, udf_get_block);
 }
 
 static int udf_write_begin(struct file *file, struct address_space *mapping,
diff --git a/include/linux/mpage.h b/include/linux/mpage.h
index 001f1fcf9836..f708c7a442ae 100644
--- a/include/linux/mpage.h
+++ b/include/linux/mpage.h
@@ -14,8 +14,9 @@
 
 struct writeback_control;
 
-int mpage_readpages(struct address_space *mapping, struct list_head *pages,
-				unsigned nr_pages, get_block_t get_block);
+int mpage_readpages(struct address_space *mapping, struct kiocb *kiocb,
+			struct list_head *pages, unsigned nr_pages,
+			get_block_t get_block);
 int mpage_readpage(struct page *page, get_block_t get_block);
 int mpage_writepages(struct address_space *mapping,
 		struct writeback_control *wbc, get_block_t get_block);
-- 
2.26.2


--------------3ADB41F72EDDDE21CDE7CE18
Content-Type: text/x-patch; charset=UTF-8;
 name="0004-iomap-set-REQ_NOWAIT-on-bio-if-IOCB_NOWAIT-is-set-in.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0004-iomap-set-REQ_NOWAIT-on-bio-if-IOCB_NOWAIT-is-set-in.pa";
 filename*1="tch"

From d17311d78f5d5ffa73cbdd5cbf925d0a4188807d Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sun, 31 May 2020 20:44:18 -0600
Subject: [PATCH 4/6] iomap: set REQ_NOWAIT on bio if IOCB_NOWAIT is set in
 kiocb

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/buffered-io.c | 9 +++++++--
 fs/xfs/xfs_aops.c      | 3 ++-
 fs/zonefs/super.c      | 5 +++--
 include/linux/iomap.h  | 5 +++--
 4 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 89e21961d1ad..4558b455182f 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -215,6 +215,7 @@ struct iomap_readpage_ctx {
 	struct page		*cur_page;
 	bool			cur_page_in_bio;
 	bool			is_readahead;
+	bool			nowait;
 	struct bio		*bio;
 	struct list_head	*pages;
 };
@@ -321,6 +322,8 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		ctx->bio->bi_opf = REQ_OP_READ;
 		if (ctx->is_readahead)
 			ctx->bio->bi_opf |= REQ_RAHEAD;
+		if (ctx->nowait)
+			ctx->bio->bi_opf |= REQ_NOWAIT;
 		ctx->bio->bi_iter.bi_sector = sector;
 		bio_set_dev(ctx->bio, iomap->bdev);
 		ctx->bio->bi_end_io = iomap_read_end_io;
@@ -432,12 +435,14 @@ iomap_readpages_actor(struct inode *inode, loff_t pos, loff_t length,
 }
 
 int
-iomap_readpages(struct address_space *mapping, struct list_head *pages,
-		unsigned nr_pages, const struct iomap_ops *ops)
+iomap_readpages(struct address_space *mapping, struct kiocb *kiocb,
+		struct list_head *pages, unsigned nr_pages,
+		const struct iomap_ops *ops)
 {
 	struct iomap_readpage_ctx ctx = {
 		.pages		= pages,
 		.is_readahead	= true,
+		.nowait		= kiocb->ki_flags & IOCB_NOWAIT,
 	};
 	loff_t pos = page_offset(list_entry(pages->prev, struct page, lru));
 	loff_t last = page_offset(list_entry(pages->next, struct page, lru));
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index bff9a2374ece..bc8ea7cd1441 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -628,7 +628,8 @@ xfs_vm_readpages(
 	struct list_head	*pages,
 	unsigned		nr_pages)
 {
-	return iomap_readpages(mapping, pages, nr_pages, &xfs_read_iomap_ops);
+	return iomap_readpages(mapping, kiocb, pages, nr_pages,
+				&xfs_read_iomap_ops);
 }
 
 static int
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 11812841a5fa..06b4f621a14a 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -79,10 +79,11 @@ static int zonefs_readpage(struct file *unused, struct page *page)
 	return iomap_readpage(page, &zonefs_iomap_ops);
 }
 
-static int zonefs_readpages(struct kiocb *unused, struct address_space *mapping,
+static int zonefs_readpages(struct kiocb *kiocb, struct address_space *mapping,
 			    struct list_head *pages, unsigned int nr_pages)
 {
-	return iomap_readpages(mapping, pages, nr_pages, &zonefs_iomap_ops);
+	return iomap_readpages(mapping, kiocb, pages, nr_pages,
+				&zonefs_iomap_ops);
 }
 
 /*
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 8b09463dae0d..6b5d802d7227 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -155,8 +155,9 @@ loff_t iomap_apply(struct inode *inode, loff_t pos, loff_t length,
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 		const struct iomap_ops *ops);
 int iomap_readpage(struct page *page, const struct iomap_ops *ops);
-int iomap_readpages(struct address_space *mapping, struct list_head *pages,
-		unsigned nr_pages, const struct iomap_ops *ops);
+int iomap_readpages(struct address_space *mapping, struct kiocb *kiocb,
+		struct list_head *pages, unsigned nr_pages,
+		const struct iomap_ops *ops);
 int iomap_set_page_dirty(struct page *page);
 int iomap_is_partially_uptodate(struct page *page, unsigned long from,
 		unsigned long count);
-- 
2.26.2


--------------3ADB41F72EDDDE21CDE7CE18
Content-Type: text/x-patch; charset=UTF-8;
 name="0003-mm-make-generic_file_buffered_read-use-iocb-read-ahe.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0003-mm-make-generic_file_buffered_read-use-iocb-read-ahe.pa";
 filename*1="tch"

From 3a7284cf4ef7c762ac21ffb9644c04346f0f4a59 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sun, 31 May 2020 20:26:34 -0600
Subject: [PATCH 3/6] mm: make generic_file_buffered_read() use iocb read-ahead
 helpers

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 mm/filemap.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index abdd3f32c932..eea40b5894fb 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2053,17 +2053,16 @@ static ssize_t generic_file_buffered_read(struct kiocb *iocb,
 
 		page = find_get_page(mapping, index);
 		if (!page) {
-			page_cache_sync_readahead(mapping,
-					ra, filp,
-					index, last_index - index);
+			__page_cache_sync_readahead(mapping, ra, iocb, index,
+							last_index - index);
 			page = find_get_page(mapping, index);
 			if (unlikely(page == NULL))
 				goto no_cached_page;
 		}
 		if (PageReadahead(page)) {
-			page_cache_async_readahead(mapping,
-					ra, filp, page,
-					index, last_index - index);
+			__page_cache_async_readahead(mapping, ra, iocb, page,
+							index,
+							last_index - index);
 		}
 		if (!PageUptodate(page)) {
 			/*
-- 
2.26.2


--------------3ADB41F72EDDDE21CDE7CE18
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-mm-provide-read-ahead-helpers-that-take-a-struct-kio.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-mm-provide-read-ahead-helpers-that-take-a-struct-kio.pa";
 filename*1="tch"

From 72dfe63dd44979d182be741d2446d364546c5df5 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sun, 31 May 2020 20:25:04 -0600
Subject: [PATCH 2/6] mm: provide read-ahead helpers that take a struct kiocb

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 mm/internal.h  | 10 +++++++
 mm/readahead.c | 79 +++++++++++++++++++++++++++++++-------------------
 2 files changed, 59 insertions(+), 30 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 1d051cbadf1a..c486d675af41 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -63,6 +63,16 @@ static inline unsigned long ra_submit(struct file_ra_state *ra,
 					ra->start, ra->size, ra->async_size);
 }
 
+void __page_cache_sync_readahead(struct address_space *mapping,
+				 struct file_ra_state *ra,
+				 struct kiocb *kiocb,  pgoff_t offset,
+				 unsigned long req_size);
+
+void __page_cache_async_readahead(struct address_space *mapping,
+				  struct file_ra_state *ra, struct kiocb *kiocb,
+				  struct page *page, pgoff_t offset,
+				  unsigned long req_size);
+
 /**
  * page_evictable - test whether a page is evictable
  * @page: the page to test
diff --git a/mm/readahead.c b/mm/readahead.c
index 657206f6318d..54a41dae4fea 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -493,6 +493,29 @@ ondemand_readahead(struct address_space *mapping,
 	return ra_submit(ra, mapping, kiocb);
 }
 
+void __page_cache_sync_readahead(struct address_space *mapping,
+				 struct file_ra_state *ra, struct kiocb *kiocb,
+				 pgoff_t offset, unsigned long req_size)
+{
+	struct file *filp = kiocb->ki_filp;
+
+	/* no read-ahead */
+	if (!ra->ra_pages)
+		return;
+
+	if (blk_cgroup_congested())
+		return;
+
+	/* be dumb */
+	if (filp && (filp->f_mode & FMODE_RANDOM)) {
+		force_page_cache_readahead(mapping, kiocb, offset, req_size);
+		return;
+	}
+
+	/* do read-ahead */
+	ondemand_readahead(mapping, ra, kiocb, false, offset, req_size);
+}
+
 /**
  * page_cache_sync_readahead - generic file readahead
  * @mapping: address_space which holds the pagecache and I/O vectors
@@ -513,23 +536,40 @@ void page_cache_sync_readahead(struct address_space *mapping,
 {
 	struct kiocb kiocb = { .ki_filp = filp, };
 
+	__page_cache_sync_readahead(mapping, ra, &kiocb, offset, req_size);
+}
+EXPORT_SYMBOL_GPL(page_cache_sync_readahead);
+
+void
+__page_cache_async_readahead(struct address_space *mapping,
+			     struct file_ra_state *ra, struct kiocb *kiocb,
+			     struct page *page, pgoff_t offset,
+			     unsigned long req_size)
+{
 	/* no read-ahead */
 	if (!ra->ra_pages)
 		return;
 
-	if (blk_cgroup_congested())
+	/*
+	 * Same bit is used for PG_readahead and PG_reclaim.
+	 */
+	if (PageWriteback(page))
 		return;
 
-	/* be dumb */
-	if (filp && (filp->f_mode & FMODE_RANDOM)) {
-		force_page_cache_readahead(mapping, &kiocb, offset, req_size);
+	ClearPageReadahead(page);
+
+	/*
+	 * Defer asynchronous read-ahead on IO congestion.
+	 */
+	if (inode_read_congested(mapping->host))
+		return;
+
+	if (blk_cgroup_congested())
 		return;
-	}
 
 	/* do read-ahead */
-	ondemand_readahead(mapping, ra, &kiocb, false, offset, req_size);
+	ondemand_readahead(mapping, ra, kiocb, true, offset, req_size);
 }
-EXPORT_SYMBOL_GPL(page_cache_sync_readahead);
 
 /**
  * page_cache_async_readahead - file readahead for marked pages
@@ -554,29 +594,8 @@ page_cache_async_readahead(struct address_space *mapping,
 {
 	struct kiocb kiocb = { .ki_filp = filp, };
 
-	/* no read-ahead */
-	if (!ra->ra_pages)
-		return;
-
-	/*
-	 * Same bit is used for PG_readahead and PG_reclaim.
-	 */
-	if (PageWriteback(page))
-		return;
-
-	ClearPageReadahead(page);
-
-	/*
-	 * Defer asynchronous read-ahead on IO congestion.
-	 */
-	if (inode_read_congested(mapping->host))
-		return;
-
-	if (blk_cgroup_congested())
-		return;
-
-	/* do read-ahead */
-	ondemand_readahead(mapping, ra, &kiocb, true, offset, req_size);
+	__page_cache_async_readahead(mapping, ra, &kiocb, page, offset,
+					req_size);
 }
 EXPORT_SYMBOL_GPL(page_cache_async_readahead);
 
-- 
2.26.2


--------------3ADB41F72EDDDE21CDE7CE18
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-fs-make-aops-readpages-take-kiocb-argument.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-fs-make-aops-readpages-take-kiocb-argument.patch"

From 707258c22fea35a5915ff0373231fb07a8a1c9eb Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sun, 31 May 2020 19:35:33 -0600
Subject: [PATCH 1/6] fs: make aops->readpages() take kiocb argument

Instead of passing in a file, pass in the kiocb instead. This still
provides access to the file through kiocb->ki_filp, but also provides
access to more information related to the IO. We'll be using that to
ensure that ->readpages() understands IOCB_NOWAIT.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/9p/vfs_addr.c       |  3 ++-
 fs/afs/file.c          |  8 ++++----
 fs/block_dev.c         |  2 +-
 fs/btrfs/inode.c       |  2 +-
 fs/ceph/addr.c         |  3 ++-
 fs/cifs/file.c         |  3 ++-
 fs/erofs/data.c        |  2 +-
 fs/erofs/zdata.c       |  2 +-
 fs/exfat/inode.c       |  2 +-
 fs/ext2/inode.c        |  2 +-
 fs/ext4/inode.c        |  2 +-
 fs/f2fs/data.c         |  2 +-
 fs/fat/inode.c         |  2 +-
 fs/fuse/file.c         |  6 +++---
 fs/gfs2/aops.c         |  2 +-
 fs/hpfs/file.c         |  2 +-
 fs/isofs/inode.c       |  2 +-
 fs/jfs/inode.c         |  2 +-
 fs/nfs/read.c          |  3 ++-
 fs/nilfs2/inode.c      |  2 +-
 fs/ocfs2/aops.c        |  2 +-
 fs/omfs/file.c         |  2 +-
 fs/qnx6/inode.c        |  2 +-
 fs/reiserfs/inode.c    |  2 +-
 fs/udf/inode.c         |  2 +-
 fs/xfs/xfs_aops.c      |  2 +-
 fs/zonefs/super.c      |  2 +-
 include/linux/fs.h     |  2 +-
 include/linux/mm.h     |  6 +++---
 include/linux/nfs_fs.h |  2 +-
 mm/fadvise.c           |  7 +++++--
 mm/filemap.c           |  3 ++-
 mm/internal.h          |  6 +++---
 mm/readahead.c         | 39 ++++++++++++++++++++++-----------------
 34 files changed, 73 insertions(+), 60 deletions(-)

diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index cce9ace651a2..f2980829bb9f 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -95,9 +95,10 @@ static int v9fs_vfs_readpage(struct file *filp, struct page *page)
  *
  */
 
-static int v9fs_vfs_readpages(struct file *filp, struct address_space *mapping,
+static int v9fs_vfs_readpages(struct kiocb *kiocb, struct address_space *mapping,
 			     struct list_head *pages, unsigned nr_pages)
 {
+	struct file *filp = kiocb->ki_filp;
 	int ret = 0;
 	struct inode *inode;
 
diff --git a/fs/afs/file.c b/fs/afs/file.c
index 8415733f7bc1..447b6524c2e9 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -22,7 +22,7 @@ static void afs_invalidatepage(struct page *page, unsigned int offset,
 			       unsigned int length);
 static int afs_releasepage(struct page *page, gfp_t gfp_flags);
 
-static int afs_readpages(struct file *filp, struct address_space *mapping,
+static int afs_readpages(struct kiocb *kiocb, struct address_space *mapping,
 			 struct list_head *pages, unsigned nr_pages);
 
 const struct file_operations afs_file_operations = {
@@ -538,10 +538,10 @@ static int afs_readpages_one(struct file *file, struct address_space *mapping,
 /*
  * read a set of pages
  */
-static int afs_readpages(struct file *file, struct address_space *mapping,
+static int afs_readpages(struct kiocb *kiocb, struct address_space *mapping,
 			 struct list_head *pages, unsigned nr_pages)
 {
-	struct key *key = afs_file_key(file);
+	struct key *key = afs_file_key(kiocb->ki_filp);
 	struct afs_vnode *vnode;
 	int ret = 0;
 
@@ -589,7 +589,7 @@ static int afs_readpages(struct file *file, struct address_space *mapping,
 	}
 
 	while (!list_empty(pages)) {
-		ret = afs_readpages_one(file, mapping, pages);
+		ret = afs_readpages_one(kiocb->ki_filp, mapping, pages);
 		if (ret < 0)
 			break;
 	}
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 980cfce01c9a..87a540b42fa7 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -614,7 +614,7 @@ static int blkdev_readpage(struct file * file, struct page * page)
 	return block_read_full_page(page, blkdev_get_block);
 }
 
-static int blkdev_readpages(struct file *file, struct address_space *mapping,
+static int blkdev_readpages(struct kiocb *kiocb, struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages)
 {
 	return mpage_readpages(mapping, pages, nr_pages, blkdev_get_block);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 320d1062068d..1569d29fdfc4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8294,7 +8294,7 @@ static int btrfs_writepages(struct address_space *mapping,
 }
 
 static int
-btrfs_readpages(struct file *file, struct address_space *mapping,
+btrfs_readpages(struct kiocb *kiocb, struct address_space *mapping,
 		struct list_head *pages, unsigned nr_pages)
 {
 	return extent_readpages(mapping, pages, nr_pages);
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6f4678d98df7..687714a29e89 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -477,9 +477,10 @@ static int start_read(struct inode *inode, struct ceph_rw_context *rw_ctx,
  * Read multiple pages.  Leave pages we don't read + unlock in page_list;
  * the caller (VM) cleans them up.
  */
-static int ceph_readpages(struct file *file, struct address_space *mapping,
+static int ceph_readpages(struct kiocb *kiocb, struct address_space *mapping,
 			  struct list_head *page_list, unsigned nr_pages)
 {
+	struct file *file = kiocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_file_info *fi = file->private_data;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 75ddce8ef456..5eec4f40811c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4344,11 +4344,12 @@ readpages_get_pages(struct address_space *mapping, struct list_head *page_list,
 	return rc;
 }
 
-static int cifs_readpages(struct file *file, struct address_space *mapping,
+static int cifs_readpages(struct kiocb *kiocb, struct address_space *mapping,
 	struct list_head *page_list, unsigned num_pages)
 {
 	int rc;
 	struct list_head tmplist;
+	struct file *file = kiocb->ki_filp;
 	struct cifsFileInfo *open_file = file->private_data;
 	struct cifs_sb_info *cifs_sb = CIFS_FILE_SB(file);
 	struct TCP_Server_Info *server;
diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index fc3a8d8064f8..853b905a15c4 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -280,7 +280,7 @@ static int erofs_raw_access_readpage(struct file *file, struct page *page)
 	return 0;
 }
 
-static int erofs_raw_access_readpages(struct file *filp,
+static int erofs_raw_access_readpages(struct kiocb *kiocb,
 				      struct address_space *mapping,
 				      struct list_head *pages,
 				      unsigned int nr_pages)
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index c4b6c9aa87ec..bc8c02b088ce 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1305,7 +1305,7 @@ static bool should_decompress_synchronously(struct erofs_sb_info *sbi,
 	return nr <= sbi->max_sync_decompress_pages;
 }
 
-static int z_erofs_readpages(struct file *filp, struct address_space *mapping,
+static int z_erofs_readpages(struct kiocb *kiocb, struct address_space *mapping,
 			     struct list_head *pages, unsigned int nr_pages)
 {
 	struct inode *const inode = mapping->host;
diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
index 06887492f54b..9905307dfba2 100644
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -372,7 +372,7 @@ static int exfat_readpage(struct file *file, struct page *page)
 	return mpage_readpage(page, exfat_get_block);
 }
 
-static int exfat_readpages(struct file *file, struct address_space *mapping,
+static int exfat_readpages(struct kiocb *kiocb, struct address_space *mapping,
 		struct list_head *pages, unsigned int nr_pages)
 {
 	return mpage_readpages(mapping, pages, nr_pages, exfat_get_block);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index c885cf7d724b..3843900d6251 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -878,7 +878,7 @@ static int ext2_readpage(struct file *file, struct page *page)
 }
 
 static int
-ext2_readpages(struct file *file, struct address_space *mapping,
+ext2_readpages(struct kiocb *kiocb, struct address_space *mapping,
 		struct list_head *pages, unsigned nr_pages)
 {
 	return mpage_readpages(mapping, pages, nr_pages, ext2_get_block);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2a4aae6acdcb..6297804d1ac2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3231,7 +3231,7 @@ static int ext4_readpage(struct file *file, struct page *page)
 }
 
 static int
-ext4_readpages(struct file *file, struct address_space *mapping,
+ext4_readpages(struct kiocb *kiocb, struct address_space *mapping,
 		struct list_head *pages, unsigned nr_pages)
 {
 	struct inode *inode = mapping->host;
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index cdf2f626bea7..7330aa1e2e39 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2304,7 +2304,7 @@ static int f2fs_read_data_page(struct file *file, struct page *page)
 	return ret;
 }
 
-static int f2fs_read_data_pages(struct file *file,
+static int f2fs_read_data_pages(struct kiocb *kiocb,
 			struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages)
 {
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 71946da84388..ab9dfcbf1bd3 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -210,7 +210,7 @@ static int fat_readpage(struct file *file, struct page *page)
 	return mpage_readpage(page, fat_get_block);
 }
 
-static int fat_readpages(struct file *file, struct address_space *mapping,
+static int fat_readpages(struct kiocb *kiocb, struct address_space *mapping,
 			 struct list_head *pages, unsigned nr_pages)
 {
 	return mpage_readpages(mapping, pages, nr_pages, fat_get_block);
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 9d67b830fb7a..ebd40681ee94 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -962,7 +962,7 @@ static int fuse_readpages_fill(void *_data, struct page *page)
 	return 0;
 }
 
-static int fuse_readpages(struct file *file, struct address_space *mapping,
+static int fuse_readpages(struct kiocb *kiocb, struct address_space *mapping,
 			  struct list_head *pages, unsigned nr_pages)
 {
 	struct inode *inode = mapping->host;
@@ -974,7 +974,7 @@ static int fuse_readpages(struct file *file, struct address_space *mapping,
 	if (is_bad_inode(inode))
 		goto out;
 
-	data.file = file;
+	data.file = kiocb->ki_filp;
 	data.inode = inode;
 	data.nr_pages = nr_pages;
 	data.max_pages = min_t(unsigned int, nr_pages, fc->max_pages);
@@ -987,7 +987,7 @@ static int fuse_readpages(struct file *file, struct address_space *mapping,
 	err = read_cache_pages(mapping, pages, fuse_readpages_fill, &data);
 	if (!err) {
 		if (data.ia->ap.num_pages)
-			fuse_send_readpages(data.ia, file);
+			fuse_send_readpages(data.ia, kiocb->ki_filp);
 		else
 			fuse_io_free(data.ia);
 	}
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 786c1ce8f030..37d18f82e5a1 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -594,7 +594,7 @@ int gfs2_internal_read(struct gfs2_inode *ip, char *buf, loff_t *pos,
  * 4. gfs2_block_map() is relied upon to set BH_Boundary in the right places.
  */
 
-static int gfs2_readpages(struct file *file, struct address_space *mapping,
+static int gfs2_readpages(struct kiocb *kiocb, struct address_space *mapping,
 			  struct list_head *pages, unsigned nr_pages)
 {
 	struct inode *inode = mapping->host;
diff --git a/fs/hpfs/file.c b/fs/hpfs/file.c
index b36abf9cb345..5b9c537d011c 100644
--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -125,7 +125,7 @@ static int hpfs_writepage(struct page *page, struct writeback_control *wbc)
 	return block_write_full_page(page, hpfs_get_block, wbc);
 }
 
-static int hpfs_readpages(struct file *file, struct address_space *mapping,
+static int hpfs_readpages(struct kiocb *kiocb, struct address_space *mapping,
 			  struct list_head *pages, unsigned nr_pages)
 {
 	return mpage_readpages(mapping, pages, nr_pages, hpfs_get_block);
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 276107cdaaf1..071da59b7266 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -1183,7 +1183,7 @@ static int isofs_readpage(struct file *file, struct page *page)
 	return mpage_readpage(page, isofs_get_block);
 }
 
-static int isofs_readpages(struct file *file, struct address_space *mapping,
+static int isofs_readpages(struct kiocb *kiocb, struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages)
 {
 	return mpage_readpages(mapping, pages, nr_pages, isofs_get_block);
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 9486afcdac76..503e2e5cb79d 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -296,7 +296,7 @@ static int jfs_readpage(struct file *file, struct page *page)
 	return mpage_readpage(page, jfs_get_block);
 }
 
-static int jfs_readpages(struct file *file, struct address_space *mapping,
+static int jfs_readpages(struct kiocb *kiocb, struct address_space *mapping,
 		struct list_head *pages, unsigned nr_pages)
 {
 	return mpage_readpages(mapping, pages, nr_pages, jfs_get_block);
diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 13b22e898116..4719f6b67b5c 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -402,9 +402,10 @@ readpage_async_filler(void *data, struct page *page)
 	return error;
 }
 
-int nfs_readpages(struct file *filp, struct address_space *mapping,
+int nfs_readpages(struct kiocb *kiocb, struct address_space *mapping,
 		struct list_head *pages, unsigned nr_pages)
 {
+	struct file *filp = kiocb->ki_filp;
 	struct nfs_pageio_descriptor pgio;
 	struct nfs_pgio_mirror *pgm;
 	struct nfs_readdesc desc = {
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 671085512e0f..a981c9404fbc 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -153,7 +153,7 @@ static int nilfs_readpage(struct file *file, struct page *page)
  * @pages - the pages to be read
  * @nr_pages - number of pages to be read
  */
-static int nilfs_readpages(struct file *file, struct address_space *mapping,
+static int nilfs_readpages(struct kiocb *kiocb, struct address_space *mapping,
 			   struct list_head *pages, unsigned int nr_pages)
 {
 	return mpage_readpages(mapping, pages, nr_pages, nilfs_get_block);
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 3a67a6518ddf..aa54b0d0d4a1 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -350,7 +350,7 @@ static int ocfs2_readpage(struct file *file, struct page *page)
  * grow out to a tree. If need be, detecting boundary extents could
  * trivially be added in a future version of ocfs2_get_block().
  */
-static int ocfs2_readpages(struct file *filp, struct address_space *mapping,
+static int ocfs2_readpages(struct kiocb *kiocb, struct address_space *mapping,
 			   struct list_head *pages, unsigned nr_pages)
 {
 	int ret, err = -EIO;
diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index d640b9388238..195bb390ba24 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -289,7 +289,7 @@ static int omfs_readpage(struct file *file, struct page *page)
 	return block_read_full_page(page, omfs_get_block);
 }
 
-static int omfs_readpages(struct file *file, struct address_space *mapping,
+static int omfs_readpages(struct kiocb *kiocb, struct address_space *mapping,
 		struct list_head *pages, unsigned nr_pages)
 {
 	return mpage_readpages(mapping, pages, nr_pages, omfs_get_block);
diff --git a/fs/qnx6/inode.c b/fs/qnx6/inode.c
index 345db56c98fd..c964fd63d4a5 100644
--- a/fs/qnx6/inode.c
+++ b/fs/qnx6/inode.c
@@ -99,7 +99,7 @@ static int qnx6_readpage(struct file *file, struct page *page)
 	return mpage_readpage(page, qnx6_get_block);
 }
 
-static int qnx6_readpages(struct file *file, struct address_space *mapping,
+static int qnx6_readpages(struct kiocb *kiocb, struct address_space *mapping,
 		   struct list_head *pages, unsigned nr_pages)
 {
 	return mpage_readpages(mapping, pages, nr_pages, qnx6_get_block);
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 6419e6dacc39..01d5ccdaa5b4 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1161,7 +1161,7 @@ int reiserfs_get_block(struct inode *inode, sector_t block,
 }
 
 static int
-reiserfs_readpages(struct file *file, struct address_space *mapping,
+reiserfs_readpages(struct kiocb *kiocb, struct address_space *mapping,
 		   struct list_head *pages, unsigned nr_pages)
 {
 	return mpage_readpages(mapping, pages, nr_pages, reiserfs_get_block);
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index e875bc5668ee..c541ca95f851 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -195,7 +195,7 @@ static int udf_readpage(struct file *file, struct page *page)
 	return mpage_readpage(page, udf_get_block);
 }
 
-static int udf_readpages(struct file *file, struct address_space *mapping,
+static int udf_readpages(struct kiocb *kiocb, struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages)
 {
 	return mpage_readpages(mapping, pages, nr_pages, udf_get_block);
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 9d9cebf18726..bff9a2374ece 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -623,7 +623,7 @@ xfs_vm_readpage(
 
 STATIC int
 xfs_vm_readpages(
-	struct file		*unused,
+	struct kiocb		*kiocb,
 	struct address_space	*mapping,
 	struct list_head	*pages,
 	unsigned		nr_pages)
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 25afcf55aa41..11812841a5fa 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -79,7 +79,7 @@ static int zonefs_readpage(struct file *unused, struct page *page)
 	return iomap_readpage(page, &zonefs_iomap_ops);
 }
 
-static int zonefs_readpages(struct file *unused, struct address_space *mapping,
+static int zonefs_readpages(struct kiocb *unused, struct address_space *mapping,
 			    struct list_head *pages, unsigned int nr_pages)
 {
 	return iomap_readpages(mapping, pages, nr_pages, &zonefs_iomap_ops);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5ffc6d236b01..cb5adf72041b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -381,7 +381,7 @@ struct address_space_operations {
 	 * Reads in the requested pages. Unlike ->readpage(), this is
 	 * PURELY used for read-ahead!.
 	 */
-	int (*readpages)(struct file *filp, struct address_space *mapping,
+	int (*readpages)(struct kiocb *kiocb, struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages);
 
 	int (*write_begin)(struct file *, struct address_space *mapping,
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5a323422d783..7c805a32fdc7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2604,18 +2604,18 @@ void task_dirty_inc(struct task_struct *tsk);
 /* readahead.c */
 #define VM_READAHEAD_PAGES	(SZ_128K / PAGE_SIZE)
 
-int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
+int force_page_cache_readahead(struct address_space *mapping, struct kiocb *kiocb,
 			pgoff_t offset, unsigned long nr_to_read);
 
 void page_cache_sync_readahead(struct address_space *mapping,
 			       struct file_ra_state *ra,
-			       struct file *filp,
+			       struct file *file,
 			       pgoff_t offset,
 			       unsigned long size);
 
 void page_cache_async_readahead(struct address_space *mapping,
 				struct file_ra_state *ra,
-				struct file *filp,
+				struct file *file,
 				struct page *pg,
 				pgoff_t offset,
 				unsigned long size);
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 73eda45f1cfd..27c62a08f499 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -550,7 +550,7 @@ nfs_have_writebacks(struct inode *inode)
  * linux/fs/nfs/read.c
  */
 extern int  nfs_readpage(struct file *, struct page *);
-extern int  nfs_readpages(struct file *, struct address_space *,
+extern int  nfs_readpages(struct kiocb *, struct address_space *,
 		struct list_head *, unsigned);
 extern int  nfs_readpage_async(struct nfs_open_context *, struct inode *,
 			       struct page *);
diff --git a/mm/fadvise.c b/mm/fadvise.c
index 4f17c83db575..58654fd13486 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -92,7 +92,9 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 		file->f_mode &= ~FMODE_RANDOM;
 		spin_unlock(&file->f_lock);
 		break;
-	case POSIX_FADV_WILLNEED:
+	case POSIX_FADV_WILLNEED: {
+		struct kiocb kiocb = { .ki_filp = file, };
+
 		/* First and last PARTIAL page! */
 		start_index = offset >> PAGE_SHIFT;
 		end_index = endbyte >> PAGE_SHIFT;
@@ -106,8 +108,9 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 		 * Ignore return value because fadvise() shall return
 		 * success even if filesystem can't retrieve a hint,
 		 */
-		force_page_cache_readahead(mapping, file, start_index, nrpages);
+		force_page_cache_readahead(mapping, &kiocb, start_index, nrpages);
 		break;
+		}
 	case POSIX_FADV_NOREUSE:
 		break;
 	case POSIX_FADV_DONTNEED:
diff --git a/mm/filemap.c b/mm/filemap.c
index 18022de7dc33..abdd3f32c932 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2403,6 +2403,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	struct address_space *mapping = file->f_mapping;
 	struct file *fpin = NULL;
 	pgoff_t offset = vmf->pgoff;
+	struct kiocb kiocb = { .ki_filp = file, };
 
 	/* If we don't want any read-ahead, don't bother */
 	if (vmf->vma->vm_flags & VM_RAND_READ)
@@ -2435,7 +2436,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	ra->start = max_t(long, 0, offset - ra->ra_pages / 2);
 	ra->size = ra->ra_pages;
 	ra->async_size = ra->ra_pages / 4;
-	ra_submit(ra, mapping, file);
+	ra_submit(ra, mapping, &kiocb);
 	return fpin;
 }
 
diff --git a/mm/internal.h b/mm/internal.h
index b5634e78f01d..1d051cbadf1a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -50,16 +50,16 @@ void unmap_page_range(struct mmu_gather *tlb,
 			     struct zap_details *details);
 
 extern unsigned int __do_page_cache_readahead(struct address_space *mapping,
-		struct file *filp, pgoff_t offset, unsigned long nr_to_read,
+		struct kiocb *kiocb, pgoff_t offset, unsigned long nr_to_read,
 		unsigned long lookahead_size);
 
 /*
  * Submit IO for the read-ahead request in file_ra_state.
  */
 static inline unsigned long ra_submit(struct file_ra_state *ra,
-		struct address_space *mapping, struct file *filp)
+		struct address_space *mapping, struct kiocb *kiocb)
 {
-	return __do_page_cache_readahead(mapping, filp,
+	return __do_page_cache_readahead(mapping, kiocb,
 					ra->start, ra->size, ra->async_size);
 }
 
diff --git a/mm/readahead.c b/mm/readahead.c
index 2fe72cd29b47..657206f6318d 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -113,7 +113,7 @@ int read_cache_pages(struct address_space *mapping, struct list_head *pages,
 
 EXPORT_SYMBOL(read_cache_pages);
 
-static int read_pages(struct address_space *mapping, struct file *filp,
+static int read_pages(struct address_space *mapping, struct kiocb *kiocb,
 		struct list_head *pages, unsigned int nr_pages, gfp_t gfp)
 {
 	struct blk_plug plug;
@@ -123,7 +123,7 @@ static int read_pages(struct address_space *mapping, struct file *filp,
 	blk_start_plug(&plug);
 
 	if (mapping->a_ops->readpages) {
-		ret = mapping->a_ops->readpages(filp, mapping, pages, nr_pages);
+		ret = mapping->a_ops->readpages(kiocb, mapping, pages, nr_pages);
 		/* Clean up the remaining pages */
 		put_pages_list(pages);
 		goto out;
@@ -133,7 +133,7 @@ static int read_pages(struct address_space *mapping, struct file *filp,
 		struct page *page = lru_to_page(pages);
 		list_del(&page->lru);
 		if (!add_to_page_cache_lru(page, mapping, page->index, gfp))
-			mapping->a_ops->readpage(filp, page);
+			mapping->a_ops->readpage(kiocb->ki_filp, page);
 		put_page(page);
 	}
 	ret = 0;
@@ -153,7 +153,7 @@ static int read_pages(struct address_space *mapping, struct file *filp,
  * Returns the number of pages requested, or the maximum amount of I/O allowed.
  */
 unsigned int __do_page_cache_readahead(struct address_space *mapping,
-		struct file *filp, pgoff_t offset, unsigned long nr_to_read,
+		struct kiocb *kiocb, pgoff_t offset, unsigned long nr_to_read,
 		unsigned long lookahead_size)
 {
 	struct inode *inode = mapping->host;
@@ -187,7 +187,7 @@ unsigned int __do_page_cache_readahead(struct address_space *mapping,
 			 * batch.
 			 */
 			if (nr_pages)
-				read_pages(mapping, filp, &page_pool, nr_pages,
+				read_pages(mapping, kiocb, &page_pool, nr_pages,
 						gfp_mask);
 			nr_pages = 0;
 			continue;
@@ -209,7 +209,7 @@ unsigned int __do_page_cache_readahead(struct address_space *mapping,
 	 * will then handle the error.
 	 */
 	if (nr_pages)
-		read_pages(mapping, filp, &page_pool, nr_pages, gfp_mask);
+		read_pages(mapping, kiocb, &page_pool, nr_pages, gfp_mask);
 	BUG_ON(!list_empty(&page_pool));
 out:
 	return nr_pages;
@@ -219,11 +219,12 @@ unsigned int __do_page_cache_readahead(struct address_space *mapping,
  * Chunk the readahead into 2 megabyte units, so that we don't pin too much
  * memory at once.
  */
-int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
-			       pgoff_t offset, unsigned long nr_to_read)
+int force_page_cache_readahead(struct address_space *mapping,
+			       struct kiocb *kiocb, pgoff_t offset,
+			       unsigned long nr_to_read)
 {
 	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
-	struct file_ra_state *ra = &filp->f_ra;
+	struct file_ra_state *ra = &kiocb->ki_filp->f_ra;
 	unsigned long max_pages;
 
 	if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages))
@@ -240,7 +241,7 @@ int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 
 		if (this_chunk > nr_to_read)
 			this_chunk = nr_to_read;
-		__do_page_cache_readahead(mapping, filp, offset, this_chunk, 0);
+		__do_page_cache_readahead(mapping, kiocb, offset, this_chunk, 0);
 
 		offset += this_chunk;
 		nr_to_read -= this_chunk;
@@ -380,7 +381,7 @@ static int try_context_readahead(struct address_space *mapping,
  */
 static unsigned long
 ondemand_readahead(struct address_space *mapping,
-		   struct file_ra_state *ra, struct file *filp,
+		   struct file_ra_state *ra, struct kiocb *kiocb,
 		   bool hit_readahead_marker, pgoff_t offset,
 		   unsigned long req_size)
 {
@@ -464,7 +465,7 @@ ondemand_readahead(struct address_space *mapping,
 	 * standalone, small random read
 	 * Read as is, and do not pollute the readahead state.
 	 */
-	return __do_page_cache_readahead(mapping, filp, offset, req_size, 0);
+	return __do_page_cache_readahead(mapping, kiocb, offset, req_size, 0);
 
 initial_readahead:
 	ra->start = offset;
@@ -489,14 +490,14 @@ ondemand_readahead(struct address_space *mapping,
 		}
 	}
 
-	return ra_submit(ra, mapping, filp);
+	return ra_submit(ra, mapping, kiocb);
 }
 
 /**
  * page_cache_sync_readahead - generic file readahead
  * @mapping: address_space which holds the pagecache and I/O vectors
  * @ra: file_ra_state which holds the readahead state
- * @filp: passed on to ->readpage() and ->readpages()
+ * @kiocb: passed on to ->readpage() and ->readpages()
  * @offset: start offset into @mapping, in pagecache page-sized units
  * @req_size: hint: total size of the read which the caller is performing in
  *            pagecache pages
@@ -510,6 +511,8 @@ void page_cache_sync_readahead(struct address_space *mapping,
 			       struct file_ra_state *ra, struct file *filp,
 			       pgoff_t offset, unsigned long req_size)
 {
+	struct kiocb kiocb = { .ki_filp = filp, };
+
 	/* no read-ahead */
 	if (!ra->ra_pages)
 		return;
@@ -519,12 +522,12 @@ void page_cache_sync_readahead(struct address_space *mapping,
 
 	/* be dumb */
 	if (filp && (filp->f_mode & FMODE_RANDOM)) {
-		force_page_cache_readahead(mapping, filp, offset, req_size);
+		force_page_cache_readahead(mapping, &kiocb, offset, req_size);
 		return;
 	}
 
 	/* do read-ahead */
-	ondemand_readahead(mapping, ra, filp, false, offset, req_size);
+	ondemand_readahead(mapping, ra, &kiocb, false, offset, req_size);
 }
 EXPORT_SYMBOL_GPL(page_cache_sync_readahead);
 
@@ -549,6 +552,8 @@ page_cache_async_readahead(struct address_space *mapping,
 			   struct page *page, pgoff_t offset,
 			   unsigned long req_size)
 {
+	struct kiocb kiocb = { .ki_filp = filp, };
+
 	/* no read-ahead */
 	if (!ra->ra_pages)
 		return;
@@ -571,7 +576,7 @@ page_cache_async_readahead(struct address_space *mapping,
 		return;
 
 	/* do read-ahead */
-	ondemand_readahead(mapping, ra, filp, true, offset, req_size);
+	ondemand_readahead(mapping, ra, &kiocb, true, offset, req_size);
 }
 EXPORT_SYMBOL_GPL(page_cache_async_readahead);
 
-- 
2.26.2


--------------3ADB41F72EDDDE21CDE7CE18--
