Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC382F0122
	for <lists+io-uring@lfdr.de>; Sat,  9 Jan 2021 17:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbhAIQHc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Jan 2021 11:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbhAIQHa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Jan 2021 11:07:30 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A348C0617A3;
        Sat,  9 Jan 2021 08:06:50 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id 190so10216019wmz.0;
        Sat, 09 Jan 2021 08:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ouhtlCdJ/DY280urrHIcZiPcXncXrhPOyIjDJZKeP64=;
        b=qy5YzKqSVfj/n61inmw754WS9TPAvCacovuEf3ll3twxCUwvazuZ1XoReQ9iWnKikI
         LIBWzWQu1z7SOxwi++WGQbPTnkcjlVXSg4idyU2Ael20Dmj6WscsKo4BjDK+k+cOCgOK
         AgfVg6ARPHkkdURVSbRB2cyeIG87ftyMhN6S30APxSo/ZGFubuF9E5plaXWQr0TFgm2D
         VsA8KwTn+D9JUhJaSNS3Mw5LO3TAbxBMcYZQXlGHMUhB8w7TPdNwk3Ey4bBoG+lGeFur
         D+r+jIEFATqrHDTKCAaQGzJYt+gXNh++yGeJvODQVW4uyj2JRglkfeBakz1FKdtZN7vP
         y9Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ouhtlCdJ/DY280urrHIcZiPcXncXrhPOyIjDJZKeP64=;
        b=C1AIrKH+g2WH1MzdATOmKtXNmbXvLspjVSSyqaBcNX+jKHQkHA5yVRrWhXY2djjFyx
         Sjn9Rna0PmaDNZL2QXuoLMnkIS/Ep1VsxA/51ApOkH+IAOfCHL5iSt8twYC8s8N8x4lf
         QAvufHD525y9T9U35mbu6GaEpLsCWh92JbpGgxKBkzw7WX4m7aylF+Thu8Ms9CdGpviy
         hO+kbm/wQiVAI7rS79I1F3XamUW6qojr0MJIkjRDBzJd6FrhKI3Kc+4ECqIXzGzvNYry
         ScO+LYO/wmmsbRjQPM5d1l2qTqCHrCyWYZFYmr0Q6sB5aYPuOup2XfGOMMLLu5jxPEtP
         iGiw==
X-Gm-Message-State: AOAM530QFRSCf/Ym/npTfsaeFMRQixOab8mGdHlzGeb94pH12SDpYyQd
        ukyK7K/dQDsj5gAnbq2bpfhKSuKcpG4L+8zq
X-Google-Smtp-Source: ABdhPJw4gnrLCSdkD/iV43iWJWvb3fyCSRNNfo8n4OuJ5w224968euoNuQ/4NpxpqxQQbSZa0wIJ1A==
X-Received: by 2002:a05:600c:2042:: with SMTP id p2mr7943949wmg.152.1610208408536;
        Sat, 09 Jan 2021 08:06:48 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id j9sm17403866wrm.14.2021.01.09.08.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 08:06:47 -0800 (PST)
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
Subject: [PATCH v3 3/7] block/psi: remove PSI annotations from direct IO
Date:   Sat,  9 Jan 2021 16:02:59 +0000
Message-Id: <faad7d7f58ff45285eaac9af7fae9a5fcca98977.1610170479.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610170479.git.asml.silence@gmail.com>
References: <cover.1610170479.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Direct IO does not operate on the current working set of pages managed
by the kernel, so it should not be accounted as memory stall to PSI
infrastructure.

The block layer and iomap direct IO use bio_iov_iter_get_pages()
to build bios, and they are the only users of it, so to avoid PSI
tracking for them clear out BIO_WORKINGSET flag. Do same for
dio_bio_submit() because fs/direct_io constructs bios by hand directly
calling bio_add_page().

Reported-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/bio.c    | 6 ++++++
 fs/direct-io.c | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index 1f2cc1fbe283..9f26984af643 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1099,6 +1099,9 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
  * fit into the bio, or are requested in @iter, whatever is smaller. If
  * MM encounters an error pinning the requested pages, it stops. Error
  * is returned only if 0 pages could be pinned.
+ *
+ * It's intended for direct IO, so doesn't do PSI tracking, the caller is
+ * responsible for setting BIO_WORKINGSET if necessary.
  */
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 {
@@ -1123,6 +1126,9 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 
 	if (is_bvec)
 		bio_set_flag(bio, BIO_NO_PAGE_REF);
+
+	/* don't account direct I/O as memory stall */
+	bio_clear_flag(bio, BIO_WORKINGSET);
 	return bio->bi_vcnt ? 0 : ret;
 }
 EXPORT_SYMBOL_GPL(bio_iov_iter_get_pages);
diff --git a/fs/direct-io.c b/fs/direct-io.c
index d53fa92a1ab6..0e689233f2c7 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -426,6 +426,8 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 	unsigned long flags;
 
 	bio->bi_private = dio;
+	/* don't account direct I/O as memory stall */
+	bio_clear_flag(bio, BIO_WORKINGSET);
 
 	spin_lock_irqsave(&dio->bio_lock, flags);
 	dio->refcount++;
-- 
2.24.0

