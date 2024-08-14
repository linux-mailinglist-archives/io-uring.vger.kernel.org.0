Return-Path: <io-uring+bounces-2765-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C38695194D
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 12:45:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28AA02812C9
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 10:45:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 233451AE875;
	Wed, 14 Aug 2024 10:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MrbT4Az/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6970B1AE86B;
	Wed, 14 Aug 2024 10:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723632329; cv=none; b=Fd4yrYpOHyfhJPhmopKISDAxu1Jyp11ZEuaJJ4z8Q2F+XLUr8ZbBMbFrdi6cSqWWsTGYbtG0bJxTRavzSq1H2msPji7ZlMAT9++snjhaNm60nqLxc6AZaqSs+pwiTmEo9yJHFaSewthLjz3mzX7zgzq/nlRlKo+N9GyHmvoXKts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723632329; c=relaxed/simple;
	bh=w2+Gx2llTSCIEW4z0w0ChEqAXKpMZsr4Hk2SFKO+bsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHHBjHdqMVqiUfYa7y+0/LfkhhqlWIVdNf8QUIsI1UtZPwQ1DYHi+rOCVngOqZdjtc8dTkCat3nXURIHBRyD9jmGIQvA2RmMbg6tK5mpHigsU3JKWYh+5R7T3BkK0/AgFPHOdcsqkCFStWovCRUvwFjWdqBr9R0FDWVoluoPaP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MrbT4Az/; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a7a9185e1c0so498025566b.1;
        Wed, 14 Aug 2024 03:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723632325; x=1724237125; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=coYbv4PcaCiw3s7iKLGpr0JKeDXM/58rHgT2Op2hXlo=;
        b=MrbT4Az/JZROeAovtsLxW4rgqg1yX5ADvPTWssGYum2DsMH75V5jnEoLWKEvGAkYrc
         aIHJwBy3+FStC4sq8E5VGUnY0RQCoApod7FfuDasUgzPR6invPy8Aqqd4SfLnlmMRKtv
         KV2ssW238YDa+JlWUMLJtmXOJPdzr+M+uQOlM95cwHaTqCIjhbGkA0w46t7J9YGJEaha
         Dh27elv1GZOIoGU2HTQZclUaM9QTfQgu4APTUjX64bjiVdsf9V7pGcKpR2PIisEv6CzY
         HFyQtVrPzAdJCoknFMxl0vXvQTDfzsFPWBnNfeHpMJW6xtW6Vkv76jjcykpyn8PyaM0Z
         EHrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723632325; x=1724237125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=coYbv4PcaCiw3s7iKLGpr0JKeDXM/58rHgT2Op2hXlo=;
        b=fNi4tEGDNBOqdamzVbEsJZzegd1YxYSsDfhNMiIj48ONzytBWl11csfTPkPnwLYk0G
         bkfkjrkMYsb+hcvm180/OtGAnoQpYZpoE8SwO9tZrgObD5BJUqYrqyGC+V2y0s7U4S2+
         Qm54a8GrTkRdiR5PosrmCooqqVg+7bDhTleSVBwxvpgywabVGgzvqtVcSxfnzE1HS7J/
         Ue2l5ae8owrEJnFQT8upWpTSJoexS7RKF8h+UgoBFSFbTTbD2PgKyBy92DsyB8XWNJ7z
         SmAmUKUU8OywAYhYh728sIIYe5O01gBynF35CsBfHX67GU/fIRpCoQItvpVaeuCYpCGQ
         w4cQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2Lnnz3/1xFQYgrzieYUxcMBV78IZz/RUjR6BlfF89XHBLUqOevRVZK7QdBoiUeaJhRWL7IOzaDFZVJeyHA0Xh51kQ2x+k2svov9o=
X-Gm-Message-State: AOJu0Yxoo7L66hD92jVzZBquKX/A1hdTuN9Ubj+1emJ57yN1hKHtPHf7
	eSU6SzO41/oTE5MBAi+c2MeTQKVQdNDX6wTHrPxgFJj/I8+0Y7Z1DMc02xxs
X-Google-Smtp-Source: AGHT+IGfriIepvv++2PrjZ9Q9AjLepaO3ymcXMwFRj3SpDze6Sv3EXtnN23wF2rBhfZ8mcwRYC92+g==
X-Received: by 2002:a17:906:cade:b0:a7a:1cfe:a262 with SMTP id a640c23a62f3a-a8367009c0emr168159466b.55.1723632325229;
        Wed, 14 Aug 2024 03:45:25 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.251])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a80f418692asm157212766b.224.2024.08.14.03.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 03:45:24 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC 3/5] filemap: introduce filemap_invalidate_pages
Date: Wed, 14 Aug 2024 11:45:52 +0100
Message-ID: <fd078cd48528a6825ec3b158ffc9c09c6b1dec3c.1723601134.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1723601133.git.asml.silence@gmail.com>
References: <cover.1723601133.git.asml.silence@gmail.com>
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


