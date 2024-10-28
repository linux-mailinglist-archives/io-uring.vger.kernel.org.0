Return-Path: <io-uring+bounces-4070-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 097599B344E
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 16:04:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3647E1C21D3F
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 15:04:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92A821D9681;
	Mon, 28 Oct 2024 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qYuTdNWw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACACB1DD864
	for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 15:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730127889; cv=none; b=O0PnlSLg0VMtN7r3Y8O+iuYbOMAAOkiSgheTOX5+cgEQhLy2TujSEcfwPrNh+H9KiXztTyhCqqIJaW+fJeM1a9YDhEFhFBjnaVWrNINfUhDAlCjydg7m3O3XKVRPagwvgkr0qJROLNR6roFPWj0DIhdkT+bNScLHMpCJPLFcjaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730127889; c=relaxed/simple;
	bh=gbtUQsMeQx/ihpjCfNEVueNKiMVBzIIvZfHP4mZ+ic0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/y2IWBUMpUpRCW/WH8sawOp9S37XRQWZjyc5fD/HH/EcWw+rT4Y2EMiVho89x8UGGAjRsY88lKB7sj9hRiWcwwtegG97nkAssUVjumQYR0UNtEng6fQ9eahuYf25jjD39+rkTtHPIxktYVL5gxjC6g5LDLtsGBP4w6/vpdeRw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qYuTdNWw; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-71808b6246bso2337520a34.2
        for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 08:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730127885; x=1730732685; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kWafocjdEh3Pob5N+inSXBHHJdCi0UP8BjhLCBT+Hd8=;
        b=qYuTdNWw1k4tUwU4s0qc12pSojRHVEq2y/7V/pZ4tIDt0ZjMMwiEf26wAN7LN8lQh9
         hlmxuxkg8MNXuf5+hMNfCb0w7DqOmQhbzoBnaCNhENjQwuhnc6iWrJFTIFaIoMGEcDT4
         ZC1QhyLmG1LMQgCXaXS7wjo+NFtmehTD3LvhaaZ90HFh6t11c+v5Dp/2q/LjHc6KgDyy
         s3DO+AkENyuNiatu14svFrEwMUO7EV87+FKv1zIymAdNe+/PROCmQWS+3r0V5IyMStyA
         ageY8ATbreqXrLk1Zaa1gC//bAn4u6A1TvRXEO39ZoUi61O4BKSpBzZkGmnAt2Rgev2H
         B9RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730127885; x=1730732685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kWafocjdEh3Pob5N+inSXBHHJdCi0UP8BjhLCBT+Hd8=;
        b=ebb2EbYkP9ki8DjPGJHCyRxaeE2QEmPxZDdXkTQwEE4jd/g1foPvlI4Tl12ERzkHHI
         nZiSkveZtsm3zxeOjBZ7D1Tt2ZXm8stIDVB8c148vyCfqVZfEGVwNJ+f/09J2cNS6O8W
         Q0FPvD2hSaEMjMSyCWFPYBTFSMBlH9csZABEwoX8ohDuxPRNPyko3kEE7zTd3FVYaLF1
         W9EyprUxQHnMarYK7wROnsg01J0QSjdLA1nscOyBl8/UTi5VhB6m1+f5v8YG84F8aNKs
         Vc9tRDHyf8vGKkKOMdAknAlVSgZFFlGUdjT2qSYtC6gtYsyaYqtE9MRnGTE/12cIDun5
         VP9g==
X-Gm-Message-State: AOJu0YykXF+cHfzS6NqmGTF3pS3MlHf8bVPJw+FhkhGvk2UgXya1EmNg
	poUR6xUmVMyxspjJZtBbr2VirD6aaQEB8MQ5e1fPI2Rup1UVPlMgBvYYGOBH5FgkyeWdnLoXTmw
	0
X-Google-Smtp-Source: AGHT+IF07h74mphVF++z2fvF+VTcvBgW8RPaoFZNx69QCaQ3VmHKuJdNd7hVbdbtlerhGFGFu+jBbg==
X-Received: by 2002:a05:6830:6311:b0:716:ab1b:6473 with SMTP id 46e09a7af769-7186829708amr7521071a34.30.1730127884954;
        Mon, 28 Oct 2024 08:04:44 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc7261c7e3sm1721616173.72.2024.10.28.08.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 08:04:44 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/13] io_uring/rsrc: move struct io_fixed_file to rsrc.h header
Date: Mon, 28 Oct 2024 08:52:32 -0600
Message-ID: <20241028150437.387667-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241028150437.387667-1-axboe@kernel.dk>
References: <20241028150437.387667-1-axboe@kernel.dk>
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
index 2f12828b22a4..d4ba4ae480d6 100644
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


