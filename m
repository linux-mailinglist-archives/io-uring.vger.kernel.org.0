Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A565E3C9CE4
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241490AbhGOKjU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241476AbhGOKjT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:39:19 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634FFC06175F;
        Thu, 15 Jul 2021 03:36:25 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id nd37so8498134ejc.3;
        Thu, 15 Jul 2021 03:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EHG39bGGVJfcCHnCV+DYwcxM8Y412mNnw+khYb5tB2Y=;
        b=XP2eWuuJLIfm0+dH47F7TdkoP6rhDrfg3RYsN1hDfMWRPxjl13t9frxYnXMgGsjpLb
         NK6T4SF0XbljFd/Yb31UlvIRqmRs4Z8YXnVUF932qpHGmVbLyPmrQd4AeUkRTU6MW5QB
         97DEQKMfw9moZeh/+hOc8eiOYfWSweVsW2izImfvk6qZGn5a/C14hpMi+an+zdxKm3xA
         iElKtU+mG9jzwZuBkQxYR4bfEp9zCls/psI5GYF53FvbIqABsyOY2NfdQvbzOEIjkDG+
         S+SHO7UN6PZu4Hvgel1Vdq+HGCMMfWayMa6X8fyrs1QsQ714IHFLtDiT7Lo9VRiX49p/
         IfRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EHG39bGGVJfcCHnCV+DYwcxM8Y412mNnw+khYb5tB2Y=;
        b=koU+49itNBlCtMr3O9FJmJTxN1WyMQGbJKEWKBmGSUnphCoCTTEsDrKghAeBMIX0Rz
         ZyCzcGZjnej4UGxfcsQzYEsCvdrbAvYXLDQ2kD5tiZkfyzSLrKDlX0mYHQ2zTsO/bJqN
         yJfLKcdOixbZkPwRKrHEJxBDPO6FrmA/gebTaIS8w+j5w23ETQ2qPB7ha+qG39Jv948s
         74SJvjczN9z/HbKamfcfaNtwCOrFksn1XIDKRWBnspAiFrW6oRYeLn3CC9bCiD0dy9ZT
         yLlkqjYTGZiD2qnEcoOmHmu1C43gtqgxi5rlQ2IbBtLEKlx06zNQtOK7MV3y6DSciUu3
         9wuA==
X-Gm-Message-State: AOAM5313JZH5HLr7VOWywEz7HT2YOlQG4Q68YzBQ+Ujl83Yek4kAtb9u
        jZT1TjYgUEd/iDUvUsXYT5w=
X-Google-Smtp-Source: ABdhPJwAYanTIqczz5voJE7//P+9hx6Vjmqksh9pkNzoqCzbIzfUdpcZ1EZA8CpwwiiW4cVdWpmMOQ==
X-Received: by 2002:a17:906:8158:: with SMTP id z24mr4799397ejw.359.1626345384047;
        Thu, 15 Jul 2021 03:36:24 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id dd24sm2228464edb.45.2021.07.15.03.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:36:23 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  10/14] namei: clean up do_symlinkat retry logic
Date:   Thu, 15 Jul 2021 17:35:56 +0700
Message-Id: <20210715103600.3570667-11-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715103600.3570667-1-dkadashev@gmail.com>
References: <20210715103600.3570667-1-dkadashev@gmail.com>
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
 fs/namei.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c4d75c94adce..61cf6bbe1e5c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4234,22 +4234,18 @@ int vfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 }
 EXPORT_SYMBOL(vfs_symlink);
 
-int do_symlinkat(struct filename *from, int newdfd, struct filename *to)
+static int try_symlinkat(struct filename *from, int newdfd, struct filename *to,
+			 unsigned int lookup_flags)
 {
 	int error;
 	struct dentry *dentry;
 	struct path path;
-	unsigned int lookup_flags = 0;
 
-retry:
-	if (IS_ERR(from)) {
-		error = PTR_ERR(from);
-		goto out;
-	}
+	if (IS_ERR(from))
+		return PTR_ERR(from);
 	dentry = __filename_create(newdfd, to, &path, lookup_flags);
-	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
-		goto out;
+		return PTR_ERR(dentry);
 
 	error = security_path_symlink(&path, dentry, from->name);
 	if (!error) {
@@ -4260,11 +4256,17 @@ int do_symlinkat(struct filename *from, int newdfd, struct filename *to)
 				    from->name);
 	}
 	done_path_create(&path, dentry);
-out:
-	if (unlikely(retry_estale(error, lookup_flags))) {
-		lookup_flags |= LOOKUP_REVAL;
-		goto retry;
-	}
+	return error;
+}
+
+int do_symlinkat(struct filename *from, int newdfd, struct filename *to)
+{
+	int error;
+
+	error = try_symlinkat(from, newdfd, to, 0);
+	if (unlikely(retry_estale(error, 0)))
+		error = try_symlinkat(from, newdfd, to, LOOKUP_REVAL);
+
 	putname(to);
 	putname(from);
 	return error;
-- 
2.30.2

