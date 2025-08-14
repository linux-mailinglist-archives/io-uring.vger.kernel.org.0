Return-Path: <io-uring+bounces-8961-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEAACB27328
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 01:51:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 594F27A562A
	for <lists+io-uring@lfdr.de>; Thu, 14 Aug 2025 23:50:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 684B523BCEE;
	Thu, 14 Aug 2025 23:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AlqE8CUp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEDA1F582E;
	Thu, 14 Aug 2025 23:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755215501; cv=none; b=YkDpMT9NkeEjGhHKQd9AJ8DNidQ8offx7bv0xheKx0RfJ7WGDdzHzdEGyCSwBpoHJzqbpyt3d6hzhjvuSN5TKzc3l9SUMpw0R4+ouGnXH67lKZiwtVk+dPyPAHCMGnFu8rPU7k8X5UX86nxGaCpChLWg39blwpN2L8H4Flg++YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755215501; c=relaxed/simple;
	bh=2n94DsaYW8+z/Lopclv4vX5S4Y4wycOMolwIYeLNa34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brmPDtlzlMZpJmmDgdbjRWYM3r2r6v1VcA/pB0iNplwHYQoMtI1zCM6dDkxbD/x3YUSbOCTVj1kQapDYihq3e3M58eO/59ldSIpnrSRsLM4wohLdZ+tzfYbCe+bCcvL39AEXxlQ99koRiUyfEFhGCetCfcOBoxPkNeKPwYlt2IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AlqE8CUp; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-32326e5f0bfso1495415a91.3;
        Thu, 14 Aug 2025 16:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755215499; x=1755820299; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E2VSupQXoP8YqYXsuIF2giuu4fjV7712IjHFWMUrrh4=;
        b=AlqE8CUpxTKQiATz5F+Jc5nrcXPFg1a2C7adKnUYde191980DST5oggLYeCO5gYOsw
         IhReKsRIbwgS9/mN6xz/GUvglsQd2gFr4n+bnpjXBDCV7PfSORtfbYvoqqpwj+BU/B0y
         a0fUBMjC97AItL3YrAVcI/e8SqJ7MTqW5n/+TWtwwUMT6RePxYQMReXMDJCH1b6pLz01
         40Ty6MVVubGxWiumTPOhwOdKDTsO7feuXVI4LHReeVmoADkioI68LXTRkIofs46Yp1Vr
         5RO3slAKn2gjV1/RO4MWr851sD/W0a/aJMD18r3ADDvwtmYhu4sE79OpawVXn3TWeJ6C
         DMMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755215499; x=1755820299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E2VSupQXoP8YqYXsuIF2giuu4fjV7712IjHFWMUrrh4=;
        b=AxF7pqhzXQZuNbEbONgZKsV+/UIyEc0XfW8ptTge5RDSE2GWQdXgTOTtEOIJPi4stP
         CcJvlTq18wSOZwrqIJS/dSLExiNjzbFTQaiY3QUvs3z/CB5fG6LdGtNGdk5yRUNWyFZn
         u5o7GxNNzTweQknnSZNk91aygSH4zSYoKlwDVwlhJr42S739R+g9ld5hx5dEGqxFg5S5
         P7xJ8hd5tEKKK/kuSvyuXWHbrzNNMIZSDoXq0clP8Jb2K4LMvSCmPukiUxO6qvWjA5g/
         FyKhCMpcxFZnuYvNFcVaFEn7BwOgYWlHRNPgtcpHFeSq8J+h/3NpU9wnV7zCR1XEl9JZ
         02Cw==
X-Forwarded-Encrypted: i=1; AJvYcCVAa4F5yfTqd6cp7Yt5UfYwD/pdc545KD4DZsePDXD+UtANaCpKa3QaFLOv6ODrnB/4Sj0+jggMfubw@vger.kernel.org, AJvYcCWXg9FZnDYkVps57a182DvzkwyoitekHlmcIugwQfdB9CMwuIQi+HErCIi3AAfhgvEok443j4UN/stSl9WP@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5aBq9gReO/MAG3tjC7mvf4rX0BgOUTZv0ta8yLBIclZSFFNQK
	5Se4ioW5rBKl59v9Q6bExgl07oNdxN00xxcWykLVjrcziAl5/QbbdQ37U4ZiG9TbnWI=
X-Gm-Gg: ASbGncuvWJNkaEme1ZbmahT0vpW9dNrXmi9vsDzdcZIMC6CT4wo6JOLeyXlEUrBMlLR
	JqhoHs3sq/a2jnNFBwQ2nq9x2aOTCjHbc+EulhP0gI7kGMmDMuDTYsSd1Klog1WGwvgcHtz/Wuz
	6lXmyKy/IVHDH7GhtqeT5fLW4orLT+XfsdKj5FcHPWIogCIAgK9ANWA6MnqWGXliajkK/vC2Rie
	vV/N6P1sz1cPGaLxFhSmaWheH2k0QYegaxcNv+mPszl0vGRtqMTH2OvnTCY7pdnfEfIAFB54a24
	+Tq4p/7RUF5orOJSASN3OGrx7sQ4uFG/FKpk25MhnpYLC+wX0qyNCObU+E2VmZjOHLdvbRypkee
	+o2AsmUp9JuHEwkEvSWqcInpm
X-Google-Smtp-Source: AGHT+IGct/gy+4M646U4Q+PFW6aiVMNePO9JYxsr+oIfHdHu2uFRt2C6YSzNtY/qz1sTIejJa6cFxA==
X-Received: by 2002:a17:90b:388c:b0:321:abd4:b108 with SMTP id 98e67ed59e1d1-32341ebf8cemr243444a91.12.1755215498757;
        Thu, 14 Aug 2025 16:51:38 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3233100c1d0sm2974721a91.17.2025.08.14.16.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 16:51:38 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH 1/6] fhandle: create helper for name_to_handle_at(2)
Date: Thu, 14 Aug 2025 17:54:26 -0600
Message-ID: <20250814235431.995876-2-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814235431.995876-1-tahbertschinger@gmail.com>
References: <20250814235431.995876-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Create a helper do_name_to_handle_at() that takes an additional argument,
lookup_flags, beyond the syscall arguments.

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
 fs/internal.h |  7 ++++++
 2 files changed, 41 insertions(+), 27 deletions(-)

diff --git a/fs/fhandle.c b/fs/fhandle.c
index 7c236f64cdea..57da648ca866 100644
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
+long do_name_to_handle_at(int dfd, const char __user *name,
+			  struct file_handle __user *handle, void __user *mnt_id,
+			  int flag, int lookup_flags)
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
+	return do_name_to_handle_at(dfd, name, handle, mnt_id, flag, 0);
+}
+
 static int get_path_anchor(int fd, struct path *root)
 {
 	if (fd >= 0) {
diff --git a/fs/internal.h b/fs/internal.h
index 38e8aab27bbd..af7e0810a90d 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -355,3 +355,10 @@ int anon_inode_getattr(struct mnt_idmap *idmap, const struct path *path,
 int anon_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		       struct iattr *attr);
 void pidfs_get_root(struct path *path);
+
+/*
+ * fs/fhandle.c
+ */
+long do_name_to_handle_at(int dfd, const char __user *name,
+			  struct file_handle __user *handle,
+			  void __user *mnt_id, int flag, int lookup_flags);
-- 
2.50.1


