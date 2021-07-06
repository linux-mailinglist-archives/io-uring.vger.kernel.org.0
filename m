Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2873BD71B
	for <lists+io-uring@lfdr.de>; Tue,  6 Jul 2021 14:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242020AbhGFMwa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Jul 2021 08:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238698AbhGFMwF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Jul 2021 08:52:05 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FE5C06175F;
        Tue,  6 Jul 2021 05:49:26 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id v14so12545588lfb.4;
        Tue, 06 Jul 2021 05:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tPu24Nbaaffql0eGi2id6DLtb7/OVopMbz8ZSt5K/Is=;
        b=ZzdIkUSPvVhkHZofM1ZoQKjurItoIqOj5KagBMunGxG6rrjVs48Wt1qWU5d+mp8IJY
         lDApPYV+us25Js5hUqZDyHSMY+fEpIBZuxbvly6vnjrZWKvbmVO/NS9XpCSI7zHFohGF
         UpT2nK9jQ+sbftz/KqLfxEoaKdRSLFnWlw2fOPUCeCt0AGT9Z79Pb9OJBY4UH5hZyNgI
         TLoY0aTZSNUiDBjFyMUK5CrC6hBONhYR/8L5CyifSO43tnA7WfHDZ/hfatPpehZa45ep
         C/mI6EH1GdUIv7wF+CofJm8Ng8iXFegd54r7gVL7DAS96KXvK7WBlAEzYdgZekU2EVHQ
         XsNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tPu24Nbaaffql0eGi2id6DLtb7/OVopMbz8ZSt5K/Is=;
        b=eqEaHS2eC/eL+/ytMAUmigdIvKvPrAGRpWLsbxQZUwoa1+FRTh2AKeewP+VM4TbT7a
         Mz+ZrrZmtiynQnl4lANvwrdca1O2pBeCBtqbok+u6VMnv8ZOh85gHeoNnV00bfPRnCsD
         UoA9Kwiz5sUVBoTqpvElYinyEdqtaX6ZUK465kq/SL7Fst1LPt5BLZuRvnIPnyfH1Css
         qkOypEtXDuX6tL+kJHfMZLsChZeME+NHwnCbDuP8xY+1JMqtSioQ0MWQFoalkzPQIbei
         IHkGOVdFNrZYv1ax0BRwT8Y5ZHKsTSPn3JRiLfty3fPAvSOkPFx38wykOxaKHC9EFF9I
         m6bQ==
X-Gm-Message-State: AOAM5328XMfTlMOHDyK+wvjKrJhVbBLrDmChna43sjl4aASfmq6LmPD5
        xJ8jREUyG/Jan79ShQesXTE=
X-Google-Smtp-Source: ABdhPJy9RjJaIlXnnq+e5caG5Ty58BQnMfnuVjcKGt7wY0gSHE06DjE66VY1gPXCAe+ow+7IkDmzVw==
X-Received: by 2002:a05:6512:22d5:: with SMTP id g21mr2986535lfu.391.1625575764811;
        Tue, 06 Jul 2021 05:49:24 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id r18sm139519ljc.120.2021.07.06.05.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 05:49:24 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v7 04/10] fs: make do_mknodat() take struct filename
Date:   Tue,  6 Jul 2021 19:48:55 +0700
Message-Id: <20210706124901.1360377-5-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706124901.1360377-1-dkadashev@gmail.com>
References: <20210706124901.1360377-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass in the struct filename pointers instead of the user string, for
uniformity with the recently converted do_unlinkat(), do_renameat(),
do_mkdirat().

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/io-uring/20210330071700.kpjoyp5zlni7uejm@wittgenstein/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/namei.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 8bc65fd357ad..34b8968dec92 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3727,7 +3727,7 @@ static int may_mknod(umode_t mode)
 	}
 }
 
-static long do_mknodat(int dfd, const char __user *filename, umode_t mode,
+static long do_mknodat(int dfd, struct filename *name, umode_t mode,
 		unsigned int dev)
 {
 	struct user_namespace *mnt_userns;
@@ -3738,9 +3738,9 @@ static long do_mknodat(int dfd, const char __user *filename, umode_t mode,
 
 	error = may_mknod(mode);
 	if (error)
-		return error;
+		goto out1;
 retry:
-	dentry = user_path_create(dfd, filename, &path, lookup_flags);
+	dentry = __filename_create(dfd, name, &path, lookup_flags);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
@@ -3748,7 +3748,7 @@ static long do_mknodat(int dfd, const char __user *filename, umode_t mode,
 		mode &= ~current_umask();
 	error = security_path_mknod(&path, dentry, mode, dev);
 	if (error)
-		goto out;
+		goto out2;
 
 	mnt_userns = mnt_user_ns(path.mnt);
 	switch (mode & S_IFMT) {
@@ -3767,24 +3767,26 @@ static long do_mknodat(int dfd, const char __user *filename, umode_t mode,
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
+	putname(name);
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

