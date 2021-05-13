Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4367337F66D
	for <lists+io-uring@lfdr.de>; Thu, 13 May 2021 13:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbhEMLJu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 May 2021 07:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbhEMLIx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 May 2021 07:08:53 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADE9C06174A;
        Thu, 13 May 2021 04:07:42 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id s20so33792060ejr.9;
        Thu, 13 May 2021 04:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=knsJcN/dC0mqT5Tdqu9B1hkAYWGeRZxKhI9dKtUA34Q=;
        b=iO2cuqisZnI14yyoGb9zXHu/f2cN25fWll1Ew7Ay6gdau4yYbSH/lZb/4N/O+qaAjS
         10zlcnJtH9GZE1O84bYlxx67QlDkttW2DZ85tLoF/NBxAgjKeZdrIHzqIESaNVYSewR0
         cq1cYg18sSij28+gGwSrDzcYA5IiWlhNvUZcpnFlJ60Z0HoWQjieupUh39+RlqTEh8nB
         U1t8HzlpMr4XN2XQwhTNAidh9NNXiDNt7baSxBX3WjDVJvieBPu5rj2kgYvd58G5+dQA
         gbetyctnOtZ9lySCjlmaFyP/c/c2VP40vT9EuzBEFNlxhcl3AmBFs81/TLa65VL7ewJX
         TBQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=knsJcN/dC0mqT5Tdqu9B1hkAYWGeRZxKhI9dKtUA34Q=;
        b=B219VGYvGu7P+iM8skYscwdYicgZk8kwE0ck0+aAMrZAH3whoy12BoMaKQiLBt8ew+
         ZJRjoon0I/1ZZuIkzcOo58Ru3NJHBf7VvmMqMJzfo9G1CjDi1FWGncT9FnfsOG0YO05E
         7BOX7aejf907yVV6VyzjnDNoqYEu90tILko3Pc/BZIdKXkX7hxzzT6baWAN1QZOVptT6
         egaQD1z8lyHbHCstcNvUvXJwFt1+6xrFAjEvzdU0MvS30r1pgKc4iuiaIL+YyOzlZQgg
         N2nASPM5pDAbKf8CpS4lGC3kNb1ua7GI8L85owrYBRb0EWrGG/dApM144dUNqfHOAs2Y
         TeYw==
X-Gm-Message-State: AOAM532/HPxxllj6BJnRPkcn0Bm38wnCTFmR7+SmMllTmYzeLA3Tgnki
        q51gu1EX+4XT2G7D6pjsiWg=
X-Google-Smtp-Source: ABdhPJxNH4IEnp1yG0+7APgA71wsN/KSlNkGZygqZicE+V5Q9cfXZ3SNHYfLbtastnbowoYdcJwHfg==
X-Received: by 2002:a17:906:b74f:: with SMTP id fx15mr4164179ejb.85.1620904061058;
        Thu, 13 May 2021 04:07:41 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id bn7sm1670864ejb.111.2021.05.13.04.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 04:07:40 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v4 3/6] fs: make do_mknodat() take struct filename
Date:   Thu, 13 May 2021 18:06:09 +0700
Message-Id: <20210513110612.688851-4-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210513110612.688851-1-dkadashev@gmail.com>
References: <20210513110612.688851-1-dkadashev@gmail.com>
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
Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/io-uring/20210330071700.kpjoyp5zlni7uejm@wittgenstein/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
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

