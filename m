Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E88E1A10E2
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 18:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgDGQDH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 12:03:07 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:52927 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgDGQDH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 12:03:07 -0400
Received: by mail-pj1-f68.google.com with SMTP id ng8so942839pjb.2
        for <io-uring@vger.kernel.org>; Tue, 07 Apr 2020 09:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PO/WcQSK3jIV6+mEeW/X0pv1XXoeNuIRAZlC7WSdLM4=;
        b=qfqV+qbGsZQhEfXJPus85N2QSLoHhVH6ifQ3fOnNREcjkNOq69TrAjrusnT578+t5z
         vTGcS6pGh9uNDDAStk0QIDYmFqX34ABEKk0AILlzIlmBDFxzNram5ZKO+EEK9p/Gsb8O
         Us3P4KHlkV2M6JCRqjkBAftaaBueAXPwPe5HmbexGuIlLKPrZAlwdCJKKJAqI9k4Mrw3
         sOI9Xlt1m2zWlWgKq0mAKQjTPZyw8nWkx2+7kdENsWZqKgJonNegWIFFoUn3SIkS7t9Q
         kT18/5gbXSqYF71YR1A5R45hQV/+MxdLp8viZ8VgtVPPfR904D1Xju0B7AY8f1YHp0j9
         bvsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PO/WcQSK3jIV6+mEeW/X0pv1XXoeNuIRAZlC7WSdLM4=;
        b=RREhbV8xTuaCwphhVi1JAqC+94sCeUCwbBc1qRGNDudDwGOOumSY8q9s2VU2INM8m4
         mY1/n1okCyjI+lRu6SXHX8sKrIrBryxvjp8FN20f1CKDquIqYv4+TVs5CIK6AcwWz5Vf
         V81Obf/WfMJEnYJjo49ANwnU/jDhEzDzYQ8G0QeoOaritQ/DR65BzJ7oTmX4uUF3avVF
         YUgk4r/Yq3rvId7SoTZL0an5WfjgTe9yNxY+K8qObnaDB7SUPEk3+cZnwQqnQWNZjMev
         14DdcsthgUhteVJI4Wfvoh2duUHWZE8IXNKmH6tPo3LDLt8X3aIQgVP6ziBKtMKKrqxN
         PlFA==
X-Gm-Message-State: AGi0PuaUITKU0ZrQIHs6OQ2ppnb0zDw0P3rmfh5YalY5idbKdILvMBxH
        2L06uFyIptltT+keysG3IXL3UuRMGJ6DZg==
X-Google-Smtp-Source: APiQypK9PoydroftiRL4O7vRBnsw2GHrshMQ2+7FXzqYsyntrYiGYbg3+X+7+0xM3F7qLFmGgGvsHw==
X-Received: by 2002:a17:902:aa94:: with SMTP id d20mr3075321plr.313.1586275384679;
        Tue, 07 Apr 2020 09:03:04 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab])
        by smtp.gmail.com with ESMTPSA id y22sm14366955pfr.68.2020.04.07.09.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 09:03:04 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk, Jens Axboe <axboe@kernel.dk>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/4] task_work: make exit_work externally visible
Date:   Tue,  7 Apr 2020 10:02:57 -0600
Message-Id: <20200407160258.933-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407160258.933-1-axboe@kernel.dk>
References: <20200407160258.933-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If task_work has already been run on task exit, we don't always know
if it's safe to run again. Most call paths don't really care as they
can never hit this condition, but io_uring would like to call task
work from the fops->release() handler, which can get invoked off
do_exit() where we could have already run exit_task_work().

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/task_work.h | 2 ++
 kernel/task_work.c        | 8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index 088538590e65..893c916d8677 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -7,6 +7,8 @@
 
 typedef void (*task_work_func_t)(struct callback_head *);
 
+extern struct callback_head task_work_exited;
+
 static inline void
 init_task_work(struct callback_head *twork, task_work_func_t func)
 {
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 9620333423a3..d6a8b4ab4858 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -3,7 +3,7 @@
 #include <linux/task_work.h>
 #include <linux/tracehook.h>
 
-static struct callback_head work_exited; /* all we need is ->next == NULL */
+struct callback_head task_work_exited = { };
 
 /**
  * task_work_add - ask the @task to execute @work->func()
@@ -31,7 +31,7 @@ task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
 
 	do {
 		head = READ_ONCE(task->task_works);
-		if (unlikely(head == &work_exited))
+		if (unlikely(head == &task_work_exited))
 			return -ESRCH;
 		work->next = head;
 	} while (cmpxchg(&task->task_works, head, work) != head);
@@ -95,14 +95,14 @@ void __task_work_run(void)
 	for (;;) {
 		/*
 		 * work->func() can do task_work_add(), do not set
-		 * work_exited unless the list is empty.
+		 * task_work_exited unless the list is empty.
 		 */
 		do {
 			head = NULL;
 			work = READ_ONCE(task->task_works);
 			if (!work) {
 				if (task->flags & PF_EXITING)
-					head = &work_exited;
+					head = &task_work_exited;
 				else
 					break;
 			}
-- 
2.26.0

