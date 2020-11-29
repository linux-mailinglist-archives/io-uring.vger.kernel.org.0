Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED362C7700
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 01:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730151AbgK2Auu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Nov 2020 19:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729806AbgK2Aus (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Nov 2020 19:50:48 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92EA6C061A48;
        Sat, 28 Nov 2020 16:50:05 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id w202so7733123pff.10;
        Sat, 28 Nov 2020 16:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m3T85bPGe5F+Y++Xanv5e+8tOU25N4OYONQwuoq/1Bg=;
        b=lqD/tU0tDTQCtA7PjLcc+V2DExVFb+xzSTUWJkOWg05/7ncV1krxldnwCAwNQbKtIr
         kX0ubA1jlwnfeL7wh0sqxAOpWkxq6I/TnUH6ydeF7C+k8P3OHNwR+eD/nKEpa4J7LeCL
         JWYXvxCkL2N/912drcMK3sw2tRkl5oG4zGYGl+BKn1JjigqIF4L0hzgTzZPkYJA8Ztij
         Tobt70TN3tvcPduGuqriyeun8JBv3Ug4E5Ly8fsoQJU5ucEGZ4aCTsRsZWsQVyuFQezp
         x5QPByemKbVvEKcYrYjn8Dds29j1cFTbc+13wyA1fSneWSwsfWrKOdioadcv+plh9kha
         1gZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m3T85bPGe5F+Y++Xanv5e+8tOU25N4OYONQwuoq/1Bg=;
        b=is2tYOGv2piW7Q20MNAlsuA+kKsaNZruaPildJX1ClG/sTmDnXG5Xt4YX0armO8PNI
         Nj9JcC87da/NArJfJ/igajMGcEJzIJcoo8+nnYV8PDqR1B8N7RX+DVz2iOJ0wZHGAXRk
         5Ro+e24bVD3GD8lP+1RoO0NgwLtBioUpYSgFHDzVnJFUh86CGfZaZBb1q7kMn2GfoYFY
         GAA/dJAZt6U5WqnmmgLpmpJaux2wKP3CxIIjrw+61Pui9dupoitaeEgh/SK+Lx27bTSd
         VsprHiR6VVhGGJvlOzPhINwbdlTIgvxNyLR0DHdMCX7PPAsruGv1giHUchgXVEa8J7z2
         I/sg==
X-Gm-Message-State: AOAM532eEE4TXOGN7MZYPQZk56wLWnL3L6NZIo0N9joq9I0hnksJqQyP
        UZxs3yZszJ5N0vWp/QEZ+1lLRPGWLroguQ==
X-Google-Smtp-Source: ABdhPJwysR6pHHiIU7NpGqTX7WAlLbdiNThKHFXvrC9AzG3R2hvHHnbX1oMJ/YdkgURbzNUeOoVjCg==
X-Received: by 2002:a17:90a:5b10:: with SMTP id o16mr18898825pji.142.1606611004639;
        Sat, 28 Nov 2020 16:50:04 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id gg19sm16444871pjb.21.2020.11.28.16.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 16:50:03 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     linux-fsdevel@vger.kernel.org
Cc:     Nadav Amit <namit@vmware.com>, Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH 07/13] fs/userfaultfd: support read_iter to use io_uring
Date:   Sat, 28 Nov 2020 16:45:42 -0800
Message-Id: <20201129004548.1619714-8-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201129004548.1619714-1-namit@vmware.com>
References: <20201129004548.1619714-1-namit@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

iouring with userfaultfd cannot currently be used fixed buffers since
userfaultfd does not provide read_iter(). This is required to allow
asynchronous (queued) reads from userfaultfd.

To support async-reads of userfaultfd provide read_iter() instead of
read().

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 fs/userfaultfd.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index b6a04e526025..6333b4632742 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1195,9 +1195,9 @@ static ssize_t userfaultfd_ctx_read(struct userfaultfd_ctx *ctx, int no_wait,
 	return ret;
 }
 
-static ssize_t userfaultfd_read(struct file *file, char __user *buf,
-				size_t count, loff_t *ppos)
+static ssize_t userfaultfd_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
+	struct file *file = iocb->ki_filp;
 	struct userfaultfd_ctx *ctx = file->private_data;
 	ssize_t _ret, ret = 0;
 	struct uffd_msg msg;
@@ -1207,16 +1207,18 @@ static ssize_t userfaultfd_read(struct file *file, char __user *buf,
 		return -EINVAL;
 
 	for (;;) {
-		if (count < sizeof(msg))
+		if (iov_iter_count(to) < sizeof(msg))
 			return ret ? ret : -EINVAL;
 		_ret = userfaultfd_ctx_read(ctx, no_wait, &msg);
 		if (_ret < 0)
 			return ret ? ret : _ret;
-		if (copy_to_user((__u64 __user *) buf, &msg, sizeof(msg)))
-			return ret ? ret : -EFAULT;
+
+		_ret = copy_to_iter(&msg, sizeof(msg), to);
+		if (_ret != sizeof(msg))
+			return ret ? ret : -EINVAL;
+
 		ret += sizeof(msg);
-		buf += sizeof(msg);
-		count -= sizeof(msg);
+
 		/*
 		 * Allow to read more than one fault at time but only
 		 * block if waiting for the very first one.
@@ -1980,7 +1982,7 @@ static const struct file_operations userfaultfd_fops = {
 #endif
 	.release	= userfaultfd_release,
 	.poll		= userfaultfd_poll,
-	.read		= userfaultfd_read,
+	.read_iter	= userfaultfd_read_iter,
 	.unlocked_ioctl = userfaultfd_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
 	.llseek		= noop_llseek,
-- 
2.25.1

