Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26D630215A
	for <lists+io-uring@lfdr.de>; Mon, 25 Jan 2021 05:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbhAYEpB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 Jan 2021 23:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727175AbhAYEo6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 Jan 2021 23:44:58 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C9FC0613ED
        for <io-uring@vger.kernel.org>; Sun, 24 Jan 2021 20:44:16 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d13so1082791plg.0
        for <io-uring@vger.kernel.org>; Sun, 24 Jan 2021 20:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Cs4J9GskE01nDEYOQ3KQaCkKWwKmXBxrzRzzc8/wsJI=;
        b=vKDGB28J3loZxpQQsNi0tNE+SmHzbz+XjsHet5K38mYCsN/wRrMJ3w6ilbulurzxlr
         zk8AlS2RjecXSxSJgrDrDWWoEiQBDcNS0I+9/ko/vKi0Uo+911tqx3a7b+YwIotsAxhm
         Q/+L0YI5UyS77khX4HdMn5b9itjjqzBZ09yTMGPzA4XfTSeVBJO01nEmFSxUi/KPcfvu
         s+4g6M9sGLonmuMuaB9Rv5LDbbkDciPtgOO3QaQJoV2LHnK46WR+7Fd+RoYG5plOsc5h
         JYuslMfgZmChOKNZRvuKjV+8pi0kauS7MxwDIX4M/olD3LiysBq8BnLey0ViiOFPATEG
         fWtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Cs4J9GskE01nDEYOQ3KQaCkKWwKmXBxrzRzzc8/wsJI=;
        b=NkzxRdKjcQ7xYTfs/oTGhSBsG9NqqLdbwujFjzBt1Cit7yig3PTzScILJvBvDHs17h
         WLVlNlIZdIzxvuSBvVnFfCrAs4ZBb+l9m1iqHcyJG5hjYgN311k2av+WAZa8mywiae34
         vz0nGw45lOX2vY2vpN2py7++8wXRCZDOv92zmfgPkMSRSizz+mqG2Y+ON06CqSWVAP/h
         QEvuKxIjVmJnNc5byG6krfUexJSjsTHkvnUERLgm9C+1d9nFRsSnT71rk/swFxUs9yu8
         w4s0ipqx/NE/yoyEHR2JRdDHKYlcnOhthdxez4q7jFvdwPLQxCcUJm9PDiVnoJrioDLJ
         abgA==
X-Gm-Message-State: AOAM532YpVU1GulQ/IpudlerN8W/4Im9k/xX8KTSY298Q2d0VYHFgEah
        J9zdvzScxCxmfbXtrsZvz14FRCpMMq0vVQ==
X-Google-Smtp-Source: ABdhPJzdALFDfkb7y4OVT7WVh3vG/AkOBJGgvUGXL6FDtcp2jkAl9T/cDXJUkTTlcwuAX76Tuy4Tmw==
X-Received: by 2002:a17:902:d64d:b029:de:8aaa:d6ba with SMTP id y13-20020a170902d64db02900de8aaad6bamr18034012plh.0.1611549855312;
        Sun, 24 Jan 2021 20:44:15 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id md7sm16622324pjb.52.2021.01.24.20.44.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jan 2021 20:44:14 -0800 (PST)
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] fs: provide locked helper variant of close_fd_get_file()
Message-ID: <61657916-6513-1a80-1434-d689ebb18709@kernel.dk>
Date:   Sun, 24 Jan 2021 21:44:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Assumes current->files->file_lock is already held on invocation. Helps
the caller check the file before removing the fd, if it needs to.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---

Al, I need this to get rid of the two-stage operation that io_uring
currently does for close operations. It's proving to be quite a headache
in terms of cancelation, since we must complete part 2 if we did part 1.
If we provide this locked variant helper, then we can ensure that we the
close as one operation, nicely fixing that problem instead of needing to
hack around it.

 fs/file.c     | 36 +++++++++++++++++++++++++-----------
 fs/internal.h |  1 +
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index dab120b71e44..f3a4bac2cbe9 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -22,6 +22,8 @@
 #include <linux/close_range.h>
 #include <net/sock.h>
 
+#include "internal.h"
+
 unsigned int sysctl_nr_open __read_mostly = 1024*1024;
 unsigned int sysctl_nr_open_min = BITS_PER_LONG;
 /* our min() is unusable in constant expressions ;-/ */
@@ -732,36 +734,48 @@ int __close_range(unsigned fd, unsigned max_fd, unsigned int flags)
 }
 
 /*
- * variant of close_fd that gets a ref on the file for later fput.
- * The caller must ensure that filp_close() called on the file, and then
- * an fput().
+ * See close_fd_get_file() below, this variant assumes current->files->file_lock
+ * is held.
  */
-int close_fd_get_file(unsigned int fd, struct file **res)
+int __close_fd_get_file(unsigned int fd, struct file **res)
 {
 	struct files_struct *files = current->files;
 	struct file *file;
 	struct fdtable *fdt;
 
-	spin_lock(&files->file_lock);
 	fdt = files_fdtable(files);
 	if (fd >= fdt->max_fds)
-		goto out_unlock;
+		goto out_err;
 	file = fdt->fd[fd];
 	if (!file)
-		goto out_unlock;
+		goto out_err;
 	rcu_assign_pointer(fdt->fd[fd], NULL);
 	__put_unused_fd(files, fd);
-	spin_unlock(&files->file_lock);
 	get_file(file);
 	*res = file;
 	return 0;
-
-out_unlock:
-	spin_unlock(&files->file_lock);
+out_err:
 	*res = NULL;
 	return -ENOENT;
 }
 
+/*
+ * variant of close_fd that gets a ref on the file for later fput.
+ * The caller must ensure that filp_close() called on the file, and then
+ * an fput().
+ */
+int close_fd_get_file(unsigned int fd, struct file **res)
+{
+	struct files_struct *files = current->files;
+	int ret;
+
+	spin_lock(&files->file_lock);
+	ret = __close_fd_get_file(fd, res);
+	spin_unlock(&files->file_lock);
+
+	return ret;
+}
+
 void do_close_on_exec(struct files_struct *files)
 {
 	unsigned i;
diff --git a/fs/internal.h b/fs/internal.h
index 77c50befbfbe..c6c85f6ad598 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -132,6 +132,7 @@ extern struct file *do_file_open_root(struct dentry *, struct vfsmount *,
 		const char *, const struct open_flags *);
 extern struct open_how build_open_how(int flags, umode_t mode);
 extern int build_open_flags(const struct open_how *how, struct open_flags *op);
+extern int __close_fd_get_file(unsigned int fd, struct file **res);
 
 long do_sys_ftruncate(unsigned int fd, loff_t length, int small);
 int chmod_common(const struct path *path, umode_t mode);
-- 
2.30.0

-- 
Jens Axboe

