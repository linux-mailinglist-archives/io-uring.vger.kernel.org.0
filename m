Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75B675BA68
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 00:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjGTWTN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 18:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjGTWTM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 18:19:12 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213C5110
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:19:12 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-682a5465e9eso264736b3a.1
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689891551; x=1690496351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=42VaD870OeDvxzIrHEo8+GOUntGBOgUhMszqKfQUcYA=;
        b=aRp2lyGJ9rCt8dC0Zs9t7I6/p/fey50e1NP4ZRNKHfd7HYSRv7PedoR4ShT2zbBLHF
         HgXnL1Q0MyE4L5xI6izlKFnypZThHMdOZUBw8g+8q/z4GKvqUP2Bc+ETo8L/mmnuGPCA
         NOyuA7NMBtD9hPDx8k+aGTerFKPerF0nDG9tnyaJeY3xxJl8rWyZHdePIXirLQdCSfb7
         IGkyla4MxeaihKNq19CPpXMhMAFTBuYhSVdO39tTJKw4tt1CSoWCJKi1QsNoZfv+0PaH
         E6EXS6iS/5tw0sJ5N3ZIS49DR/yfjO2BHA3bBJ6+jcAfnptBLh95h0WnBXNR1I8R7ONy
         kkMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689891551; x=1690496351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=42VaD870OeDvxzIrHEo8+GOUntGBOgUhMszqKfQUcYA=;
        b=DHORJBtepj4upjttOvdWInin2I0pbxK8gJUYYUooAxGHLS9Sv2HW29EEgBon67uF7T
         PFmTrO1pl4Yz5mSoqqo3WheA6sbdoiXjeZc1R3sfthFKGKCMiPQKFW6GtzRGqHb6CM+N
         xiOfSLuehdAeDoIrTXOm7Kzb4WKpyhZjjq596828v+TrTVHhZyws8HGhe8+Tw7tvnmLG
         fx2RgovMb5Z/uBkRYyWabjOn+3tTYBaFwie2TK0LJnNK1hmWuXJmfwqLKukDiD9HOUC7
         LpbZMKExExWk0p7wlvan8Raf9tLBlCyCL4PWfa/WYMT6IV4wWuLNuCtawPFLU5D/+tQa
         +NvQ==
X-Gm-Message-State: ABy/qLY4a2MR3PCvr3YiIlM3TaHXCUxR5a3bFFKiyhBz2+8IZOIBs5D4
        xE9qdgw3M6QxawCm7i3rQaPvihvu0Ww/8bEeoOQ=
X-Google-Smtp-Source: APBJJlGQbbA44tc8PP7+BeAbRXR4aaPtZk5MRld32V9dcrd1UaPCyDgN6xO+L62ThkCbhvkZCTnNXA==
X-Received: by 2002:a05:6a20:42a8:b0:123:3ec2:360d with SMTP id o40-20020a056a2042a800b001233ec2360dmr205014pzj.5.1689891550897;
        Thu, 20 Jul 2023 15:19:10 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q1-20020a63bc01000000b0055b3af821d5sm1762454pge.25.2023.07.20.15.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 15:19:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/10] futex: Flag conversion
Date:   Thu, 20 Jul 2023 16:18:51 -0600
Message-Id: <20230720221858.135240-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230720221858.135240-1-axboe@kernel.dk>
References: <20230720221858.135240-1-axboe@kernel.dk>
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
 kernel/futex/futex.h    | 48 ++++++++++++++++++++++++++++++++++++++---
 kernel/futex/syscalls.c | 21 +++++++++++-------
 kernel/futex/waitwake.c |  4 ++--
 3 files changed, 60 insertions(+), 13 deletions(-)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index b5379c0e6d6d..54f4470b7db8 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -16,8 +16,15 @@
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
@@ -25,8 +32,43 @@
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
+static inline unsigned int futex_size(unsigned int flags)
+{
+	unsigned int size = flags & FLAGS_SIZE_MASK;
+	return 1 << size; /* {0,1,2,3} -> {1,2,4,8} */
+}
 
 #ifdef CONFIG_FAIL_FUTEX
 extern bool should_fail_futex(bool fshared);
diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index d5bb6dad22fe..7234538a490d 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -85,15 +85,12 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
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
@@ -201,6 +198,8 @@ static int futex_parse_waitv(struct futex_vector *futexv,
 	unsigned int i;
 
 	for (i = 0; i < nr_futexes; i++) {
+		unsigned int bits, flags;
+
 		if (copy_from_user(&aux, &uwaitv[i], sizeof(aux)))
 			return -EFAULT;
 
@@ -210,7 +209,13 @@ static int futex_parse_waitv(struct futex_vector *futexv,
 		if ((aux.flags & FUTEX2_64) != FUTEX2_32)
 			return -EINVAL;
 
-		futexv[i].w.flags = aux.flags;
+		flags = futex2_to_flags(aux.flags);
+		bits = 8 * futex_size(flags);
+
+		if (bits < 64 && aux.val >> bits)
+			return -EINVAL;
+
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

