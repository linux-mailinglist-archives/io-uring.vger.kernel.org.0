Return-Path: <io-uring+bounces-4114-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 990999B4DBE
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:23:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D448282B4F
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB4E4194123;
	Tue, 29 Oct 2024 15:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="111bQjNn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF97B192B77
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 15:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730215401; cv=none; b=na5uP/I0T59bkdwfpBn3Y8j9JsG6egr2pLy0Fwv70KeDIj0yCDndmD1Lky393fXgf15gsHf+R2SsqlB9zm8wHDlZZLQIZ7/wMRZRrAt9GgusDOJHDx3Z0jlwvm3xFIZdtCTIMHE5Q2lH3wY8cvdBTstm6JdJ1IVdhMDhp/L+778=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730215401; c=relaxed/simple;
	bh=29WfLfchpB31ecsDmbLXfbvXZ6Z5zdmNqGCC0eIaSj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1x7smR8LfG4Qh3GvR7o5BIg45f2s6xVtqeJgvZyCH2nPBrdFjYAIwCs2+sTCKil6xxvzv5LHDj8YaBn7356gTubF0M6wr4jX5Q//FpuYbwbQ8TMUV4gTUk0j+mTA9eBwPZsYBZeQuLXc5FGu4BM6SL6vCnjLU4uciYZdS4PSEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=111bQjNn; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-83a9be2c028so207848239f.1
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 08:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730215397; x=1730820197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/iw1ID0xXFiXgPx+FCcIfK0kokYS+rNNPARBrPnOuXs=;
        b=111bQjNnuixFZrca7czsu8UeuuH4m+apqfYKfCcIysN86B1AS6enMt4SDusP9VxV3V
         qjGVhpg6tgmPW9zGBUMUbNXpNaE7QV88dA8GriIcBZ80dWFsCgUsLZH1vt4iXY3gbWdj
         0pa5Hiskmdx8aUzjee1yS9XlKENM4CICpwG+eYPrvErB9lX0y6lYN0HAe0aSvhHqB6rT
         QUHIQacI3PngXxL1oK7hIrJZhK7BbhLvMZ/tQXS+PikU6RMIqIh/3N9RrhBkR9uicH+H
         vG0zTameYipzOE41MTFcq3mpgKGqQ51B+VcICoMOEps394agqetndVMzNaXxQD5oVQe7
         CFBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730215397; x=1730820197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/iw1ID0xXFiXgPx+FCcIfK0kokYS+rNNPARBrPnOuXs=;
        b=ZmoZcRnYFRZZBnQbzdzOjKPrmH1cGWoMXbyWt/2pBOVpkRPHe5UHkfJS0xVFT92HIa
         SfR+n9rUvvVtcunp+Xg1AiAdMEeggEcBL+pPm5LkqMReVq/QpdogLeLn1gHechsQ8fuK
         HuULj7Gf6sYxdW3/SV1Uiayl+oZI7hgH7Sgl/22lVGAaBMugek4N270QPHFQU5Z54vkb
         buOWeB5nKwetNUO7JTCvXU6e9dua45YRqVGo9MgE3m3coBI8X0iPZEE/egllu3kj4Zha
         /ZwmAkasCsQsA0qtgMCoohJfVQH/HauQtfTnYI/Ar41ziyPg6CAARrVq0uViWZp3ghXe
         VuYQ==
X-Gm-Message-State: AOJu0YzhVyAypXk+ORb9+/YcfPBTSGEBVhXhSwMPIYe9hc/c/kzUO4N4
	5xXVVghNqu0+bAJGVgEGJ1nNPXb+8kNuXv7p3HaQrSlkTKHSDMT7vUcLpsXYE5FHj8QLXirO2ID
	Q
X-Google-Smtp-Source: AGHT+IGYTzDxxJwQwC+RBGI8hM+oO5HDBIX1rvhOQFCKWfAYOC+KBWaW2+/fbu7HO2fw+2h+qbGldw==
X-Received: by 2002:a05:6602:2b01:b0:83a:b7e8:a684 with SMTP id ca18e2360f4ac-83b1c60b7d9mr1461007939f.11.1730215397502;
        Tue, 29 Oct 2024 08:23:17 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc725eb58esm2434160173.27.2024.10.29.08.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 08:23:16 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 12/14] io_uring/filetable: remove io_file_from_index() helper
Date: Tue, 29 Oct 2024 09:16:41 -0600
Message-ID: <20241029152249.667290-13-axboe@kernel.dk>
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

It's only used in fdinfo, nothing really gained from having this helper.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/fdinfo.c    |  4 +++-
 io_uring/filetable.h | 10 ----------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index e3f5e9fe5562..9d96481e2eb6 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -167,8 +167,10 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 	seq_printf(m, "SqWorkTime:\t%llu\n", sq_work_time);
 	seq_printf(m, "UserFiles:\t%u\n", ctx->file_table.data.nr);
 	for (i = 0; has_lock && i < ctx->file_table.data.nr; i++) {
-		struct file *f = io_file_from_index(&ctx->file_table, i);
+		struct file *f = NULL;
 
+		if (ctx->file_table.data.nodes[i])
+			f = io_slot_file(ctx->file_table.data.nodes[i]);
 		if (f)
 			seq_printf(m, "%5u: %s\n", i, file_dentry(f)->d_iname);
 		else
diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index 29edda0caa65..6c0c9642f6e9 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -49,16 +49,6 @@ static inline struct file *io_slot_file(struct io_rsrc_node *node)
 	return (struct file *)(node->file_ptr & FFS_MASK);
 }
 
-static inline struct file *io_file_from_index(struct io_file_table *table,
-					      int index)
-{
-	struct io_rsrc_node *node = io_rsrc_node_lookup(&table->data, index);
-
-	if (node)
-		return io_slot_file(node);
-	return NULL;
-}
-
 static inline void io_fixed_file_set(struct io_rsrc_node *node,
 				     struct file *file)
 {
-- 
2.45.2


