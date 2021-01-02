Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2127E2E87BA
	for <lists+io-uring@lfdr.de>; Sat,  2 Jan 2021 16:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbhABPWL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Jan 2021 10:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbhABPWK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Jan 2021 10:22:10 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29F1C0613ED;
        Sat,  2 Jan 2021 07:21:27 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id 91so26566410wrj.7;
        Sat, 02 Jan 2021 07:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7FOerU/+uiaLOx8IjnYNL5LXRoiyAnmqji55A4AV5Zs=;
        b=LBsSYTbjwdI3QmQu4IbgQ7olNGDMBAqElqxAyPsojxLe7NcTh8El+Pke0BmUM22eYb
         AuZq9SBpNP53WKEFTQdHVDQPCC/8PDYsWLnhkSG7Q2av8EAE8APyACuUnwA3w3t7JqWh
         R4mCXlk4y9W+n2bx+NU4V6SqSobRuYDWexgtwJuMlhnrLQQMDddC3lR9NTJlDYGo4U1G
         Yntmje7tslRu50v12yeP/tlquNu8wXFd0g77n+FLG0DNgXfWPtBPtB8SMzz/3+rhpWhR
         Epwmsr+CSoG9EWj2xUflykAOxhsPhi2ABMO72oHO7eo5cj09XjFAKrK+DFY/UA4J8N0y
         OWaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7FOerU/+uiaLOx8IjnYNL5LXRoiyAnmqji55A4AV5Zs=;
        b=H54ehalIm4pDyQ20WUtcI4FW9hSb/7osqZR9HBk+rzMD32OM0cWqAMMMZMfZA57Cf3
         vQi8Sj5yv6SHhQS95nr2OUK1mjnpOtKZUG8PVsCw6PAvEy4fiUmny0scjRb6fl4SZsZy
         o4b40qV+ruSi90OC0jZjPHrZI6g1T/dgX2Ugeb1HBzf4S7IUbhnmDMNmF/PFl5yVX7xm
         4IclwqlzPwjK8Jg3lMyiNZjYTz12SBI0ZyCg2AAfZz7YYJAWa6rkZfXxuPDihImJn4Nu
         Gq7GXbvd2PkE5TkzKNekGWANcuToq2oH/VBogzBNfn+XvvXfUT84qfH/bendRWDaRiUF
         /zew==
X-Gm-Message-State: AOAM532vVaNBSbbz8b10LLhrk1DTnnHmFPlkojsPahgQLncNsDl1DcF0
        +NvOfaLIqM84eM+Qv+AfvBJCAsRBSy/3UQ==
X-Google-Smtp-Source: ABdhPJzvzXyfPCTdTGrqpyWR+n7zH7gi0rGiGb6+ilO2BRa7Nk9Cv57P3HckjnOAEWjCCb1q8AjWLg==
X-Received: by 2002:a5d:6789:: with SMTP id v9mr71303602wru.86.1609600886321;
        Sat, 02 Jan 2021 07:21:26 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.0])
        by smtp.gmail.com with ESMTPSA id h13sm78671243wrm.28.2021.01.02.07.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 07:21:25 -0800 (PST)
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
Subject: [PATCH v2 3/7] block/psi: remove PSI annotations from direct IO
Date:   Sat,  2 Jan 2021 15:17:35 +0000
Message-Id: <c77839347f1f3fdf917ac2bc251310f1c1f26044.1609461359.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609461359.git.asml.silence@gmail.com>
References: <cover.1609461359.git.asml.silence@gmail.com>
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

