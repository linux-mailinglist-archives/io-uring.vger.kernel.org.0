Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC42F1A10E0
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 18:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgDGQDE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 12:03:04 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42298 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgDGQDE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 12:03:04 -0400
Received: by mail-pl1-f194.google.com with SMTP id v2so29088plp.9
        for <io-uring@vger.kernel.org>; Tue, 07 Apr 2020 09:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ts5xLofRQw1zLvX1GvhDN16FH9hbS7zNXq6heiTnOX8=;
        b=IKXl2gWQkp0yNjjv/j1guwImSTNH0UkuMhACYeswhcRoBizcHeoIYf10ESF/bXXYvr
         ABGd61KfL3NMbf/hnWopmKxoW/3giXrKv0LipWVulSVznr05Ekij3KIDTZ3TT3HDcewn
         fUQ+vTCH5vkm38gHbZamglufpOUqju7nIvgBaYL7aCQ9lwRdBEfPaoUSKissMoVhqs+f
         ehVtMUblBrik74ND99wcp44+bD6kQo7xUIp28MgwFzqG6Tq5mi3TzvTilXX9xgcfjzGZ
         7eVyZ6fEPn/a7jIpm5n6XcyEd0M+EAC459B+T3CN8xKGiERW7iry5TJ9iIyL3tIsfZ6m
         spEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ts5xLofRQw1zLvX1GvhDN16FH9hbS7zNXq6heiTnOX8=;
        b=ERD06jU5dn5RcNTvTLzKe1z5uXQX7mvBchanRSPMjW6uMSs0sqZmp93a9joe0CeGQN
         KS969Y/VurIuOV+rtfvlFGIU4RTHcmNRXwn05wf1ZZwIh0ipqZQRw1DaRXkYANbgADUH
         T4AvAlZ0OFTzH+pwsoYxRuxaFuXqEVRYr06DnSbtV2SVkq9FSPydI5RlcbqasLiyQ3is
         8NDqjZm67H8Zm7mEVmRlAh6OWHtrC3hskp9hjhczcSynOsptoOIqub7ThwrDUJEmgcWK
         zvwVNdRd/DfTkY91BPcwkQbJ843Lbdx/OWzIJswGFF57Z2ciN9M/fQlF8h1bInOXVu/k
         x7eA==
X-Gm-Message-State: AGi0PuaZ4sUQ7rdgFypOs2VvGEE56HPEDOuK4RLjJPY7rVBdtWTT9Jp9
        MD+qGD0FbC2MmV4AXolsAW/Zdm6qs2s0yw==
X-Google-Smtp-Source: APiQypLK3uZV+r4ud/lmZKonkXWeDq5sYL+ZSkAPikN+brWUAOuj5YzwP9OhUay3o8yPxC2MwzDYpg==
X-Received: by 2002:a17:902:8d89:: with SMTP id v9mr3128248plo.83.1586275382459;
        Tue, 07 Apr 2020 09:03:02 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab])
        by smtp.gmail.com with ESMTPSA id y22sm14366955pfr.68.2020.04.07.09.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 09:03:02 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk, Jens Axboe <axboe@kernel.dk>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/4] task_work: add task_work_pending() helper
Date:   Tue,  7 Apr 2020 10:02:55 -0600
Message-Id: <20200407160258.933-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407160258.933-1-axboe@kernel.dk>
References: <20200407160258.933-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Various callsites currently check current->task_works != NULL to know
when to run work. Add a helper that we use internally for that. This is
in preparation for also not running if exit queue has been queued.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/task_work.h | 16 ++++++++++++++--
 kernel/task_work.c        |  2 +-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index bd9a6a91c097..088538590e65 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -15,11 +15,23 @@ init_task_work(struct callback_head *twork, task_work_func_t func)
 
 int task_work_add(struct task_struct *task, struct callback_head *twork, bool);
 struct callback_head *task_work_cancel(struct task_struct *, task_work_func_t);
-void task_work_run(void);
+void __task_work_run(void);
+
+static inline bool task_work_pending(void)
+{
+	return current->task_works;
+}
+
+static inline void task_work_run(void)
+{
+	if (task_work_pending())
+		__task_work_run();
+}
 
 static inline void exit_task_work(struct task_struct *task)
 {
-	task_work_run();
+	/* must always run to install exit work */
+	__task_work_run();
 }
 
 #endif	/* _LINUX_TASK_WORK_H */
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 825f28259a19..9620333423a3 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -87,7 +87,7 @@ task_work_cancel(struct task_struct *task, task_work_func_t func)
  * it exits. In the latter case task_work_add() can no longer add the
  * new work after task_work_run() returns.
  */
-void task_work_run(void)
+void __task_work_run(void)
 {
 	struct task_struct *task = current;
 	struct callback_head *work, *head, *next;
-- 
2.26.0

