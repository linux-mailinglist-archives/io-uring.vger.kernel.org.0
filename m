Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3295E2DA4C3
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 01:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbgLOAZQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 19:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728437AbgLOAZI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 19:25:08 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6BFC0617B0;
        Mon, 14 Dec 2020 16:24:09 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id r7so18152809wrc.5;
        Mon, 14 Dec 2020 16:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KwoEZ6JyxQmbBCmxLJQ+KWQFWoJwlaOL+90wK7NFOco=;
        b=CCqnIhGkYp5ddpdcS1UPTb39Ra4D+5WscVMtb6oidexSCYeRHWEJdco70zMnNXbweP
         Pn9+E/zWBZSVxQulIBksAPt2eJsrV+hcX5QXQ5e/rNpsVTCUypnB4O6PqOB1cPyrdig5
         Z2W2sZoDSXpf3t6IsKdOTrqvZNe7gphiU7OKr3DzkP3ai/bVVx+ROIKjzGv/MjUZreFw
         UJYaTjClZtkxL3Qk4unb4sOP/qIqrNNTCyOMK+oyZy/vMPEVYMwnvSidQGP0uwVdVXKT
         RUMiYdgenV+xw4kpOcRJAQoq5G7ku8XOkHkg7hXSJdQunmwauFc9IIpAaXUTAN1K0Asq
         asiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KwoEZ6JyxQmbBCmxLJQ+KWQFWoJwlaOL+90wK7NFOco=;
        b=C8fnFApzFssakdswfeTqlZYEDLAwW0mE3Cf7u83WCfUK6eyspdxWPpSaTNRo3UoGkX
         FeX1xUJSCQpDmh8LpaS1FU4VQ59cwXfamSZy1KiXVoOBeJJyVHwfaiT1qIeUC0PjVxxl
         QzpMzww5uSYPblj9pMsZJKTWsfk0uGE/yyqrnsgVt4tm3+ldHH7zV+1VCpNSJT2GiTTI
         Io937H2qY53E8qXBKNQ3GjG/alxwtF5gsMok9xxeZLQo5sFWMeR+v85jKfHfs+GNJlaw
         kDOGaKMTT2deo9XTDFk4MRfypSPovgPm4WYyilNdAr5nwpNeNm0HusbVLMNt9vj1zxor
         hu0w==
X-Gm-Message-State: AOAM531GiGUTbCY6fXyoB7aV6Gz1gY5LCKVEp+5A45yMbeS7EsVlWLl0
        3aRIoihqCycesAxeOgqY/C+JyHDYx+fXZGcR
X-Google-Smtp-Source: ABdhPJy2l/O+oho3Jx+i8vPBRwZoxDCJHPX4ZJfTmMVoBuUmrUSRDXK9gRQP/XvrS0UN33z/eOUSAg==
X-Received: by 2002:a5d:6708:: with SMTP id o8mr190459wru.64.1607991847796;
        Mon, 14 Dec 2020 16:24:07 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.163])
        by smtp.gmail.com with ESMTPSA id b19sm5362012wmj.37.2020.12.14.16.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 16:24:07 -0800 (PST)
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
Subject: [PATCH v1 4/6] block/psi: remove PSI annotations from direct IO
Date:   Tue, 15 Dec 2020 00:20:23 +0000
Message-Id: <1d3cf86668e44b3a3d35b5dbe759a086a157e434.1607976425.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1607976425.git.asml.silence@gmail.com>
References: <cover.1607976425.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As reported, we must not do pressure stall information accounting for
direct IO, because otherwise it tells that it's thrashing a page when
actually doing IO on hot data.

Apparently, bio_iov_iter_get_pages() is used only by paths doing direct
IO, so just make it avoid setting BIO_WORKINGSET, it also saves us CPU
cycles on doing that. For fs/direct-io.c just clear the flag before
submit_bio(), it's not of much concern performance-wise.

Reported-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/bio.c    | 25 ++++++++++++++++---------
 fs/direct-io.c |  2 ++
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 4a8f77bb3956..3192358c411f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -963,18 +963,22 @@ EXPORT_SYMBOL_GPL(bio_release_pages);
 static int __bio_iov_bvec_add_pages(struct bio *bio, struct iov_iter *iter)
 {
 	const struct bio_vec *bv = iter->bvec;
-	unsigned int len;
-	size_t size;
+	struct page *page = bv->bv_page;
+	bool same_page = false;
+	unsigned int off, len;
 
 	if (WARN_ON_ONCE(iter->iov_offset > bv->bv_len))
 		return -EINVAL;
 
 	len = min_t(size_t, bv->bv_len - iter->iov_offset, iter->count);
-	size = bio_add_page(bio, bv->bv_page, len,
-				bv->bv_offset + iter->iov_offset);
-	if (unlikely(size != len))
-		return -EINVAL;
-	iov_iter_advance(iter, size);
+	off = bv->bv_offset + iter->iov_offset;
+
+	if (!__bio_try_merge_page(bio, page, len, off, &same_page)) {
+		if (bio_full(bio, len))
+			return -EINVAL;
+		bio_add_page_noaccount(bio, page, len, off);
+	}
+	iov_iter_advance(iter, len);
 	return 0;
 }
 
@@ -1023,8 +1027,8 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 				put_page(page);
 		} else {
 			if (WARN_ON_ONCE(bio_full(bio, len)))
-                                return -EINVAL;
-			__bio_add_page(bio, page, len, offset);
+				return -EINVAL;
+			bio_add_page_noaccount(bio, page, len, offset);
 		}
 		offset = 0;
 	}
@@ -1099,6 +1103,9 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
  * fit into the bio, or are requested in @iter, whatever is smaller. If
  * MM encounters an error pinning the requested pages, it stops. Error
  * is returned only if 0 pages could be pinned.
+ *
+ * It also doesn't set BIO_WORKINGSET, so is intended for direct IO. If used
+ * otherwise the caller is responsible to do that to keep PSI happy.
  */
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 {
diff --git a/fs/direct-io.c b/fs/direct-io.c
index d53fa92a1ab6..914a7f600ecd 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -426,6 +426,8 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 	unsigned long flags;
 
 	bio->bi_private = dio;
+	/* PSI is only for paging IO */
+	bio_clear_flag(bio, BIO_WORKINGSET);
 
 	spin_lock_irqsave(&dio->bio_lock, flags);
 	dio->refcount++;
-- 
2.24.0

