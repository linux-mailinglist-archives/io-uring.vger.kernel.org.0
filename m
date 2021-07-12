Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413D63C5C4A
	for <lists+io-uring@lfdr.de>; Mon, 12 Jul 2021 14:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbhGLMkF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jul 2021 08:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233699AbhGLMkE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jul 2021 08:40:04 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30738C0613DD;
        Mon, 12 Jul 2021 05:37:15 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id w14so16075186edc.8;
        Mon, 12 Jul 2021 05:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P41raHAuj/pcv2cD5b4j6cUVpmmMBYiOzuiSoR2Uwxc=;
        b=TqoQc3/b3Fo4bNf/n6MVBvnUa4h4ho5lUHSFhxHFj4XP+pKyzPlvLTvXbdcW04UqMN
         ORY01xv4nwScPZViCRyKA7CSeyM+Oi8oEbJ+cAQhlsYz8CKxcfH8y62RzF4MeOxARwON
         Na1do0Cndg9L02kqarhIK8QCKEvQvLJzX//9yjwuopwxInRGLC5bf/0mUI/JC2sDyUhu
         4NwYaQAnSh8PlbX0PRg/1QHKX+tRXWBSaD0XLPeHi6qOsqYhW00qifO2KV4qedfQSidA
         YUKGU3CPxdogrp7gF5lhWiM5wFBT9bfRl9dcgZcmvDyCMxqbV01Xv+2c3QCchCoO3ms3
         Alhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P41raHAuj/pcv2cD5b4j6cUVpmmMBYiOzuiSoR2Uwxc=;
        b=OEmKEtSpC2bBK3TwZ0850Y274g3iDakStAUfij0bcMdVfweutizEKMlRZUqpPihrzw
         9FrZ6rztkaLcT3YIWT8kw149zq9aCq8MXqUKZ6AyBSpnDRHz9sIOo7BpscH27cHoMPR6
         ZHnmQosvyrJHgl4q+oV90kR42lq2+s7NCB37lClRFf41dVlxBHOJe7NE9/kxqCxA2MNB
         j1WNlYo9Ss9SqCWp3GcFNmf0Hmed+TiEeVW00/wMJklxUinTG0ZHbxmhXGau1HDtkeuC
         oZzo4htrMCWceLxhtcxJwZ6pvg4F5cVGPDo1yJLF0n564USxrZgY2GyWqH7NQecGlGJL
         fm/Q==
X-Gm-Message-State: AOAM530tC9Mx5veLv4P2hUg+BgyJ0VT1G9F4gMH5w20oh3G9ftnej9hC
        omuMXI7REKWUmgqExieFrO8=
X-Google-Smtp-Source: ABdhPJwxucei/aajRtRFbKbnul6duGPPJbUvR+0UEPRZZ0shVRxvpS25gWGjCyZ0y1+cL/22tSCBrg==
X-Received: by 2002:a05:6402:4c5:: with SMTP id n5mr63705758edw.322.1626093433895;
        Mon, 12 Jul 2021 05:37:13 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id y7sm6785216edc.86.2021.07.12.05.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 05:37:13 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  4/7] namei: clean up do_mknodat retry logic
Date:   Mon, 12 Jul 2021 19:36:46 +0700
Message-Id: <20210712123649.1102392-5-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712123649.1102392-1-dkadashev@gmail.com>
References: <20210712123649.1102392-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Moving the main logic to a helper function makes the whole thing much
easier to follow.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/io-uring/CAHk-=wiG+sN+2zSoAOggKCGue2kOJvw3rQySvQXsZstRQFTN+g@mail.gmail.com/
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---
 fs/namei.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index b9762e2cf3b9..7bf7a9f38ce2 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3745,29 +3745,27 @@ static int may_mknod(umode_t mode)
 	}
 }
 
-static int do_mknodat(int dfd, struct filename *name, umode_t mode,
-		unsigned int dev)
+static int mknodat_helper(int dfd, struct filename *name, umode_t mode,
+			  unsigned int dev, unsigned int lookup_flags)
 {
 	struct user_namespace *mnt_userns;
 	struct dentry *dentry;
 	struct path path;
 	int error;
-	unsigned int lookup_flags = 0;
 
 	error = may_mknod(mode);
 	if (error)
-		goto out1;
-retry:
+		return error;
 	dentry = __filename_create(dfd, name, &path, lookup_flags);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto out1;
+		return error;
 
 	if (!IS_POSIXACL(path.dentry->d_inode))
 		mode &= ~current_umask();
 	error = security_path_mknod(&path, dentry, mode, dev);
 	if (error)
-		goto out2;
+		goto out;
 
 	mnt_userns = mnt_user_ns(path.mnt);
 	switch (mode & S_IFMT) {
@@ -3786,13 +3784,20 @@ static int do_mknodat(int dfd, struct filename *name, umode_t mode,
 					  dentry, mode, 0);
 			break;
 	}
-out2:
+out:
 	done_path_create(&path, dentry);
-	if (retry_estale(error, lookup_flags)) {
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
-	}
-out1:
+	return error;
+}
+
+static int do_mknodat(int dfd, struct filename *name, umode_t mode,
+		unsigned int dev)
+{
+	int error;
+
+	error = mknodat_helper(dfd, name, mode, dev, 0);
+	if (retry_estale(error, 0))
+		error = mknodat_helper(dfd, name, mode, dev, LOOKUP_REVAL);
+
 	putname(name);
 	return error;
 }
-- 
2.30.2

