Return-Path: <io-uring+bounces-4105-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 313569B4DB4
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:23:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B59521F21FD7
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:23:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDB6A194A44;
	Tue, 29 Oct 2024 15:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="naAazT9i"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E591946A2
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 15:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730215388; cv=none; b=El1SfcliEnG7Hqr7bpVqCr5Ibt7trJ6sRgcx9lanCQrD//1G2SPZGegld0E0RS+joi8l2DZv/41Pdqnp2sK7hp4Y0sU2+mdJ2Fdgqrk3QssxralkZ4UN/7EttUQ1vrUbT0t/PBA3T3EMYmOLEkuiencsfbYuRt56XvwMcZg1TVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730215388; c=relaxed/simple;
	bh=gbtUQsMeQx/ihpjCfNEVueNKiMVBzIIvZfHP4mZ+ic0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYJ2h8GrFlIcAk/Ggc75EnWDaAfdFmAogyiy0cZH133ch5ppf6nU3Tj8uHtxzBoUseJher8H3DNslWsw/eLLSCXrOZKKAVPFueCO7V/NtPigOKzEi5qRPkssI1T0YOqOnHIA0n7d00LRPiHT/agxqLlnpEgW8IuLA9srHIOzKrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=naAazT9i; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-83ac4dacaf9so204319239f.2
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 08:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730215385; x=1730820185; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kWafocjdEh3Pob5N+inSXBHHJdCi0UP8BjhLCBT+Hd8=;
        b=naAazT9iqZHhEIyQnWk2PA9YzIao5ZYxuihcUC8yqAbGSI4Rx6l6tiIq7516IRe1+x
         c+BvG4vYBimT9CfKuu0SsbYKBV6y8QQshgqVplkJUXPG13yMdYWViwt2Tcdai/P31Vvu
         2h+xYPo4UhgFSXZ1LukdikO8v1FSXp6J5toQJ23WmrOFuSdBwAdjo3DVM9m+uKOd30/2
         /mq3rqhOYdXvtB2pGhvjs63M6se6z6oXgddeW4Q1ZDF1UaMHDhGHBvAREU3r160Pn1gO
         iM3ZCBlOtxJRez+P+AL2XtWRqdcKd31ujSaGOCBBD5uhnywgTq0/u5PYBdiRq8Gvg+qM
         hB1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730215385; x=1730820185;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kWafocjdEh3Pob5N+inSXBHHJdCi0UP8BjhLCBT+Hd8=;
        b=oarZFgXWGy88wz6ZVAnmZVpVVaQnCkiTjtQ9lh/g5/exLAO1KbgqAlHEKQqnqOIiSt
         UHFcyDOv9dSFVJGPVhYq19O61SQIJkMKlDsMlui1yFNaz/R/lf5+xxKtcx8ebWDktoP4
         +M1v62vubVHSqEtjESVbgmufUnpD9qM90SbOCJpP+CsamJVmh2Np5gcfbHpWh4WNqCwE
         UEgdQz4XVQM8iV27lob9crkflk29d1uUjrDLg0QfWOwcsP8W0utjyiNT5l7uL1CvbKe4
         8nYc7V7090k0XUR/OF8maRh78j0y+lDilDCKupeYxsbQNn7a5VRSnttVaN13wrDG/zKX
         gXYQ==
X-Gm-Message-State: AOJu0YyQcKN+D0GBS0gv2fbmRsqMkSjW2rHHF2Rou8zWp5H061ozWNY+
	AdJ01LC5CXuqm20tyjjy4uVGsAjNZIxRFyOE+cDTJOfSipegulKAEteyflyDSXFMl/jS5/wJLH2
	/
X-Google-Smtp-Source: AGHT+IEF57D2EsrbgHFGL1E7Ym3krPfmxeP8OuzrYyL7wqJ1uJgXkjmHDelNbiqPolBWIslX40BYhw==
X-Received: by 2002:a05:6602:2c12:b0:83b:470d:bcdf with SMTP id ca18e2360f4ac-83b470dbd6cmr439571339f.13.1730215385093;
        Tue, 29 Oct 2024 08:23:05 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc725eb58esm2434160173.27.2024.10.29.08.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 08:23:03 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/14] io_uring/rsrc: move struct io_fixed_file to rsrc.h header
Date: Tue, 29 Oct 2024 09:16:31 -0600
Message-ID: <20241029152249.667290-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241029152249.667290-1-axboe@kernel.dk>
References: <20241029152249.667290-1-axboe@kernel.dk>
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


