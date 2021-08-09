Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB863E4534
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbhHIMF3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235335AbhHIMF3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:29 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC16C0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:08 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id f5so5304389wrm.13
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=DBkqB5qZjAHJwQOUDCxxzpHjz84HnBmWlpSxGEej8j4=;
        b=KPN/lIyC5Mik3r7YGzUSKkOQ1CMTxHNiOOuNVdKu59ew1gmJzc3ezBI5mRIgl6Qdpn
         3jrChbi7pzuZWAoYly4OY1KyKM3ptxeW6Bi0fGQJIUzp9tBf/KbitsXd0McreCSlSgjI
         D5e17viRtfNz7Qec3SAZAfcg3vJqPdCXsNut5i6ZQqsHGemwP97tk317LSCOJgh6/Tt5
         LItnHhapQ5TGZVbkEGd31L81xNHPxyjgQqKIeKAPxZ6J55i5BINBVHFASgzvJXyUvGSA
         heLB82llOOx5y+rnDEVDxrGdd7d122ZlYbf4l2rHjG6q6Nb+ABZzY2blzhmVX79JqKVn
         kfSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DBkqB5qZjAHJwQOUDCxxzpHjz84HnBmWlpSxGEej8j4=;
        b=QdV6YWBQP24oQxkaQ1x6Pt24r1cnafRGBo8Tv+jpEOzOX0vILen/oRsTRVKYlvvbzb
         jpACin3JgCUqj1b0MmdTMMHVgm8fmI0Phid6fKgIljyDZLMw5yDZ7o8BA3Ju8/yqZGWy
         iPyiocHwT7iEvJa4gDNhF4NNw8Aive+fTNzJM4GXfVu6fKgT8SLeIFRCKJaBc5g8xmPx
         0acGwnZYU/dmzf145WL+hdHEVvCsjXHXwNfWcyZpUyX2wE+OKpEx2psJcgquf93edYDC
         fnyj8ajrvHfLC9h0Im3nTa8rNzbGbJW0LV+BxqhojDx15pEjo8OjhApBkVYmgf3USE4K
         vC9Q==
X-Gm-Message-State: AOAM530FPYf+9D+ieQGoIu5P+HLDeGqxpFyQevbj4jW4LkRZmLk9GZAk
        kh36h/pVpkr8UvNc+0GoKo4=
X-Google-Smtp-Source: ABdhPJwg0xJNwYvslvj+BHj6q87P2fMr+u+I3LC89OnMSVcERi+RUOUYXTHUMJY9usWeP+9+HF3tTQ==
X-Received: by 2002:a05:6000:18c8:: with SMTP id w8mr24287401wrq.90.1628510707351;
        Mon, 09 Aug 2021 05:05:07 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 04/28] io_uring: avoid touching inode in rw prep
Date:   Mon,  9 Aug 2021 13:04:04 +0100
Message-Id: <0a62780c491ca2522cd52db4ae3f16e03aafed0f.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we use fixed files, we can be sure (almost) that REQ_F_ISREG is set.
However, for non-reg files io_prep_rw() still will look into inode to
double check, and that's expensive and can be avoided.

The only caveat is that it only currently works with 64+ bit
architectures, see FFS_ISREG, so we should consider that.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d34bba222039..42cf69c6d9b6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1230,6 +1230,20 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 	return false;
 }
 
+#define FFS_ASYNC_READ		0x1UL
+#define FFS_ASYNC_WRITE		0x2UL
+#ifdef CONFIG_64BIT
+#define FFS_ISREG		0x4UL
+#else
+#define FFS_ISREG		0x0UL
+#endif
+#define FFS_MASK		~(FFS_ASYNC_READ|FFS_ASYNC_WRITE|FFS_ISREG)
+
+static inline bool io_req_ffs_set(struct io_kiocb *req)
+{
+	return IS_ENABLED(CONFIG_64BIT) && (req->flags & REQ_F_FIXED_FILE);
+}
+
 static void io_req_track_inflight(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_INFLIGHT)) {
@@ -2679,7 +2693,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	unsigned ioprio;
 	int ret;
 
-	if (!(req->flags & REQ_F_ISREG) && S_ISREG(file_inode(file)->i_mode))
+	if (!io_req_ffs_set(req) && S_ISREG(file_inode(file)->i_mode))
 		req->flags |= REQ_F_ISREG;
 
 	kiocb->ki_pos = READ_ONCE(sqe->off);
@@ -6320,15 +6334,6 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	}
 }
 
-#define FFS_ASYNC_READ		0x1UL
-#define FFS_ASYNC_WRITE		0x2UL
-#ifdef CONFIG_64BIT
-#define FFS_ISREG		0x4UL
-#else
-#define FFS_ISREG		0x0UL
-#endif
-#define FFS_MASK		~(FFS_ASYNC_READ|FFS_ASYNC_WRITE|FFS_ISREG)
-
 static inline struct io_fixed_file *io_fixed_file_slot(struct io_file_table *table,
 						       unsigned i)
 {
-- 
2.32.0

