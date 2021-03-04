Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAE032C9A7
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235206AbhCDBKD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348204AbhCDAd2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:33:28 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C4DC0613E8
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:22 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id p21so17616692pgl.12
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3ezGVZWPHudQ53VoTJIV0CGurj6JphiEK5IXbgVDDVY=;
        b=FcimO3l3mrhpEyMQZBmE3pegkqjygnbEjU6s/2m5F3jIifTgQLVarDSNSVNArLzVs+
         5GDLGTOyJCYuB+DUOAn3lsq0PhECU0TqZuPXHffah86Vpnq0/2vx2d/XhOd3KlguWhSb
         Vcn4SnO0RipCDnOqB004w2403S7wBfj7XLh9fE3eVtcHA9QLqOk9HhT/drXi27lQiHZB
         XMvx5ocOduLv9fp3v7ToeYsGzfetTZvrCOGp3TIuV9OlN+B7OeFU2IddZIWz7UwuWZ0x
         f11ga2wFss7M4D8NFqs3IXne9i8j6P3By12FOUsmGjBpjKYUsTNKBQDdAuu4H7NsoT3P
         iAzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3ezGVZWPHudQ53VoTJIV0CGurj6JphiEK5IXbgVDDVY=;
        b=NMpzMi0AznqZLEd4mMrC37pPAg9DFQUpUrlepylqUAtIOWMn348hr7fgrzJu6k4q6u
         xxmBIw7ycVhw0Qh9c5brygiBGiysCGQn0DjgThWI2rzawTZENSt6Xul3Oiqap0/DdjZT
         AS8HG5wub7J1R+4obSGH6n5FVF9nEVDKaXJLV6Uj/T17zOIoTcVkct1x5/MzMI5DND/D
         y81o02YBEw5klYPIW8IF5RIrhmXKfn26JtBnvfx5zg18rPo/6JAKz3F/LNIwvg32aesi
         aG1tDKaj9AalhOaYQxAf7UR3J3LrVg6jS9drjSCoL8cabbVF1GpKVGB7bvvykJfAfij8
         aiqg==
X-Gm-Message-State: AOAM531xy4SJrP/hXPhwqp6wTofD3FdR/4UiNVEiYJkK/IthImPPpneS
        74zeElO2zcGM1IV+Mjawo4aYniUCFvGusmIM
X-Google-Smtp-Source: ABdhPJyNj8LUL34pdpxiG81/iXxUSH6CfEWkuWF/RE3K/tDOb4u+BP2UbftpZkfSSzDuFUqTFkxpqw==
X-Received: by 2002:aa7:96c6:0:b029:1ed:9913:c23b with SMTP id h6-20020aa796c60000b02901ed9913c23bmr1310085pfq.70.1614817642110;
        Wed, 03 Mar 2021 16:27:22 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:21 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 14/33] io_uring: destroy io-wq on exec
Date:   Wed,  3 Mar 2021 17:26:41 -0700
Message-Id: <20210304002700.374417-15-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

Destroy current's io-wq backend and tctx on __io_uring_task_cancel(),
aka exec(). Looks it's not strictly necessary, because it will be done
at some point when the task dies and changes of creds/files/etc. are
handled, but better to do that earlier to free io-wq and not potentially
lock previous mm and other resources for the time being.

It's safe to do because we wait for all requests of the current task to
complete, so no request will use tctx afterwards. Note, that
io_uring_files_cancel() may leave some requests for later reaping, so it
leaves tctx intact, that's ok as the task is dying anyway.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c            | 19 ++++++++++---------
 include/linux/io_uring.h |  2 +-
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d495735de2d9..4afe3dd1430c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8835,13 +8835,17 @@ static void io_uring_del_task_file(struct file *file)
 		fput(file);
 }
 
-static void io_uring_remove_task_files(struct io_uring_task *tctx)
+static void io_uring_clean_tctx(struct io_uring_task *tctx)
 {
 	struct file *file;
 	unsigned long index;
 
 	xa_for_each(&tctx->xa, index, file)
 		io_uring_del_task_file(file);
+	if (tctx->io_wq) {
+		io_wq_put_and_exit(tctx->io_wq);
+		tctx->io_wq = NULL;
+	}
 }
 
 void __io_uring_files_cancel(struct files_struct *files)
@@ -8856,13 +8860,8 @@ void __io_uring_files_cancel(struct files_struct *files)
 		io_uring_cancel_task_requests(file->private_data, files);
 	atomic_dec(&tctx->in_idle);
 
-	if (files) {
-		io_uring_remove_task_files(tctx);
-		if (tctx->io_wq) {
-			io_wq_put_and_exit(tctx->io_wq);
-			tctx->io_wq = NULL;
-		}
-	}
+	if (files)
+		io_uring_clean_tctx(tctx);
 }
 
 static s64 tctx_inflight(struct io_uring_task *tctx)
@@ -8954,7 +8953,9 @@ void __io_uring_task_cancel(void)
 
 	atomic_dec(&tctx->in_idle);
 
-	io_uring_remove_task_files(tctx);
+	io_uring_clean_tctx(tctx);
+	/* all current's requests should be gone, we can kill tctx */
+	__io_uring_free(current);
 }
 
 void __io_uring_unshare(void)
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index bfe2fcb4f478..796e0d7d186d 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -44,7 +44,7 @@ static inline void io_uring_unshare(void)
 }
 static inline void io_uring_task_cancel(void)
 {
-	if (current->io_uring && !xa_empty(&current->io_uring->xa))
+	if (current->io_uring)
 		__io_uring_task_cancel();
 }
 static inline void io_uring_files_cancel(struct files_struct *files)
-- 
2.30.1

