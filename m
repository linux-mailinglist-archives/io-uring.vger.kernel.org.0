Return-Path: <io-uring+bounces-3077-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D6F6C96FE32
	for <lists+io-uring@lfdr.de>; Sat,  7 Sep 2024 00:57:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0EA6E1C2473B
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 22:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 985B315B0E8;
	Fri,  6 Sep 2024 22:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eh5RCxPc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D258A15B0E5;
	Fri,  6 Sep 2024 22:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725663423; cv=none; b=eNlLvY8C5GGOvfCaRN+3YWYy50u5Mf2pvAnFZRQrEsineY1k5ikdxibo09no2HA7FjYWsHckcQBHP7qYNraYNjJXibR+6+yAak4E3pEZQAVsPaScRzGzug0+toikdrab5eWe00FBYR2URjq8MSzsatqduFPc0g+eDoinjoO4Eww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725663423; c=relaxed/simple;
	bh=JrAOgMM2iAIABQmCU3ZV4QTcl0u9rm5SIWFUspGZWXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1KNswRmmUDPi1pz37w3twHRwj6Prq4E2rh9d2MKXNZ1L4e3mTyGAV54HwXrP4hEiR84Lny1udZBVnck+z/MV5FUh8eqoAvVoKYdW7GP45xZ+eSJk/8AH9v5xB2+MU86Jn/7xNPqY5Aqhjqytm1tXgZpP1Ss17S5z2vzWlqYmr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eh5RCxPc; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a8692bbec79so346671966b.3;
        Fri, 06 Sep 2024 15:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725663420; x=1726268220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2XjW/1z5M+e5L1HlSBo37JIC76JYeYPBxc+HZavMul8=;
        b=Eh5RCxPcAWOksrt+up8VqwN5sKhrFP9opupmWubBNT/yNN/IeXw4XB+6sW2uwMeu7k
         UiR2jcEHYmps69zK3EY7RrUO5UX8pvr4jJB5MUcvdY9BWpHzNCYs1jKn/Noi9vJygVIT
         65QANLR1nwyaMOlk6REOYtrvIMiYTzBEQCevzVIYAdKZuDvqMScxV6yqTHe57O0Hkqjj
         MqODOfdJyAnPUt7mFOtE4RqImdQMwO2v4cj9abJtiT1SbPrzF96AiMkxjQAlBCKY2YCM
         4V49hlgwfuwds4TMVP0c4m64MRli46JKkkqh0woLREDigqAvDHVVjZfBpGNvAZbn9Hcy
         88zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725663420; x=1726268220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2XjW/1z5M+e5L1HlSBo37JIC76JYeYPBxc+HZavMul8=;
        b=qjskSgRgH0SQA0bFQnaap4uVsb3uSK95tlE3/pHnrwTykyRCl5HVyn1xIII8YJDtni
         JBNAwrjXnTMyVYIzzg4TOoPDlaLbPIDrNYfQAn8QCe4SabRfjcmhULWcEyzIc5vWo2P4
         +UHqgn2rCbR73a9X5BGHzYcZPqoJpa+yUd1wm//xIMWoRe5MqCDawtruUlnlLcUf0G/X
         qh1NRmzE4RGMSuSbQXTQtG2/qbW+ReZp/SXtusCg/kz/tTadv7j3jIGMgiZZPK7s+e0G
         bj4c3fEtDkL2u65vbtdbxApGSmNUeUcC/6y96GU/rwHWJON8bjXox/lMbM6/smv2JAIK
         xCRw==
X-Forwarded-Encrypted: i=1; AJvYcCUXm1TCKXFJDxLMdjx6QuFZNMq3kRYUea5H9ZtUafboO8ZMJnnXJLP3b0WgJzaxMND5aDJgIlPcTqB87g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxI4QKPpyUuc8m455B1l08yX67U/68c457momy5qyVeriLWXe1B
	MwUESiLNq+1xUqUil9gzYfGQQvOdIbRE4nhJ7Z26mbUjpk2hOqYde7P2E9Zd
X-Google-Smtp-Source: AGHT+IElFIAZCS4JhFrJt5ylxD7009i496r/jtdVHC3NBh65yo7l8qVQPQsC4GCBaH1S1XbN+0jHTA==
X-Received: by 2002:a17:906:f59f:b0:a86:b32f:eee6 with SMTP id a640c23a62f3a-a8a88858b21mr338191766b.54.1725663419302;
        Fri, 06 Sep 2024 15:56:59 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.236])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25d54978sm2679566b.199.2024.09.06.15.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 15:56:58 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v4 3/8] filemap: introduce filemap_invalidate_pages
Date: Fri,  6 Sep 2024 23:57:20 +0100
Message-ID: <f81374b52c92d0dce0f01a279d1eed42b54056aa.1725621577.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725621577.git.asml.silence@gmail.com>
References: <cover.1725621577.git.asml.silence@gmail.com>
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


