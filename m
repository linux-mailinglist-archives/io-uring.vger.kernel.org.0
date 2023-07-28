Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AACF767220
	for <lists+io-uring@lfdr.de>; Fri, 28 Jul 2023 18:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjG1Qmu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Jul 2023 12:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbjG1Qmr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Jul 2023 12:42:47 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F9E1739
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 09:42:42 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id e9e14a558f8ab-34770dd0b4eso1764255ab.0
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 09:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690562562; x=1691167362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=30eD9fAtYTDVQhSBmDtrnQoUWRd4/P+cYE3Me4cIvhU=;
        b=DKvcWZja9ydTXsU5tYZC8ODhETIbn5KR9hRed/c2NdhL4yY3uygRbDb5dDpGPIZmNR
         BlNzu5WNQYhZkw7Vlb+FJoMxxXJp2Rs9l5K32ZlR+xTZxOdARQ2RlK7VCgor7RzgPYFL
         tBNfXpcdQakAIi1W+bqEbixou2yk9uRPNjHpe9XZhRAGRiB9SGwK6GhDpm1IAzvAp2SA
         /xrm5m8vmVTqcRlgSiq84QIj6f/DaB7sXCbDtCd/wccBuIU80cWHRxPzjuALtRcngYb3
         48Ut2CMMr0NQruQqc+pA4QQuKwIgyCIGJXIbowoUi0VKb4Pzgac8YwfH+U1niBycADs0
         eQpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690562562; x=1691167362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=30eD9fAtYTDVQhSBmDtrnQoUWRd4/P+cYE3Me4cIvhU=;
        b=a+YR+7CA0I1SWCpdiqZMjUBwWDqVGen+5iIwdrRlYPq0T40eLgOlfiZ/rb9AnDPFJy
         5mtdKPEjhekrvRsR89y6QVW8ajuXjdFeO/XEx1NiWSwas9pT56+pjxYmdTDbWGKDpg9e
         ZviMJbuUcoNFpMPuFqG1ydT/VOu9kIoxy+1vU/KI+lcBX6kDiCWkjVCFATjAGzt6C1ux
         qhGpxZQ5PzaSZDr+q/h9ClECUQWswzXLPoTyk05/Wl55Q5Ode1ZIJ9q2kD0Dd3sXsTCe
         hCO1QXa6x+9ksRxySYUSu0KrxyN8GP+EJQaQsHdYjwDG2NVDhpMXtK97qg5d9t/nl1dq
         z+Dg==
X-Gm-Message-State: ABy/qLbCnKOUOan6GT4yhCgBT2mfBoJCCPv6/peZRPF0nGeyIfud9lW2
        uN4BSF/PrHr2sCgQluIoyQMjYoWEfNcckIv8q48=
X-Google-Smtp-Source: APBJJlHzPyCbNiUtQSTRO/d4Nx6b6ON2V8yqilLfWxeJXRIzcggEvl1vz3AI6uFMkgsRxm/THoi2BQ==
X-Received: by 2002:a92:c64f:0:b0:346:10c5:2949 with SMTP id 15-20020a92c64f000000b0034610c52949mr66624ill.1.1690562561891;
        Fri, 28 Jul 2023 09:42:41 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b2-20020a029a02000000b0042b37dda71asm1158808jal.136.2023.07.28.09.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jul 2023 09:42:41 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/12] futex: Flag conversion
Date:   Fri, 28 Jul 2023 10:42:26 -0600
Message-Id: <20230728164235.1318118-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230728164235.1318118-1-axboe@kernel.dk>
References: <20230728164235.1318118-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Futex has 3 sets of flags:

 - legacy futex op bits
 - futex2 flags
 - internal flags

Add a few helpers to convert from the API flags into the internal
flags.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/futex/futex.h    | 64 +++++++++++++++++++++++++++++++++++++++--
 kernel/futex/syscalls.c | 24 ++++++----------
 kernel/futex/waitwake.c |  4 +--
 3 files changed, 72 insertions(+), 20 deletions(-)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index b5379c0e6d6d..c0e04599904a 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -5,6 +5,7 @@
 #include <linux/futex.h>
 #include <linux/rtmutex.h>
 #include <linux/sched/wake_q.h>
+#include <linux/compat.h>
 
 #ifdef CONFIG_PREEMPT_RT
 #include <linux/rcuwait.h>
@@ -16,8 +17,15 @@
  * Futex flags used to encode options to functions and preserve them across
  * restarts.
  */
+#define FLAGS_SIZE_8		0x00
+#define FLAGS_SIZE_16		0x01
+#define FLAGS_SIZE_32		0x02
+#define FLAGS_SIZE_64		0x03
+
+#define FLAGS_SIZE_MASK		0x03
+
 #ifdef CONFIG_MMU
-# define FLAGS_SHARED		0x01
+# define FLAGS_SHARED		0x10
 #else
 /*
  * NOMMU does not have per process address space. Let the compiler optimize
@@ -25,8 +33,58 @@
  */
 # define FLAGS_SHARED		0x00
 #endif
-#define FLAGS_CLOCKRT		0x02
-#define FLAGS_HAS_TIMEOUT	0x04
+#define FLAGS_CLOCKRT		0x20
+#define FLAGS_HAS_TIMEOUT	0x40
+#define FLAGS_NUMA		0x80
+
+/* FUTEX_ to FLAGS_ */
+static inline unsigned int futex_to_flags(unsigned int op)
+{
+	unsigned int flags = FLAGS_SIZE_32;
+
+	if (!(op & FUTEX_PRIVATE_FLAG))
+		flags |= FLAGS_SHARED;
+
+	if (op & FUTEX_CLOCK_REALTIME)
+		flags |= FLAGS_CLOCKRT;
+
+	return flags;
+}
+
+/* FUTEX2_ to FLAGS_ */
+static inline unsigned int futex2_to_flags(unsigned int flags2)
+{
+	unsigned int flags = flags2 & FUTEX2_64;
+
+	if (!(flags2 & FUTEX2_PRIVATE))
+		flags |= FLAGS_SHARED;
+
+	if (flags2 & FUTEX2_NUMA)
+		flags |= FLAGS_NUMA;
+
+	return flags;
+}
+
+static inline bool futex_flags_valid(unsigned int flags)
+{
+	/* Only 64bit futexes for 64bit code */
+	if (!IS_ENABLED(CONFIG_64BIT) || in_compat_syscall()) {
+		if ((flags & FLAGS_SIZE_MASK) == FLAGS_SIZE_64)
+			return false;
+	}
+
+	/* Only 32bit futexes are implemented -- for now */
+	if ((flags & FLAGS_SIZE_MASK) != FLAGS_SIZE_32)
+		return false;
+
+	return true;
+}
+
+static inline unsigned int futex_size(unsigned int flags)
+{
+	unsigned int size = flags & FLAGS_SIZE_MASK;
+	return 1 << size; /* {0,1,2,3} -> {1,2,4,8} */
+}
 
 #ifdef CONFIG_FAIL_FUTEX
 extern bool should_fail_futex(bool fshared);
diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index cfc8001e88ea..36824b64219a 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
-#include <linux/compat.h>
 #include <linux/syscalls.h>
 #include <linux/time_namespace.h>
 
@@ -85,15 +84,12 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
+	unsigned int flags = futex_to_flags(op);
 	int cmd = op & FUTEX_CMD_MASK;
-	unsigned int flags = 0;
 
-	if (!(op & FUTEX_PRIVATE_FLAG))
-		flags |= FLAGS_SHARED;
-
-	if (op & FUTEX_CLOCK_REALTIME) {
-		flags |= FLAGS_CLOCKRT;
-		if (cmd != FUTEX_WAIT_BITSET && cmd != FUTEX_WAIT_REQUEUE_PI &&
+	if (flags & FLAGS_CLOCKRT) {
+		if (cmd != FUTEX_WAIT_BITSET &&
+		    cmd != FUTEX_WAIT_REQUEUE_PI &&
 		    cmd != FUTEX_LOCK_PI2)
 			return -ENOSYS;
 	}
@@ -201,21 +197,19 @@ static int futex_parse_waitv(struct futex_vector *futexv,
 	unsigned int i;
 
 	for (i = 0; i < nr_futexes; i++) {
+		unsigned int flags;
+
 		if (copy_from_user(&aux, &uwaitv[i], sizeof(aux)))
 			return -EFAULT;
 
 		if ((aux.flags & ~FUTEX2_MASK) || aux.__reserved)
 			return -EINVAL;
 
-		if (!IS_ENABLED(CONFIG_64BIT) || in_compat_syscall()) {
-			if ((aux.flags & FUTEX2_64) == FUTEX2_64)
-				return -EINVAL;
-		}
-
-		if ((aux.flags & FUTEX2_64) != FUTEX2_32)
+		flags = futex2_to_flags(aux.flags);
+		if (!futex_flags_valid(flags))
 			return -EINVAL;
 
-		futexv[i].w.flags = aux.flags;
+		futexv[i].w.flags = flags;
 		futexv[i].w.val = aux.val;
 		futexv[i].w.uaddr = aux.uaddr;
 		futexv[i].q = futex_q_init;
diff --git a/kernel/futex/waitwake.c b/kernel/futex/waitwake.c
index ba01b9408203..fa9757766103 100644
--- a/kernel/futex/waitwake.c
+++ b/kernel/futex/waitwake.c
@@ -419,11 +419,11 @@ static int futex_wait_multiple_setup(struct futex_vector *vs, int count, int *wo
 	 */
 retry:
 	for (i = 0; i < count; i++) {
-		if ((vs[i].w.flags & FUTEX_PRIVATE_FLAG) && retry)
+		if (!(vs[i].w.flags & FLAGS_SHARED) && retry)
 			continue;
 
 		ret = get_futex_key(u64_to_user_ptr(vs[i].w.uaddr),
-				    !(vs[i].w.flags & FUTEX_PRIVATE_FLAG),
+				    vs[i].w.flags & FLAGS_SHARED,
 				    &vs[i].q.key, FUTEX_READ);
 
 		if (unlikely(ret))
-- 
2.40.1

