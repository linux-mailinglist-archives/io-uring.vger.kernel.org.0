Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B947E3B2D82
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 13:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbhFXLRb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 07:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbhFXLRa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 07:17:30 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC5AC06175F;
        Thu, 24 Jun 2021 04:15:11 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id j4so9592117lfc.8;
        Thu, 24 Jun 2021 04:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PsIkIlYkcRuVZO2iraM96+UBjw71A+O5XYihkmv99aY=;
        b=SWsU/P3D0kaQR2TvWhtm8l2HrdbIVx85lqNEUyzVr4YQJJfwz/yy/Qv8AFbPPhxlWj
         VWsGrf4YzFPYO6MEIN5WpvwG5Oyh4ikkqq2ULtsaY3jbn0BhNnphKr34Ora7zbX9rllB
         gQXdDmzHITw+AfG73IVyYABmpQ34WcdLWaznKBOScNEEukD5BBiI/lcXeHWl2DYDA+xn
         XTykEoyS+Ti1zULLpfvBzrDZlOsN71um2qclntQrMblCnIDXsAHURdEe70JOENkFM+HK
         DBmkY31x1eh2aBIyZRf+PZHuNsIH0TL00LGmNIP69BarF1TjfC/SIWjFDLAoa3Zn/oy3
         7zIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PsIkIlYkcRuVZO2iraM96+UBjw71A+O5XYihkmv99aY=;
        b=DjPHwbXG2lCYHFnyK+oTG2u9bdT6IORvukIXnMrbKgIMmyxWmiwTg28XPKWFdAORmV
         qbEBajyxqDlkXlnnrsUkFJH9TcI9zSIjce0VZNZxV+o/FSPd3G+yqQ/rbLKyCtXdDepW
         Bh/9MqoxgCQhRUr5sDPMmbmfEOyqx3/jMM9GV0qKx4uoDsaj4kcAVF0yZcsETYwMSd6S
         9YYEwV3Ls1K7hl4FGjEx29vp5cUsZOOgQwW338r7sGi5m+voLQYJ3+Uv2G+26yobg4gW
         t7zjHD/Lf1TCkIjar1qt/yCzTiePXLsv47tkPuWQF0lZT1v1pmVtS6N8YUMf+Q/Ixmpp
         lOSg==
X-Gm-Message-State: AOAM530zNLM6PYydvDo3Po2URdgrPAUVqZKb/YCZExIBUJjL8m/Jz8bN
        o0MIgEqkVqzLph3HJEThsnA=
X-Google-Smtp-Source: ABdhPJwymf6vqvQOLZDszG61wVFkmMLL5CLN4xOOgf20TvIQABfzE9Q+8/AAKCzHtKYGbz8dFJI+yQ==
X-Received: by 2002:ac2:442c:: with SMTP id w12mr3475317lfl.303.1624533309782;
        Thu, 24 Jun 2021 04:15:09 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id q21sm195293lfp.233.2021.06.24.04.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 04:15:09 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v6 3/9] fs: make do_mknodat() take struct filename
Date:   Thu, 24 Jun 2021 18:14:46 +0700
Message-Id: <20210624111452.658342-4-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210624111452.658342-1-dkadashev@gmail.com>
References: <20210624111452.658342-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass in the struct filename pointers instead of the user string, for
uniformity with the recently converted do_unlinkat(), do_renameat(),
do_mkdirat().

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/io-uring/20210330071700.kpjoyp5zlni7uejm@wittgenstein/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/namei.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 49317c018341..9fc981e28788 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3724,7 +3724,7 @@ static int may_mknod(umode_t mode)
 	}
 }
 
-static long do_mknodat(int dfd, const char __user *filename, umode_t mode,
+static long do_mknodat(int dfd, struct filename *name, umode_t mode,
 		unsigned int dev)
 {
 	struct user_namespace *mnt_userns;
@@ -3735,9 +3735,9 @@ static long do_mknodat(int dfd, const char __user *filename, umode_t mode,
 
 	error = may_mknod(mode);
 	if (error)
-		return error;
+		goto out1;
 retry:
-	dentry = user_path_create(dfd, filename, &path, lookup_flags);
+	dentry = __filename_create(dfd, name, &path, lookup_flags);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
@@ -3745,7 +3745,7 @@ static long do_mknodat(int dfd, const char __user *filename, umode_t mode,
 		mode &= ~current_umask();
 	error = security_path_mknod(&path, dentry, mode, dev);
 	if (error)
-		goto out;
+		goto out2;
 
 	mnt_userns = mnt_user_ns(path.mnt);
 	switch (mode & S_IFMT) {
@@ -3764,24 +3764,27 @@ static long do_mknodat(int dfd, const char __user *filename, umode_t mode,
 					  dentry, mode, 0);
 			break;
 	}
-out:
+out2:
 	done_path_create(&path, dentry);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
 	}
+out1:
+	if (!IS_ERR(name))
+		putname(name);
 	return error;
 }
 
 SYSCALL_DEFINE4(mknodat, int, dfd, const char __user *, filename, umode_t, mode,
 		unsigned int, dev)
 {
-	return do_mknodat(dfd, filename, mode, dev);
+	return do_mknodat(dfd, getname(filename), mode, dev);
 }
 
 SYSCALL_DEFINE3(mknod, const char __user *, filename, umode_t, mode, unsigned, dev)
 {
-	return do_mknodat(AT_FDCWD, filename, mode, dev);
+	return do_mknodat(AT_FDCWD, getname(filename), mode, dev);
 }
 
 /**
-- 
2.30.2

