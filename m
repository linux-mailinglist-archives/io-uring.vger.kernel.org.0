Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDD875BA65
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 00:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjGTWTL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 18:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjGTWTK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 18:19:10 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150BE196
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:19:09 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-682a5465e9eso264721b3a.1
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 15:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689891548; x=1690496348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qfXIoWZOPMTUuZ51sHKPtDeshXixERaT1oNJnhO0ex0=;
        b=WOL067osaUVD2WGIgkXdT50lTOWUWIgvc4AEqkDscXJLFPBMT0ONp5BBak35zLctZZ
         AMZnsNVfpx8/08fVLo9HjESlx+fL3eg5vh135rKOTWXQyoqVRxwQag9lzCve0IJR+XFl
         CjPCfU3Bly9kThOZi5HS+8criRD6s8AlmuoTpjK+BT/BgDgU+WFx66UXFOob1Lebb7Gi
         K75u9i9VpneJ0NC6/5n4gD4z84Kpu0FHcaY+56XRjjmCE2bYfqVG2RuYXd3m9QA47+oj
         mGBGlTqOKvANBl6jQBINEwv53cFjn14pfgR5YxoEQ0T9KKKTelIe/ggkoaoFs1qS0iD2
         inOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689891548; x=1690496348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qfXIoWZOPMTUuZ51sHKPtDeshXixERaT1oNJnhO0ex0=;
        b=Of16SwP+rorqMxRlcsvsHImcirjU421f+y6+8+SLoW5HsSAigi2DM8ygpq6l2WlhHg
         ZaFWeszp7phraiKsKejkvPCton/Rc+NlLPevWEdjscarr9ieRLJzzV8KDvFyvQI+6B6T
         sRVg5V7hI2trxX7e7Q2MhPnF61pJQ5uDYk+JCEpOJaMSz7VVXm1G+o0Ug7F3iLjlrANr
         +x+Z3cVNjn931wO+dKCojEcOVDp6cucFxEs6uGJSBeyJYKD+s6VVGT0HvQ9PNrtKkLVX
         x8aQPXHY+HwbHq8Mm4Yih/3oZz/DL/+Tr8q1EbDI+iTy5Mj5zKkpEmEY0HKBe6doTRhv
         7CNw==
X-Gm-Message-State: ABy/qLaWhzEekkl3slZQsWa5olJyQn41FmU7zkl9b+CFTnW4zBO/XvHL
        jGD9mdoQF6Qa8usmDB3oeIVmR6Uwx8//XgH6vro=
X-Google-Smtp-Source: APBJJlHNoXWkTaeiFsQJURdZN83WfpPtpj9P4/mBIuHx8U5G8nUY5PwY02lmoCqavwUbnSiNbkA2Lw==
X-Received: by 2002:a05:6a20:42a8:b0:123:3ec2:360d with SMTP id o40-20020a056a2042a800b001233ec2360dmr204903pzj.5.1689891548133;
        Thu, 20 Jul 2023 15:19:08 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q1-20020a63bc01000000b0055b3af821d5sm1762454pge.25.2023.07.20.15.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 15:19:07 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/10] futex: Clarify FUTEX2 flags
Date:   Thu, 20 Jul 2023 16:18:49 -0600
Message-Id: <20230720221858.135240-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230720221858.135240-1-axboe@kernel.dk>
References: <20230720221858.135240-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

sys_futex_waitv() is part of the futex2 series (the first and only so
far) of syscalls and has a flags field per futex (as opposed to flags
being encoded in the futex op).

This new flags field has a new namespace, which unfortunately isn't
super explicit. Notably it currently takes FUTEX_32 and
FUTEX_PRIVATE_FLAG.

Introduce the FUTEX2 namespace to clarify this

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/futex.h | 16 +++++++++++++---
 kernel/futex/syscalls.c    |  7 +++----
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/futex.h b/include/uapi/linux/futex.h
index 71a5df8d2689..0c5abb6aa8f8 100644
--- a/include/uapi/linux/futex.h
+++ b/include/uapi/linux/futex.h
@@ -44,10 +44,20 @@
 					 FUTEX_PRIVATE_FLAG)
 
 /*
- * Flags to specify the bit length of the futex word for futex2 syscalls.
- * Currently, only 32 is supported.
+ * Flags for futex2 syscalls.
  */
-#define FUTEX_32		2
+			/*	0x00 */
+			/*	0x01 */
+#define FUTEX2_32		0x02
+			/*	0x04 */
+			/*	0x08 */
+			/*	0x10 */
+			/*	0x20 */
+			/*	0x40 */
+#define FUTEX2_PRIVATE		FUTEX_PRIVATE_FLAG
+
+/* do not use */
+#define FUTEX_32		FUTEX2_32 /* historical accident :-( */
 
 /*
  * Max numbers of elements in a futex_waitv array
diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index a8074079b09e..42b6c2fac7db 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -183,8 +183,7 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 	return do_futex(uaddr, op, val, tp, uaddr2, (unsigned long)utime, val3);
 }
 
-/* Mask of available flags for each futex in futex_waitv list */
-#define FUTEXV_WAITER_MASK (FUTEX_32 | FUTEX_PRIVATE_FLAG)
+#define FUTEX2_MASK (FUTEX2_32 | FUTEX2_PRIVATE)
 
 /**
  * futex_parse_waitv - Parse a waitv array from userspace
@@ -205,10 +204,10 @@ static int futex_parse_waitv(struct futex_vector *futexv,
 		if (copy_from_user(&aux, &uwaitv[i], sizeof(aux)))
 			return -EFAULT;
 
-		if ((aux.flags & ~FUTEXV_WAITER_MASK) || aux.__reserved)
+		if ((aux.flags & ~FUTEX2_MASK) || aux.__reserved)
 			return -EINVAL;
 
-		if (!(aux.flags & FUTEX_32))
+		if (!(aux.flags & FUTEX2_32))
 			return -EINVAL;
 
 		futexv[i].w.flags = aux.flags;
-- 
2.40.1

