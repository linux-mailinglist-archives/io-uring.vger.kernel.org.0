Return-Path: <io-uring+bounces-2882-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5AD695ABFC
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 05:36:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A19A62876CD
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 03:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF61738DC0;
	Thu, 22 Aug 2024 03:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iwVF/m/v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F36C39FDD;
	Thu, 22 Aug 2024 03:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724297742; cv=none; b=GYRrkBPqxtIPA0QTYQjzqqDtfhdoRZfAQu6bd4/nDAGoD/AuTGOhuFumFPZuJt41dw+ei4OiFHJjNzpeKbr+FGZRHhOhTnFiV5jYzE4kuqJ8mAEVlH0Z04Rgid+1VczJOnt2u2OH2kD792kz7ZrzcevOua67SESRT8TtQAiuXBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724297742; c=relaxed/simple;
	bh=w2+Gx2llTSCIEW4z0w0ChEqAXKpMZsr4Hk2SFKO+bsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iI3CkwoI+RAme40MoIoGcxhoKjGd0vP5QezZ9UCRnKczW7S0pHTTGuTLcVD5r8t/vWlelCkGwRyw3xam76ttHkvCEJ90gQ3qOLlcYrM/9PzQNEQpM4CvBU6Mcn6KCzyu9jqAVKcWLOiamGYpyBK8mMcSDTci5PmR7bda4TfgDus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iwVF/m/v; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3719896b7c8so107862f8f.3;
        Wed, 21 Aug 2024 20:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724297739; x=1724902539; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=coYbv4PcaCiw3s7iKLGpr0JKeDXM/58rHgT2Op2hXlo=;
        b=iwVF/m/vaGMWqIWVxUKFgzwYj3eQiqAD4eAlZv77LMFB8QcYEbIyLHUIgGRnHSGZ7G
         YP7xVgISsA8iZ2rGx+WIRLmNKimlvXr2/j4etDl00yTvvVIqSuVGj4ZUM4gE618RWo+m
         mGfy+XKGiZ5jSaY3AnXCg3+XN+l09ILNbEAV/M+s+8AQrhcOlVV8ImtdQy3en1nwGuK/
         iUA+4YrX0iIkMj+LfYoAXPr+Z8pgX0gNT/Hrktun+0DhNanI2Anc+hx84RfaHFssp0gA
         2V5VN7VgB1Xh6+66RyTtFrXiomd/qW6tVs4IP/1xi12JpOGtn93H1JPWL5V0g1VEI35a
         BisQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724297739; x=1724902539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=coYbv4PcaCiw3s7iKLGpr0JKeDXM/58rHgT2Op2hXlo=;
        b=l2bKP73EePGnG6jhT6k02X96HiCXtHS0Yk6zLZZwu6PsNU8YCI4hMO6Aojj0L+buiL
         idG5H3/VghON1B+bxOp8Y0bJeg8a2IaiwkjcNttIVgfeJ/5fVjZFzvtTt4DxlPxGiAqS
         R+V+18Iaektnpw2EDKn7eBGdn+dwe/6ZWiOZGmnkDHWa64+Zp8OjUJyLAd93CVmqgcdD
         dqsiXWtrMENIIS7x1f2ZjIyi4rNuptaUpflTZ31KacI6grQvCDqmiLRZF4ZjPSc59oQx
         o5ydbzJ7RQPoWxI02lErcqpJo9V1dXuNAj7IZPxIK2Ew/ERGaP7EKXyAcUK18XJRXZA1
         D6+w==
X-Forwarded-Encrypted: i=1; AJvYcCUbbScAvFAhe0FANwt4UZk/h/b/fSoRtAatn/F8RfIc+oucjDIZqFfezqBUfxAv92PcoGP13PEiM0Ba5Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzLlm99QjyZUwgB/5UoCH5HLIj310JkUOA8y1X/4EsAUfJiolw9
	XAxJZd/jf3MCZdg9pncw9kF5tbydhg45fPDOLsfejMf0h3mO3q1cqt93WQ==
X-Google-Smtp-Source: AGHT+IHP7tOkU4byOXFqX59kqg4UjLfQGE6iQhOnMRCrdta+ni4FkcLFL3OtNWEW+YJSDoGtQ2G8Gw==
X-Received: by 2002:adf:ef0b:0:b0:371:8763:763c with SMTP id ffacd0b85a97d-372fd5a45d5mr2872795f8f.33.1724297738908;
        Wed, 21 Aug 2024 20:35:38 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abefc626fsm45491995e9.31.2024.08.21.20.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 20:35:38 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 3/7] filemap: introduce filemap_invalidate_pages
Date: Thu, 22 Aug 2024 04:35:53 +0100
Message-ID: <5bf2b0f08ec25fa649f04c0847722c6b028f660c.1724297388.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1724297388.git.asml.silence@gmail.com>
References: <cover.1724297388.git.asml.silence@gmail.com>
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
 mm/filemap.c            | 18 +++++++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

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
index d62150418b91..74baec119239 100644
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
@@ -2738,6 +2736,16 @@ int kiocb_invalidate_pages(struct kiocb *iocb, size_t count)
 	return invalidate_inode_pages2_range(mapping, pos >> PAGE_SHIFT,
 					     end >> PAGE_SHIFT);
 }
+
+int kiocb_invalidate_pages(struct kiocb *iocb, size_t count)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+	loff_t pos = iocb->ki_pos;
+	loff_t end = pos + count - 1;
+
+	return filemap_invalidate_pages(mapping, pos, end,
+					iocb->ki_flags & IOCB_NOWAIT);
+}
 EXPORT_SYMBOL_GPL(kiocb_invalidate_pages);
 
 /**
-- 
2.45.2


