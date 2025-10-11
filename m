Return-Path: <io-uring+bounces-9964-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 65AB7BCEDF2
	for <lists+io-uring@lfdr.de>; Sat, 11 Oct 2025 03:33:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FD9F1A669F6
	for <lists+io-uring@lfdr.de>; Sat, 11 Oct 2025 01:34:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B04B73FBB3;
	Sat, 11 Oct 2025 01:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="QeATIuYO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1332B9A8
	for <io-uring@vger.kernel.org>; Sat, 11 Oct 2025 01:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760146411; cv=none; b=SGky8xo9ApgcHwL685SEH8z/8spEFWdDfcNJIJxUONnd3MIBDJcF4ueaZ84+jeJPKLBsXX7fTWAaO/1vcNdyHRHgeJQC/eavBnHoOqgviCn3Jh+/jWSQCXh11oja1+0Y2b8WNQjpfOGBOfmpHLJmVL2f46eHqiVgntrhvh4mJuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760146411; c=relaxed/simple;
	bh=FMRXqxPu0WQ5Ax5nNw0lt7BC+iqQTQtavFODzaAsDT8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VskG9qediEqvpmPYGXLrNAI+tX11hdShA+orEThQyowI/19Ej4P9rS32T60igyLN13kepwWG12sxYHWlYIGadfxNB/CiltXaKw1ZTbg1aa1oNETSZkezEQ3eZkBkofCtkE9S/WmF6W6WXu1cm+0NM72vIqBGESr3g8uW08nIqqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=QeATIuYO; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-267facf9b58so15767095ad.2
        for <io-uring@vger.kernel.org>; Fri, 10 Oct 2025 18:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1760146408; x=1760751208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d/dbVKML6jyfDJLg2rXlA//5YED8oSUDfIzTUJyF0qc=;
        b=QeATIuYOcV0Ubn5NJlFEQDCHZ0h28DOmhcI+7yCi3dTo2PHhSkNAMKrV4rHFhJVa3Q
         hRGRX4Dg5/FIGNviJ5G8oEgQGL12pWHXmMg4qZygXcKEA6yHqCENVu+3atCXPrv/RnXr
         w5/4sGoiCCQDhUzRDdY91lCQZ0hnDuY7v1e64/9vpk8XmCQz9/TgDeO2vk6dEyveCSJt
         xVP2wf1XwEEXlxeZWVousAUDWJeNSKpf9/zuB7YcW/YAUBgk1/N7yCTIFZs0o7qPbak0
         BPb0ujZjAqJJEYVCm8b8W1c4A7iF2OuBdSdwUNK2EWst1hQAggSA0MzrARvvLXvPneyd
         zVqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760146408; x=1760751208;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d/dbVKML6jyfDJLg2rXlA//5YED8oSUDfIzTUJyF0qc=;
        b=a2aQPQRjbDlr8aIb2ltl+49yZQHKsK8Rrqj1eARcBCUSGwkOAJFc/wq+X16rlR/Cr0
         8EKxNdh6nVD65K7ApASe3/tFpheH8yC15rO4P7T3g7auzOdImolflNyZhQSpGvU+oxGx
         DtKsGF/gIxjSDIlnFMijwX/ttBsE6T+1IqQyKMGih0rLzjJnHvb7s5aMnUypXZY0N82B
         LX1PxnoR5wDGB8LOflTav9wiMNfb1GLzl7dxAKUqKIC9AIGNCX9UVK/oQ2pSLSTv5pwY
         nFV9L5A1sdzg8+TdCBmvm9VVOXCX/emLBxCrkgv7qGW257SJs4uvwXUHTg/W0t92im+D
         ZAuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWg3O7W+eto39Jc+32macNT/Lh0jVKEyHZeunOg/9EIXivVd5BUh7nXYRO8LEPYz3GQJhia/INwgg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxlKTaDezgIHW8rQHZiiV2HGY0kgnkZthqh+8Xdajq7roN/BIQo
	Ats6xp9sHN9kM9jUA7U2ErEcSrliBoa1Or+3PhSuE3te5c4FRydzrisPEW1Ht1Jza5w=
X-Gm-Gg: ASbGncs+oo1DoZh78Szk4uTHMTzy1wPWs/J6zqjlZnWQYM+NtIAo9rcIChqiy4rxOTd
	7c4LIcvfogzpJlZfNsGHmxD2F4En5neNWqrS7HFo/EpEtyFNrImrYXF48jdQPFkhq2UNqnV/Llo
	UBcnyt5FlDzLzEJxZE/a5SAuDLiU5cS1cy5SKLYWEqMhb+bB4tHhnFIFvGJadlRHxmpvDO4clT2
	HEkxeLXTBsPdRai4FU2qP1X5urx7TFTkpyINtAeUWTtIX003DGb7YeLwmzua5RF204em4MMEKne
	MeTXJaiVnv44YRYfnQuq+rC/4T4oRVPxCSVMaCHuuEU4oaSw2nnP6PFxTJjj5Qjk+gjRF2L3tB5
	b38HMXeKKc4Fca5TMKyDGuq4+RYTlLU0wTUErvDXs5GdTvU+9OnY6F43SAewieI3onInHGQs/DY
	IV/1IDDw==
X-Google-Smtp-Source: AGHT+IH2ZLFZnAX+DFQkY9v0s+2anWfLJ5/4tgkkHlg3OcqGLJ41YRx4qbgQD3SYi5SqmtyxL/sNpg==
X-Received: by 2002:a17:902:da8e:b0:26a:589b:cf11 with SMTP id d9443c01a7336-29027402d24mr204107925ad.43.1760146407559;
        Fri, 10 Oct 2025 18:33:27 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.239])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b678ddc9f8esm3533310a12.10.2025.10.10.18.33.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 10 Oct 2025 18:33:27 -0700 (PDT)
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
	linux-ext4@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>
Subject: [PATCH] block: enable per-cpu bio cache by default
Date: Sat, 11 Oct 2025 09:33:12 +0800
Message-Id: <20251011013312.20698-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Per cpu bio cache was only used in the io_uring + raw block device,
after commit 12e4e8c7ab59 ("io_uring/rw: enable bio caches for IRQ
rw"),  bio_put is safe for task and irq context, bio_alloc_bioset is
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
 block/blk-map.c    |  4 ++++
 block/fops.c       |  4 ----
 include/linux/fs.h |  3 ---
 io_uring/rw.c      |  1 -
 5 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 3b371a5da159..16b20c10cab7 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -513,20 +513,18 @@ struct bio *bio_alloc_bioset(struct block_device *bdev, unsigned short nr_vecs,
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
+	opf |= REQ_ALLOC_CACHE;
+	if (bs->cache && nr_vecs <= BIO_INLINE_VECS) {
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
diff --git a/block/blk-map.c b/block/blk-map.c
index 23e5d5ebe59e..570a7ca6edd1 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -255,6 +255,10 @@ static struct bio *blk_rq_map_bio_alloc(struct request *rq,
 {
 	struct bio *bio;
 
+	/*
+	 * Even REQ_ALLOC_CACHE is enabled by default, we still need this to
+	 * mark bio is allocated by bio_alloc_bioset.
+	 */
 	if (rq->cmd_flags & REQ_ALLOC_CACHE && (nr_vecs <= BIO_INLINE_VECS)) {
 		bio = bio_alloc_bioset(NULL, nr_vecs, rq->cmd_flags, gfp_mask,
 					&fs_bio_set);
diff --git a/block/fops.c b/block/fops.c
index ddbc69c0922b..090562a91b4c 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -177,8 +177,6 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	loff_t pos = iocb->ki_pos;
 	int ret = 0;
 
-	if (iocb->ki_flags & IOCB_ALLOC_CACHE)
-		opf |= REQ_ALLOC_CACHE;
 	bio = bio_alloc_bioset(bdev, nr_pages, opf, GFP_KERNEL,
 			       &blkdev_dio_pool);
 	dio = container_of(bio, struct blkdev_dio, bio);
@@ -326,8 +324,6 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 	loff_t pos = iocb->ki_pos;
 	int ret = 0;
 
-	if (iocb->ki_flags & IOCB_ALLOC_CACHE)
-		opf |= REQ_ALLOC_CACHE;
 	bio = bio_alloc_bioset(bdev, nr_pages, opf, GFP_KERNEL,
 			       &blkdev_dio_pool);
 	dio = container_of(bio, struct blkdev_dio, bio);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 601d036a6c78..18ec41732186 100644
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
index af5a54b5db12..fa7655ab9097 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -856,7 +856,6 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
 	if (unlikely(ret))
 		return ret;
-	kiocb->ki_flags |= IOCB_ALLOC_CACHE;
 
 	/*
 	 * If the file is marked O_NONBLOCK, still allow retry for it if it
-- 
2.39.5 (Apple Git-154)


