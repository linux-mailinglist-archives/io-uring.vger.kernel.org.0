Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A3D3BF59A
	for <lists+io-uring@lfdr.de>; Thu,  8 Jul 2021 08:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhGHGh7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jul 2021 02:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbhGHGh5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jul 2021 02:37:57 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8137FC061574;
        Wed,  7 Jul 2021 23:35:15 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ga42so7598353ejc.6;
        Wed, 07 Jul 2021 23:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ldQ7yGS4aEvHdrCjdrJwmRjCzLuQxIXl0hNYPBTwz2Q=;
        b=HHFQhUq/vzRr043P2CTflyIRyRVpFHZUm2CtPvk9LQxsu9Gu8UGE1ohOc4n4HQP3hb
         BrA8p+u9bg+m1hHqGS4wkSWxkdSVEum+LRiJMfOxL7y2WLvY7GsaYWLihV0NeAPWRBDI
         GRw1QOxWwvGzNL9N6tWFLgsBzdcahQVT5DX75TSh+9WWcqUGYF6IqIS/aDCWd1uGTuOz
         QbtBCh7x0wU4GhASWGIpsrTXW9Xp+stdJFitbHy/V1ZyA+gr/MBQpCHTXNQrDICY69Yn
         5yiwRjVeSqZAEWp03rgC+VBNoHbqcNhuR7qiW62bVGT7o+nJaDThhbcu4NaFamlfU6MN
         B+6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ldQ7yGS4aEvHdrCjdrJwmRjCzLuQxIXl0hNYPBTwz2Q=;
        b=hN8r9pgyQ6pL3BoDJTJ8PugaA9Wmh7hC8A9EsqsqwVKRiQ0Z6GO8B2nBT909NO/8tS
         gbmDls6yuM7Am/U9gw/uqVICZC62Br+Q4+HX9EfbWJIsjyye+t/aWQGKA0KqxPxUGg4X
         egjTr2E9vzWHGyDPavmGVcZhhLn1Z8ZyUmTxbORO9OkkYKZmV9+oX/ERSUsmiCI0TZjM
         +iHv4+NrKNEv6h7iPDWh90OBmR66DiRK8ajVMfljgE8Y8Jr3sj75KXqlwgFJtZyf1vnR
         62lih3rW7xHVNhdv7UnkYaY4CypHVD2a5INxyNshX9SROeIisfwdAWYIk5UWIwrMbUei
         O5aw==
X-Gm-Message-State: AOAM532sJhe8/JbYhsSih9N5XG6ikHZAjIdtcz15Vq2VqhNIzIYh6Leu
        0BF2p+G25a5rhB2zo8DrBvc=
X-Google-Smtp-Source: ABdhPJx51asT/OQxLxRQQg6VNUir1JVmH6bjOkv04OZm1KZfb8d6njWZnZL1SkD8rAQvzXZJCRzOcw==
X-Received: by 2002:a17:907:9701:: with SMTP id jg1mr17644208ejc.56.1625726114200;
        Wed, 07 Jul 2021 23:35:14 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id u21sm410260eja.59.2021.07.07.23.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 23:35:13 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v9 04/11] namei: make do_mknodat() take struct filename
Date:   Thu,  8 Jul 2021 13:34:40 +0700
Message-Id: <20210708063447.3556403-5-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210708063447.3556403-1-dkadashev@gmail.com>
References: <20210708063447.3556403-1-dkadashev@gmail.com>
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
 fs/namei.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 54d5f19ee1ce..0bc8ff637934 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3729,7 +3729,7 @@ static int may_mknod(umode_t mode)
 	}
 }
 
-static long do_mknodat(int dfd, const char __user *filename, umode_t mode,
+static long do_mknodat(int dfd, struct filename *name, umode_t mode,
 		unsigned int dev)
 {
 	struct user_namespace *mnt_userns;
@@ -3740,17 +3740,18 @@ static long do_mknodat(int dfd, const char __user *filename, umode_t mode,
 
 	error = may_mknod(mode);
 	if (error)
-		return error;
+		goto out1;
 retry:
-	dentry = user_path_create(dfd, filename, &path, lookup_flags);
+	dentry = __filename_create(dfd, name, &path, lookup_flags);
+	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
+		goto out1;
 
 	if (!IS_POSIXACL(path.dentry->d_inode))
 		mode &= ~current_umask();
 	error = security_path_mknod(&path, dentry, mode, dev);
 	if (error)
-		goto out;
+		goto out2;
 
 	mnt_userns = mnt_user_ns(path.mnt);
 	switch (mode & S_IFMT) {
@@ -3769,24 +3770,26 @@ static long do_mknodat(int dfd, const char __user *filename, umode_t mode,
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

