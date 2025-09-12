Return-Path: <io-uring+bounces-9769-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B4E53B55359
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 17:27:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A8FE1D666F1
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 15:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DACB222259F;
	Fri, 12 Sep 2025 15:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CAsCrcOT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FAA21A421
	for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 15:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757690843; cv=none; b=ctGvAZH4Uoo9F+asUpOo9aWsT19bmjPo1nnXMEiUqhBX+u33BfDHqoT0i3KxyNWuQ1f4ZTnegh8x6z5olC16kcjtM3g0/I616Pkxj3lJwJJMhEI5eZcZeh334obMCAbzbPfawcyQcaztwirzHQJwPW4eOw4eshfWp4hlJAfDRLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757690843; c=relaxed/simple;
	bh=07LPQc3ZerGkSIXkghCbTp1td4/RY5pn1siD0cOwh/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEIR3VyFHuF2uu00b6J1KSjLnxHcPMnXxMIJQcxz7m9AuUf+3ZwQoTEhwz4gdu/Gv82o0KsEH41+0+HlV+m2YuTgFEC9O8iFIKAh4tRNzM+GIBTqNjd3kHc8tMV+WKD1COffEuO2wsOtINyeA22WaaHKtVpcRv8q48J5JRHZPWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CAsCrcOT; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-76e4f2e4c40so1856735b3a.2
        for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 08:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757690841; x=1758295641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mOV1e62HSpWbhz5w905oMR3LjLD2VgAcPj9wueKbUQA=;
        b=CAsCrcOTLYRmekOvWo/VGGbSwH3F4bf27WnabbZhLPeC5ZtPyQU9lkBHWFMjjRaHFT
         0VcCMBd+LSdnis+hEZ5YLvdYY8g9izyj41EVhJna0AebJFq0ZJRcSB+VYxZUJTLXQUeD
         EAbpOXAXW53i2y1TJFHH7Sn1MfZset46TRQSS6MbWe9apDEoTPUicP124YFzRdo1r0rV
         lv079+8+H3g82sSBdDfmT5x6uauvv6BFBl/KgFainry9tnD/vkilPPvOXLzoRkHb7WaG
         VwIMwH7VbOgMWIx+Q/UgwOf1qxUslqOOt7R2Jmj3kKx67W4gn/P6ieF2KpCTmSYsMVPR
         IdsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757690841; x=1758295641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mOV1e62HSpWbhz5w905oMR3LjLD2VgAcPj9wueKbUQA=;
        b=ByR+cLR2mipDJ8cHlr/I/tG0Mq4L3jjf6GJA3+1nQXQQddbIyIgdyrxvBgqhuTCzlz
         3/W4Ut2hn0GwP0LEAG6YlVChoBZuzjUNRQfipv1lay18a2uLfmReskDy0hUQDF7dJ8J0
         OHj83yqWNi2/lKFJUirs3KZGZ1QzxUvvAHLx/a+tyupCxXomJiNHxddR5KzVpF284bNE
         JHCrflbN+Fc0968+WuZI+bX/HsssoFlMCFRqGCmFXgw3TQHTa/YSjvqdek4tS6UbALlO
         iCQRTDKvVrsd9TjXGLzmsBY2YYE1+iWJTgmcKQxU6odtL9dTZO7kfKbsnU/2ndZcNCed
         hgag==
X-Gm-Message-State: AOJu0YyqPG3LnDjj8mhANjhBtuZTMYFSggu3HjD9oq1MO722f7il6H0D
	YBKyjZWqgzD4Y1FCpwibIYwz7FSx/NPFDGFRycILyGXJ282cK9qo7C5xt7cGaKpT
X-Gm-Gg: ASbGncsLvAabdYYh6anpDPh/ipTdFoadJn+Z9zxOqA6aYJWvUz0ppjIbaG8X8AwZ7G+
	qxC1AK9mqoLFB5Ye3+2xxFMFlF8hnsg303J74MQ2hZVywLZrLnxwOAuzYtPkM1H2LpDxaHRZHP2
	tzBNmoLreBwME2qDvVbtmoj6eT/CLkZbGgBb4SbBsvKOpn4b42/m78g/VN7x7UvMC61O51uXTD4
	jzkgt2pUfrxwm7PDcH+avXSUSLf1g+/gEHpB1VeF4sfdc+RWjTm+rKGFU/dtktAVCzeHWgejp1q
	dLBMUH4T57VJIfh1Wg02yw+KKYxv1sjyDvz6kgD3vJbOq0Lo6UxH4wJHC2txVe6jxxQagLwEqm7
	q8HsiIJNJ/HsdMiwFH8ktsC0C6pG5gj57ZW8F
X-Google-Smtp-Source: AGHT+IEX2VJwLZXnTTSkoj8cz8rXva/C6SB7iBmi3sPS3P5Hn1aEvI2/0J9AwFeaSLucx/ni/rcJFg==
X-Received: by 2002:a05:6a00:ac8:b0:772:80d3:b684 with SMTP id d2e1a72fcca58-776121a79a6mr4229957b3a.22.1757690839051;
        Fri, 12 Sep 2025 08:27:19 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7760944a9a9sm5436846b3a.78.2025.09.12.08.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:27:18 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	jlayton@kernel.org,
	amir73il@gmail.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH v3 01/10] fhandle: create helper for name_to_handle_at(2)
Date: Fri, 12 Sep 2025 09:28:46 -0600
Message-ID: <20250912152855.689917-2-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250912152855.689917-1-tahbertschinger@gmail.com>
References: <20250912152855.689917-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Create a helper do_sys_name_to_handle_at() that takes an additional
argument, lookup_flags, beyond the syscall arguments.

Because name_to_handle_at(2) doesn't take any lookup flags, it always
passes 0 for this argument.

Future callers like io_uring may pass LOOKUP_CACHED in order to request
a non-blocking lookup.

This helper's name is confusingly similar to do_sys_name_to_handle()
which takes care of returning the file handle, once the filename has
been turned into a struct path. To distinguish the names more clearly,
rename the latter to do_path_to_handle().

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/fhandle.c  | 61 ++++++++++++++++++++++++++++-----------------------
 fs/internal.h |  9 ++++++++
 2 files changed, 43 insertions(+), 27 deletions(-)

diff --git a/fs/fhandle.c b/fs/fhandle.c
index 68a7d2861c58..605ad8e7d93d 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -14,10 +14,10 @@
 #include "internal.h"
 #include "mount.h"
 
-static long do_sys_name_to_handle(const struct path *path,
-				  struct file_handle __user *ufh,
-				  void __user *mnt_id, bool unique_mntid,
-				  int fh_flags)
+static long do_path_to_handle(const struct path *path,
+			      struct file_handle __user *ufh,
+			      void __user *mnt_id, bool unique_mntid,
+			      int fh_flags)
 {
 	long retval;
 	struct file_handle f_handle;
@@ -111,27 +111,11 @@ static long do_sys_name_to_handle(const struct path *path,
 	return retval;
 }
 
-/**
- * sys_name_to_handle_at: convert name to handle
- * @dfd: directory relative to which name is interpreted if not absolute
- * @name: name that should be converted to handle.
- * @handle: resulting file handle
- * @mnt_id: mount id of the file system containing the file
- *          (u64 if AT_HANDLE_MNT_ID_UNIQUE, otherwise int)
- * @flag: flag value to indicate whether to follow symlink or not
- *        and whether a decodable file handle is required.
- *
- * @handle->handle_size indicate the space available to store the
- * variable part of the file handle in bytes. If there is not
- * enough space, the field is updated to return the minimum
- * value required.
- */
-SYSCALL_DEFINE5(name_to_handle_at, int, dfd, const char __user *, name,
-		struct file_handle __user *, handle, void __user *, mnt_id,
-		int, flag)
+long do_sys_name_to_handle_at(int dfd, const char __user *name,
+			      struct file_handle __user *handle,
+			      void __user *mnt_id, int flag, int lookup_flags)
 {
 	struct path path;
-	int lookup_flags;
 	int fh_flags = 0;
 	int err;
 
@@ -155,19 +139,42 @@ SYSCALL_DEFINE5(name_to_handle_at, int, dfd, const char __user *, name,
 	else if (flag & AT_HANDLE_CONNECTABLE)
 		fh_flags |= EXPORT_FH_CONNECTABLE;
 
-	lookup_flags = (flag & AT_SYMLINK_FOLLOW) ? LOOKUP_FOLLOW : 0;
+	if (flag & AT_SYMLINK_FOLLOW)
+		lookup_flags |= LOOKUP_FOLLOW;
 	if (flag & AT_EMPTY_PATH)
 		lookup_flags |= LOOKUP_EMPTY;
 	err = user_path_at(dfd, name, lookup_flags, &path);
 	if (!err) {
-		err = do_sys_name_to_handle(&path, handle, mnt_id,
-					    flag & AT_HANDLE_MNT_ID_UNIQUE,
-					    fh_flags);
+		err = do_path_to_handle(&path, handle, mnt_id,
+					flag & AT_HANDLE_MNT_ID_UNIQUE,
+					fh_flags);
 		path_put(&path);
 	}
 	return err;
 }
 
+/**
+ * sys_name_to_handle_at: convert name to handle
+ * @dfd: directory relative to which name is interpreted if not absolute
+ * @name: name that should be converted to handle.
+ * @handle: resulting file handle
+ * @mnt_id: mount id of the file system containing the file
+ *          (u64 if AT_HANDLE_MNT_ID_UNIQUE, otherwise int)
+ * @flag: flag value to indicate whether to follow symlink or not
+ *        and whether a decodable file handle is required.
+ *
+ * @handle->handle_size indicate the space available to store the
+ * variable part of the file handle in bytes. If there is not
+ * enough space, the field is updated to return the minimum
+ * value required.
+ */
+SYSCALL_DEFINE5(name_to_handle_at, int, dfd, const char __user *, name,
+		struct file_handle __user *, handle, void __user *, mnt_id,
+		int, flag)
+{
+	return do_sys_name_to_handle_at(dfd, name, handle, mnt_id, flag, 0);
+}
+
 static int get_path_anchor(int fd, struct path *root)
 {
 	if (fd >= 0) {
diff --git a/fs/internal.h b/fs/internal.h
index 38e8aab27bbd..c972f8ade52d 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -355,3 +355,12 @@ int anon_inode_getattr(struct mnt_idmap *idmap, const struct path *path,
 int anon_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		       struct iattr *attr);
 void pidfs_get_root(struct path *path);
+
+/*
+ * fs/fhandle.c
+ */
+#ifdef CONFIG_FHANDLE
+long do_sys_name_to_handle_at(int dfd, const char __user *name,
+			      struct file_handle __user *handle,
+			      void __user *mnt_id, int flag, int lookup_flags);
+#endif /* CONFIG_FHANDLE */
-- 
2.51.0


