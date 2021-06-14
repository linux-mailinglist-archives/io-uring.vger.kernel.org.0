Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107DF3A5B5F
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 03:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhFNBjM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Jun 2021 21:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbhFNBjL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Jun 2021 21:39:11 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DCCC0613A2
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 18:36:55 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id m3so5900396wms.4
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 18:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5wpgHOKNUaUwLZA/5ijeQO6uoeaJIdg8EUPICdQwE3I=;
        b=JZm+M7SKZgvGOy2wMOBW+Yz0HjEMiy8+iDiymQuRz8WBQ/rd+ojcHj7Pud/wpaK3vV
         t5A0ly74BtIZ3vN7BzOFBHVCAFwPJNuHyE0pYC2sCVDIajjHWvQJzizPkdiDcWDJIW6O
         oW/fakHzO55DywzTkh8cpmAaIeBHl03sOorUUiHbenGxosr0MujdmZA1cE3LN/li0kSi
         9Kqpe86vt4K+dxh11kNS+ps/4U20S3SaLkL1mg4Y2mD+d0BVzwYbygzwQ4WuYcdioXPq
         ThEWGfYbcCRVuq0PGBNZARTF2Pvvf74xfz7UPgn4cn7R24lCrxhBhRWXrmNdMF1q/0L3
         d2Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5wpgHOKNUaUwLZA/5ijeQO6uoeaJIdg8EUPICdQwE3I=;
        b=qil2f91FgWEmGvHuc2t0Q2wgS2YF51pWuF+GBhe3fKSa5a1ZElX0TxmyM6jbM6FZF8
         DMjr2rBFEBN4zHmtRGbsNAO8MzvokPrDHrOZ37LMaEipQT1uB3mft1ej7h+JKK+6phw5
         VuRr+JufHoGuJ2xUdwQXURTI+99b6YU50pMCDffDXeoDSpKTQsCkf/LWnXFQiIcWsoDG
         DMTHfTtcpBv4pbZdGZyLVQAc75zrl+m1CoeBm4vgKu2rzc7+EQE69K7WUlFlWd7J3uts
         62aoCEq74/k+gg8JIo6snQ1PievIw/lt/qC/yvyHc6d/f7pIHHAk0+Q1wenvG3HyZT0s
         SjQA==
X-Gm-Message-State: AOAM533w6WzxFCYY3YKLx7Pc2Mo2azRaD8LVFyZzvukzeM87fy054jVq
        BwT8ysUqeY1xIVC/tBHRsIpC1dR2tGhqSg==
X-Google-Smtp-Source: ABdhPJz49M4icZM9/r2yoyItfUEznyu/XakEjIdQV1UwnfpxFTbW/LjGWcndLjD5580DDDkSRhkwDQ==
X-Received: by 2002:a1c:4d0d:: with SMTP id o13mr30407605wmh.59.1623634612910;
        Sun, 13 Jun 2021 18:36:52 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.119])
        by smtp.gmail.com with ESMTPSA id a9sm6795291wrv.37.2021.06.13.18.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 18:36:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 09/13] io_uring: add helpers for 2 level table alloc
Date:   Mon, 14 Jun 2021 02:36:20 +0100
Message-Id: <1709212359cd82eb416d395f86fc78431ccfc0aa.1623634181.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623634181.git.asml.silence@gmail.com>
References: <cover.1623634181.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some parts like fixed file table use 2 level tables, factor out helpers
for allocating/deallocating them as more users are to come.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 73 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 43 insertions(+), 30 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 59cd9dc6164c..d6c1322119d6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7054,14 +7054,36 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
 }
 
-static void io_free_file_tables(struct io_file_table *table, unsigned nr_files)
+static void io_free_page_table(void **table, size_t size)
 {
-	unsigned i, nr_tables = DIV_ROUND_UP(nr_files, IORING_MAX_FILES_TABLE);
+	unsigned i, nr_tables = DIV_ROUND_UP(size, PAGE_SIZE);
 
 	for (i = 0; i < nr_tables; i++)
-		kfree(table->files[i]);
-	kfree(table->files);
-	table->files = NULL;
+		kfree(table[i]);
+	kfree(table);
+}
+
+static void **io_alloc_page_table(size_t size)
+{
+	unsigned i, nr_tables = DIV_ROUND_UP(size, PAGE_SIZE);
+	size_t init_size = size;
+	void **table;
+
+	table = kcalloc(nr_tables, sizeof(*table), GFP_KERNEL);
+	if (!table)
+		return NULL;
+
+	for (i = 0; i < nr_tables; i++) {
+		unsigned int this_size = min(size, PAGE_SIZE);
+
+		table[i] = kzalloc(this_size, GFP_KERNEL);
+		if (!table[i]) {
+			io_free_page_table(table, init_size);
+			return NULL;
+		}
+		size -= this_size;
+	}
+	return table;
 }
 
 static inline void io_rsrc_ref_lock(struct io_ring_ctx *ctx)
@@ -7190,6 +7212,22 @@ static int io_rsrc_data_alloc(struct io_ring_ctx *ctx, rsrc_put_fn *do_put,
 	return 0;
 }
 
+static bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
+{
+	size_t size = nr_files * sizeof(struct io_fixed_file);
+
+	table->files = (struct io_fixed_file **)io_alloc_page_table(size);
+	return !!table->files;
+}
+
+static void io_free_file_tables(struct io_file_table *table, unsigned nr_files)
+{
+	size_t size = nr_files * sizeof(struct io_fixed_file);
+
+	io_free_page_table((void **)table->files, size);
+	table->files = NULL;
+}
+
 static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
 #if defined(CONFIG_UNIX)
@@ -7451,31 +7489,6 @@ static int io_sqe_files_scm(struct io_ring_ctx *ctx)
 }
 #endif
 
-static bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
-{
-	unsigned i, nr_tables = DIV_ROUND_UP(nr_files, IORING_MAX_FILES_TABLE);
-
-	table->files = kcalloc(nr_tables, sizeof(*table->files), GFP_KERNEL);
-	if (!table->files)
-		return false;
-
-	for (i = 0; i < nr_tables; i++) {
-		unsigned int this_files = min(nr_files, IORING_MAX_FILES_TABLE);
-
-		table->files[i] = kcalloc(this_files, sizeof(*table->files[i]),
-					GFP_KERNEL);
-		if (!table->files[i])
-			break;
-		nr_files -= this_files;
-	}
-
-	if (i == nr_tables)
-		return true;
-
-	io_free_file_tables(table, nr_tables * IORING_MAX_FILES_TABLE);
-	return false;
-}
-
 static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 {
 	struct file *file = prsrc->file;
-- 
2.31.1

