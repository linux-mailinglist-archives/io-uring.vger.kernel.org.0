Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF8D3E7D99
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 18:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236203AbhHJQiE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 12:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236106AbhHJQiA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 12:38:00 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4200C06179A
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 09:37:37 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id l11so10253508plk.6
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 09:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EOUkUjkApB+u9s/YlxR3KEiPACxa20TSw4f2NjsBDFs=;
        b=Ot4LUM9vennjOsDScG+3pnXhAVWQ+7ozD6mExFiU/aVRNFuzm8PMzBcMa4XZsEwso3
         i9z5RAna0gYQtTFNd61o9jeiOH6tWKu5LajdsFaXhMLrd25cJuPf1ojBIyeL1Yv4ZoPD
         7MOdpeqh+HQ2uXmWsVIyXBZARr/xXmTikyFle987FhGhVW+m35RITgGN7HQ6DXm1p3eK
         zUlgyuHNjDHxjLaMGmmvhd+EivglTjKNTR9hkOcueDk1lZvwuW5+Y8//8B7YgQFqIxWm
         T5LzRUZ+P0bsZA0elYv2i3Xz0aZ+92cIbrFLg1iqcEcrT2GOxRD3g3RJ9ktYVZLwtfqF
         CQ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EOUkUjkApB+u9s/YlxR3KEiPACxa20TSw4f2NjsBDFs=;
        b=bA5+61Y5OCei+Rhw6vN788Z4Xx4huCJdv/sgjSdkTDA/A1qPis01ZfsQS67BMoPhNN
         gqf/mCWnUrS9VAZHivZGWd8RkAu0tvF5tmZo2zt+I1WBdZef5mVJ77mctQ8RiJBdng/t
         bo+mM+s2CnFZ9vMma5EZAejdEGfI+TUyvpFbm/KWwSyWMEvxJes52X39w+PO53PTar37
         wMVO4jz/wWuVeVuQAh0hQRXNVv1StbFKpIQAvb6BKEC/3RSGW0QxOve8eQkREeTSC619
         XGdpkVKhxIAFLn/U64a8t4s+4qDYhpsZkuhgWzbEe++kru3IbesrFsZvCt29yiJ+rjWS
         qliw==
X-Gm-Message-State: AOAM530fdl9K2Zjm4OzqlkCU2LZnepNewddjEsPk6CRZiYDpK60rc2Qz
        4LfQ81oED8OLZf7c2bmO3EAwbgSsqH6WN+b8
X-Google-Smtp-Source: ABdhPJwbB4i6KbTtSHoL8+GibG3II0wrltUkyNqSuMSNeJPHqSJinHnylmT6nDOpvLO+YEKUOjamcQ==
X-Received: by 2002:a63:f011:: with SMTP id k17mr193635pgh.391.1628613457217;
        Tue, 10 Aug 2021 09:37:37 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id pi14sm3517744pjb.38.2021.08.10.09.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 09:37:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] fs: add ki_bio_cache pointer to struct kiocb
Date:   Tue, 10 Aug 2021 10:37:26 -0600
Message-Id: <20210810163728.265939-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810163728.265939-1-axboe@kernel.dk>
References: <20210810163728.265939-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This allows an issuer (and owner of a kiocb) to pass in a bio allocation
cache that can be used to improve the efficiency of the churn of repeated
bio allocations and frees.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/fs.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 640574294216..5f17d10ddc2d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -291,6 +291,7 @@ struct page;
 struct address_space;
 struct writeback_control;
 struct readahead_control;
+struct bio_alloc_cache;
 
 /*
  * Write life time hint values.
@@ -319,6 +320,8 @@ enum rw_hint {
 /* iocb->ki_waitq is valid */
 #define IOCB_WAITQ		(1 << 19)
 #define IOCB_NOIO		(1 << 20)
+/* iocb->ki_bio_cache is valid */
+#define IOCB_ALLOC_CACHE	(1 << 21)
 
 struct kiocb {
 	struct file		*ki_filp;
@@ -337,6 +340,14 @@ struct kiocb {
 		struct wait_page_queue	*ki_waitq; /* for async buffered IO */
 	};
 
+	/*
+	 * If set, owner of iov_iter can pass in a fast-cache for bio
+	 * allocations.
+	 */
+#ifdef CONFIG_BLOCK
+	struct bio_alloc_cache	*ki_bio_cache;
+#endif
+
 	randomized_struct_fields_end
 };
 
-- 
2.32.0

