Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0DF2F0141
	for <lists+io-uring@lfdr.de>; Sat,  9 Jan 2021 17:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbhAIQIK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Jan 2021 11:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbhAIQII (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Jan 2021 11:08:08 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A73C0617A5;
        Sat,  9 Jan 2021 08:06:52 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id k10so10197014wmi.3;
        Sat, 09 Jan 2021 08:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BfcAWicfY3ps8Cp/gsA4qs7Avo53ajYGpXmNYv+JbSY=;
        b=AeQssdOPinNt7VEfPxpzOS0PFW0o40Y9EV+3MG63+Dd8wEjtQhPls6aUI/zqMC4gsv
         IW3I6GjVy1dOi5SnlEp+YRA1/gtBdhH5asZs1Vc8BwgkTu/OQL9SiwZQeTeh6MEK9Ytx
         oKJWgI/oCxvRIUq3vpAnYYeXiwoUDBD2DaSwvxqPoCeBCIOxe63PTPOjy+qnYmafOzLt
         pOInVokeOb4fjqx5nf6WKgyOT4BJn7nKX37LNZAUETQywherYZWmn6EShmOq2aNMEzsS
         +u1A8+eL2dHUF/rHQOXJTo6YWxB4tASlksAkwh8nvZUnfMoL5BQpSeLSg0/B3npBgBaE
         OwzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BfcAWicfY3ps8Cp/gsA4qs7Avo53ajYGpXmNYv+JbSY=;
        b=BHGQA2UIqbpfCASUyFgEzop2pJwTum3A7MttmuA/MrYk2Y3Fziq9Bxy0/lqLKHk8zc
         rmTsFH9Vfb8m96q1zpOJCLRfsPkZthPsR6OAgXBay6d/22KO0DS0yhZEb+Q4SI6RFFZH
         G+pEqVuPrPfrrFloNkvEB8DItyqJbwtX/jL4sphIZwoEPXDZl9P6Tg7nXmOERVZgiliM
         BpbYZEdabwzwe1QfRoKpDrbyVV6nkpslp4HXbWZriYkGIgeFk84UXfclgF1cSV1b8N6U
         2BoSt0luBZm/j/zdFs1MkZA065atDw4ledBsvR2A6An6s9RYWPw4DVeyc+q1PrW+BDPP
         Y2uQ==
X-Gm-Message-State: AOAM531nrSjIY+5yn6vWpErUL/Le9z/2dp1MNepGCXcwuMNQQIwKYPUt
        HVseCUtTEabpC7s8yQRqJaR90G0HzrRuyCZC
X-Google-Smtp-Source: ABdhPJx4y4lbIa9CtCF5CrCkTJk2J7iIX4ikX7/zFLt/oXjOr5IOUBU+qaI+PSRkIWiQi2yqw+zLjA==
X-Received: by 2002:a1c:4384:: with SMTP id q126mr7875358wma.84.1610208411272;
        Sat, 09 Jan 2021 08:06:51 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id j9sm17403866wrm.14.2021.01.09.08.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 08:06:50 -0800 (PST)
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
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 5/7] iov_iter: optimise bvec iov_iter_advance()
Date:   Sat,  9 Jan 2021 16:03:01 +0000
Message-Id: <58552e3ba333650ccd425823cb9dc0b949350959.1610170479.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610170479.git.asml.silence@gmail.com>
References: <cover.1610170479.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

iov_iter_advance() is heavily used, but implemented through generic
means. For bvecs there is a specifically crafted function for that, so
use bvec_iter_advance() instead, it's faster and slimmer.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 lib/iov_iter.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 7de304269641..9b1c109dc8a9 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1065,6 +1065,21 @@ static void pipe_advance(struct iov_iter *i, size_t size)
 	pipe_truncate(i);
 }
 
+static void iov_iter_bvec_advance(struct iov_iter *i, size_t size)
+{
+	struct bvec_iter bi;
+
+	bi.bi_size = i->count;
+	bi.bi_bvec_done = i->iov_offset;
+	bi.bi_idx = 0;
+	bvec_iter_advance(i->bvec, &bi, size);
+
+	i->bvec += bi.bi_idx;
+	i->nr_segs -= bi.bi_idx;
+	i->count = bi.bi_size;
+	i->iov_offset = bi.bi_bvec_done;
+}
+
 void iov_iter_advance(struct iov_iter *i, size_t size)
 {
 	if (unlikely(iov_iter_is_pipe(i))) {
@@ -1075,6 +1090,10 @@ void iov_iter_advance(struct iov_iter *i, size_t size)
 		i->count -= size;
 		return;
 	}
+	if (iov_iter_is_bvec(i)) {
+		iov_iter_bvec_advance(i, size);
+		return;
+	}
 	iterate_and_advance(i, size, v, 0, 0, 0)
 }
 EXPORT_SYMBOL(iov_iter_advance);
-- 
2.24.0

