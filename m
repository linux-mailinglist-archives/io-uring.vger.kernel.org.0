Return-Path: <io-uring+bounces-3141-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BA2D975886
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 18:34:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E26ECB25212
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 16:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 659391B012C;
	Wed, 11 Sep 2024 16:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YvzCwbfb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A471AED3F;
	Wed, 11 Sep 2024 16:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726072469; cv=none; b=KmIb+/88tQ10d+ljklVzULApk/7Ujdm+IdoG7SCX+jeWPgc6P1sLMCc4x802SsO15U6WunYQ2ILkhdS0jsjWOZlgXtcwBfCcG0TpbX5zvuzKKVufrpRqWwfLjbXfBnxwEEBG3tZxRpjs23gAY5JHHwWgqhA9sEn/WoacfNx3M+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726072469; c=relaxed/simple;
	bh=JrAOgMM2iAIABQmCU3ZV4QTcl0u9rm5SIWFUspGZWXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/Sce4j31eehEsIz+38L2Or5UeYOUt11ZATMd1+I/EgL4wpaa9bkoh3VTXtljDZW89uwCNVfP1n9x9KdnIL1N4OzACVS3zjVGvM9L8JcR9ME9OdoZFR4iKJ2cWh+p3OE4tSM+uK1rnNA0OOcpdtAwmQldhc8pOHTaKzhB0oRzy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YvzCwbfb; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a8a7596b7dfso192652766b.0;
        Wed, 11 Sep 2024 09:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726072466; x=1726677266; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2XjW/1z5M+e5L1HlSBo37JIC76JYeYPBxc+HZavMul8=;
        b=YvzCwbfbVbEXy1873OZRCktgLD9hwfSRVXTrkYus0CFjMRimUyLMTMtUYS5maimzFH
         L5tJYz0hgMnWxrfrPcxUd5ZzdVmQ1thcZkflgNaNBNcdsgd1FCFatOBA9egbKxaPAGFw
         +72u/7tQ1LY4lb/Hc4FNa9A0xMqRHXgrn5mIFknEwfYFh0h1m4zUnn/Hdwtu+9Fb4ZIk
         51T+i3NViem8BEJwGWFNuY0WS7mRm4yvImFhIGXhVoPltbycUYtouYZt38b77qegO5bk
         EGwqO/cIweGpDcJoPGsl2dpo9cR4PJjWzTFKWDcnnfF3UoWTsezRXAShCZUhxjuPtpko
         BSJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726072466; x=1726677266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2XjW/1z5M+e5L1HlSBo37JIC76JYeYPBxc+HZavMul8=;
        b=BEfc41FTOfWDwKbawvo0e/zbQcVeGEUWpLh92EhBJ2IxrLfvbRkVqlcQV8P6kFz1s4
         HfGC61JT9+G8N69NFdXEyM5CYbHYiXukJa9qCuufG9rzYBwDoE+T+plPZaPYrU8z+Aqb
         aycvhZjJcYOH2dlEjhKYsOF1rCo/UaCC4ZXb4EcWDNgigCB2Lq1DE+oFuSxcaSIV5AOl
         yWyTVSVNkI1SNus2TZcdyOMIyLwNs7JJKVlmmcuu0ixDKuanE+nJR9ONMRp7njaknwU+
         721jGL8y4jd1OCXmYzjulH9/uqI9YQRbKwSwWyY50xn0EVRfRLPJdydpDi/dFGtrD3a8
         B8ZA==
X-Forwarded-Encrypted: i=1; AJvYcCUDAn2FxJMQt6iGXmsj81HqUGElRofMEOK7wcXkRFZPPIIRGNCQV4CsxN1PO5tcjpYVX8Hbid7zFInugA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxgwwg8I+zEQh4FCDXzCHP2cqPoQnDnIbt7AHtZyJNSmwabl9W8
	kAJCuX64WT3xGOLWZt+HlMlxNpaEx4cEyfY9NxYq3APpWaJ23iXNe7jLpa1Q
X-Google-Smtp-Source: AGHT+IFMn90AnKpQjlSSfbL+WudXYP6lMWX8+dJQnqeRgseHvIS6DUoUvcDEA12mRbA7+KIVujg4Mw==
X-Received: by 2002:a17:907:94d4:b0:a8d:141a:87cb with SMTP id a640c23a62f3a-a8ffb2459a6mr490300366b.18.1726072464867;
        Wed, 11 Sep 2024 09:34:24 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25c72ed3sm631820866b.135.2024.09.11.09.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 09:34:23 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v5 3/8] filemap: introduce filemap_invalidate_pages
Date: Wed, 11 Sep 2024 17:34:39 +0100
Message-ID: <f81374b52c92d0dce0f01a279d1eed42b54056aa.1726072086.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1726072086.git.asml.silence@gmail.com>
References: <cover.1726072086.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kiocb_invalidate_pages() is useful for the write path, however not
everything is backed by kiocb and we want to reuse the function for bio
based discard implementation. Extract and and reuse a new helper called
filemap_invalidate_pages(), which takes a argument indicating whether it
should be non-blocking and might return -EAGAIN.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/pagemap.h |  2 ++
 mm/filemap.c            | 17 ++++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index d9c7edb6422b..e39c3a7ce33c 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -32,6 +32,8 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 		pgoff_t start, pgoff_t end);
 int kiocb_invalidate_pages(struct kiocb *iocb, size_t count);
 void kiocb_invalidate_post_direct_write(struct kiocb *iocb, size_t count);
+int filemap_invalidate_pages(struct address_space *mapping,
+			     loff_t pos, loff_t end, bool nowait);
 
 int write_inode_now(struct inode *, int sync);
 int filemap_fdatawrite(struct address_space *);
diff --git a/mm/filemap.c b/mm/filemap.c
index d62150418b91..6843ed4847d4 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2712,14 +2712,12 @@ int kiocb_write_and_wait(struct kiocb *iocb, size_t count)
 }
 EXPORT_SYMBOL_GPL(kiocb_write_and_wait);
 
-int kiocb_invalidate_pages(struct kiocb *iocb, size_t count)
+int filemap_invalidate_pages(struct address_space *mapping,
+			     loff_t pos, loff_t end, bool nowait)
 {
-	struct address_space *mapping = iocb->ki_filp->f_mapping;
-	loff_t pos = iocb->ki_pos;
-	loff_t end = pos + count - 1;
 	int ret;
 
-	if (iocb->ki_flags & IOCB_NOWAIT) {
+	if (nowait) {
 		/* we could block if there are any pages in the range */
 		if (filemap_range_has_page(mapping, pos, end))
 			return -EAGAIN;
@@ -2738,6 +2736,15 @@ int kiocb_invalidate_pages(struct kiocb *iocb, size_t count)
 	return invalidate_inode_pages2_range(mapping, pos >> PAGE_SHIFT,
 					     end >> PAGE_SHIFT);
 }
+
+int kiocb_invalidate_pages(struct kiocb *iocb, size_t count)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+
+	return filemap_invalidate_pages(mapping, iocb->ki_pos,
+					iocb->ki_pos + count - 1,
+					iocb->ki_flags & IOCB_NOWAIT);
+}
 EXPORT_SYMBOL_GPL(kiocb_invalidate_pages);
 
 /**
-- 
2.45.2


