Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419FA30F46B
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 15:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236521AbhBDN7g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 08:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236538AbhBDN51 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 08:57:27 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED61BC061353
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 05:56:14 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id m1so3072964wml.2
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 05:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=AuBZBrVWaAmNt8cFRYQbQKzSDE4eLRO1oQUrE/dDkgg=;
        b=irhGI1KPE160YMlA7ZR+Su5jPh7xusirBTNW/bn7po/HekJXtgw6UNZ9Bcqs2GwnW3
         UJ3sWceg6ly3S5D15nKuby3QIOAj830unwq7upVCxoeGxoeH5j8jcvONCWRcwL4kfn+8
         JJk+SBNhry/SazOwad00+CGJdjHZ8Gg4RQ1BilLuTOhd5PcTpzZHqzvffDUQC0MUHGyF
         spOBImxzt+ZmhbWhNiVr7cmGUnRyDCJcrZ6b91RIZ/KVa9oowwVMFSNLi0eXn+UTkGXj
         OovwERsVtafnE30ukPb98BoNrrl0qpJQR8/tDqlgT09AbF5K0Y/l9GHpEOJqY6cwKsns
         7iYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AuBZBrVWaAmNt8cFRYQbQKzSDE4eLRO1oQUrE/dDkgg=;
        b=j8iOMHlqIPyce9SKY3MD1g6fEoPXqZuuFXtbnsrp7XBYrUBeD4N2+ud6sprMu6rgoh
         g4UJ0ZH8wt90mTIMSjmT6r1h50ByfwRyU9HZFA0vITwoSW5uuSI3LOl7t4t1k7S4ICIs
         LRyd5CxfkrrVvJOWX0dfdmw+q7qek0RzGtdMq/kSl9q1S0EqG8mqJQzrARLreqBsUNGB
         bKczCCSCjic007s2ecoGTFXg09M0HtJ9qX6hpX48kdrrIjFmSjn6FYmVqTbGVCD99+DR
         Q6LNu9WK65OzzpxXCOwkIQhMe2ZPHd85GdoO8/x2voXVDpqveVxrGaptWvhxfyBkXtUh
         HjUw==
X-Gm-Message-State: AOAM530kwgxn9EhcZ9IC9EyRP+LHeXvKI8r3EJckAa6ThtVcVZU9kRrH
        /QQROe62ecnZY/C3UIAH0h8=
X-Google-Smtp-Source: ABdhPJw/YDiXeY3L1NtSjo9KFsO5QbK4spPL6e9zQC/ltlNWuvYSy66R3XwgshcbhX29KWJxL0a5/w==
X-Received: by 2002:a1c:e903:: with SMTP id q3mr7635961wmc.100.1612446973723;
        Thu, 04 Feb 2021 05:56:13 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id k4sm8910561wrm.53.2021.02.04.05.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 05:56:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 12/13] io_uring: deduplicate file table slot calculation
Date:   Thu,  4 Feb 2021 13:52:07 +0000
Message-Id: <0281a308eb5a98a46654eaa2ea2e2ed5ec2ebeef.1612446019.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612446019.git.asml.silence@gmail.com>
References: <cover.1612446019.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Extract a helper io_fixed_file_slot() returning a place in our fixed
files table, so we don't hand-code it three times in the code.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 24cc00ff7155..5ee6a9273fca 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7740,6 +7740,15 @@ static void io_rsrc_put_work(struct work_struct *work)
 	}
 }
 
+static struct file **io_fixed_file_slot(struct fixed_rsrc_data *file_data,
+					unsigned i)
+{
+	struct fixed_rsrc_table *table;
+
+	table = &file_data->table[i >> IORING_FILE_TABLE_SHIFT];
+	return &table->files[i & IORING_FILE_TABLE_MASK];
+}
+
 static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 {
 	struct fixed_rsrc_ref_node *ref_node;
@@ -7808,6 +7817,7 @@ static void destroy_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node)
 	kfree(ref_node);
 }
 
+
 static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 				 unsigned nr_args)
 {
@@ -7840,9 +7850,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		goto out_free;
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
-		struct fixed_rsrc_table *table;
-		unsigned index;
-
 		if (copy_from_user(&fd, &fds[i], sizeof(fd))) {
 			ret = -EFAULT;
 			goto out_fput;
@@ -7867,9 +7874,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			fput(file);
 			goto out_fput;
 		}
-		table = &file_data->table[i >> IORING_FILE_TABLE_SHIFT];
-		index = i & IORING_FILE_TABLE_MASK;
-		table->files[index] = file;
+		*io_fixed_file_slot(file_data, i) = file;
 	}
 
 	ret = io_sqe_files_scm(ctx);
@@ -7972,7 +7977,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 {
 	struct fixed_rsrc_data *data = ctx->file_data;
 	struct fixed_rsrc_ref_node *ref_node;
-	struct file *file;
+	struct file *file, **file_slot;
 	__s32 __user *fds;
 	int fd, i, err;
 	__u32 done;
@@ -7990,9 +7995,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 	fds = u64_to_user_ptr(up->data);
 	for (done = 0; done < nr_args; done++) {
-		struct fixed_rsrc_table *table;
-		unsigned index;
-
 		err = 0;
 		if (copy_from_user(&fd, &fds[done], sizeof(fd))) {
 			err = -EFAULT;
@@ -8002,14 +8004,13 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			continue;
 
 		i = array_index_nospec(up->offset + done, ctx->nr_user_files);
-		table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
-		index = i & IORING_FILE_TABLE_MASK;
-		if (table->files[index]) {
-			file = table->files[index];
-			err = io_queue_file_removal(data, file);
+		file_slot = io_fixed_file_slot(ctx->file_data, i);
+
+		if (*file_slot) {
+			err = io_queue_file_removal(data, *file_slot);
 			if (err)
 				break;
-			table->files[index] = NULL;
+			*file_slot = NULL;
 			needs_switch = true;
 		}
 		if (fd != -1) {
@@ -8031,13 +8032,12 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				err = -EBADF;
 				break;
 			}
-			table->files[index] = file;
 			err = io_sqe_file_register(ctx, file, i);
 			if (err) {
-				table->files[index] = NULL;
 				fput(file);
 				break;
 			}
+			*file_slot = file;
 		}
 	}
 
@@ -9488,11 +9488,8 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	seq_printf(m, "SqThreadCpu:\t%d\n", sq ? task_cpu(sq->thread) : -1);
 	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
 	for (i = 0; has_lock && i < ctx->nr_user_files; i++) {
-		struct fixed_rsrc_table *table;
-		struct file *f;
+		struct file *f = *io_fixed_file_slot(ctx->file_data, i);
 
-		table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
-		f = table->files[i & IORING_FILE_TABLE_MASK];
 		if (f)
 			seq_printf(m, "%5u: %s\n", i, file_dentry(f)->d_iname);
 		else
-- 
2.24.0

