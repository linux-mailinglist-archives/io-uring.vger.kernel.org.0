Return-Path: <io-uring+bounces-3341-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16FCE98AE98
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 22:40:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA7DE281964
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 20:40:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A21621373;
	Mon, 30 Sep 2024 20:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="29f+CWvV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A58199E8E
	for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 20:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727728834; cv=none; b=Z8lOVyb0Pp1g7tT+9YVkuu55o2D4jFF0AnzOYedrsRgH8YFmLwDjLfUs+mBL6lhUFl29SlfGrjTp8HKuFvsY+0MF2trpLlR66hCKN+oogHEZprirH76eJx52BNx3K1m5zL4AlOBmLsO1JJhKgGD8DAh2s2tUYYc9TmUVnR/wzhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727728834; c=relaxed/simple;
	bh=lp05/IfRAcCB864MdOpi4/54CxOQa2AO+8OgPS0E+sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rdo+muu2kcPK+9Wk6u3/dTuKt41efqnSOZMJO2ZoTiNVaFmuqq7bhzAnKf36+I1xsd8HN+muGPnlszaXJjd5Zva0VfL9XL8fxPZTy/5H2tEAm9SlMq+omyI11Ebe3IkUwMiJ1act3m+UnYxwboEoemYl/i7a5v0j1+zl6m0L790=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=29f+CWvV; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3a0be4d803eso15928555ab.0
        for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 13:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727728831; x=1728333631; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=noqafkmXQlFniP1vN6HSn+4V1mhVCqCJBxND01DbHbQ=;
        b=29f+CWvVE/bEf1g8FPGEK0ypJnLe5gBfZW21AO7WNZZNfuGIBqkjHx5EVx9o3+A2Sn
         Jm+DunWserPCgPgF6ocvtVFxnujffjRZq1T8My1g+2VlrMs0zYT2SSbECpie6mx7zl39
         GaY2SUech9qfxW6I7uDbgrgHaiKHQlbo8LSROZ7g5i6Oa6oB9Zs1ZNWs7Vn5M4vaiqa2
         ALz4JNijuj2il41deoxwhr+9vtsgpy/fQIBwuS56hUiyd8GDsTwXhB81p+dgv10JN5Pz
         PWY1a3SLRhG6fJ5qRUhGEZvbeGGF7QuQE2HKs1LcJS+DHQIe20+qNsI1tki9BWWHWaw6
         K2EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727728831; x=1728333631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=noqafkmXQlFniP1vN6HSn+4V1mhVCqCJBxND01DbHbQ=;
        b=UNzUe3AyjyaZfgczJx8eHQGQAZ1m9pFMd4ySQU0V097bpAhtuuGNrhzE581XMX45Bi
         8yd73mWEbz3qCZ7kJ9E10FsaqWqPdhgS9o2ifBWSBBYKQYkhwS+gjsUJDvKy+tZyPnI3
         Dixpb46J8ErGp6FX2E+FqFLstIlTHGdC8jBGtFDK0kOmJpeJKo/C0+EE/nS0p8J8TtQr
         dYoixrpmDCjfpCMtBvZpup64qbk0kEZGtaiaviqANf0L3Le/Wy1GNCofpAqzKjpPEt+G
         XFtrUf/JwnuCfSfRI8fLUVaCYpJj73kbYnSg8AiWbO0x0zQmGk6oZK9ldGkvr0pK9vKK
         ZUzw==
X-Gm-Message-State: AOJu0YwIy4uvX/MSMgD04rYRaYl5j2nSRT1ZY+B4A+/mw1nRTnEqhyXo
	Es1HINcV+hwoOJzXXfwD5YWd+JnjsIbMgYyakjZLL8o2lgupxEyN7dyhG93JEoyXw1RCl79lUcU
	iC3k=
X-Google-Smtp-Source: AGHT+IFJdxnYLOehQ3fMkpTkpFWOLC2rKbpsaVJ9ZSUAahGueAdWlU91yc5H5ob9FpjxFimLfNBIAQ==
X-Received: by 2002:a92:c266:0:b0:3a0:8ecb:a1dc with SMTP id e9e14a558f8ab-3a34517fac8mr114447175ab.15.1727728831070;
        Mon, 30 Sep 2024 13:40:31 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a344d60728sm26430175ab.2.2024.09.30.13.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 13:40:28 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring/cancel: get rid of init_hash_table() helper
Date: Mon, 30 Sep 2024 14:37:49 -0600
Message-ID: <20240930204018.109617-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240930204018.109617-1-axboe@kernel.dk>
References: <20240930204018.109617-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All it does is initialize the lists, just move the INIT_HLIST_HEAD()
into the one caller.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/cancel.c   | 8 --------
 io_uring/cancel.h   | 1 -
 io_uring/io_uring.c | 4 +++-
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 755dd5506a5f..cc3475b22ae5 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -232,14 +232,6 @@ int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
-void init_hash_table(struct io_hash_table *table, unsigned size)
-{
-	unsigned int i;
-
-	for (i = 0; i < size; i++)
-		INIT_HLIST_HEAD(&table->hbs[i].list);
-}
-
 static int __io_sync_cancel(struct io_uring_task *tctx,
 			    struct io_cancel_data *cd, int fd)
 {
diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index b33995e00ba9..bbfea2cd00ea 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -20,7 +20,6 @@ int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_try_cancel(struct io_uring_task *tctx, struct io_cancel_data *cd,
 		  unsigned int issue_flags);
-void init_hash_table(struct io_hash_table *table, unsigned size);
 
 int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg);
 bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6685932aea9b..469900007eae 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -263,13 +263,15 @@ static int io_alloc_hash_table(struct io_hash_table *table, unsigned bits)
 {
 	unsigned hash_buckets = 1U << bits;
 	size_t hash_size = hash_buckets * sizeof(table->hbs[0]);
+	int i;
 
 	table->hbs = kmalloc(hash_size, GFP_KERNEL);
 	if (!table->hbs)
 		return -ENOMEM;
 
 	table->hash_bits = bits;
-	init_hash_table(table, hash_buckets);
+	for (i = 0; i < hash_buckets; i++)
+		INIT_HLIST_HEAD(&table->hbs[i].list);
 	return 0;
 }
 
-- 
2.45.2


