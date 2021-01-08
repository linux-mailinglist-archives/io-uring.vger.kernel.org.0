Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E79172EEA1D
	for <lists+io-uring@lfdr.de>; Fri,  8 Jan 2021 01:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbhAHAEG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jan 2021 19:04:06 -0500
Received: from a4-5.smtp-out.eu-west-1.amazonses.com ([54.240.4.5]:48469 "EHLO
        a4-5.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728605AbhAHAEG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jan 2021 19:04:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=pqvuhxtqt36lwjpmqkszlz7wxaih4qwj; d=urbackup.org; t=1610064168;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding;
        bh=nX5usKXr9hm/oBwtWsmmoOyPD0qU8y5cxU1wkpNSrAU=;
        b=g5ReCeyC+Rmb1KeKXtg5GCFvKWA1xRdQ818qfGJ5EAA5Iiq5Y+AZ8VcWfFdYjMal
        8hNieezQWtbtocbVcCrBwYoFsXQztJxsJTc6tigP4kX1m1GYITnnbWvKI71fhbP8soe
        gBWoS4khPAvaTvaS0ywbpA+Q6fZpz9/IQh/qLKw8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=shh3fegwg5fppqsuzphvschd53n6ihuv; d=amazonses.com; t=1610064168;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding:Feedback-ID;
        bh=nX5usKXr9hm/oBwtWsmmoOyPD0qU8y5cxU1wkpNSrAU=;
        b=dL1ycDb0fDwNrg2c6Q16oPh0HuRLQFLkoRzwTaDNJP2+obOKbHCzmQhf91rYUg7W
        fCnb5+X3FjwW8BH3lHnUYbroHCOxV/GJoPjyBORSUk2ifVypWSXVvH082T9RNi0ZtTh
        7G1ss5neYUQB7yhR8YYKmct3csxHXpJ5A3b8S2gM=
From:   Martin Raiber <martin@urbackup.org>
To:     linux-btrfs@vger.kernel.org
Cc:     io-uring@vger.kernel.org, Martin Raiber <martin@urbackup.org>
Subject: [PATCH] btrfs: Prevent nowait or async read from doing sync IO
Date:   Fri, 8 Jan 2021 00:02:48 +0000
Message-ID: <01020176df4d86ba-658b4ef1-1b4a-464f-afe4-fb69ca60e04e-000000@eu-west-1.amazonses.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SES-Outgoing: 2021.01.08-54.240.4.5
Feedback-ID: 1.eu-west-1.zKMZH6MF2g3oUhhjaE2f3oQ8IBjABPbvixQzV8APwT0=:AmazonSES
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When reading from btrfs file via io_uring I get following
call traces:

[<0>] wait_on_page_bit+0x12b/0x270
[<0>] read_extent_buffer_pages+0x2ad/0x360
[<0>] btree_read_extent_buffer_pages+0x97/0x110
[<0>] read_tree_block+0x36/0x60
[<0>] read_block_for_search.isra.0+0x1a9/0x360
[<0>] btrfs_search_slot+0x23d/0x9f0
[<0>] btrfs_lookup_csum+0x75/0x170
[<0>] btrfs_lookup_bio_sums+0x23d/0x630
[<0>] btrfs_submit_data_bio+0x109/0x180
[<0>] submit_one_bio+0x44/0x70
[<0>] extent_readahead+0x37a/0x3a0
[<0>] read_pages+0x8e/0x1f0
[<0>] page_cache_ra_unbounded+0x1aa/0x1f0
[<0>] generic_file_buffered_read+0x3eb/0x830
[<0>] io_iter_do_read+0x1a/0x40
[<0>] io_read+0xde/0x350
[<0>] io_issue_sqe+0x5cd/0xed0
[<0>] __io_queue_sqe+0xf9/0x370
[<0>] io_submit_sqes+0x637/0x910
[<0>] __x64_sys_io_uring_enter+0x22e/0x390
[<0>] do_syscall_64+0x33/0x80
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Prevent those by setting IOCB_NOIO before calling
generic_file_buffered_read.

Async read has the same problem. So disable that by removing
FMODE_BUF_RASYNC. This was added with commit
8730f12b7962b21ea9ad2756abce1e205d22db84 ("btrfs: flag files as
supporting buffered async reads") with 5.9. Io_uring will read
the data via worker threads if it can't be read without sync IO
this way.

Signed-off-by: Martin Raiber <martin@urbackup.org>
---
 fs/btrfs/file.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 0e41459b8..8bb561f6d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3589,7 +3589,7 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int whence)
 
 static int btrfs_file_open(struct inode *inode, struct file *filp)
 {
-	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
+	filp->f_mode |= FMODE_NOWAIT;
 	return generic_file_open(inode, filp);
 }
 
@@ -3639,7 +3639,18 @@ static ssize_t btrfs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			return ret;
 	}
 
-	return generic_file_buffered_read(iocb, to, ret);
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		iocb->ki_flags |= IOCB_NOIO;
+
+	ret = generic_file_buffered_read(iocb, to, ret);
+
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		iocb->ki_flags &= ~IOCB_NOIO;
+		if (ret == 0)
+			ret = -EAGAIN;
+	}
+
+	return ret;
 }
 
 const struct file_operations btrfs_file_operations = {
-- 
2.30.0

