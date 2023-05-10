Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63A936FDBEC
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 12:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbjEJKxb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 May 2023 06:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbjEJKxT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 May 2023 06:53:19 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1B244A1;
        Wed, 10 May 2023 03:53:18 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 12D38C01C; Wed, 10 May 2023 12:53:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1683715997; bh=ztcZe/9kU1q9dB4s88Yjc8V4rSthT6QyJ5cIynFlzKw=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=dRQjo2SbXZ2nmnK5uDuEWedfAO9qGSSkll/uUdixQA/vsFyboCwQfL/1a8fCoapyz
         alRLv4cx89zct1pfd2eOhZEcwfcY0A2YERDUmB+/45N4GQl+yMhoHfPZXyRF3rpC9d
         v6MvgiHt66HqrSd8Ehalh/Oqc1PmFhWmGj3/kwW3uAay+Itr2AOJBWzX5q5fRPNChw
         olDLr5qjTT/CnsZOYVS+cuGy0GSuKX0cLJeiIG6iDxKzAoP9hbzOmAIfX9ZrILfKxT
         YhdenZmOQyWgIQVE1rHQtZfo+RbCqY20xxsmyqr+aoS11AnNkB0WUI80MDlOrtk8Ey
         tYKTDzeGb4XTQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 494DFC01B;
        Wed, 10 May 2023 12:53:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1683715996; bh=ztcZe/9kU1q9dB4s88Yjc8V4rSthT6QyJ5cIynFlzKw=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=iSq3RbaWdxp6erflei1gNI5HFYgOC8tJRBS/nYb1wVHDjVrCED1WafkDeyPBj8Nao
         favpyCotJnSvi+vsmHkLQW54cKoBGOd/e7hRkQmtLeZoLGXNRPrazFywsw8mnIcG/z
         mHiEv8SRSlD/YDMpn7t3+sVrGV0SHyJQEREJ4N1fGv+eITbvioh/vd9ftFxbKctQh7
         YJF3s/cNJhWHmDOuS6woLNhTPbJpsxwqZoUWlR/KpXNRzvu/4j7ebIYhCS+quBjvPc
         5++pM5PaOxsVuTss7GF9trnPKC18XUsXNbOgnfNJIVixjxgo65oZlPgmqxNBmSxYox
         7xka8YuNqb7bw==
Received: from [127.0.0.2] (localhost [::1])
        by odin.codewreck.org (OpenSMTPD) with ESMTP id 32fdd01d;
        Wed, 10 May 2023 10:53:02 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
Date:   Wed, 10 May 2023 19:52:49 +0900
Subject: [PATCH v2 1/6] fs: split off vfs_getdents function of getdents64
 syscall
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230422-uring-getdents-v2-1-2db1e37dc55e@codewreck.org>
References: <20230422-uring-getdents-v2-0-2db1e37dc55e@codewreck.org>
In-Reply-To: <20230422-uring-getdents-v2-0-2db1e37dc55e@codewreck.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>
Cc:     Clay Harris <bugs@claycon.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>
X-Mailer: b4 0.13-dev-f371f
X-Developer-Signature: v=1; a=openpgp-sha256; l=2636;
 i=asmadeus@codewreck.org; h=from:subject:message-id;
 bh=cPTv2wL6wLKLM00aZ75XOdO1cPc08BAWHjE8CCzXRtA=;
 b=owEBbQKS/ZANAwAIAatOm+xqmOZwAcsmYgBkW3eNkBvllWp6P///MucyMoGfFTUCk+oG7WhgQ
 Cwcvy8zZDmJAjMEAAEIAB0WIQT8g9txgG5a3TOhiE6rTpvsapjmcAUCZFt3jQAKCRCrTpvsapjm
 cP66EACqjpqxA0uN1MwDeFmeHID8g+co9EP4zXCLFdgQvmryvZQQsRX5V/VlGkP8bOHZN8yrc9P
 YOzfKu12GCzRSq4cITlVJgsPJYdLihMMEjEnplkANHcD/IRcjkQlqX9PBXY/BRbZlIZY8oYWh60
 tctT84YTmoGQuplQq4eJom8aART9GwKMnkmmpSOuY5F6wZ3uRQhNudgkKmPtSu/nR5k3FKsN0sc
 qjtvDuf+t2PbjQQGvuaRm0g7HAIyyEO8pyyeGO0EATRDJbObCm+3jCsyfCUu4phMCwIjRuiNP20
 w4MxPuVd4g2S5UmIcMaYn75mW4YZTi4pEUWz6qCKhwEv7OMrElxJPY33TFcGfFGwxIRkcxWiaJb
 puCAkRuw6JjLeS8uVrCw+A0nEU5xZMJMqyYEOM3/m8F+k41vdwThZlghwZZpgEg13p6Lv00WQ8G
 a29NMPNpn8l2bKo6oEHkSSB/S501HV05QrRTiyWqf5ikoKz74+GdfFmjwUdvZG/ySBxGBWU//+O
 whtGGdPM3QBIHVJyKD814QB7YIlu95nycpQStQab8THI3zTpaExu2mmbZ4si4yahLxpIx/odxbw
 2vq6jqPh+flvsMRpNtfh+h5J7ka3aJkpt7RCi9BBaay6yeGeD4pvE5SLespezkM0Cb/ESZty285
 m8/ek1NXPthTVqg==
X-Developer-Key: i=asmadeus@codewreck.org; a=openpgp;
 fpr=B894379F662089525B3FB1B9333F1F391BBBB00A
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This splits off the vfs_getdents function from the getdents64 system
call.
This will allow io_uring to call the vfs_getdents function.

Co-authored-by: Stefan Roesch <shr@fb.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
 fs/internal.h |  8 ++++++++
 fs/readdir.c  | 34 ++++++++++++++++++++++++++--------
 2 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index bd3b2810a36b..e8ca000e6613 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -260,3 +260,11 @@ ssize_t __kernel_write_iter(struct file *file, struct iov_iter *from, loff_t *po
 struct mnt_idmap *alloc_mnt_idmap(struct user_namespace *mnt_userns);
 struct mnt_idmap *mnt_idmap_get(struct mnt_idmap *idmap);
 void mnt_idmap_put(struct mnt_idmap *idmap);
+
+/*
+ * fs/readdir.c
+ */
+struct linux_dirent64;
+
+int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
+		 unsigned int count);
diff --git a/fs/readdir.c b/fs/readdir.c
index 9c53edb60c03..ed0803d0011e 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -21,6 +21,7 @@
 #include <linux/unistd.h>
 #include <linux/compat.h>
 #include <linux/uaccess.h>
+#include "internal.h"
 
 #include <asm/unaligned.h>
 
@@ -351,10 +352,16 @@ static bool filldir64(struct dir_context *ctx, const char *name, int namlen,
 	return false;
 }
 
-SYSCALL_DEFINE3(getdents64, unsigned int, fd,
-		struct linux_dirent64 __user *, dirent, unsigned int, count)
+
+/**
+ * vfs_getdents - getdents without fdget
+ * @file    : pointer to file struct of directory
+ * @dirent  : pointer to user directory structure
+ * @count   : size of buffer
+ */
+int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
+		 unsigned int count)
 {
-	struct fd f;
 	struct getdents_callback64 buf = {
 		.ctx.actor = filldir64,
 		.count = count,
@@ -362,11 +369,7 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 	};
 	int error;
 
-	f = fdget_pos(fd);
-	if (!f.file)
-		return -EBADF;
-
-	error = iterate_dir(f.file, &buf.ctx);
+	error = iterate_dir(file, &buf.ctx);
 	if (error >= 0)
 		error = buf.error;
 	if (buf.prev_reclen) {
@@ -379,6 +382,21 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 		else
 			error = count - buf.count;
 	}
+	return error;
+}
+
+SYSCALL_DEFINE3(getdents64, unsigned int, fd,
+		struct linux_dirent64 __user *, dirent, unsigned int, count)
+{
+	struct fd f;
+	int error;
+
+	f = fdget_pos(fd);
+	if (!f.file)
+		return -EBADF;
+
+	error = vfs_getdents(f.file, dirent, count);
+
 	fdput_pos(f);
 	return error;
 }

-- 
2.39.2

