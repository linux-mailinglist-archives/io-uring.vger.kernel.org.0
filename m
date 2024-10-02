Return-Path: <io-uring+bounces-3356-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7757698CAB2
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 03:22:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8A211C2096F
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 01:22:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71633747F;
	Wed,  2 Oct 2024 01:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="rNmFDG91"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8444944E;
	Wed,  2 Oct 2024 01:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832154; cv=none; b=URXYo8SN3aghsR4sYule38S/o+6hYd9nudKmnTeqaTCvAsLgsJEObZVGWpy1essWqpx1po7fpLuWDF6F5qwTCqCkMzEorXBtlpusCKA3AikXZbgIB9TLC5KExrkbzWQgwlfWlO8wtHrb7gSRZAZ65Ygyyuh1M8uZFUV1Ut7gXlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832154; c=relaxed/simple;
	bh=4oy05+QC+QtHw8UXpK8yWCleR38ElzdTZCWh3lDpUzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRzO/cuQOrEewrI4FEQiLukNYRW6cZ0uW/IclFZf2Ca4fY3AYurCq8UaI+C6fGUaGrBZo2QZOYWKwW88YaJrYFO1TiHCF1zj7JzSlYPZKnXOVQIdGDvfyMhPWiI/ioS3gukPsXJYpUOMeOWIwPRSOG3IHvvKu5kr9g15C2gSRpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=rNmFDG91; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YIq7cR2J9S1CfidyrsAypk2OC0OslepJ1WnLnG0MFcA=; b=rNmFDG916VQUMfWcmAxpk/WA7a
	QKrFTFaUhnBOkHf+VYZ+t1W4dngs55fvs1oPzetYU1H/LgvhCM7EP+j+9tt1SZ/vr3rkt1Gr6TZyQ
	RxrZ8ugS4FpJY8dvPt3B6iAj+ot2LGZB1CYXcFhYj3r7EAzIuQY6m+VA1n36wCwRmT+toVA5pCLgd
	AbJp00m/DXnepyh8jt42r9V06LFg10kEJ0lelJZ445jhq1XmDytphoACurAycnaPG2DOxPeeHcWI+
	5zquM+Pi0IsIUUvaYjCwEB3eHDjTOupJ19/fHlKq9wbCbpAD1cElS1yg9ZfRw8x3BWfYBfZ7UVHUi
	Gu8GGN3Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1svo4U-0000000HW09-18Fd;
	Wed, 02 Oct 2024 01:22:30 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: brauner@kernel.org,
	io-uring@vger.kernel.org,
	cgzones@googlemail.com
Subject: [PATCH 1/9] xattr: switch to CLASS(fd)
Date: Wed,  2 Oct 2024 02:22:22 +0100
Message-ID: <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20241002011011.GB4017910@ZenIV>
References: <20241002011011.GB4017910@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/xattr.c | 35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 05ec7e7d9e87..0fc813cb005c 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -697,9 +697,9 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
 	int error;
 
 	CLASS(fd, f)(fd);
-	if (!fd_file(f))
-		return -EBADF;
 
+	if (fd_empty(f))
+		return -EBADF;
 	audit_file(fd_file(f));
 	error = setxattr_copy(name, &ctx);
 	if (error)
@@ -809,16 +809,13 @@ SYSCALL_DEFINE4(lgetxattr, const char __user *, pathname,
 SYSCALL_DEFINE4(fgetxattr, int, fd, const char __user *, name,
 		void __user *, value, size_t, size)
 {
-	struct fd f = fdget(fd);
-	ssize_t error = -EBADF;
+	CLASS(fd, f)(fd);
 
-	if (!fd_file(f))
-		return error;
+	if (fd_empty(f))
+		return -EBADF;
 	audit_file(fd_file(f));
-	error = getxattr(file_mnt_idmap(fd_file(f)), fd_file(f)->f_path.dentry,
+	return getxattr(file_mnt_idmap(fd_file(f)), fd_file(f)->f_path.dentry,
 			 name, value, size);
-	fdput(f);
-	return error;
 }
 
 /*
@@ -885,15 +882,12 @@ SYSCALL_DEFINE3(llistxattr, const char __user *, pathname, char __user *, list,
 
 SYSCALL_DEFINE3(flistxattr, int, fd, char __user *, list, size_t, size)
 {
-	struct fd f = fdget(fd);
-	ssize_t error = -EBADF;
+	CLASS(fd, f)(fd);
 
-	if (!fd_file(f))
-		return error;
+	if (fd_empty(f))
+		return -EBADF;
 	audit_file(fd_file(f));
-	error = listxattr(fd_file(f)->f_path.dentry, list, size);
-	fdput(f);
-	return error;
+	return listxattr(fd_file(f)->f_path.dentry, list, size);
 }
 
 /*
@@ -950,12 +944,12 @@ SYSCALL_DEFINE2(lremovexattr, const char __user *, pathname,
 
 SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
 {
-	struct fd f = fdget(fd);
+	CLASS(fd, f)(fd);
 	char kname[XATTR_NAME_MAX + 1];
-	int error = -EBADF;
+	int error;
 
-	if (!fd_file(f))
-		return error;
+	if (fd_empty(f))
+		return -EBADF;
 	audit_file(fd_file(f));
 
 	error = strncpy_from_user(kname, name, sizeof(kname));
@@ -970,7 +964,6 @@ SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
 				    fd_file(f)->f_path.dentry, kname);
 		mnt_drop_write_file(fd_file(f));
 	}
-	fdput(f);
 	return error;
 }
 
-- 
2.39.5


