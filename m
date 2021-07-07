Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF903BE7E7
	for <lists+io-uring@lfdr.de>; Wed,  7 Jul 2021 14:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhGGMay (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Jul 2021 08:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbhGGMax (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Jul 2021 08:30:53 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DCAC061760;
        Wed,  7 Jul 2021 05:28:11 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id eb14so3211053edb.0;
        Wed, 07 Jul 2021 05:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+aL8eUyCcZIm7m9c9cpQrgQm638OpqOKLxLINa0Iv48=;
        b=nECrUqx96pfsG0+U9bgzmafnKr7nwXea/HDgen+8gMNzKFHKMFh5TQCNTE4ObNJMaW
         YLMGfDx2COXutUExDnzBMiX7HxHUzvz/EccGzNoGT4MWZ5TS+lrToi7dkgfsic87vSTp
         5EFC6DOa2Jg3fkhItk7bHnlmCCF2kMB3DQO0UXkI1XE8aSdbSmueIM6CB/oS9D4WsT9m
         4NYGDPvOSw7nIioKxGSFUzQf+JIEcIaYbJkheQ2tjNHB9Ex0IQ6DAwTnuYHEGsKE9RYq
         1G6sD/LZ8AYjPsLmXiL3NBTl3vvFnumNeFpfNDYiE3PIEJpjfn18qYlfaKGQmFzTZmKt
         xsLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+aL8eUyCcZIm7m9c9cpQrgQm638OpqOKLxLINa0Iv48=;
        b=dOdChFcpBscC54g2iS6KXiLtlRwFRlzGK/1HGsl8dGQfNe85x6W0pOgTAEg6Q+s9IJ
         uoShAxkGpAe1y+qH8u2ans8KQoheYxCSaewcrAJP/wqpAgrF95cWHGcxiv0FIjpdp59f
         ji/OY+fsTpb8snMFSN58bxk/VR0J9e5pKzwEDPZadLby0ooKrljXpY5840HEOIbUIsDK
         TUwz9FklQ59w7pI3lxp7VIDUbcJ/C9L/i80ugOLjp2930ef93x3lzqeSG/DcSmiMILKW
         u2q+9eIYxId3xO+LT4+qpExrt99tkxPe9EBruVtFHiu6d87BkKMH3kudjnmHzpUnhMPC
         GPOg==
X-Gm-Message-State: AOAM531LznDSm9PuWK6mDVQ5AcEGKnXAF4zjkIVnBpeyUcIldVY5cSLq
        pBA0IDurPbyM0VImqayVMP8=
X-Google-Smtp-Source: ABdhPJyJUKVucU8K2aKn2zn/Ojk/7XK+oyaPvpRS+eowo9yqQ5mSiy7+T2yfGwpXMFsXKhYIvW75og==
X-Received: by 2002:a05:6402:290c:: with SMTP id ee12mr29532948edb.161.1625660890072;
        Wed, 07 Jul 2021 05:28:10 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id ze15sm7019821ejb.79.2021.07.07.05.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 05:28:09 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v8 07/11] namei: add getname_uflags()
Date:   Wed,  7 Jul 2021 19:27:43 +0700
Message-Id: <20210707122747.3292388-8-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210707122747.3292388-1-dkadashev@gmail.com>
References: <20210707122747.3292388-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are a couple of places where we already open-code the (flags &
AT_EMPTY_PATH) check and io_uring will likely add another one in the
future.  Let's just add a simple helper getname_uflags() that handles
this directly and use it.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/io-uring/20210415100815.edrn4a7cy26wkowe@wittgenstein/
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/exec.c          | 8 ++------
 fs/namei.c         | 8 ++++++++
 include/linux/fs.h | 1 +
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 18594f11c31f..df33ecaf2111 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2069,10 +2069,8 @@ SYSCALL_DEFINE5(execveat,
 		const char __user *const __user *, envp,
 		int, flags)
 {
-	int lookup_flags = (flags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
-
 	return do_execveat(fd,
-			   getname_flags(filename, lookup_flags, NULL),
+			   getname_uflags(filename, flags),
 			   argv, envp, flags);
 }
 
@@ -2090,10 +2088,8 @@ COMPAT_SYSCALL_DEFINE5(execveat, int, fd,
 		       const compat_uptr_t __user *, envp,
 		       int,  flags)
 {
-	int lookup_flags = (flags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
-
 	return compat_do_execveat(fd,
-				  getname_flags(filename, lookup_flags, NULL),
+				  getname_uflags(filename, flags),
 				  argv, envp, flags);
 }
 #endif
diff --git a/fs/namei.c b/fs/namei.c
index add984e4bfd0..ab7979f9daaa 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -203,6 +203,14 @@ getname_flags(const char __user *filename, int flags, int *empty)
 	return result;
 }
 
+struct filename *
+getname_uflags(const char __user *filename, int uflags)
+{
+	int flags = (uflags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
+
+	return getname_flags(filename, flags, NULL);
+}
+
 struct filename *
 getname(const char __user * filename)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c3c88fdb9b2a..5885a68d2c12 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2781,6 +2781,7 @@ static inline struct file *file_clone_open(struct file *file)
 extern int filp_close(struct file *, fl_owner_t id);
 
 extern struct filename *getname_flags(const char __user *, int, int *);
+extern struct filename *getname_uflags(const char __user *, int);
 extern struct filename *getname(const char __user *);
 extern struct filename *getname_kernel(const char *);
 extern void putname(struct filename *name);
-- 
2.30.2

