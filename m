Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426B83999C4
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhFCFWB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:22:01 -0400
Received: from mail-ed1-f46.google.com ([209.85.208.46]:34421 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhFCFWB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:22:01 -0400
Received: by mail-ed1-f46.google.com with SMTP id cb9so5657192edb.1;
        Wed, 02 Jun 2021 22:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cjY5NIv8T/UjPF6/khgDh63aie+4OSg4ezXbryOnIVo=;
        b=L+lGiB8phnEr2PFwvu29s12yFsAgkqufFtWzpf3YDgkfKM56DjCSZzcPkV6m6JLzoc
         4wR/Rrl32QvUAJ5ntz1X4CUEakwXIWjAVK7nAhMaKvz9kvssHVJw+SEo49cL8mW405iz
         OYoPlEzp+F3bYmpRfIyAviBYW4+YKPlhQ3gMUCBXnkdFLV8IoJD2vC3xheqw6PgVpEv3
         wHz6YTBAw7eShlY3SQjiQqAAKw9kgru34mQGddAGsSlKlYlXIbR7ZVC9Hq20+DEh4TBG
         4UbjYO4L6GxDg7uSvuMXmOjY5/7C+h3Zs1TJUqZP0LPr2+q/H8PCTpJHZziq25dZEnYX
         VBzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cjY5NIv8T/UjPF6/khgDh63aie+4OSg4ezXbryOnIVo=;
        b=fBBVTUSrxyLOy9g+s3b3Z9xehorbKmjloyR6hwpF/37nkNrw7AKTFUAS24+V3vpXkq
         H4GWBFHEEaPLU84fgeKLs7Bsrp8LlIkwCo5pJzgVKLoMpPnhhMY+7qLCT4SW/G0nQYDs
         u3GOAI4E1TQyE5C+H9yfNV9KF5KlW6Tb4J7EIyqtSNYxvJa0pQ9H/GTBp8pqwlZdl0ZW
         yXwoiEZeng1S1tYwYTqkh1hlP3LMDnmbWbPhmw50tFH1Pmr9F1Xp528Pk1adA5ptCBiT
         rHBlfRFTnSLxsezQPlkHb5lFkGT3M7/5tOJyGhYHRUbm64mTEoeiVECiQ1aI8hKxlfGw
         8bkQ==
X-Gm-Message-State: AOAM530/gEDQBsry9eyb2d5SAtE4lXdkhpFMTQ+GpLmQUIDOML4Pv0rA
        YzyE1Rnm0ZfEzwlWQOSxQ8Q=
X-Google-Smtp-Source: ABdhPJxBQ1Ua7O8zOK+V7Vo+n9XvLnoMiqPIi1V4hs69VpXooJkakqO4wwdVGDk1CA1RCwJmVrELww==
X-Received: by 2002:aa7:cb84:: with SMTP id r4mr41879537edt.187.1622697542301;
        Wed, 02 Jun 2021 22:19:02 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id f7sm963668ejz.95.2021.06.02.22.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:19:02 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v5 05/10] namei: add getname_uflags()
Date:   Thu,  3 Jun 2021 12:18:31 +0700
Message-Id: <20210603051836.2614535-6-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603051836.2614535-1-dkadashev@gmail.com>
References: <20210603051836.2614535-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are a couple of places where we already open-code the (flags &
AT_EMPTY_PATH) check and io_uring will likely add another one in the
future.  Let's just add a simple helper getname_uflags() that handles
this directly and use it.

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
index 76572d703e82..010455938826 100644
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

