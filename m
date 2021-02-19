Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3DB31FDAC
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 18:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhBSRLX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 12:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhBSRLQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 12:11:16 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94021C061221
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:32 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id f6so6358782ioz.5
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SWvGBw/CeY3188r2gHQPepeNIA1z7Y0TKDoCt/h7QQU=;
        b=hLAnbCaFBA3BZa8EsI5NVm+UEhp+l328XyPrq4R3VmIa4WXsqhxMCGgBT6zo6mjPUx
         TALep3FjTqSKGOV3Mf23f1Ihz+Jc88aiueza5YseTsncW5NsDdSTUEuu/XJtL0Ta+3UK
         sNKbY2fS3qpxNIBbxOAFMVWGfUqWlEyPHRpwct+89O3kaVBjercDleo0p3WOWyI0f1Ya
         JP6V8AaTrLPt7tmqZfOm2+gsr6YyrsJw1Pl5wfLiJdr/V6m4S/vxdUk9+zt7YW3zbq5h
         8ydxChVZc0Ts0TdF6E9NmfvZb3GBpBYlvEoHfBIbUOlf0XQALQesoZPToHVHO5XBcBQ9
         wDyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SWvGBw/CeY3188r2gHQPepeNIA1z7Y0TKDoCt/h7QQU=;
        b=KLGNG1QGdyBWCX6AyOO8Lul086ix+ZF2BN19TXeYD7Jx90qmlDkgeoU16huCLeTJzs
         d9ckEfFVigtM1lY7hBiWftR3J3JuxofdfTN/1hyWJS91tBWHzjCDCpUsj/MY4kdZykd4
         MsRADRZQ001Od0X7jXh3MlbFLHXU9rPjJ4z7M2kHqjRChi1I8Rw2/iUEqVRwuZTbcgSb
         jw5oYcecCU1+POn1VgQOHKtU78Hn9/lD/527gHaQU2JLxz8UddxJq1CWMgbq+wjiMUN0
         vhYcorIure3gFWPb3KYA0sm7LTOPUHC1ZJLErHvfRmw0baWj8exx8XIEromdGlX6rO6p
         z/jw==
X-Gm-Message-State: AOAM532w15aG0kfKrLNIRfICFr/QYuBuO6NfiGWiwn5VNuM8nGY6g3Bd
        GrIuktImW8Q72S7JC4dKqtH5w2/N3Hkuxeay
X-Google-Smtp-Source: ABdhPJwMYVUfwkT16HAXRTVtgYmsQoqkFbeQ5N1x5b/q9V2NHsj5Rybu5ENoLQRP1V73LHh3G86APA==
X-Received: by 2002:a02:82c7:: with SMTP id u7mr10503856jag.76.1613754630362;
        Fri, 19 Feb 2021 09:10:30 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o17sm4805431ilo.73.2021.02.19.09.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:10:29 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 16/18] Revert "proc: don't allow async path resolution of /proc/thread-self components"
Date:   Fri, 19 Feb 2021 10:10:08 -0700
Message-Id: <20210219171010.281878-17-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210219171010.281878-1-axboe@kernel.dk>
References: <20210219171010.281878-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This reverts commit 0d4370cfe36b7f1719123b621a4ec4d9c7a25f89.

No longer needed, as the io-wq worker threads have the right identity.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/proc/self.c        | 2 +-
 fs/proc/thread_self.c | 7 -------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/proc/self.c b/fs/proc/self.c
index a4012154e109..cc71ce3466dc 100644
--- a/fs/proc/self.c
+++ b/fs/proc/self.c
@@ -20,7 +20,7 @@ static const char *proc_self_get_link(struct dentry *dentry,
 	 * Not currently supported. Once we can inherit all of struct pid,
 	 * we can allow this.
 	 */
-	if (current->flags & PF_IO_WORKER)
+	if (current->flags & PF_KTHREAD)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	if (!tgid)
diff --git a/fs/proc/thread_self.c b/fs/proc/thread_self.c
index d56681d86d28..a553273fbd41 100644
--- a/fs/proc/thread_self.c
+++ b/fs/proc/thread_self.c
@@ -17,13 +17,6 @@ static const char *proc_thread_self_get_link(struct dentry *dentry,
 	pid_t pid = task_pid_nr_ns(current, ns);
 	char *name;
 
-	/*
-	 * Not currently supported. Once we can inherit all of struct pid,
-	 * we can allow this.
-	 */
-	if (current->flags & PF_IO_WORKER)
-		return ERR_PTR(-EOPNOTSUPP);
-
 	if (!pid)
 		return ERR_PTR(-ENOENT);
 	name = kmalloc(10 + 6 + 10 + 1, dentry ? GFP_KERNEL : GFP_ATOMIC);
-- 
2.30.0

