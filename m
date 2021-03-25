Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3FFB34971E
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 17:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhCYQoH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 12:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhCYQnt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 12:43:49 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5C3C06175F
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 09:43:49 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id k25so2544920iob.6
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 09:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zelrk36zpmC+2fEIaTzCe8iAs0QYE8m4zqDOwegDXxU=;
        b=QLqByaEHTRPwGeUS1pOq5E8tTBozcYgNoU0DBDvnF2zaT4Moftc+JhKY6s7sagWObm
         pQuhuSWdD53SqSqWiQ60vUU+WrpJwTOLrbdnSAOrv5FHd1mf8yi8JX0S//j4bZxzhlKR
         qt1E1tR5X1rsX31PtU4jNGpbucp+ruUSzfDwXIXyCwHi4MNqLoK6shp9KlsyA429DdMW
         kpnB/Y4xtQp39aO8MK36jUB27WAfnrN6XfftZCG1cEb/pGnaLwgTFRMjrBtXXvyRrbRI
         uHc6sPcSmCOmCTU0OtWuynAM15qkhs2Dr68y+h07fTmhtexCh63eoQT7dhmOZWz96LnE
         4tnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zelrk36zpmC+2fEIaTzCe8iAs0QYE8m4zqDOwegDXxU=;
        b=purAYQhepCs+e0b4uGnMp8RywtgFcvPYEw9MQbwDih3shpElEv739UzR1oiIFnEr8d
         glNbByZzQlCXXp95xYml3+j8o1PmQbbDDWSUvFMJzCT6GldLdDhpeurVLdSLy/ywXINV
         6oOsRaOse7zj5glF+AWMzVfNlk7YPhKHEAUI6xZAWYhfMiBZmhaNfcQkjyo5FFdKJo8g
         G1zapmqwrlRIEjowMKI8JiJn8XYwRUzvnFoTXM+0xCenCIGz+5VUJ0g541hXrfjCQj8M
         4uAhhmlVruRglpNW5pAOzp31LG5H1GznjGJTbO+Kor8oC+nUlCZjFs8wX46JaknqUSX0
         9ETQ==
X-Gm-Message-State: AOAM533naW0voo7GfDNzFBZob8yn5LCbY96uZ5zFfojJJ+HLWRToIGDt
        KBBd2jtpsEJYGGVjRLM3fnygZkzG7X5UUQ==
X-Google-Smtp-Source: ABdhPJyFxG6jE4JyH3R/U5GLHMaVOP8xt4cFnvszKiM7dZP9MvQ6l80nPe2d2VkNep1HFuDssJGtFQ==
X-Received: by 2002:a02:714f:: with SMTP id n15mr8440902jaf.6.1616690629100;
        Thu, 25 Mar 2021 09:43:49 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k12sm2990605ios.2.2021.03.25.09.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 09:43:48 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, oleg@redhat.com, metze@samba.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] kernel: don't include PF_IO_WORKERs as part of same_thread_group()
Date:   Thu, 25 Mar 2021 10:43:42 -0600
Message-Id: <20210325164343.807498-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210325164343.807498-1-axboe@kernel.dk>
References: <20210325164343.807498-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't pretend that the IO threads are in the same thread group, the only
case where that seems to be desired is for accounting purposes. Add
a special accounting function for that and make the scheduler side use it.

For signals and ptrace, we don't allow them to be treated as threads
anyway.

Reported-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/sched/signal.h | 9 ++++++++-
 kernel/sched/cputime.c       | 2 +-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 3f6a0fcaa10c..4f621e386abf 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -668,11 +668,18 @@ static inline bool thread_group_leader(struct task_struct *p)
 }
 
 static inline
-bool same_thread_group(struct task_struct *p1, struct task_struct *p2)
+bool same_thread_group_account(struct task_struct *p1, struct task_struct *p2)
 {
 	return p1->signal == p2->signal;
 }
 
+static inline
+bool same_thread_group(struct task_struct *p1, struct task_struct *p2)
+{
+	return same_thread_group_account(p1, p2) &&
+			!((p1->flags | p2->flags) & PF_IO_WORKER);
+}
+
 static inline struct task_struct *next_thread(const struct task_struct *p)
 {
 	return list_entry_rcu(p->thread_group.next,
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 5f611658eeab..625110cacc2a 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -307,7 +307,7 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 	 * those pending times and rely only on values updated on tick or
 	 * other scheduler action.
 	 */
-	if (same_thread_group(current, tsk))
+	if (same_thread_group_account(current, tsk))
 		(void) task_sched_runtime(current);
 
 	rcu_read_lock();
-- 
2.31.0

