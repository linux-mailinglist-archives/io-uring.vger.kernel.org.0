Return-Path: <io-uring+bounces-10437-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F711C3E35C
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 03:07:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B33E3AE34A
	for <lists+io-uring@lfdr.de>; Fri,  7 Nov 2025 02:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7882E4279;
	Fri,  7 Nov 2025 02:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="FdDcFUQp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EB22DC32E
	for <io-uring@vger.kernel.org>; Fri,  7 Nov 2025 02:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762481250; cv=none; b=QM8tEiYOuum+84YnJPdlKiV7fQSox0i1UAFXmpYmI4fi7u4zPZtQsdRikQ9x1Pa+JUiiYhE/SA//JdAyQOJi6BPb6GNefq855mwGyyKG1EimHWKSO3nkkQPUkHkxlHiJN5Sq0NjvpsruN0gSyBmFP3g9ezIbrwkzQatEhfa/ZbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762481250; c=relaxed/simple;
	bh=UIab7wtwL7MJOqUh9OsFCLgRkvtJ87T6L6S86OEG8/0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qi1jB61xzJ16N/MP1lG9e1N9HN8DQPTLJqNiKIQaLOFkeqdB1UOLkdJHrgC1K6k/DmdSBu3tGCCoLjRdSbuGami1GvQaHLl1PzeySBCnwn2kyBVjnWU7Viv8vA78CcfAJ6DZ+Wc6joc76Gp5Vq9trHA2GhvDpi7xk4pIMk0lmB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=FdDcFUQp; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b6271ea3a6fso183749a12.0
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 18:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1762481249; x=1763086049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QuX17fCzmjSlKD2oTV0BAVWCX3GMVQ03UEsOj2aXO/w=;
        b=FdDcFUQpsQGrRs9SYQctX6rOgF3sJar5Sa3J/Z1NyX9Kcrd6r8qDuhYdT5+d+fJI2w
         UZSaA4F0AraXyZQXLVh+QxtFSL0cHWr7nTQvbWrT/DSykZBgijRu7Vg14/lcO2zcREUY
         VYIo+gxoNkhfP4PfAvkr0acMP4HukdlXehlPpoJiIEBQoyeV39+8eYrhvkc8FvrFhtj1
         vn7HYjP3kVBaEAlL31mNTqJt76AJ7+IgXJ+J6G1aoabe//Cw1+pkZbGTedDRenPRrMeK
         NqVK8nF/Pca8gNMqDS/ODyhjXFMq7w6hKjZOPXzw0TGyI0+CF0N/PDO/YirWWGKcWYlQ
         ZIzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762481249; x=1763086049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QuX17fCzmjSlKD2oTV0BAVWCX3GMVQ03UEsOj2aXO/w=;
        b=QPXTtgcLYK2qXU9w0wNd9OIz5Iux1QtD1D12cjDjNAkEE5wMbIKc34Afj/cLIBk9fb
         JnhGJ9Bfiqi9VptfncztuySjp8BAn7h4NQmSFcWssSelgDffsI6Gm3PtWe5htmsAscli
         iEBg6NFMMsOTPHNjbDqmGfIHup8nhCkxcpWCNldYweKl7RubTzcKqnh37K3WVcP/hznG
         WfGy7/rUN6Bhbzr+ZyyTVDyod58dzkq3MCIqaAoesTqkFNoobf/axykZ1xTVAktiNK3k
         y+5ZE14TpQj7YhrswePbzYeyftmZjzXbtK4VVuwj7227IeGdtzdzuMGwiUZDD5nwmN+/
         rr/A==
X-Forwarded-Encrypted: i=1; AJvYcCVus86vlFc2szfaoX6l1kkYsQBStLFwVNGcZ+EyjW85TU//MgTsCrvcBeAY18JWt2mcfQtvl0gYWA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzG3ykLVNjgSZiRFLZkEWwN/E6EELYdhoUNOCUqHfMAGO1pmJan
	Ds8S7WblskYoRfGagyAWK4+W4REiEgiifz43m3vG6dmXcLjkEUIIBoTbw/+t8LQy0Bc=
X-Gm-Gg: ASbGnctb92YBK4F2q1yDcHvXkrPNo3ai2KW3zJ76twt6iEMRNii3Ao48622ygll77+m
	pIIqa9FCPkxfv52/XVKuP8ekleVoh8p5Ho6ipcIgCfSY69CCoxmRKaCpY6RKX3ZSFkIVl6bWApp
	HBVIUP0zKNBbNWgq9ZC0lh6q5rPL97Ox9fErmPsMUYzV6ZYBdFtNe3992qSr8nO+x07us9YZr9c
	e7VmyichKxTLBf/nGH3pz876Ctk864kNfAMy6Kow+VMFDv0JF6Wa/miQhKu1gMpj6tFgIyPyJGF
	MAz039uXlMW3klR5xURqUTOw0t3Q2IEvjI1OtsVuhU+zr9i2vDC8u6s3aKWN4YkHA8rGIWWCPN9
	hImhteXtHL5rrwrvMmLHvE3UUy7EzFX/c/c8PIfcqRVvZMoAhv96VGJBGgfXhcCxKiwvzldh5Yw
	ifto2x9GQ5BYJF/7IU
X-Google-Smtp-Source: AGHT+IHXmZOcta8jUuxDACQrWTlF7AFvsAayeKJwmvo20B5+lL1aR+s8qHZVmeDX1E1ADNkEK+YkjQ==
X-Received: by 2002:a17:903:1a85:b0:295:94e1:91da with SMTP id d9443c01a7336-297c04601efmr20299015ad.33.1762481248360;
        Thu, 06 Nov 2025 18:07:28 -0800 (PST)
Received: from localhost.localdomain ([2408:8740:c4ff:1::4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2965096825esm43129885ad.3.2025.11.06.18.07.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 06 Nov 2025 18:07:28 -0800 (PST)
From: Fengnan Chang <changfengnan@bytedance.com>
To: axboe@kernel.dk,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	asml.silence@gmail.com,
	willy@infradead.org,
	djwong@kernel.org,
	hch@infradead.org,
	ritesh.list@gmail.com,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org,
	ming.lei@redhat.com,
	linux-nvme@lists.infradead.org
Cc: Fengnan Chang <changfengnan@bytedance.com>
Subject: [PATCH v2 2/2] block: enable per-cpu bio cache by default
Date: Fri,  7 Nov 2025 10:05:57 +0800
Message-Id: <20251107020557.10097-3-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20251107020557.10097-1-changfengnan@bytedance.com>
References: <20251107020557.10097-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since after commit 12e4e8c7ab59 ("io_uring/rw: enable bio caches for
IRQ rw"), bio_put is safe for task and irq context, bio_alloc_bioset is
safe for task context and no one calls in irq context, so we can enable
per cpu bio cache by default.

Benchmarked with t/io_uring and ext4+nvme:
taskset -c 6 /root/fio/t/io_uring  -p0 -d128 -b4096 -s1 -c1 -F1 -B1 -R1
-X1 -n1 -P1  /mnt/testfile
base IOPS is 562K, patch IOPS is 574K. The CPU usage of bio_alloc_bioset
decrease from 1.42% to 1.22%.

The worst case is allocate bio in CPU A but free in CPU B, still use
t/io_uring and ext4+nvme:
base IOPS is 648K, patch IOPS is 647K.

Also use fio test ext4/xfs with libaio/sync/io_uring on null_blk and
nvme, no obvious performance regression.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 block/bio.c        | 26 ++++++++++++--------------
 block/fops.c       |  4 ----
 include/linux/fs.h |  3 ---
 io_uring/rw.c      |  1 -
 4 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index b3a79285c278..64a1599a5930 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -516,20 +516,18 @@ struct bio *bio_alloc_bioset(struct block_device *bdev, unsigned short nr_vecs,
 	if (WARN_ON_ONCE(!mempool_initialized(&bs->bvec_pool) && nr_vecs > 0))
 		return NULL;
 
-	if (opf & REQ_ALLOC_CACHE) {
-		if (bs->cache && nr_vecs <= BIO_INLINE_VECS) {
-			bio = bio_alloc_percpu_cache(bdev, nr_vecs, opf,
-						     gfp_mask, bs);
-			if (bio)
-				return bio;
-			/*
-			 * No cached bio available, bio returned below marked with
-			 * REQ_ALLOC_CACHE to particpate in per-cpu alloc cache.
-			 */
-		} else {
-			opf &= ~REQ_ALLOC_CACHE;
-		}
-	}
+	if (bs->cache && nr_vecs <= BIO_INLINE_VECS) {
+		opf |= REQ_ALLOC_CACHE;
+		bio = bio_alloc_percpu_cache(bdev, nr_vecs, opf,
+					     gfp_mask, bs);
+		if (bio)
+			return bio;
+		/*
+		 * No cached bio available, bio returned below marked with
+		 * REQ_ALLOC_CACHE to participate in per-cpu alloc cache.
+		 */
+	} else
+		opf &= ~REQ_ALLOC_CACHE;
 
 	/*
 	 * submit_bio_noacct() converts recursion to iteration; this means if
diff --git a/block/fops.c b/block/fops.c
index 5e3db9fead77..7ef2848244b1 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -184,8 +184,6 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	loff_t pos = iocb->ki_pos;
 	int ret = 0;
 
-	if (iocb->ki_flags & IOCB_ALLOC_CACHE)
-		opf |= REQ_ALLOC_CACHE;
 	bio = bio_alloc_bioset(bdev, nr_pages, opf, GFP_KERNEL,
 			       &blkdev_dio_pool);
 	dio = container_of(bio, struct blkdev_dio, bio);
@@ -333,8 +331,6 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 	loff_t pos = iocb->ki_pos;
 	int ret = 0;
 
-	if (iocb->ki_flags & IOCB_ALLOC_CACHE)
-		opf |= REQ_ALLOC_CACHE;
 	bio = bio_alloc_bioset(bdev, nr_pages, opf, GFP_KERNEL,
 			       &blkdev_dio_pool);
 	dio = container_of(bio, struct blkdev_dio, bio);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c895146c1444..1be899ac8b5a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -365,8 +365,6 @@ struct readahead_control;
 /* iocb->ki_waitq is valid */
 #define IOCB_WAITQ		(1 << 19)
 #define IOCB_NOIO		(1 << 20)
-/* can use bio alloc cache */
-#define IOCB_ALLOC_CACHE	(1 << 21)
 /*
  * IOCB_DIO_CALLER_COMP can be set by the iocb owner, to indicate that the
  * iocb completion can be passed back to the owner for execution from a safe
@@ -399,7 +397,6 @@ struct readahead_control;
 	{ IOCB_WRITE,		"WRITE" }, \
 	{ IOCB_WAITQ,		"WAITQ" }, \
 	{ IOCB_NOIO,		"NOIO" }, \
-	{ IOCB_ALLOC_CACHE,	"ALLOC_CACHE" }, \
 	{ IOCB_DIO_CALLER_COMP,	"CALLER_COMP" }, \
 	{ IOCB_AIO_RW,		"AIO_RW" }, \
 	{ IOCB_HAS_METADATA,	"AIO_HAS_METADATA" }
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 5b2241a5813c..c0c59eb358a8 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -862,7 +862,6 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
 	if (unlikely(ret))
 		return ret;
-	kiocb->ki_flags |= IOCB_ALLOC_CACHE;
 
 	/*
 	 * If the file is marked O_NONBLOCK, still allow retry for it if it
-- 
2.39.5 (Apple Git-154)


