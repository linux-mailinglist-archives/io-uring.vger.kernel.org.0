Return-Path: <io-uring+bounces-3021-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D43F96C005
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 16:20:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EDA31F26509
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 14:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 900EC2575F;
	Wed,  4 Sep 2024 14:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a8SvQuC4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05A91E0B9C;
	Wed,  4 Sep 2024 14:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725459471; cv=none; b=QpB9K5jCw71Cobmvq1qU+Tbm9zPDD3GbZm9Rbd+A2NpjNNtMpG+yU2Qy6cDHcsP/X8UQjZCbJnxE1coiUmb8n28cY4FJm0gLVqtDT7L06hbvZoDY8eNFR1+gsISb7TdZD90Kc65mgM3o178UlKfjWE8tPBnjzJJuNv2F60aWMJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725459471; c=relaxed/simple;
	bh=JrAOgMM2iAIABQmCU3ZV4QTcl0u9rm5SIWFUspGZWXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAfNyCXi1FDGgK4cmwdtuSgPt6aRRnAU9Uvzwt484Y2EO55lonsyPJuvB9FZgIrrxwwoPhFV9B2iMJepgX4IsS3sNMkw1iY4bqVK8DfhFX6av2XIOCpVp71/4gmscz+urrZToyaVVS1wRfvM+5uQbvQrF51Z1Y4dM2CxfbXVrPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a8SvQuC4; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a86e9db75b9so739471266b.1;
        Wed, 04 Sep 2024 07:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725459468; x=1726064268; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2XjW/1z5M+e5L1HlSBo37JIC76JYeYPBxc+HZavMul8=;
        b=a8SvQuC4AM1diZaMBfDKvheL4ygM5HfgLrAQTpjhmuWpypp2mcE48MQ4chmU1hpwxb
         FpVGiHT+56Dz/EMgnPYdlyRT+LtoFutx9O5N6cOXA4P8dIJ/YWlBkOk8fpAe/HPOeZg7
         Y+r2Ak5lFUf1WQGZMorHLnJcRjL9AZii8YkWP9UalvMzM+tENiXKEcmEIdEH99fnbY+1
         ZP2Vwq5zhIxJB/921wOTpx8YDjt5/hbNuhocctg0Ch3S/pQF+7yD52zzXeLjnJy0eyfR
         dh3pmtSGet8zG7Q0TJXzQ3Vp4VZoy/2VY5CEcesa8eCAo/Yq/D7qfptyFFMBWPSTJNDw
         F6GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725459468; x=1726064268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2XjW/1z5M+e5L1HlSBo37JIC76JYeYPBxc+HZavMul8=;
        b=xEJ+5orNtTw5rAvXEVthYYrDdBlylNtch/Xjt8Ho6OhGDvPi9O1LSeWSLLQgDrEjiX
         6oVWR3s7UiFyJV9Iud6k0eugbiptj6n96485M8so/l9za5jXYyQeVhm+uAlV0r/TV0/I
         II4f8D9h8+s2AtygpoZ8xCckxhujMMOZ6TXYPwbaxaBzfirPbF0qdOqsUjjkzW/S3l//
         N6GQSo7f7EroYWC2dEtBQf3LyYlfVHhZXEcqh7N00RXr7zLBnHNHweghim5jpTCuiIHT
         LwYRQF+j/ZgpU6moF93bKn7NstDvts0TFKi8qPqT44bIIwErRiGbwd+foB4ya/RZ5CXX
         hKdw==
X-Forwarded-Encrypted: i=1; AJvYcCXPemvetmqfrSdNn+jkAwws8KVrmPsKpadLjJic8z66F+w2tRbpSz2ldCXYqusfzSBz+ZlcjY4ESEhgwA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyIYjE1kgU0YmFhHCcvNtIPYg/bdjoGsJGTDtdFOItKjQ9/iy07
	JTH27+0aIXQspcGmvTEOORtdFIckjHvQfTTsCRQOBR1Qr6mljR/oMahIJw==
X-Google-Smtp-Source: AGHT+IEYnlE2jE9AeI30LzbXw8Pi928CHHZ2cfjLj3+Sl10dnyCa2YAie/Zh3flyVcceULOyKSQ8nA==
X-Received: by 2002:a17:907:1ca4:b0:a77:c080:11fa with SMTP id a640c23a62f3a-a8a1d4d2201mr484969666b.48.1725459467509;
        Wed, 04 Sep 2024 07:17:47 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8989196c88sm811160766b.102.2024.09.04.07.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 07:17:46 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 3/8] filemap: introduce filemap_invalidate_pages
Date: Wed,  4 Sep 2024 15:18:02 +0100
Message-ID: <f81374b52c92d0dce0f01a279d1eed42b54056aa.1725459175.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725459175.git.asml.silence@gmail.com>
References: <cover.1725459175.git.asml.silence@gmail.com>
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


