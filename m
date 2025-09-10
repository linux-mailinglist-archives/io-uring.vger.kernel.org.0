Return-Path: <io-uring+bounces-9712-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ED7EB523B2
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 23:46:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B9D77BC2E6
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 21:44:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6731B2C21F7;
	Wed, 10 Sep 2025 21:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nBpCR/ri"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2DE25A350;
	Wed, 10 Sep 2025 21:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757540791; cv=none; b=bD2urePn1RjDzl7Z6JmgHJFUamWsQn+gR6+ReTVuQ8tFl6/enVrbryWbFvXp5QlGKdL+ul5miRlPOhPIvfrSVPWIpdUFa9ZaT5BBthBXseFXykIuQ4NgbiJtZM5RQ3dfgT7BTx4vKBj3U72ppRAk2/mwevalp/suNc/hFOkU2zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757540791; c=relaxed/simple;
	bh=LRm1Rw/cIpl4C39XBzSiQuwCXOhSHcoUrq32ONK/heo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuvM+Q54fkpks6jq94UJmQqL3aERIzRbJwudV+ty8jWF0z1MX9G2zK67MNik7qmBFuogRyUrX0gjKPsq7e4WqpUl7drHFOM/tv1a39xkFKDtHU5cmLIq40hN1+7VRm1jIUu6NmCZ88WRTEe332Tpx9yuc+pKtuAOEpZO4wji21s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nBpCR/ri; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-772301f8ae2so83664b3a.0;
        Wed, 10 Sep 2025 14:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757540789; x=1758145589; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yzMgwsjB3XJMvyiVDOaAbUkNo38WkDa6XkoN/jNLvFs=;
        b=nBpCR/ri0FZwRq8tmTuxtkPIjz3yp7iFj4mmD6nV7K1aFjdu1RTGW0YwC9TCfL/rhE
         dXkf+VI3GI5DGsO91rZb72GsXtpn35ACgAMWCtd0+DpT2itWmo2kOYOejVWZGONDNJGv
         Tt6Aev1+t/YSFkSbIuf2UeDC7HH53k6azt7fAqb7Si99aXt7e+eIfzdc58AEfV96rwYw
         zVjdSa62bevVaijLGKTFsojQa4a6doP+r30w1KPnuT9X0tTwmMsBx6SEfvcWOqZ1IeOr
         JFMOmSYwITRUPojNaW9AcsYUdKLUTxOUxuWepT739ERjNJdMILOyKIo/T6+dw9tqOtUA
         nQDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757540789; x=1758145589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yzMgwsjB3XJMvyiVDOaAbUkNo38WkDa6XkoN/jNLvFs=;
        b=Hj0IcHxxCd80RlPuf68Q0AyTB4vBtmXH6kv7ogT6R3cX3fqMpS/yek8RK0JQ3Dtplu
         37SNQK0U7XXtzU9ENpv7do4whklheqxuzyLQo43YJ/L+wgxKGnyGlAm3Coy3RQ1yBeiw
         YPtJ3EH1+h56wlaXUgTzJi4Uo6AHfM7L+DI+WNHGqYrW1G63zTG1t4GF7seczQTKasM0
         CQnWO+Qx1xQy0A+z7eSijPBcKZZpG/Gi61IzpSN8t53d8oiWKXr7KsW/zoNncd3VbsOm
         uknKA0ENQkvLeRzdRc44XxAguwwVKO0RUoooA6AXknXPv1aOa1kPUFQYJTyIIAmgtWsM
         SInw==
X-Forwarded-Encrypted: i=1; AJvYcCV6/qm/3L5DvA/HB8VplNPr+dQQk5zRtrfHN5tQGmvkvADUCT1e+ZpjESlubdLKeU8sqBVJnWFDx0oT@vger.kernel.org, AJvYcCVlUP2Jd0yAwKx68fs/+9O1QUPFDircvv6WFtnEydjhkm2Ntk7NBxS76y6SbO7il1fPDoeLZKtKLrIf/v1s@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0l1EGDmeF71cSU/nw7gQJujsFMaPC9BqV7zGcGapIm3DvhkTB
	22no3U9a66LOM2voEHqmv/07zQQPB5S405FLTdYHNXauk+05For353W3Ga3h3/Ux
X-Gm-Gg: ASbGncu+RFvodgom0BnOknarBMU1VA366UqpunDqQy8BEIGeevDjvjwdFbdwL5Rh+17
	qUQrIaQMz7eiB+Q8QVzfxlH/6Ouc4yD+tK+0RD3dYrn9WzCkrBKaGfZgB6KVEvIrDRgm5UIW2mG
	o2RMMsS3ik+HdOc1hoVvaGUaK2dOrW3JYbaiwahLmb6kWCK8cpqpnzOq3qJUWbbvot88k2dRHPZ
	4n1OhsuajSIbQhzJ/qxKkLRfI9T6yc3B4BiqCS+Tcmf62vW3KWeN+fvqZOiGJTfmhUg8HcMomNU
	XXWzEAYtl8RD6POnQSZ53QdYW4yLCqkMbN4B9Cu3MMW+jHE0+8UyRvOKaVV/dAJSXxsjHhs3Gx5
	EI/eE/nQMAg3rRsJhXqRZFOfAEMCwSDKogZnv
X-Google-Smtp-Source: AGHT+IEpPVTbYf7ZHKpwNndcmI/9i15qR9PUNXcpjXM1dftLgHHm67CcfVNYItF3GWwwWusac9GX8Q==
X-Received: by 2002:a05:6a00:1804:b0:774:2274:a555 with SMTP id d2e1a72fcca58-7742de5bc54mr22314405b3a.15.1757540788743;
        Wed, 10 Sep 2025 14:46:28 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-775fbbc3251sm2422516b3a.103.2025.09.10.14.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 14:46:28 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH 01/10] fhandle: create helper for name_to_handle_at(2)
Date: Wed, 10 Sep 2025 15:49:18 -0600
Message-ID: <20250910214927.480316-2-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910214927.480316-1-tahbertschinger@gmail.com>
References: <20250910214927.480316-1-tahbertschinger@gmail.com>
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


