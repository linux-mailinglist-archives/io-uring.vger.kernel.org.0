Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9EE03AD2A7
	for <lists+io-uring@lfdr.de>; Fri, 18 Jun 2021 21:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbhFRTV5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Jun 2021 15:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbhFRTV5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Jun 2021 15:21:57 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B86C061574
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 12:19:47 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id q10so11650112oij.5
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 12:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AsWJrnxl1rXNFkUCAk/hY4ul7jqtEdp6/T5bk6nJeFI=;
        b=bcePLH3XAb91ft8OJfbp2GIht4wUd8DQbEFkiniqWiuGtRksdWRNdrnWsnvDlKImwb
         pXB4UsdqNsEGCkTpy1g4Hj7pDn5xVpZ/LZ3OodcmY58aSglr9q2Bc8c0Bn71xURNkdfT
         dHDo3zkrZuSE+pGX2s0NBK1bMsVlnEP2Zx1FS9mOcFMEEBPt/wbLu6/qe8VADh3fjbpG
         ha/VilWig6KyO+UjsSdjt5H85G71K6D/O6hbrPDPmqo/esjE/EHSKRmgnpcwy6/WOVqJ
         xmZaCI/6GNmOHQYfsVAKWj1CY6tDhyBUlopY2f1b28UiUj3qq5KLBnnOTc2DF87Rr5lT
         DsRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AsWJrnxl1rXNFkUCAk/hY4ul7jqtEdp6/T5bk6nJeFI=;
        b=C6oIoYXrVpK90jFQZyhVpoq1edmg7rgty/KRsRnW1QuV/yoQsm3VXT01IJRabzrReL
         rmaCxJfQptJL25Q72jRWDJjgoJ4AZx3xyLmi8vrYUoTrm3AFK9/JvcuoXiE4/yuqgUar
         W05QVrZKYS+SNlNRav0U0Ur6Lw+Utfd+9zf/D+PvCMotPkSztj5VHtLUpQ7IgH+jcAsy
         vTx9G/ZL5+Lz0AvsD5BTrOOobCQpXgMwBNBZSCYF98gu/75jJjpJiRoJVp+XoIzzDr3W
         GRaetcW48Vntj8Fv5fFMy4MhPoa8B94Xlu9iVa52b1K+z4assYz1R8G5888QFR+1H/HO
         u8TA==
X-Gm-Message-State: AOAM533LJ8stswj2F+t+aKI06sodz/bFIYvyGkc9tyGWbci+IfJFHWpd
        722akCmfN2lRq16ggJ5w3keClNvYu5kMiA==
X-Google-Smtp-Source: ABdhPJwxlu5j7LW8ZEWROq70kqXjNn00NMseX2bN5YNm/XV44cIjdRCoFzR87khFqOFFMLlYT7YfGg==
X-Received: by 2002:a05:6808:13c5:: with SMTP id d5mr7194060oiw.164.1624043985905;
        Fri, 18 Jun 2021 12:19:45 -0700 (PDT)
Received: from p1.localdomain ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id u15sm1981732ooq.24.2021.06.18.12.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 12:19:45 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     samuel@codeotaku.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: add IOSQE_IGNORE_NONBLOCK flag
Date:   Fri, 18 Jun 2021 13:19:40 -0600
Message-Id: <20210618191940.68303-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210618191940.68303-1-axboe@kernel.dk>
References: <20210618191940.68303-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If a file has O_NONBLOCK set, then io_uring will not arm poll and wait
for data/space if none is available. Instead, -EAGAIN is returned if
an IO attempt is made on the file descriptor.

For library use cases, the library may not be in full control of the
file descriptor, and hence cannot modify file flags through fcntl(2).
Or even if it can, it'd be inefficient and require 3 system calls to
check, set, and re-set.

IOSQE_IGNORE_NONBLOCK provides a way to tell io_uring to ignore O_NONBLOCK
and arm poll to wait for data/space instead, just like we would have if
O_NONBLOCK wasn't set on the file descriptor.

Suggested-by: Samuel Williams <samuel@codeotaku.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 11 ++++++++---
 include/uapi/linux/io_uring.h |  3 +++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fc8637f591a6..2d42273bb50f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -108,7 +108,7 @@
 
 #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
 				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
-				IOSQE_BUFFER_SELECT)
+				IOSQE_BUFFER_SELECT | IOSQE_IGNORE_NONBLOCK)
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
 				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS)
 
@@ -706,6 +706,7 @@ enum {
 	REQ_F_HARDLINK_BIT	= IOSQE_IO_HARDLINK_BIT,
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
+	REQ_F_IGNORE_NONBLOCK_BIT	= IOSQE_IGNORE_NONBLOCK_BIT,
 
 	/* first byte is taken by user flags, shift it to not overlap */
 	REQ_F_FAIL_BIT		= 8,
@@ -743,6 +744,8 @@ enum {
 	REQ_F_FORCE_ASYNC	= BIT(REQ_F_FORCE_ASYNC_BIT),
 	/* IOSQE_BUFFER_SELECT */
 	REQ_F_BUFFER_SELECT	= BIT(REQ_F_BUFFER_SELECT_BIT),
+	/* IOSQE_IGNORE_NONBLOCK */
+	REQ_F_IGNORE_NONBLOCK	= BIT(REQ_F_IGNORE_NONBLOCK_BIT),
 
 	/* fail rest of links */
 	REQ_F_FAIL		= BIT(REQ_F_FAIL_BIT),
@@ -2686,7 +2689,8 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return ret;
 
 	/* don't allow async punt for O_NONBLOCK or RWF_NOWAIT */
-	if ((kiocb->ki_flags & IOCB_NOWAIT) || (file->f_flags & O_NONBLOCK))
+	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
+	    ((file->f_flags & O_NONBLOCK) && !(req->flags & REQ_F_IGNORE_NONBLOCK)))
 		req->flags |= REQ_F_NOWAIT;
 
 	ioprio = READ_ONCE(sqe->ioprio);
@@ -4709,7 +4713,8 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
 	int ret;
 
-	if (req->file->f_flags & O_NONBLOCK)
+	if ((req->file->f_flags & O_NONBLOCK) &&
+	    !(req->flags & REQ_F_IGNORE_NONBLOCK))
 		req->flags |= REQ_F_NOWAIT;
 
 	ret = __sys_accept4_file(req->file, file_flags, accept->addr,
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f1f9ac114b51..582eee6e898b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -70,6 +70,7 @@ enum {
 	IOSQE_IO_HARDLINK_BIT,
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
+	IOSQE_IGNORE_NONBLOCK_BIT,
 };
 
 /*
@@ -87,6 +88,8 @@ enum {
 #define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
 /* select buffer from sqe->buf_group */
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
+/* ignore if file has O_NONBLOCK set */
+#define IOSQE_IGNORE_NONBLOCK	(1U << IOSQE_IGNORE_NONBLOCK_BIT)
 
 /*
  * io_uring_setup() flags
-- 
2.32.0

