Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29CB4767225
	for <lists+io-uring@lfdr.de>; Fri, 28 Jul 2023 18:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbjG1Qmz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Jul 2023 12:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbjG1Qmt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Jul 2023 12:42:49 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8BD3C22
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 09:42:44 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-7835bbeb6a0so33276939f.0
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 09:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690562563; x=1691167363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YUJiOK1ym7lvCvvQLvWy2I//CZyKSdCVkDmBm3xzfUg=;
        b=2uarFxq6l4LF0iYUmrIR5R6ld0C1sNTQloeFP9NZniGqCpXDfNqN4kdzp/v9lF71rn
         Cc6pIudy/N5dwUpMAUkOrYWVqlv5x8QGrmAVBfLP4bCrWLEZVk2Ci8dtsp5QhN5QIX86
         KvfKq8uqWqElwGg917IDsdSfuAOPtp6iab9ti6lD3ZYupxuX5lFMNcz7xrz0pH43pMLt
         0aLjkSR1CxXmgDjVh95jyJJApBy5x4LCsyMIOZJr6VC9HFTSt+0s+fsD05lHJAPm/InS
         RDEN0jkwXwiMajW+0Z2mpJdFp7yFOrBrGq+R5UaUQAxORXizXlLHqnTGnis+lHa0keSb
         FD0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690562563; x=1691167363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YUJiOK1ym7lvCvvQLvWy2I//CZyKSdCVkDmBm3xzfUg=;
        b=Hph15nKpILbIj7WkMT0N7pwq++XPgeaAZgdWde0CZO07SoOeZ98JXpaM63ZkQWsawI
         YoZM/vZFPdziE4BLROsF0aedVEpUbH3Yls7r6azzhikZ1cOe0yF2dpwBKmOf5X4xllwy
         Pe1xFNrlBbI0w3l4gj5G2P7pnOF/UjVKbQWbzRDP7VaMsf7TSz2cYGYj4w5pP67w8lk4
         0TS1JAk9oCKv9CXSWmYWgkAUmArwv109JRmDkANEU3JrMWVFakm1tlZczI0fNiRFnRQ4
         urZ0Qnm/XxWTp2ncfwphfhVYxbImnQ2jL6GbyJ9ShC/jduGqazqDCnLtG/Di82IJuutn
         P0+Q==
X-Gm-Message-State: ABy/qLYCKKoGnPerJaKgETkTlyx+QPGuroX6FN6oMhgyDdMCUTi+Ioc7
        9vNiuiUaiZ4bcmy3q0Q/tqF9sjmv1JkwCNmgX7E=
X-Google-Smtp-Source: APBJJlE88bgunU1WjkIMMX4CA1hQsAfuvNstXEByPL7kx/sEII7LwtjlzTa4DLb/i/AzmM+CuAmCvQ==
X-Received: by 2002:a6b:c30f:0:b0:783:6e76:6bc7 with SMTP id t15-20020a6bc30f000000b007836e766bc7mr60982iof.2.1690562563452;
        Fri, 28 Jul 2023 09:42:43 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b2-20020a029a02000000b0042b37dda71asm1158808jal.136.2023.07.28.09.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jul 2023 09:42:43 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/12] futex: move FUTEX2_MASK to futex.h
Date:   Fri, 28 Jul 2023 10:42:28 -0600
Message-Id: <20230728164235.1318118-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230728164235.1318118-1-axboe@kernel.dk>
References: <20230728164235.1318118-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We need this for validating the futex2 flags outside of the normal
futex syscalls.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/futex/futex.h    | 2 ++
 kernel/futex/syscalls.c | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index d0a43d751e30..2f8deaabc9bc 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -51,6 +51,8 @@ static inline unsigned int futex_to_flags(unsigned int op)
 	return flags;
 }
 
+#define FUTEX2_MASK (FUTEX2_64 | FUTEX2_PRIVATE)
+
 /* FUTEX2_ to FLAGS_ */
 static inline unsigned int futex2_to_flags(unsigned int flags2)
 {
diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index d2b2bcf2a665..221c49797de9 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -179,8 +179,6 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 	return do_futex(uaddr, op, val, tp, uaddr2, (unsigned long)utime, val3);
 }
 
-#define FUTEX2_MASK (FUTEX2_64 | FUTEX2_PRIVATE)
-
 /**
  * futex_parse_waitv - Parse a waitv array from userspace
  * @futexv:	Kernel side list of waiters to be filled
-- 
2.40.1

