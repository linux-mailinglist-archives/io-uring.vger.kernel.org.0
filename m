Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB8F290920
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 18:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410542AbgJPQCq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 12:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395555AbgJPQCq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 12:02:46 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9A6C061755
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:45 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a17so1628091pju.1
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DJHAPBQA5lUfIPc2vpKzxHSJq63fjq1SHWxWwo0SKcM=;
        b=LMXRwm5/muux32fD8duIDqgMd4Ewqaz62Pp37AYW+pCCwjHci4UsRGjyavLDdMhXbP
         wWyvSxT94ex3pdnwOowu7IZ0fRPWU9lDSbBqZBHf09LumM3tBtk5Y70UKCF3u42TZm2W
         okbRDddvprfzq3OjI9Zw7ghVHrLNyvRuZaAifKNHGafGGdjS3zU+On5vBZ45VP1PctAN
         rItFegfM8wQ+sP/QkqY5Th1PdnAePgY7BtYE1f4ZALVyCFeBwCOe07/gqi9OMrBeKjMz
         /787sVDweUONeXhWoNQNSmxgLVYXbNzbAy8+YTbsF0bYFLWfOb6/37/J4oA6nUdBdVke
         3Z1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DJHAPBQA5lUfIPc2vpKzxHSJq63fjq1SHWxWwo0SKcM=;
        b=IsdLmNVxx8BrTyy4ISoafaQu6bxTiaFQV2H73cAx3FyU0czxA3kSexL752tGk3dDsK
         jNGykuKRgGRThXVblI2xo6AtBDXBH6hn5c7Tt5UmtPZj/vChm+UkkxNOGx96j3tCGSFz
         3BNqqtihQ7zeX5ZewJvHSPcHPQAwxpu+KY5/3Jo1YRz1E/gn14Z0tPZPttTyFnlzpf6b
         HgDn9m6I23OTf4izbwWVD1M2Nj21hI/tSJPOXdjLfXdk3RVqXPbmmSFpGntk4GMPNqQt
         T8xyqb1MUQoL3xuQ2/9ltSljuYYtAQuRwUju/V/uaWzQrhTck3+10TX+CTtIOURywuCl
         mEew==
X-Gm-Message-State: AOAM530K/tcprQlP68oWT5td2ziaXRqgIGDW6jmJBi11jpr6n/S+B3mz
        6bv3se6thQ8Z2EIzDXppMA3gbCO2MgV81T3v
X-Google-Smtp-Source: ABdhPJz26kEfR40S7a8NM20uzlyG6XL1GktaoLpWuW9K9xNdgskogl91q1FDLznd5kN0iiOpjA9Uzg==
X-Received: by 2002:a17:90a:6683:: with SMTP id m3mr4857295pjj.225.1602864165103;
        Fri, 16 Oct 2020 09:02:45 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t13sm3190109pfc.1.2020.10.16.09.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:02:44 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 13/18] io_uring: rely solely on work flags to determine personality.
Date:   Fri, 16 Oct 2020 10:02:19 -0600
Message-Id: <20201016160224.1575329-14-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016160224.1575329-1-axboe@kernel.dk>
References: <20201016160224.1575329-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We solely rely on work->work_flags now, so use that for proper checking
and clearing/dropping of various identity items.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c    |  4 ----
 fs/io_uring.c | 51 +++++++++++++++++++++++++++++++++------------------
 2 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index e636898f8a1f..b7d8e544a804 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -429,14 +429,10 @@ static void io_wq_switch_mm(struct io_worker *worker, struct io_wq_work *work)
 		mmput(worker->mm);
 		worker->mm = NULL;
 	}
-	if (!work->mm)
-		return;
 
 	if (mmget_not_zero(work->mm)) {
 		kthread_use_mm(work->mm);
 		worker->mm = work->mm;
-		/* hang on to this mm */
-		work->mm = NULL;
 		return;
 	}
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6f6f6bcef82d..5b3f624fef6b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1162,19 +1162,21 @@ static void io_req_clean_work(struct io_kiocb *req)
 
 	req->flags &= ~REQ_F_WORK_INITIALIZED;
 
-	if (req->work.mm) {
+	if (req->work.flags & IO_WQ_WORK_MM) {
 		mmdrop(req->work.mm);
-		req->work.mm = NULL;
+		req->work.flags &= ~IO_WQ_WORK_MM;
 	}
 #ifdef CONFIG_BLK_CGROUP
-	if (req->work.blkcg_css)
+	if (req->work.flags & IO_WQ_WORK_BLKCG) {
 		css_put(req->work.blkcg_css);
+		req->work.flags &= ~IO_WQ_WORK_BLKCG;
+	}
 #endif
-	if (req->work.creds) {
+	if (req->work.flags & IO_WQ_WORK_CREDS) {
 		put_cred(req->work.creds);
-		req->work.creds = NULL;
+		req->work.flags &= ~IO_WQ_WORK_CREDS;
 	}
-	if (req->work.fs) {
+	if (req->work.flags & IO_WQ_WORK_FS) {
 		struct fs_struct *fs = req->work.fs;
 
 		spin_lock(&req->work.fs->lock);
@@ -1183,7 +1185,7 @@ static void io_req_clean_work(struct io_kiocb *req)
 		spin_unlock(&req->work.fs->lock);
 		if (fs)
 			free_fs_struct(fs);
-		req->work.fs = NULL;
+		req->work.flags &= ~IO_WQ_WORK_FS;
 	}
 }
 
@@ -1201,7 +1203,7 @@ static void io_prep_async_work(struct io_kiocb *req)
 		if (def->unbound_nonreg_file)
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
 	}
-	if (!req->work.files &&
+	if (!(req->work.flags & IO_WQ_WORK_FILES) &&
 	    (io_op_defs[req->opcode].work_flags & IO_WQ_WORK_FILES) &&
 	    !(req->flags & REQ_F_NO_FILE_TABLE)) {
 		req->work.files = get_files_struct(current);
@@ -1212,13 +1214,17 @@ static void io_prep_async_work(struct io_kiocb *req)
 		spin_lock_irq(&ctx->inflight_lock);
 		list_add(&req->inflight_entry, &ctx->inflight_list);
 		spin_unlock_irq(&ctx->inflight_lock);
+		req->work.flags |= IO_WQ_WORK_FILES;
 	}
-	if (!req->work.mm && (def->work_flags & IO_WQ_WORK_MM)) {
+	if (!(req->work.flags & IO_WQ_WORK_MM) &&
+	    (def->work_flags & IO_WQ_WORK_MM)) {
 		mmgrab(current->mm);
 		req->work.mm = current->mm;
+		req->work.flags |= IO_WQ_WORK_MM;
 	}
 #ifdef CONFIG_BLK_CGROUP
-	if (!req->work.blkcg_css && (def->work_flags & IO_WQ_WORK_BLKCG)) {
+	if (!(req->work.flags & IO_WQ_WORK_BLKCG) &&
+	    (def->work_flags & IO_WQ_WORK_BLKCG)) {
 		rcu_read_lock();
 		req->work.blkcg_css = blkcg_css();
 		/*
@@ -1227,16 +1233,22 @@ static void io_prep_async_work(struct io_kiocb *req)
 		 */
 		if (!css_tryget_online(req->work.blkcg_css))
 			req->work.blkcg_css = NULL;
+		else
+			req->work.flags |= IO_WQ_WORK_BLKCG;
 		rcu_read_unlock();
 	}
 #endif
-	if (!req->work.creds)
+	if (!(req->work.flags & IO_WQ_WORK_CREDS)) {
 		req->work.creds = get_current_cred();
-	if (!req->work.fs && (def->work_flags & IO_WQ_WORK_FS)) {
+		req->work.flags |= IO_WQ_WORK_CREDS;
+	}
+	if (!(req->work.flags & IO_WQ_WORK_FS) &&
+	    (def->work_flags & IO_WQ_WORK_FS)) {
 		spin_lock(&current->fs->lock);
 		if (!current->fs->in_exec) {
 			req->work.fs = current->fs;
 			req->work.fs->users++;
+			req->work.flags |= IO_WQ_WORK_FS;
 		} else {
 			req->work.flags |= IO_WQ_WORK_CANCEL;
 		}
@@ -1246,8 +1258,6 @@ static void io_prep_async_work(struct io_kiocb *req)
 		req->work.fsize = rlimit(RLIMIT_FSIZE);
 	else
 		req->work.fsize = RLIM_INFINITY;
-
-	req->work.flags |= def->work_flags;
 }
 
 static void io_prep_async_link(struct io_kiocb *req)
@@ -1437,7 +1447,8 @@ static inline bool io_match_files(struct io_kiocb *req,
 {
 	if (!files)
 		return true;
-	if (req->flags & REQ_F_WORK_INITIALIZED)
+	if ((req->flags & REQ_F_WORK_INITIALIZED) &&
+	    (req->work.flags & IO_WQ_WORK_FILES))
 		return req->work.files == files;
 	return false;
 }
@@ -5687,7 +5698,7 @@ static void io_req_drop_files(struct io_kiocb *req)
 	req->flags &= ~REQ_F_INFLIGHT;
 	put_files_struct(req->work.files);
 	put_nsproxy(req->work.nsproxy);
-	req->work.files = NULL;
+	req->work.flags &= ~IO_WQ_WORK_FILES;
 }
 
 static void __io_clean_op(struct io_kiocb *req)
@@ -6053,6 +6064,7 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 			old_creds = NULL; /* restored original creds */
 		else
 			old_creds = override_creds(req->work.creds);
+		req->work.flags |= IO_WQ_WORK_CREDS;
 	}
 
 	ret = io_issue_sqe(req, true, cs);
@@ -6360,6 +6372,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		if (unlikely(!req->work.creds))
 			return -EINVAL;
 		get_cred(req->work.creds);
+		req->work.flags |= IO_WQ_WORK_CREDS;
 	}
 
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
@@ -8227,7 +8240,8 @@ static bool io_wq_files_match(struct io_wq_work *work, void *data)
 {
 	struct files_struct *files = data;
 
-	return !files || work->files == files;
+	return !files || ((work->flags & IO_WQ_WORK_FILES) &&
+				work->files == files);
 }
 
 /*
@@ -8382,7 +8396,8 @@ static bool io_uring_cancel_files(struct io_ring_ctx *ctx,
 
 		spin_lock_irq(&ctx->inflight_lock);
 		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
-			if (files && req->work.files != files)
+			if (files && (req->work.flags & IO_WQ_WORK_FILES) &&
+			    req->work.files != files)
 				continue;
 			/* req is being completed, ignore */
 			if (!refcount_inc_not_zero(&req->refs))
-- 
2.28.0

