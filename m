Return-Path: <io-uring+bounces-9051-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2211DB2BBC4
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 10:25:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC37C1BA157D
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 08:26:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEB7A311973;
	Tue, 19 Aug 2025 08:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3ORTNbCU"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51C031195C;
	Tue, 19 Aug 2025 08:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755591927; cv=none; b=j/+VErarElQG3aN1kY+766uMe03WXP94VeW49OQS1ylYflnDuo0VT0jCfxTyy4pz2nHcbtytusbOjKICb7OkwcO16jifCPEv6WbyA/gXV5vYQ89ltbW9Tfj67K6cSkHb6kfSJPoaC6NYOiO+DYdqo8o/7Ha3jl7zOHEslKup1To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755591927; c=relaxed/simple;
	bh=5fY9e4/1nr96XwYCfBdaSFFkrQLfAZMBswqxKipfXIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYm/lyOIKeO8gBgD8m5Rj7CGZv+gO9VQlrJP7S79y4PipA45438xjgX4b0E/ZtXTpZ6UJAWKtYGPc9d9EB2zVUYOYDRy83jEfeLj2rNPS4DkF/zjl8J0kiUw+uGGikt98hMc02ualQoHR/b11uYlIVniyMk4cRkinTgmpNZ7os8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3ORTNbCU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MO6L3LgIvKugnESrJ8j0+ha2SBW5SXB8OA7sveh3nSI=; b=3ORTNbCU0/lKqYp+uxrXF9Mel+
	V/wMspHF82SNRyiCZOCr5LdEmTIPK1YltDcWs4pzuxFcl5vS1+wDKjPQhN31dsFrWvsaY6jD6+g/M
	ZVDHZ2bdlco4f7o/gSe5yO5DdBdFik0jXICnxIhuoQQHSjC5zJ7MyW7Zq/g7yO6wH1E0w9hLCmVVw
	Nsf6QDY4RG7yVXIp++RCKqRkDC0VlThj1vqqsSDdJ/qw/1e6VgKTAT21DaSf39qgr192wAUf5jAP0
	igna3iYCs240FrbezRannlEWe4TOTGKzSh+HYCNcTlS/xjgkVCsBB/eWuU8jE0PVwo5I+YxlyLOJJ
	dveK/Z3Q==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uoHel-00000009nVT-3hPs;
	Tue, 19 Aug 2025 08:25:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH 1/2] fs: add a FMODE_ flag to indicate IOCB_HAS_METADATA availability
Date: Tue, 19 Aug 2025 10:25:00 +0200
Message-ID: <20250819082517.2038819-2-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250819082517.2038819-1-hch@lst.de>
References: <20250819082517.2038819-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently the kernel will happily route io_uring requests with metadata
to file operations that don't support it.  Add a FMODE_ flag to guard
that.

Fixes: 4de2ce04c862 ("fs: introduce IOCB_HAS_METADATA for metadata")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/fops.c       | 3 +++
 include/linux/fs.h | 3 ++-
 io_uring/rw.c      | 3 +++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index 82451ac8ff25..08e7c21bd9f1 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -7,6 +7,7 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/blkdev.h>
+#include <linux/blk-integrity.h>
 #include <linux/buffer_head.h>
 #include <linux/mpage.h>
 #include <linux/uio.h>
@@ -687,6 +688,8 @@ static int blkdev_open(struct inode *inode, struct file *filp)
 
 	if (bdev_can_atomic_write(bdev))
 		filp->f_mode |= FMODE_CAN_ATOMIC_WRITE;
+	if (blk_get_integrity(bdev->bd_disk))
+		filp->f_mode |= FMODE_HAS_METADATA;
 
 	ret = bdev_open(bdev, mode, filp->private_data, NULL, filp);
 	if (ret)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d7ab4f96d705..601d036a6c78 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -149,7 +149,8 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* Expect random access pattern */
 #define FMODE_RANDOM		((__force fmode_t)(1 << 12))
 
-/* FMODE_* bit 13 */
+/* Supports IOCB_HAS_METADATA */
+#define FMODE_HAS_METADATA	((__force fmode_t)(1 << 13))
 
 /* File is opened with O_PATH; almost nothing can be done with it */
 #define FMODE_PATH		((__force fmode_t)(1 << 14))
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 52a5b950b2e5..af5a54b5db12 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -886,6 +886,9 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	if (req->flags & REQ_F_HAS_METADATA) {
 		struct io_async_rw *io = req->async_data;
 
+		if (!(file->f_mode & FMODE_HAS_METADATA))
+			return -EINVAL;
+
 		/*
 		 * We have a union of meta fields with wpq used for buffered-io
 		 * in io_async_rw, so fail it here.
-- 
2.47.2


