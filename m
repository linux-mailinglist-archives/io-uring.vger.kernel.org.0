Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF63736B0D
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 13:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbjFTLc6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 07:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbjFTLc5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 07:32:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A365FE
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 04:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=cA+Tgvvo+DnJVVkgrzEmjRYhFDG0B2ufcY5cUFFTsds=; b=4g+fMwp6W+wAFYIu9QLAKk7hMo
        T4915HjYhJaR3pXD+C0jjuH0D0W8N6JHTtlzFqonglclMkuXCCjl4Sxq+QkN0jafLRIQ5gMRYICkj
        pKVxjmG/pITs5v1lqmFJkOsBP8/zLR7Twzs05QcWDvrZ3Rs4STTZIcHei+BwSzS+LcRfPrcbBEfAB
        xdWEdBBjaHayWb6uF7SqnjWhG8Ur2BZ+XlXeTlkJByZp/A0asUVngA0mMCwNaOZvnWtVfBsJvgyrU
        9Nj3/QCH4PjJLAam/Wtm4SrZi0yvufO+3KML4rf+RB0byuIV6ic1ry6hm+fGcBXs0bVvWL+193/ya
        /claJz4Q==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qBZbT-00B8a6-2u;
        Tue, 20 Jun 2023 11:32:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Subject: [PATCH 5/8] io_uring: return REQ_F_ flags from io_file_get_flags
Date:   Tue, 20 Jun 2023 13:32:32 +0200
Message-Id: <20230620113235.920399-6-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230620113235.920399-1-hch@lst.de>
References: <20230620113235.920399-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Two of the three callers want them, so return the more usual format,
and shift into the FFS_ form only for the fixed file table.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 io_uring/filetable.h | 6 ++----
 io_uring/io_uring.c  | 6 +++---
 io_uring/rw.c        | 2 +-
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index 351111ff888274..697cb68adc8169 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -54,10 +54,8 @@ static inline struct file *io_file_from_index(struct io_file_table *table,
 static inline void io_fixed_file_set(struct io_fixed_file *file_slot,
 				     struct file *file)
 {
-	unsigned long file_ptr = (unsigned long) file;
-
-	file_ptr |= io_file_get_flags(file);
-	file_slot->file_ptr = file_ptr;
+	file_slot->file_ptr = (unsigned long)file |
+		(io_file_get_flags(file) >> REQ_F_SUPPORT_NOWAIT_BIT);
 }
 
 static inline void io_reset_alloc_hint(struct io_ring_ctx *ctx)
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0e0bdb6ac9a202..1f348753694bfe 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -425,7 +425,7 @@ static void io_prep_async_work(struct io_kiocb *req)
 		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 
 	if (req->file && !(req->flags & REQ_F_FIXED_FILE))
-		req->flags |= io_file_get_flags(req->file) << REQ_F_SUPPORT_NOWAIT_BIT;
+		req->flags |= io_file_get_flags(req->file);
 
 	if (req->file && (req->flags & REQ_F_ISREG)) {
 		bool should_hash = def->hash_reg_file;
@@ -1771,9 +1771,9 @@ unsigned int io_file_get_flags(struct file *file)
 	unsigned int res = 0;
 
 	if (S_ISREG(file_inode(file)->i_mode))
-		res |= FFS_ISREG;
+		res |= REQ_F_ISREG;
 	if ((file->f_flags & O_NONBLOCK) || (file->f_mode & FMODE_NOWAIT))
-		res |= FFS_NOWAIT;
+		res |= REQ_F_SUPPORT_NOWAIT;
 	return res;
 }
 
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1cf5742f2ae9cb..1bce2208b65c4f 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -667,7 +667,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 		return -EBADF;
 
 	if (!(req->flags & REQ_F_FIXED_FILE))
-		req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
+		req->flags |= io_file_get_flags(file);
 
 	kiocb->ki_flags = file->f_iocb_flags;
 	ret = kiocb_set_rw_flags(kiocb, rw->flags);
-- 
2.39.2

