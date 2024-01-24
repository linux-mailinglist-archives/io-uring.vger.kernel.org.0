Return-Path: <io-uring+bounces-479-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F078D83A42C
	for <lists+io-uring@lfdr.de>; Wed, 24 Jan 2024 09:33:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CD2E1F2329B
	for <lists+io-uring@lfdr.de>; Wed, 24 Jan 2024 08:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F44B1758E;
	Wed, 24 Jan 2024 08:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mSaDtctR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD033168CD;
	Wed, 24 Jan 2024 08:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706085201; cv=none; b=WTvPoZCzpl6YnEYTXnPJsatqTzvxY368IhdfORGfHS5XQ2DfexbiPrLLoYaEh/erOjj5TiyIk95VajzSy04NdL/0yKDwQgaX7UznLsL7p8UKsUkbL3LLr7TJXEImgR/NfU4qVxjHFu7HiJLyNO2ZM1i1RiGdvpsysQ/So6hv/Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706085201; c=relaxed/simple;
	bh=ufx37yWDc607w5zJuEiXrTZsvL1QTPVQvIrC9K5vtv0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MWWTvHszWaL+mqgjbW9UQz8AFyqbj3Fu+8hGOGmn449JJ4ogzkUuIwT4usbH7csHO3EkboBnbjQ/aoZ2BmnV0BZf8P9IaDF5x8GjzmUrAh1Tnnunrivb8KMbQBxRYwA1c6IcNI5ptd5kMWCg6aPnOck78XZ7poKjOO86Y3+tRK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mSaDtctR; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-40eb2f392f0so19744995e9.1;
        Wed, 24 Jan 2024 00:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706085197; x=1706689997; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cuUx9kNqNqCLHIn9WIMcvochR91I2HEz6Us7mVIXsXY=;
        b=mSaDtctRhtRPbpvqIFTJ3KicYjOOTlTyi3IlWwO8BngdTbZE5ArRNHOdW6Wz3IIOEu
         as7OtzS3G10bZCyrgop1jim67/UFBby7A9JBeAH/W8Om2qNERPcqLBDoT7etYdBS6VwY
         7V3Hg/de6tG3wba2u3Frxo3AMAR7aPqnnD4yj1UR5xt91ut9UTtAeNgvJwFNMMzEzwan
         YBWJ2wvzSY02q0qb0gzhKxHi+2LwY5F3xEb0g9O0yienlmXWNWewT+4++zWEiOf5nQhA
         JlVO/NPAXTCQiyp+6/gTL2kX2MGgP9x6eiPJS2vD5uGTefzlta2UXq552jqXWJSvg7lY
         O+QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706085197; x=1706689997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cuUx9kNqNqCLHIn9WIMcvochR91I2HEz6Us7mVIXsXY=;
        b=jDACWuKIUZrWlmn2/iMZKy1dPAkiHNzTEmN1R31jQaYkOwkoaGtBuUGnKSJrMAuAXx
         eIoJIaWHi8z0jL8qTByOhF8dGsYkoPyAVkDDo/xNPewxci0sE6cJIJBy/g4JnAgclsGP
         n++DL5y79xrdA1mWdxQdVbCdvN6AARGXdgCqdJr1xAhdLBkYSUZklS3NcWU2nXK367xs
         VfVYjuZEfE/JeTYyRr6BwzRvztTdWM/6GI3b1vfyV42XQrrNhiRhrhYIItyjMdDZmwPi
         GOtRgEB+pZrmIT1zcg4PE+yNRcTDkLYY6A05oC26r7ABTaAYv1hWMg2pWUKejHCqDYFK
         ITAw==
X-Gm-Message-State: AOJu0YyQI7KSyOryY3kC4n1bIR51jULHcJXIfLSdZq0bBC1WbiPKd3+B
	5DKZ70Ow6qP7Nb3SubQdS//2ZN/mcJU6QMIvBO0nXuw09RhO1nKuAx2k6D44SNZjLQ==
X-Google-Smtp-Source: AGHT+IEVCu+i/WgAqQ/NnOlYLN8/OHCNdRwM2WReWtRbNnUqaVQ+j48TOg4zWvdRbcwgQb7n2lD46A==
X-Received: by 2002:a05:600c:45d1:b0:40e:4932:3995 with SMTP id s17-20020a05600c45d100b0040e49323995mr799308wmo.14.1706085197383;
        Wed, 24 Jan 2024 00:33:17 -0800 (PST)
Received: from localhost.localdomain ([147.235.201.119])
        by smtp.gmail.com with ESMTPSA id p16-20020a05600c469000b0040e39cbf2a4sm49324365wmo.42.2024.01.24.00.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 00:33:17 -0800 (PST)
From: Tony Solomonik <tony.solomonik@gmail.com>
To: 
Cc: io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	Tony Solomonik <tony.solomonik@gmail.com>
Subject: [PATCH v5 1/2] Add ftruncate_file that truncates a struct file
Date: Wed, 24 Jan 2024 10:33:00 +0200
Message-Id: <20240124083301.8661-2-tony.solomonik@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240124083301.8661-1-tony.solomonik@gmail.com>
References: <20240124083301.8661-1-tony.solomonik@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

do_sys_ftruncate receives a file descriptor, fgets the struct file, and
finally actually truncates the file.

ftruncate_file allows for passing in a file directly, with the caller
already holding a reference to it.

Signed-off-by: Tony Solomonik <tony.solomonik@gmail.com>
---
 fs/internal.h |  1 +
 fs/open.c     | 53 +++++++++++++++++++++++++++------------------------
 2 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 58e43341aebf..78a641ebd16e 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -182,6 +182,7 @@ extern struct open_how build_open_how(int flags, umode_t mode);
 extern int build_open_flags(const struct open_how *how, struct open_flags *op);
 extern struct file *__close_fd_get_file(unsigned int fd);
 
+long ftruncate_file(struct file *file, loff_t length, int small);
 long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
 int chmod_common(const struct path *path, umode_t mode);
 int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
diff --git a/fs/open.c b/fs/open.c
index 02dc608d40d8..649d38eecfe4 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -154,49 +154,52 @@ COMPAT_SYSCALL_DEFINE2(truncate, const char __user *, path, compat_off_t, length
 }
 #endif
 
-long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
+long ftruncate_file(struct file *file, loff_t length, int small)
 {
 	struct inode *inode;
 	struct dentry *dentry;
-	struct fd f;
 	int error;
 
-	error = -EINVAL;
-	if (length < 0)
-		goto out;
-	error = -EBADF;
-	f = fdget(fd);
-	if (!f.file)
-		goto out;
-
 	/* explicitly opened as large or we are on 64-bit box */
-	if (f.file->f_flags & O_LARGEFILE)
+	if (file->f_flags & O_LARGEFILE)
 		small = 0;
 
-	dentry = f.file->f_path.dentry;
+	dentry = file->f_path.dentry;
 	inode = dentry->d_inode;
-	error = -EINVAL;
-	if (!S_ISREG(inode->i_mode) || !(f.file->f_mode & FMODE_WRITE))
-		goto out_putf;
+	if (!S_ISREG(inode->i_mode) || !(file->f_mode & FMODE_WRITE))
+		return -EINVAL;
 
-	error = -EINVAL;
 	/* Cannot ftruncate over 2^31 bytes without large file support */
 	if (small && length > MAX_NON_LFS)
-		goto out_putf;
+		return -EINVAL;
 
-	error = -EPERM;
 	/* Check IS_APPEND on real upper inode */
-	if (IS_APPEND(file_inode(f.file)))
-		goto out_putf;
+	if (IS_APPEND(file_inode(file)))
+		return -EPERM;
 	sb_start_write(inode->i_sb);
-	error = security_file_truncate(f.file);
+	error = security_file_truncate(file);
 	if (!error)
-		error = do_truncate(file_mnt_idmap(f.file), dentry, length,
-				    ATTR_MTIME | ATTR_CTIME, f.file);
+		error = do_truncate(file_mnt_idmap(file), dentry, length,
+				    ATTR_MTIME | ATTR_CTIME, file);
 	sb_end_write(inode->i_sb);
-out_putf:
+
+  return error;
+}
+
+long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
+{
+	struct fd f;
+	int error;
+
+	if (length < 0)
+		return -EINVAL;
+	f = fdget(fd);
+	if (!f.file)
+		return -EBADF;
+
+	error = ftruncate_file(f.file, length, small);
+
 	fdput(f);
-out:
 	return error;
 }
 
-- 
2.34.1


