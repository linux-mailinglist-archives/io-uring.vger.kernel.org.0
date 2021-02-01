Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3B330A992
	for <lists+io-uring@lfdr.de>; Mon,  1 Feb 2021 15:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhBAOWP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 09:22:15 -0500
Received: from raptor.unsafe.ru ([5.9.43.93]:49612 "EHLO raptor.unsafe.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232625AbhBAOVo (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 1 Feb 2021 09:21:44 -0500
Received: from comp-core-i7-2640m-0182e6.redhat.com (ip-94-112-41-137.net.upcbroadband.cz [94.112.41.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by raptor.unsafe.ru (Postfix) with ESMTPSA id E67A220A18;
        Mon,  1 Feb 2021 14:20:56 +0000 (UTC)
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
Subject: [PATCH v5 1/7] Increase size of ucounts to atomic_long_t
Date:   Mon,  1 Feb 2021 15:18:29 +0100
Message-Id: <0158da9809bc24f03f4f2bf11c8a9b0b2a1aa723.1612188590.git.gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1612188590.git.gladkov.alexey@gmail.com>
References: <cover.1612188590.git.gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Mon, 01 Feb 2021 14:21:00 +0000 (UTC)
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

