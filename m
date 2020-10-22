Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742C8296718
	for <lists+io-uring@lfdr.de>; Fri, 23 Oct 2020 00:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372766AbgJVWY6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 18:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S372761AbgJVWY4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 18:24:56 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C28C0613CE
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 15:24:55 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id o9so1713517plx.10
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 15:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2LtcIpK4Q4iLBP2w7UhfR96BPjR+fhgUZtzjipu+IWI=;
        b=x1jjTTGbEkEGWjLHpK1oEot1ck5vwR6n4umtPERuv90ETEKvTJ07X1KrDZ/j8V7kcP
         qqA1XGfPy2VdevqKQl9zNpL1nnp8pyiZ6y1ZC0iJhreEBKTudT7vhNEeo4tR7oS7p/Yd
         MhIuHqf6P0FkDQwC+ARNH4lXWwayPwusj4GU6Vn7F0lil/p6mmbYkKNRH97esY9ndXG/
         JN0UO2Pr6NZgI94vvVECaeT/HVE8hgzpjySa79F9hatB4sbwL9139XiPj60oG8Lj0dkI
         V/65UAAKcjvcH6vwUJm/fZote/GuENG6Rt5nhWt8diqSXKbcNtymSBxJDUMejh5tSuFM
         AUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2LtcIpK4Q4iLBP2w7UhfR96BPjR+fhgUZtzjipu+IWI=;
        b=dtrGq6/PbKZJ3vxXijOSbH8GQk8B52cP4z655UBQRHxleu2+xqaGkEd5omemH/eFl4
         VTaqi6kgmVSjycSeTCVkVbcYAVTGMumtu3C0kQR2fPj++ES7Xm5exuwx05+G3icltehu
         71ZC6T7kXrm57YMntaNrixw74vioXV8mb1mDHt9E6wjQRc6BACVd/pNiEstN7REuyn8k
         qAHT3WauOqYHv/S1p4gW52YJfr0XZBPpETvy0t7GlGrKuebsVmehx1SlyvRBSCHi+zTs
         JHeb9CxW/T8nCPm99ahqXfqcjld2bzE07lse0c6pSTTF0XjEwk6pStEaW406njvz/rLV
         0YmQ==
X-Gm-Message-State: AOAM530Eckxtnz5VYB8vUxMOgXi6wifytm09gKk9aXHQBp+lFw8pmE5C
        7R9OzptzUbmprqeG1iDH0ewiS3AnH5Unww==
X-Google-Smtp-Source: ABdhPJzw5e6uqrPkBO8wEowt15ICNXoB0taSqwl6ooSEYanSwvDnYQBYEDyYT/7YXjtUGySdmVkczA==
X-Received: by 2002:a17:902:8508:b029:d5:af79:8b40 with SMTP id bj8-20020a1709028508b02900d5af798b40mr4534268plb.28.1603405494641;
        Thu, 22 Oct 2020 15:24:54 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id e5sm3516437pfl.216.2020.10.22.15.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 15:24:54 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] splice: change exported internal do_splice() helper to take kernel offset
Date:   Thu, 22 Oct 2020 16:24:47 -0600
Message-Id: <20201022222447.62020-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201022222447.62020-1-axboe@kernel.dk>
References: <20201022222447.62020-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With the set_fs change, we can no longer rely on copy_{to,from}_user()
accepting a kernel pointer. Clean this up and change the internal helper
that io_uring uses to deal with kernel pointers instead. This puts the
offset copy in/out in __do_splice() instead, which just calls the same
helper.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/splice.c            | 63 +++++++++++++++++++++++++++++++++---------
 include/linux/splice.h |  4 +--
 2 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 70cc52af780b..d9305af930d8 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1107,9 +1107,8 @@ static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 /*
  * Determine where to splice to/from.
  */
-long do_splice(struct file *in, loff_t __user *off_in,
-		struct file *out, loff_t __user *off_out,
-		size_t len, unsigned int flags)
+long do_splice(struct file *in, loff_t *off_in, struct file *out,
+	       loff_t *off_out, size_t len, unsigned int flags)
 {
 	struct pipe_inode_info *ipipe;
 	struct pipe_inode_info *opipe;
@@ -1143,8 +1142,7 @@ long do_splice(struct file *in, loff_t __user *off_in,
 		if (off_out) {
 			if (!(out->f_mode & FMODE_PWRITE))
 				return -EINVAL;
-			if (copy_from_user(&offset, off_out, sizeof(loff_t)))
-				return -EFAULT;
+			offset = *off_out;
 		} else {
 			offset = out->f_pos;
 		}
@@ -1165,8 +1163,8 @@ long do_splice(struct file *in, loff_t __user *off_in,
 
 		if (!off_out)
 			out->f_pos = offset;
-		else if (copy_to_user(off_out, &offset, sizeof(loff_t)))
-			ret = -EFAULT;
+		else
+			*off_out = offset;
 
 		return ret;
 	}
@@ -1177,8 +1175,7 @@ long do_splice(struct file *in, loff_t __user *off_in,
 		if (off_in) {
 			if (!(in->f_mode & FMODE_PREAD))
 				return -EINVAL;
-			if (copy_from_user(&offset, off_in, sizeof(loff_t)))
-				return -EFAULT;
+			offset = *off_in;
 		} else {
 			offset = in->f_pos;
 		}
@@ -1202,8 +1199,8 @@ long do_splice(struct file *in, loff_t __user *off_in,
 			wakeup_pipe_readers(opipe);
 		if (!off_in)
 			in->f_pos = offset;
-		else if (copy_to_user(off_in, &offset, sizeof(loff_t)))
-			ret = -EFAULT;
+		else
+			*off_in = offset;
 
 		return ret;
 	}
@@ -1211,6 +1208,46 @@ long do_splice(struct file *in, loff_t __user *off_in,
 	return -EINVAL;
 }
 
+static long __do_splice(struct file *in, loff_t __user *off_in,
+			struct file *out, loff_t __user *off_out,
+			size_t len, unsigned int flags)
+{
+	struct pipe_inode_info *ipipe;
+	struct pipe_inode_info *opipe;
+	loff_t offset, *__off_in = NULL, *__off_out = NULL;
+	long ret;
+
+	ipipe = get_pipe_info(in, true);
+	opipe = get_pipe_info(out, true);
+
+	if (ipipe && off_in)
+		return -ESPIPE;
+	if (opipe && off_out)
+		return -ESPIPE;
+
+	if (off_out) {
+		if (copy_from_user(&offset, off_out, sizeof(loff_t)))
+			return -EFAULT;
+		__off_out = &offset;
+	}
+	if (off_in) {
+		if (copy_from_user(&offset, off_in, sizeof(loff_t)))
+			return -EFAULT;
+		__off_in = &offset;
+	}
+
+	ret = do_splice(in, __off_in, out, __off_out, len, flags);
+	if (ret < 0)
+		return ret;
+
+	if (__off_out && copy_to_user(off_out, __off_out, sizeof(loff_t)))
+		return -EFAULT;
+	if (__off_in && copy_to_user(off_in, __off_in, sizeof(loff_t)))
+		return -EFAULT;
+
+	return ret;
+}
+
 static int iter_to_pipe(struct iov_iter *from,
 			struct pipe_inode_info *pipe,
 			unsigned flags)
@@ -1405,8 +1442,8 @@ SYSCALL_DEFINE6(splice, int, fd_in, loff_t __user *, off_in,
 	if (in.file) {
 		out = fdget(fd_out);
 		if (out.file) {
-			error = do_splice(in.file, off_in, out.file, off_out,
-					  len, flags);
+			error = __do_splice(in.file, off_in, out.file, off_out,
+						len, flags);
 			fdput(out);
 		}
 		fdput(in);
diff --git a/include/linux/splice.h b/include/linux/splice.h
index 5c47013f708e..a55179fd60fc 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -78,8 +78,8 @@ extern ssize_t add_to_pipe(struct pipe_inode_info *,
 			      struct pipe_buffer *);
 extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
 				      splice_direct_actor *);
-extern long do_splice(struct file *in, loff_t __user *off_in,
-		      struct file *out, loff_t __user *off_out,
+extern long do_splice(struct file *in, loff_t *off_in,
+		      struct file *out, loff_t *off_out,
 		      size_t len, unsigned int flags);
 
 extern long do_tee(struct file *in, struct file *out, size_t len,
-- 
2.29.0

