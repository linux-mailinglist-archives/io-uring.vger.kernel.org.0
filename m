Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF92437F66F
	for <lists+io-uring@lfdr.de>; Thu, 13 May 2021 13:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbhEMLJw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 May 2021 07:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbhEMLI5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 May 2021 07:08:57 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACF3C061763;
        Thu, 13 May 2021 04:07:45 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id c20so3910836ejm.3;
        Thu, 13 May 2021 04:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J95HUr/u051ThgJM2GbK44c2L7CudLAKit1ZcrrYHBk=;
        b=grSx8OOYqkaAMoYnqpd2E9YY2pDJ3jpQTS16+0d1CRCaBUJHoesBfD9JOfiCsPtEyu
         8eRJYk4pmlw/l1atupdmNXBy5NC6/iZ/V0gnlD1EGsMtX3x9ac0GWgr3XJ7gJMzU0kjc
         rgX/lzl39NNAZyMG2hJ1E0kFhhCgxOzOVATLDKrynHQo27Cz26RJNyybbAnAyFoyu2gx
         Rd4wY5RXBi/0Z7ruI+lDM9ld66ZAcYzxJN9hyrCYgBQDQZFBcF/N+vBErLeyRreHy5Ou
         aTprTAqOaJ/MUE61zEhs5iFyCdZHZ1EceF1Olg2COZNwAxGqZOlN/BfuhSSgI4t0upzB
         IRsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J95HUr/u051ThgJM2GbK44c2L7CudLAKit1ZcrrYHBk=;
        b=HiMqPYvUpTminXh+3cHxvESe9HLUL7uiKqgqX5Uc2ClI37wMPiEyMTTz56iT8JjMG+
         dO1Cixb0/WKMREe32YJKgcjeiCpKH7Yh7d2gz+jErOSoijZ0MYRGB2QHXH6WyOhCu4OH
         ylBSdVkOhYCBdJ2htS/pmBxhIW2/AzbjZw2eoGOTn4wMF65EyPfmxFvM+gkwAc6djXfR
         IO14YZdcSDyk+Jof/BstZ6Z4FF/U8f9I6mSF2wibfdKUMR2CrWyaySz4nwiddxlSpikk
         P2ABLSQHt3kgy75/0AxFeSM1jnvecp50HhaYGKZRoH5RtT6IBCt3wI9MDGOWnQouf/vH
         Wesw==
X-Gm-Message-State: AOAM533pTVt2v4tOAQQ59gxYPEcuFen9mHs4L4BREyslAahXzRNLN7hp
        YRtJ8CzVNioobXOnicb2w70=
X-Google-Smtp-Source: ABdhPJycMt1W3nHcIOPaAfJvAyg/qSCqeB+shffL5ez3pn8y9ieqExBGzoRwNeaCt/Aj+KJQYKFLtQ==
X-Received: by 2002:a17:906:6ace:: with SMTP id q14mr44492137ejs.79.1620904064428;
        Thu, 13 May 2021 04:07:44 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id bn7sm1670864ejb.111.2021.05.13.04.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 04:07:44 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v4 5/6] namei: add getname_uflags()
Date:   Thu, 13 May 2021 18:06:11 +0700
Message-Id: <20210513110612.688851-6-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210513110612.688851-1-dkadashev@gmail.com>
References: <20210513110612.688851-1-dkadashev@gmail.com>
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
Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/io-uring/20210415100815.edrn4a7cy26wkowe@wittgenstein/
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
---

Christian, I've kept your Signed-off-by here, even though I took only
part of the change (leaving getname_flags() switch to boolean out to
keep the change smaller). Please let me know if that is OK or not and/or
if you prefer the rest of the change be restored.

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
index bf4e90d3ab18..c46e70682fc0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2783,6 +2783,7 @@ static inline struct file *file_clone_open(struct file *file)
 extern int filp_close(struct file *, fl_owner_t id);
 
 extern struct filename *getname_flags(const char __user *, int, int *);
+extern struct filename *getname_uflags(const char __user *, int);
 extern struct filename *getname(const char __user *);
 extern struct filename *getname_kernel(const char *);
 extern void putname(struct filename *name);
-- 
2.30.2

