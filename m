Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B6A2F7F04
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 16:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731075AbhAOPIk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 10:08:40 -0500
Received: from raptor.unsafe.ru ([5.9.43.93]:33420 "EHLO raptor.unsafe.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727719AbhAOPIk (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 15 Jan 2021 10:08:40 -0500
X-Greylist: delayed 528 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jan 2021 10:08:39 EST
Received: from comp-core-i7-2640m-0182e6.redhat.com (ip-89-103-122-167.net.upcbroadband.cz [89.103.122.167])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by raptor.unsafe.ru (Postfix) with ESMTPSA id BB5F720A22;
        Fri, 15 Jan 2021 14:59:13 +0000 (UTC)
From:   Alexey Gladkov <gladkov.alexey@gmail.com>
To:     LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-mm@kvack.org
Cc:     Alexey Gladkov <legion@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [RFC PATCH v3 7/8] Move RLIMIT_NPROC check to the place where we increment the counter
Date:   Fri, 15 Jan 2021 15:57:28 +0100
Message-Id: <0829877fe0381f10d927bb94548021224e72f3c9.1610722474.git.gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610722473.git.gladkov.alexey@gmail.com>
References: <cover.1610722473.git.gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Fri, 15 Jan 2021 14:59:14 +0000 (UTC)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After calling set_user(), we always have to call commit_creds() to apply
new credentials upon the current task. There is no need to separate
limit check and counter incrementing.

Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 kernel/cred.c | 22 +++++++++++++++++-----
 kernel/sys.c  | 13 -------------
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index c43e30407d22..991c43559ee8 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -487,14 +487,26 @@ int commit_creds(struct cred *new)
 	if (!gid_eq(new->fsgid, old->fsgid))
 		key_fsgid_changed(new);
 
-	/* do it
-	 * RLIMIT_NPROC limits on user->processes have already been checked
-	 * in set_user().
-	 */
 	alter_cred_subscribers(new, 2);
 	if (new->user != old->user || new->user_ns != old->user_ns) {
+		bool overlimit;
+
 		set_cred_ucounts(new, new->user_ns, new->euid);
-		inc_rlimit_ucounts(new->ucounts, UCOUNT_RLIMIT_NPROC, 1);
+
+		overlimit = inc_rlimit_ucounts_and_test(new->ucounts, UCOUNT_RLIMIT_NPROC,
+				1, rlimit(RLIMIT_NPROC));
+
+		/*
+		 * We don't fail in case of NPROC limit excess here because too many
+		 * poorly written programs don't check set*uid() return code, assuming
+		 * it never fails if called by root.  We may still enforce NPROC limit
+		 * for programs doing set*uid()+execve() by harmlessly deferring the
+		 * failure to the execve() stage.
+		 */
+		if (overlimit && new->user != INIT_USER)
+			current->flags |= PF_NPROC_EXCEEDED;
+		else
+			current->flags &= ~PF_NPROC_EXCEEDED;
 	}
 	rcu_assign_pointer(task->real_cred, new);
 	rcu_assign_pointer(task->cred, new);
diff --git a/kernel/sys.c b/kernel/sys.c
index c2734ab9474e..180c4e06064f 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -467,19 +467,6 @@ static int set_user(struct cred *new)
 	if (!new_user)
 		return -EAGAIN;
 
-	/*
-	 * We don't fail in case of NPROC limit excess here because too many
-	 * poorly written programs don't check set*uid() return code, assuming
-	 * it never fails if called by root.  We may still enforce NPROC limit
-	 * for programs doing set*uid()+execve() by harmlessly deferring the
-	 * failure to the execve() stage.
-	 */
-	if (is_ucounts_overlimit(new->ucounts, UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC)) &&
-			new_user != INIT_USER)
-		current->flags |= PF_NPROC_EXCEEDED;
-	else
-		current->flags &= ~PF_NPROC_EXCEEDED;
-
 	free_uid(new->user);
 	new->user = new_user;
 	return 0;
-- 
2.29.2

