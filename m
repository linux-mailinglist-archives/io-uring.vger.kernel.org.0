Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406DC75BA66
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 00:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjGTWTM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 18:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjGTWTL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 18:19:11 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8B7196
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:19:10 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-66d6a9851f3so268789b3a.0
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689891549; x=1690496349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mj8xxKFWXxw8N/3XRbYC3t5/jp7h6u5L88bvfUimjEA=;
        b=t49oUdZQpzZOWC6YASaylQyj1E+7dckMY+ViXFRmwuXlsxfKJ1UL7l/xy1/Gz6hBqf
         sCD6tUbYwBMpOBab9sksENGyPQy10Gmc1a/j+Une2Yv6YWAgVbW4b7wkmTDM6vxswKRA
         d4rvpIkfcplm/ubVbOfgv9cBS+AC0B+X51hH7LLRSa2RsL+VrV2KyMT+2o4FxcwjCDXP
         J4plY1AD93F9nSP2wROZpGvvIr5tU79MAHRic4MbRFfQolPIfKStbIoGzeNyoHaOf64T
         58xjsqNLG1yOR7ELrj6/pJ9O09YHy9PzdLGt/VYO62LIlLPGcXAxfeZzTQLBncPDf+y8
         OCWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689891549; x=1690496349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mj8xxKFWXxw8N/3XRbYC3t5/jp7h6u5L88bvfUimjEA=;
        b=lSUfDsXYelrMnaHTINRouoBGzbYLHieJZ39+XiJml46JF5W+8pRlMYbeq/aMywPlwR
         MZiMIXwlXD8KI1cazIdQowPTTZb+RmnsbeAZRMXXzuV6e/RwbX57+4cqIod+tEfrUxzr
         uJIjJUlBffT/KKQW6AdMabvdomGSWi4Te9TRyjUfxtnySnp4PhBb7bdeDj6+cF7NrAUv
         j7jlclClRIJnp+7vDTh7LD/9L/xlUDNNHrEG2LCq4F1zUNk2AvdEBdKXh9CkCJ8Fd3nn
         wSwD0a70uKJDr9TmLu14ZX0w+Gtxs4DE4WlO+kl7tkqONFf4EaPHWSTakaIKVwW8ti6S
         niZQ==
X-Gm-Message-State: ABy/qLYibTQWnUFO+XBTe5fYmS9/ugOdtzVDZD7CbHONJNp6bpHQ0cZ8
        Emljm1l0X4z0KpjGTVf1SFGx+wVyV6Pd/WP2Ev0=
X-Google-Smtp-Source: APBJJlHH/Ok6khMThnLocbLVqHQORlSG746cDoy+APeVjbFC2xpZMlWAhQX/1As3PXTSZgKRXu4/zA==
X-Received: by 2002:a05:6a00:1807:b0:67f:ff0a:1bbb with SMTP id y7-20020a056a00180700b0067fff0a1bbbmr191762pfa.1.1689891549357;
        Thu, 20 Jul 2023 15:19:09 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q1-20020a63bc01000000b0055b3af821d5sm1762454pge.25.2023.07.20.15.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 15:19:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/10] futex: Extend the FUTEX2 flags
Date:   Thu, 20 Jul 2023 16:18:50 -0600
Message-Id: <20230720221858.135240-3-axboe@kernel.dk>
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

Add the definition for the missing but always intended extra sizes,
and add a NUMA flag for the planned numa extention.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/futex.h | 7 ++++---
 kernel/futex/syscalls.c    | 4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/futex.h b/include/uapi/linux/futex.h
index 0c5abb6aa8f8..0ed021acc1d9 100644
--- a/include/uapi/linux/futex.h
+++ b/include/uapi/linux/futex.h
@@ -46,10 +46,11 @@
 /*
  * Flags for futex2 syscalls.
  */
-			/*	0x00 */
-			/*	0x01 */
+#define FUTEX2_8		0x00
+#define FUTEX2_16		0x01
 #define FUTEX2_32		0x02
-			/*	0x04 */
+#define FUTEX2_64		0x03
+#define FUTEX2_NUMA		0x04
 			/*	0x08 */
 			/*	0x10 */
 			/*	0x20 */
diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index 42b6c2fac7db..d5bb6dad22fe 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -183,7 +183,7 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 	return do_futex(uaddr, op, val, tp, uaddr2, (unsigned long)utime, val3);
 }
 
-#define FUTEX2_MASK (FUTEX2_32 | FUTEX2_PRIVATE)
+#define FUTEX2_MASK (FUTEX2_64 | FUTEX2_PRIVATE)
 
 /**
  * futex_parse_waitv - Parse a waitv array from userspace
@@ -207,7 +207,7 @@ static int futex_parse_waitv(struct futex_vector *futexv,
 		if ((aux.flags & ~FUTEX2_MASK) || aux.__reserved)
 			return -EINVAL;
 
-		if (!(aux.flags & FUTEX2_32))
+		if ((aux.flags & FUTEX2_64) != FUTEX2_32)
 			return -EINVAL;
 
 		futexv[i].w.flags = aux.flags;
-- 
2.40.1

