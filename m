Return-Path: <io-uring+bounces-4080-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B256A9B3459
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 16:05:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76518280F92
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 15:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 705491DE3A4;
	Mon, 28 Oct 2024 15:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fn3FPivD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDA31DE3AC
	for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 15:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730127901; cv=none; b=LuEFCNty5rE3gvHByhIVCpC7qsnIUgsqH5nRjdWt/lIKYdXXQh1knayiQCqaFoSbgA7RcVi5bmrOxl6FtOgrlYV/D9NKEp6bF3w001MNVwhpZzIBU09Ly1LIm0VPeZOQYdh7GpDrU8Jmmjey7wqZqu9ZbBxeFRH89Y3orKJQhGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730127901; c=relaxed/simple;
	bh=pkYcWRssBfizJinpMOsKyjVzc8YHB6Nvuut57LJm0pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArZlp8AujCEaf4KPENOn+UDx8D6YnwdFgOkcHgXYFb/Yz9NYnQxPfmomQksmdom1BNy9nGmCmfjhEv9Zk1nRP9BHjswH37e628ceNcYUUFE6wEQgVryn3yf8JA+QrbB/daWeMFMZjQY+jyxYQ2m+L8cg5ymFf4gO83/S5qOIR0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fn3FPivD; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3a3a6abcbf1so17541585ab.2
        for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 08:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730127897; x=1730732697; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R4ABfE88V2XiWFzjVdtoTBBUyKwlbamhOB0YbTSimnQ=;
        b=fn3FPivDrWM85jQvt7yBpxtSFsnQpRC6WG4YBiA8td4bVnxfdo4FfE3lEmEm3kmTlF
         Qk6NXNuj1UJpdMDkIACfYuIrnh0W0wNJSi9ya3EOUmyhnH1iks4gFz7VEgYmCkyHyRx/
         vGCxbF2ICntv/3K+YjH2rBbbOGoiiilWMneoEKITXtvGOSyqtsyE42GV/o+crA5LXPeL
         NS67/p0Qsn+nkQ122UZa/pHHbLXFk3cc/r/SAut++Y3IYk+nxExbHJyG/7a1DBOkPewd
         z7+yciPNZQwbHhmfYnIuNcmgW6ohC4+WaE6NA7JS+9IAseM/iUk6IO6WKNHJ68R19q+/
         AHww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730127897; x=1730732697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R4ABfE88V2XiWFzjVdtoTBBUyKwlbamhOB0YbTSimnQ=;
        b=OCyLiuXWPUj2TepkSIpos0+I9gHO1xklwOElL4q+DMG9a8WGeaxcIDiF/mG28q9P33
         il/yWeumSm7TLZzo0gjNZkr8WZemksW5pb77UMwcNboN35JsD5z6gsfoJ3ZfbZMMG9g7
         S2gGb/gldBIxYDLPo5rI3y+V3Khes6YCCWhGefawI3o8/kANXtMxYvVLtZnhgFQIUe79
         Ob9rnaziv0xvQFKFaPMb9gR44/JOofNjL/UVSl9KwYpRxq6HFkgsBOOWZSYW9AwZP0dV
         G10glM7eWo+2/RMucMT/6iFazNYHesYlZt+kgxnUw1LU9HPPkqUxfjX9/0yjSrp0Y1Pu
         CtYQ==
X-Gm-Message-State: AOJu0YzwYFv4sLsq3DFkjQxfEtdldo1z1iNeyRKdD9UYo5j3N7997/Bm
	FxPrsne1C/zVo+5sJHjH3yiioTrwv6gul5qFmWhTVI0zREFKkdli7vwESHqojGxL7abH6kzkIA4
	Q
X-Google-Smtp-Source: AGHT+IEZ4HRSR4Vtbj31I0C/aubFKUmJNXF2IXtNxrqztTPR+46jqMcsgMSlm7ZcBxoIp3ZVralPrA==
X-Received: by 2002:a05:6e02:1d85:b0:3a3:445d:f711 with SMTP id e9e14a558f8ab-3a4ed1c2ea6mr83401225ab.0.1730127897604;
        Mon, 28 Oct 2024 08:04:57 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc7261c7e3sm1721616173.72.2024.10.28.08.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 08:04:56 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 12/13] io_uring/filetable: remove io_file_from_index() helper
Date: Mon, 28 Oct 2024 08:52:42 -0600
Message-ID: <20241028150437.387667-13-axboe@kernel.dk>
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

It's only used in fdinfo, nothing really gained from having this helper.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/fdinfo.c    |  4 +++-
 io_uring/filetable.h | 11 -----------
 2 files changed, 3 insertions(+), 12 deletions(-)

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
index f68ffc24061c..782d28d66245 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -49,17 +49,6 @@ static inline struct file *io_slot_file(struct io_rsrc_node *node)
 	return (struct file *)(node->file_ptr & FFS_MASK);
 }
 
-static inline struct file *io_file_from_index(struct io_file_table *table,
-					      int index)
-{
-	struct io_rsrc_node *node;
-
-	node = io_rsrc_node_lookup(&table->data, &index);
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


