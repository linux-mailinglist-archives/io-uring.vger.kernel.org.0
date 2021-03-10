Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16682333BED
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 13:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbhCJMCK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 07:02:10 -0500
Received: from raptor.unsafe.ru ([5.9.43.93]:56056 "EHLO raptor.unsafe.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230512AbhCJMBo (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 10 Mar 2021 07:01:44 -0500
Received: from comp-core-i7-2640m-0182e6.redhat.com (ip-94-113-225-162.net.upcbroadband.cz [94.113.225.162])
        by raptor.unsafe.ru (Postfix) with ESMTPSA id 59AD640DB8;
        Wed, 10 Mar 2021 12:01:42 +0000 (UTC)
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
Subject: [PATCH v8 1/8] Increase size of ucounts to atomic_long_t
Date:   Wed, 10 Mar 2021 13:01:26 +0100
Message-Id: <18b439960a2de06e9352c36b8d04fb149a024a86.1615372955.git.gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1615372955.git.gladkov.alexey@gmail.com>
References: <cover.1615372955.git.gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.4 (raptor.unsafe.ru [0.0.0.0]); Wed, 10 Mar 2021 12:01:42 +0000 (UTC)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

RLIMIT_MSGQUEUE and RLIMIT_MEMLOCK use unsigned long to store their
counters. As a preparation for moving rlimits based on ucounts, we need
to increase the size of the variable to long.

Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 include/linux/user_namespace.h |  4 ++--
 kernel/ucount.c                | 16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 64cf8ebdc4ec..0bb833fd41f4 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -85,7 +85,7 @@ struct user_namespace {
 	struct ctl_table_header *sysctls;
 #endif
 	struct ucounts		*ucounts;
-	int ucount_max[UCOUNT_COUNTS];
+	long ucount_max[UCOUNT_COUNTS];
 } __randomize_layout;
 
 struct ucounts {
@@ -93,7 +93,7 @@ struct ucounts {
 	struct user_namespace *ns;
 	kuid_t uid;
 	int count;
-	atomic_t ucount[UCOUNT_COUNTS];
+	atomic_long_t ucount[UCOUNT_COUNTS];
 };
 
 extern struct user_namespace init_user_ns;
diff --git a/kernel/ucount.c b/kernel/ucount.c
index 11b1596e2542..04c561751af1 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -175,14 +175,14 @@ static void put_ucounts(struct ucounts *ucounts)
 	kfree(ucounts);
 }
 
-static inline bool atomic_inc_below(atomic_t *v, int u)
+static inline bool atomic_long_inc_below(atomic_long_t *v, int u)
 {
-	int c, old;
-	c = atomic_read(v);
+	long c, old;
+	c = atomic_long_read(v);
 	for (;;) {
 		if (unlikely(c >= u))
 			return false;
-		old = atomic_cmpxchg(v, c, c+1);
+		old = atomic_long_cmpxchg(v, c, c+1);
 		if (likely(old == c))
 			return true;
 		c = old;
@@ -196,17 +196,17 @@ struct ucounts *inc_ucount(struct user_namespace *ns, kuid_t uid,
 	struct user_namespace *tns;
 	ucounts = get_ucounts(ns, uid);
 	for (iter = ucounts; iter; iter = tns->ucounts) {
-		int max;
+		long max;
 		tns = iter->ns;
 		max = READ_ONCE(tns->ucount_max[type]);
-		if (!atomic_inc_below(&iter->ucount[type], max))
+		if (!atomic_long_inc_below(&iter->ucount[type], max))
 			goto fail;
 	}
 	return ucounts;
 fail:
 	bad = iter;
 	for (iter = ucounts; iter != bad; iter = iter->ns->ucounts)
-		atomic_dec(&iter->ucount[type]);
+		atomic_long_dec(&iter->ucount[type]);
 
 	put_ucounts(ucounts);
 	return NULL;
@@ -216,7 +216,7 @@ void dec_ucount(struct ucounts *ucounts, enum ucount_type type)
 {
 	struct ucounts *iter;
 	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
-		int dec = atomic_dec_if_positive(&iter->ucount[type]);
+		long dec = atomic_long_dec_if_positive(&iter->ucount[type]);
 		WARN_ON_ONCE(dec < 0);
 	}
 	put_ucounts(ucounts);
-- 
2.29.2

