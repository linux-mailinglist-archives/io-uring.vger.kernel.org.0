Return-Path: <io-uring+bounces-4049-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB8399B1B45
	for <lists+io-uring@lfdr.de>; Sun, 27 Oct 2024 00:24:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B7592827C0
	for <lists+io-uring@lfdr.de>; Sat, 26 Oct 2024 22:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 139EB10E5;
	Sat, 26 Oct 2024 22:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vCBDDfTP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C632A42AB1
	for <io-uring@vger.kernel.org>; Sat, 26 Oct 2024 22:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729981440; cv=none; b=BOvFLKh4DFDftlqKZOfai8GufAQSUqchXdq2TZ/hnrVEMtY4/eBqvhUtw+7RHC9pQOeYCLa9oHbY5uOW0iykyfGMdE5rdUSINHf1OuMJE/sgPLPqIcVvylS/Tk/vSHY/TggMU8Om/or/dIb4xC5bqe+Inkib+915cPV6Tp6pgaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729981440; c=relaxed/simple;
	bh=RrDXVmFVz1DJrLc0BSNRTXBdkG6HbImKxPgyJQkLKTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEV1VyhYUEU3/gYFfrG0Be1XBfZdyxtfxNjAxhH8Nlgo2+8iQFUVhYFJtTQlYxoQAJTb+k/1C6nSLwqxx08kK/3qBvWqhTHn0jeRXestdB6E6IKGyw8HCHDI/vNNYGjDRD9N1/5osENTDjiQ/7JMh+xEI0c411jZe2iDJSz8Q98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vCBDDfTP; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-20c693b68f5so32310915ad.1
        for <io-uring@vger.kernel.org>; Sat, 26 Oct 2024 15:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729981435; x=1730586235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RwJIDvb53GRUtCJpMgJ66hIkVw8Alhl/3YCSjG18yfU=;
        b=vCBDDfTP4ysshkAbKQaaBFtt79fTHxTELlex1+A7jW0E9PKArNHt9UrhL67s1bSQjZ
         54av+8kXj4KWp6m0dMak23b7CFMywJsAvcDT70hynoVhf0mctBw/g3feer5moKHjKl7n
         eX2ARPfs/5iHq0M8ZPciDqigpjCOddroPEamk5Y2J9zW+CUceRowWhQSmDARtcc4STvQ
         jba3Mklp/cn354wATYiEDRWnnGxKQPHPiG9lchgc78eQib4wnKzILCQlCG/+arVojZBk
         FuGfFvWbDyvb1NemYfYUa/vzAS2HKXmuw/BN2SxL0uTiQprAItNYIF1NMJTM0e4fbsJQ
         2VOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729981435; x=1730586235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RwJIDvb53GRUtCJpMgJ66hIkVw8Alhl/3YCSjG18yfU=;
        b=di/mkN/48uWVJTpG763Dt9XaxCPnZuoVcRX5Pv14kJdM2iR0WeSy3M3MV1gYIx3N2N
         2tEAR863/3EME1vLJP25L/INWiBCwHkTr75wWJtidUqhF8MTEUqheWPcPoJ2QftLFmuw
         onRhvZxiTAj7WhJqFP8SHX/mmQDAIeyzVNJm14k8WoXSHmls/ZBvQdBKR13cujV66x+k
         +ysGhAl+jtk3tRJyWj94LXXJvUqyaAjzLFaSF5vmnzgulxHCy28ghuc28chHpHXFIhrn
         z2A+lps/WxTm7TfhoPPDz3g4kVdBjmuqgbt6eXXDghG1IiLmNgdA8lwLi3gOo6xSBb74
         BykQ==
X-Gm-Message-State: AOJu0YxkywWn8UggYX1VWNAP3g13MukjGR3j/2BdMtDcRN888QzPaYkl
	BW3V2cEJOuKRao+mIUr9FKmE8LlAqIyXoXmEdMjIokbLHEMQ9nnS+TvVdr+1BB1TVFHwvieGBe6
	u
X-Google-Smtp-Source: AGHT+IFxKLQUiTqYGxd/Zqgdn4dbMwlRysDo6A1e8VwQLViXxmX3CB1yMn8I6wTrffQLCeOgn+jvCw==
X-Received: by 2002:a17:902:ccce:b0:20c:f9ec:cd9e with SMTP id d9443c01a7336-210c6c6ef7fmr52715115ad.41.1729981435293;
        Sat, 26 Oct 2024 15:23:55 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bbf44321sm28134705ad.30.2024.10.26.15.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2024 15:23:53 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/7] io_uring/rsrc: move strct io_fixed_file to rsrc.h header
Date: Sat, 26 Oct 2024 16:08:26 -0600
Message-ID: <20241026222348.90331-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241026222348.90331-1-axboe@kernel.dk>
References: <20241026222348.90331-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's no need for this internal structure to be visible, move it to
the private rsrc.h header instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h | 5 -----
 io_uring/filetable.h           | 1 +
 io_uring/rsrc.h                | 5 +++++
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 841579dcdae9..b61db1e8b639 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -55,11 +55,6 @@ struct io_wq_work {
 	int cancel_seq;
 };
 
-struct io_fixed_file {
-	/* file * with additional FFS_* flags */
-	unsigned long file_ptr;
-};
-
 struct io_file_table {
 	struct io_fixed_file *files;
 	unsigned long *bitmap;
diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index b2435c4dca1f..c027ed4ad68d 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -4,6 +4,7 @@
 
 #include <linux/file.h>
 #include <linux/io_uring_types.h>
+#include "rsrc.h"
 
 bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files);
 void io_free_file_tables(struct io_file_table *table);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index c50d4be4aa6d..e072fb3ee351 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -40,6 +40,11 @@ struct io_rsrc_node {
 	struct io_rsrc_put		item;
 };
 
+struct io_fixed_file {
+	/* file * with additional FFS_* flags */
+	unsigned long file_ptr;
+};
+
 struct io_mapped_ubuf {
 	u64		ubuf;
 	unsigned int	len;
-- 
2.45.2


