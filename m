Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A60EC132C85
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2020 18:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgAGRGV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jan 2020 12:06:21 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:33144 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728236AbgAGRGU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jan 2020 12:06:20 -0500
Received: by mail-il1-f193.google.com with SMTP id v15so228946iln.0
        for <io-uring@vger.kernel.org>; Tue, 07 Jan 2020 09:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=491locdRtuN4Y2mr+mNo2Sj9pBk1+R4oVqrtsXFQitc=;
        b=HgBxpyIq2SWFCPs9Qyz2F31KtDNhECCO524AsP+l8BIgjIB+shjmJz/GkPBh5z7E4I
         +8RWN+P8TTH9OmiFlXj/1V3XGZg4GGH1rfkPvFGXXYqZ8QYbK9gFVgoQdKbJl3E1nHDJ
         DQ+IjQ1Z4OoEVieiesBi72N734T3Gusxomp1SIF6rQ8SQT0LjyhSuuXXmTlPe+DYmrHS
         RBaliiNabS0yhYeML8RGHBFE8gKNMGCx1ywnkrC+TvcGPQzccGw90vmxm55/JuGMNInn
         hN3Fo4NQVSqJam7bsDONJ330bqFBJ3YTfT4j/Ftom+lrUXroNai2FMEdTiwOa3U+LwLi
         hgqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=491locdRtuN4Y2mr+mNo2Sj9pBk1+R4oVqrtsXFQitc=;
        b=Kxnv59V4a8losJEPgRDnqrX5+EBrdca46d8BgSTAhmzWTWxuPh5iANKatm8OiZIzUI
         7JFS07dqJJyAC92O79OysKbGsBA366hr5TRx2vb52/cfyL4LtwhX1xOG7iLC/dj9HJfe
         PPDtz0sDGCs8GncTxxC+N8jd0XLGKJ+3x/Oh8UupUNnwVXD1x3szhAdAU+7S2VK6Z/zA
         q39XhpeperPGoYkhF3cvoPKDzeM1NRs9qciUtjGTO1GfuUafewTt9xUxqc92sNimqmsG
         q4IZoJgtjhkqxDKb7/3L/gfgeQ9MaS2EEortPnEz/YO3fw/2IxWOpYd8h+DtBtP+ACfA
         6MAQ==
X-Gm-Message-State: APjAAAU8BokKZ/Rf1DyIPGrTd+BvDZLHlCBnNP/v1AV+3y7sRrRlaKrk
        JoRGulKhNLu8EyRSfYl4KFVrd97lt+M=
X-Google-Smtp-Source: APXvYqx43tluriyQkwFyVvEazUYhP0s2adPkJF1i25kaBmuCIdVHuKZIXhYTGO/K67MqxcNz7cH/4g==
X-Received: by 2002:a92:2904:: with SMTP id l4mr51958ilg.166.1578416440079;
        Tue, 07 Jan 2020 09:00:40 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g4sm42547iln.81.2020.01.07.09.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:00:39 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] fs: move filp_close() outside of __close_fd_get_file()
Date:   Tue,  7 Jan 2020 10:00:32 -0700
Message-Id: <20200107170034.16165-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107170034.16165-1-axboe@kernel.dk>
References: <20200107170034.16165-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just one caller of this, and just use filp_close() there manually.
This is important to allow async close/removal of the fd.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/android/binder.c | 6 ++++--
 fs/file.c                | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index b2dad43dbf82..cf72ca250a08 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2249,10 +2249,12 @@ static void binder_deferred_fd_close(int fd)
 		return;
 	init_task_work(&twcb->twork, binder_do_fd_close);
 	__close_fd_get_file(fd, &twcb->file);
-	if (twcb->file)
+	if (twcb->file) {
+		filp_close(twcb->file, current->files);
 		task_work_add(current, &twcb->twork, true);
-	else
+	} else {
 		kfree(twcb);
+	}
 }
 
 static void binder_transaction_buffer_release(struct binder_proc *proc,
diff --git a/fs/file.c b/fs/file.c
index 3da91a112bab..fb7081bfac2b 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -642,7 +642,9 @@ int __close_fd(struct files_struct *files, unsigned fd)
 EXPORT_SYMBOL(__close_fd); /* for ksys_close() */
 
 /*
- * variant of __close_fd that gets a ref on the file for later fput
+ * variant of __close_fd that gets a ref on the file for later fput.
+ * The caller must ensure that filp_close() called on the file, and then
+ * an fput().
  */
 int __close_fd_get_file(unsigned int fd, struct file **res)
 {
@@ -662,7 +664,7 @@ int __close_fd_get_file(unsigned int fd, struct file **res)
 	spin_unlock(&files->file_lock);
 	get_file(file);
 	*res = file;
-	return filp_close(file, files);
+	return 0;
 
 out_unlock:
 	spin_unlock(&files->file_lock);
-- 
2.24.1

