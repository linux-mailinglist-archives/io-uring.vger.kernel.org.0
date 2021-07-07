Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB2F3BE7E2
	for <lists+io-uring@lfdr.de>; Wed,  7 Jul 2021 14:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhGGMax (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Jul 2021 08:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbhGGMat (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Jul 2021 08:30:49 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20AEC061574;
        Wed,  7 Jul 2021 05:28:07 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id v20so2952196eji.10;
        Wed, 07 Jul 2021 05:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ldQ7yGS4aEvHdrCjdrJwmRjCzLuQxIXl0hNYPBTwz2Q=;
        b=Ri5Bpwad+zlp9Z+l1hjneI54yDTzOVjTRro1+7EstTjdfHq7b3NtctF/n5dfX4SsbG
         jnoRTxmxt/V4fRUpPXtPoKU2UBLUx49gjZmO9WkAld9bbY/3ynbmgo4mZm4wzheftNqt
         /Uiklv5cQwYHcDIy3jSFYlnIbzQ56cYCgrkWPEOtKHM//hsOP7iWjJDdvf3o++HSu3B8
         fYJsyjW/yJ1OzIXAHucPGww9s2HdA6LCDzLnw3YpLjMmTK0mTPHOskPpQVug4QYZklkN
         mKYkG9+jgL65D+xYm4IREePGZ9Q3eal6nMBN2GZy+rDDihkkFQX5DoGgC2fEZQRj1302
         dH+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ldQ7yGS4aEvHdrCjdrJwmRjCzLuQxIXl0hNYPBTwz2Q=;
        b=jlgHQV/K7i30LTveKXtgQpypYxNrcGpU6zAg9y6toAdUhmrsExUQpeyb/Nb/D3Lyr0
         knL71tpdU797a0q5M4VWbl/8nGVV81yRMlNt4hf6WubtO+1Os9r7Ge0R7JQoM2kUWBLa
         Hzq3+ohlO1zHrg1vvkIomCxFQtuqEtL3tg09zCzlJimXM+oJ4ipPPvL3o6UaFmTUe8qL
         Qxy+vbl6nMM+UiDySh2jxZFVKqDcVKyq3f3Kjmr5/5apOFc+2jSg1JWgKYpSR+lFxcuJ
         kBnFX0Jn9z/fsMnlvc9yP6nVvMy91sY7XiIfvdUf40zEiDH6VZp5MZgFZGoKtPVOqIGs
         qiKQ==
X-Gm-Message-State: AOAM531to0HK66MlXIsGf4a0G1MK/86ktKH47ef3hLO3kdSetrE3tjaQ
        qf5tu3EQ9oJgyu3dVUPrvEk=
X-Google-Smtp-Source: ABdhPJzHGPXxH0KlQZcnraA2FCmvGiT0o4BbrJLg5boVjz0QVx/QrR/a4AW2yn0o5Uk9dPpFPmVs0g==
X-Received: by 2002:a17:906:fa05:: with SMTP id lo5mr24162834ejb.272.1625660886669;
        Wed, 07 Jul 2021 05:28:06 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id ze15sm7019821ejb.79.2021.07.07.05.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 05:28:06 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v8 05/11] fs: make do_mknodat() take struct filename
Date:   Wed,  7 Jul 2021 19:27:41 +0700
Message-Id: <20210707122747.3292388-6-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210707122747.3292388-1-dkadashev@gmail.com>
References: <20210707122747.3292388-1-dkadashev@gmail.com>
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

