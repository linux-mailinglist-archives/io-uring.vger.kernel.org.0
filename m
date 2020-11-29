Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F102C76EF
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 01:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgK2AuY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Nov 2020 19:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgK2AuX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Nov 2020 19:50:23 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44226C0613D3;
        Sat, 28 Nov 2020 16:49:58 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id b63so7728540pfg.12;
        Sat, 28 Nov 2020 16:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nFkJoKPeq39q/ozwvQXnPpdStMMrP7v5qpVsCdMDZk4=;
        b=C3gcjbX3aLSo4umLVqP+rCP8zJSdnMBS69XdnatzhP8jmv74bTeGnEW8CXv2KZSvlR
         +Qdgb8UFvN/NzhkGTffCThDIZho5WOhV02h1uRh3dAQSH9F+q18LUJn9XEsQbYgaApbg
         LmK8VjHbxuvFZhkmMgD4A1ihXkT/7rrjf0dxnts/5Lrm2V8tSY8vl24Px26ANzI/FXa1
         HXtO999TyEe8v/31E4q5z8Zkpge1cuLXUucjAJ0f2/kxrm59ljfbP9k9gmICJWFWL/ov
         50ZaeTjH4DZ2L3VxBcE5XDjLRxVvdFxLU/gKS0ZeT0XF705fRa7mv8ddd/v/G7ToMGGx
         pKBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nFkJoKPeq39q/ozwvQXnPpdStMMrP7v5qpVsCdMDZk4=;
        b=UOY1D++AZFuiOiB7JIVtnAl3//9TYpFWzI2l0tPGD3Yho43BJ7PlVsgTac0sDM00e5
         gMYfpBa1O7YVlIJv4Nwgy+n8XBId/azpgn3TYFvGUKRvE9keVB833MzQrKhXIMmuCaAn
         kWvnGqrIavEIxdvvWA/voumhcL8EZNyShALYWOhw5oKrdFX/Qt0Ce7IEavNDlXMDXtG4
         EOoIRzYNdAP058zKaNzysCTU63wx8MTXRMtQ6C8q3vjbj6cwSih9Nk8T3kdWJmRpWecI
         blq4TY3aBGKNm3369y3bw4Fjckrx7rWqVTrw4BzM9W2cPHGvmORrojPXoIA91JMLpyaN
         ahAw==
X-Gm-Message-State: AOAM530/IfKid1w3M1iE+M6Abs7JDuvSSzEVQzCcSsI8Mb2zCarDvxvS
        +lgEAIKNqOssZYgqzMZvo9GQe/B+gbecfA==
X-Google-Smtp-Source: ABdhPJyV8QMujyZJg90GfsjSfqFKtOCCIIbNPeEYQK9xFJkSDYD4nzy72zPRHIZ39CRA9Tl/92bdIw==
X-Received: by 2002:a17:90a:b118:: with SMTP id z24mr8951103pjq.14.1606610997318;
        Sat, 28 Nov 2020 16:49:57 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id gg19sm16444871pjb.21.2020.11.28.16.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 16:49:56 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     linux-fsdevel@vger.kernel.org
Cc:     Nadav Amit <namit@vmware.com>, Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH 02/13] fs/userfaultfd: fix wrong file usage with iouring
Date:   Sat, 28 Nov 2020 16:45:37 -0800
Message-Id: <20201129004548.1619714-3-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201129004548.1619714-1-namit@vmware.com>
References: <20201129004548.1619714-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

Using io-uring with userfaultfd for reads can lead upon a fork event to
the installation of the userfaultfd file descriptor on the worker kernel
thread instead of the process that initiated the read. io-uring assumes
that no new file descriptors are installed during read.

As a result the controlling process would not be able to access the
new forked process userfaultfd file descriptor.

To solve this problem, Save the files_struct of the process that
initiated userfaultfd syscall in the context and reload it when needed.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Fixes: 2b188cc1bb85 ("Add io_uring IO interface")
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 fs/userfaultfd.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index c8ed4320370e..4fe07c1a44c6 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -27,6 +27,7 @@
 #include <linux/ioctl.h>
 #include <linux/security.h>
 #include <linux/hugetlb.h>
+#include <linux/fdtable.h>
 
 int sysctl_unprivileged_userfaultfd __read_mostly = 1;
 
@@ -76,6 +77,8 @@ struct userfaultfd_ctx {
 	bool mmap_changing;
 	/* mm with one ore more vmas attached to this userfaultfd_ctx */
 	struct mm_struct *mm;
+	/* controlling process files as they might be different than current */
+	struct files_struct *files;
 };
 
 struct userfaultfd_fork_ctx {
@@ -173,6 +176,7 @@ static void userfaultfd_ctx_put(struct userfaultfd_ctx *ctx)
 		VM_BUG_ON(spin_is_locked(&ctx->fd_wqh.lock));
 		VM_BUG_ON(waitqueue_active(&ctx->fd_wqh));
 		mmdrop(ctx->mm);
+		put_files_struct(ctx->files);
 		kmem_cache_free(userfaultfd_ctx_cachep, ctx);
 	}
 }
@@ -666,6 +670,8 @@ int dup_userfaultfd(struct vm_area_struct *vma, struct list_head *fcs)
 		ctx->mm = vma->vm_mm;
 		mmgrab(ctx->mm);
 
+		ctx->files = octx->files;
+		atomic_inc(&ctx->files->count);
 		userfaultfd_ctx_get(octx);
 		WRITE_ONCE(octx->mmap_changing, true);
 		fctx->orig = octx;
@@ -976,10 +982,32 @@ static int resolve_userfault_fork(struct userfaultfd_ctx *ctx,
 				  struct userfaultfd_ctx *new,
 				  struct uffd_msg *msg)
 {
+	struct files_struct *files = NULL;
 	int fd;
 
+	BUG_ON(new->files == NULL);
+
+	/*
+	 * This function can be called from another context than the controlling
+	 * process, for instance, for an io-uring submission kernel thread. If
+	 * that is the case we must ensure the correct files are being used.
+	 */
+	if (current->files != new->files) {
+		task_lock(current);
+		files = current->files;
+		current->files = new->files;
+		task_unlock(current);
+	}
+
 	fd = anon_inode_getfd("[userfaultfd]", &userfaultfd_fops, new,
 			      O_RDWR | (new->flags & UFFD_SHARED_FCNTL_FLAGS));
+
+	if (files != NULL) {
+		task_lock(current);
+		current->files = files;
+		task_unlock(current);
+	}
+
 	if (fd < 0)
 		return fd;
 
@@ -1986,6 +2014,8 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
 	/* prevent the mm struct to be freed */
 	mmgrab(ctx->mm);
 
+	ctx->files = get_files_struct(current);
+
 	fd = anon_inode_getfd("[userfaultfd]", &userfaultfd_fops, ctx,
 			      O_RDWR | (flags & UFFD_SHARED_FCNTL_FLAGS));
 	if (fd < 0) {
-- 
2.25.1

