Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27B438F683
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 01:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhEXXxJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 May 2021 19:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbhEXXxI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 May 2021 19:53:08 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D40DC061756
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:38 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id s5-20020a7bc0c50000b0290147d0c21c51so11794454wmh.4
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yeZsi4TxT000m1LB2kZ2UznvbTaqIT8LLfRfR5xxQeU=;
        b=WkRjx+vgmyER7X+C0GIKFHe6Dxq/I0Lic/e9BoyCgTibxaUaiPoLJ7r0E4hSzqJspy
         MfX+9ODJT6NOQ7E3iJP6IT8C++kx52OWQgDbfdj4BL1vWgbH+JsR9JtEGcS8AHkTGEAm
         XGTd83Jbvn/0mh+unvYSKER01NIMQsCdNaOv/c+aeCV9aw7lQ3cGn0MpR/2swlQ73iJM
         Ke4OfIGrX0VPhCaWEi/xBcHXzzKHa2QiAeEqo6LIWrn82uuPM1x/lHv6/pusGLmW8ixD
         Rn5rUietnIt+YsOY6LMcB08ihpOS1aqkdkfG6GNQn1WEGqSLpukZPG7vGj2LU99ulm1s
         VWNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yeZsi4TxT000m1LB2kZ2UznvbTaqIT8LLfRfR5xxQeU=;
        b=aiZE6R5eTrdEXaZ+D5ebESHy5uuStD8FV5gG7cspEhVPJcDklzsszZvhyc9uptXfKi
         uhWBkMIoZKs8jsU7Tl2GgoRfytVRpgWwmx0+vekEXa/YU40vcGrSW7Hpu4pz62wFe9uD
         W+8lVpjNxoMeVEF3XE83gLLx/v8ug6h94ISnGTbYNzM9I5U1Iysd36H/27yI7zgykYf/
         2MfgcUNkR0zj9wPcpZ0vzFr4jIq8GYkG/Gb6cbPLRA/Gyw5vN2Nmz/hL0IKvaDwOTDwr
         SU6M0VVwQ7nup4S5alu+w65uysF3Yrm+nI+kStcCWpBvcIn5oYUwJ/AeEaYSVpqeI4lQ
         rhCA==
X-Gm-Message-State: AOAM531lMA71ap5AvX46IKFKWdYYzL1Kc4C/UZ1pX9tttuIoYzdA9Sc1
        nDlcBgTzg6s4zwDTHWH/IM4=
X-Google-Smtp-Source: ABdhPJxzBOL+cnsT4J4gYyUftLkJYsfZgUYLTtIjTYOiMSYg4aOHmKBNbA5Tlsh7k0hdTtE44P3LjQ==
X-Received: by 2002:a7b:cbc4:: with SMTP id n4mr1182524wmi.153.1621900297053;
        Mon, 24 May 2021 16:51:37 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.116])
        by smtp.gmail.com with ESMTPSA id f7sm8961069wmq.30.2021.05.24.16.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:51:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 10/13] io_uring: add helpers for 2 level table alloc
Date:   Tue, 25 May 2021 00:51:09 +0100
Message-Id: <5290fc671b3f5db3ff2a20e2242dd39eba01ec1d.1621899872.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621899872.git.asml.silence@gmail.com>
References: <cover.1621899872.git.asml.silence@gmail.com>
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
index 40b70c34c1b2..1cc2d16637ff 100644
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

