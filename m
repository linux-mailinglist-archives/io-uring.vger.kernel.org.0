Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929EA3C9D21
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241650AbhGOKs4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240397AbhGOKsz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:48:55 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C4CC06175F;
        Thu, 15 Jul 2021 03:46:01 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id dt7so8491377ejc.12;
        Thu, 15 Jul 2021 03:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Eg5z+PqQJCS7nsIZodl87fjo91xdwFW+8QRSOZStkvM=;
        b=LQWgcm7KRHjf93vBGy203TlbK968/zscfRdA2n1dVI4piLF9FfmeFA126caPP2oE78
         DVWVOgAU6dFr6wO+YSioRibIdl1/RXXeH3JLLR0We9YaIa2uAeAk6YWUbf5J6pTxO1B+
         Ds68eROYSfQsPXOxEwzeGevWMZh429GeKyfmzh8YpIoMlevNz8rsZ/SUjU0F3Jhsspw5
         79YSq+z7RROV/RPzgEpUQbRbcD9aM3u7R1of6hj4ND3k0xygqHj5iWGR6fNnbKEPq237
         RMsCqw/0OecmxaWEY5GsXCrOeY0pYqI9Awc32k1+XDGXdKcJecrAWGVymVZzKkxGUdF6
         yD6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eg5z+PqQJCS7nsIZodl87fjo91xdwFW+8QRSOZStkvM=;
        b=MKSLh4IUuUtXjMw3keruruthwKtCMpV0GYbv3NJEj+QvrpNGloZFDfO4AlLS2kl+HW
         DevsAZ9JqYtE40qZKU+DjKsGvXqnPPJYbfuAh+CBsr92OP1s9qdevtktKHi1UDopRoEa
         tcSaRogg4P81opN2CqJNGgOKyEvG8VaLBiL1kAms91WyH8Zg33mutMHRUw6dBq9TzRQr
         hBbMpmL0Y0mnzaXaf9soQvSBDKdvU6It/iuPTL7CBcXWSd2X9KNk0d+sLeZs7WDY+yIh
         bpE3pOTkYrOtsVCiSOdyAVd59fUo9C9E/y8ZMBRink1LfTyLokC6bXzLZeACCrYzpwxc
         N5iw==
X-Gm-Message-State: AOAM5315gOSPFtZ/5ltprIycXojAASh8NUtMCHKC9MHA7ZxDsLYOSQQP
        WyrZlk/EQjxck/b2rYiZvSU=
X-Google-Smtp-Source: ABdhPJwF8vbY3o/S8MxXSPmtad1KLXkdp7coSv4pKOiKkG9lQ1G66Ypabmk1yxdG29pT+t9GpHTUDg==
X-Received: by 2002:a17:906:d541:: with SMTP id cr1mr4800913ejc.81.1626345959863;
        Thu, 15 Jul 2021 03:45:59 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id d19sm2231498eds.54.2021.07.15.03.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:45:59 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v2 08/14] namei: clean up do_mknodat retry logic
Date:   Thu, 15 Jul 2021 17:45:30 +0700
Message-Id: <20210715104536.3598130-9-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715104536.3598130-1-dkadashev@gmail.com>
References: <20210715104536.3598130-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

No functional changes, just move the main logic to a helper function to
make the whole thing easier to follow.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/io-uring/CAHk-=wiG+sN+2zSoAOggKCGue2kOJvw3rQySvQXsZstRQFTN+g@mail.gmail.com/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 4008867e516d..f7cde1543b47 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3745,29 +3745,26 @@ static int may_mknod(umode_t mode)
 	}
 }
 
-static int do_mknodat(int dfd, struct filename *name, umode_t mode,
-		unsigned int dev)
+static int try_mknodat(int dfd, struct filename *name, umode_t mode,
+		       unsigned int dev, unsigned int lookup_flags)
 {
 	struct user_namespace *mnt_userns;
 	struct dentry *dentry;
 	struct path path;
 	int error;
-	unsigned int lookup_flags = 0;
 
-retry:
 	error = may_mknod(mode);
 	if (error)
-		goto out1;
+		return error;
 	dentry = __filename_create(dfd, name, &path, lookup_flags);
-	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto out1;
+		return PTR_ERR(dentry);
 
 	if (!IS_POSIXACL(path.dentry->d_inode))
 		mode &= ~current_umask();
 	error = security_path_mknod(&path, dentry, mode, dev);
 	if (error)
-		goto out2;
+		goto out;
 
 	mnt_userns = mnt_user_ns(path.mnt);
 	switch (mode & S_IFMT) {
@@ -3786,13 +3783,20 @@ static int do_mknodat(int dfd, struct filename *name, umode_t mode,
 					  dentry, mode, 0);
 			break;
 	}
-out2:
+out:
 	done_path_create(&path, dentry);
-out1:
-	if (unlikely(retry_estale(error, lookup_flags))) {
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
-	}
+	return error;
+}
+
+static int do_mknodat(int dfd, struct filename *name, umode_t mode,
+		unsigned int dev)
+{
+	int error;
+
+	error = try_mknodat(dfd, name, mode, dev, 0);
+	if (unlikely(retry_estale(error, 0)))
+		error = try_mknodat(dfd, name, mode, dev, LOOKUP_REVAL);
+
 	putname(name);
 	return error;
 }
-- 
2.30.2

