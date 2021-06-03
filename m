Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02163999BC
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhFCFU7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbhFCFU6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:20:58 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E60C061760;
        Wed,  2 Jun 2021 22:19:00 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id cb9so5657085edb.1;
        Wed, 02 Jun 2021 22:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MkFs7GOSKkUTZGz9Kob9gnsknMUkw6urfLA/Fs3ZvX8=;
        b=P2ZyoCizdR8kC57pNYXGUKMsuoDdsCzd5buakmd6QPy8tO4khSoBQg21DjOeS2WQjZ
         RSGd2/YwINdZ22CYCC2myrQzFUwD1A7mJrCTuOnJM0lzqJ9EmbdU9a50dtrCOh085eIn
         olbWBtRnblhucmy6tzykdkYmYQrskAEPznsWuDE0E6dGUEQhj+0x2f3A0lbbxMYVWNVc
         1/0sqb3x5kVQ5vdm0iIwaHPpCVeM/3NCDhkY7K8ggEH6kO9otzzaaV32HdDGN7GofsFy
         YzuEEzapePOzICHy4c3Xaf7/9ByAtr5hilfIKWLIX7RTO0Jn4FUqm/LVC5WczAtCcWNp
         /j4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MkFs7GOSKkUTZGz9Kob9gnsknMUkw6urfLA/Fs3ZvX8=;
        b=HRKRuQrJcWSW/+z6k9m4/zOa3WHQyCtNcJEM1dmQhKugr9X3QsGu4zfP2CDNelRLQC
         eKWgrVXHrnYSirUdCKsRijZEc2e74OQYIULg/uhQS7bPzKSpX5o8inaR9GCpiRIQTiS0
         ODP8jCcYUJp04LROQ/g63GUtdynAqCa8NfrUa70h4yvTASVzh20Seu9gqzPEY64qcDRz
         fB7MJbyTSSwBPIBK+QqDlLpKcu70BWhdbevwDzlFbCUu+EkfCsMJ2hw7rDZVGjqZVfMY
         NUnRluazSdMd+TXZtnSFWO+SFtXHJmN8k5cjBFJ0EuYzzqEm6OaW+kfyZMNzMKoNqAro
         8mtg==
X-Gm-Message-State: AOAM530fLjpUITRJCXneA+dsnXebNuYChT+wZqf1A02oSbZH9X5yhqe3
        JpDZCBFtKb6tO6XEYudIj84=
X-Google-Smtp-Source: ABdhPJy8vr8w2G+BBIiMHGgZj6xSA0lYNmdaZlJxrXNgDzVdPw0oZgPX6ZcPG5zsw3PNsYIVrqjIGg==
X-Received: by 2002:a05:6402:2688:: with SMTP id w8mr1085454edd.130.1622697539086;
        Wed, 02 Jun 2021 22:18:59 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id f7sm963668ejz.95.2021.06.02.22.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:18:58 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v5 03/10] fs: make do_mknodat() take struct filename
Date:   Thu,  3 Jun 2021 12:18:29 +0700
Message-Id: <20210603051836.2614535-4-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603051836.2614535-1-dkadashev@gmail.com>
References: <20210603051836.2614535-1-dkadashev@gmail.com>
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

