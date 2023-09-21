Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB277A9E03
	for <lists+io-uring@lfdr.de>; Thu, 21 Sep 2023 21:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjIUTxY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Sep 2023 15:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjIUTxH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Sep 2023 15:53:07 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07214D7DB0
        for <io-uring@vger.kernel.org>; Thu, 21 Sep 2023 11:29:16 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id ca18e2360f4ac-760dff4b701so17914539f.0
        for <io-uring@vger.kernel.org>; Thu, 21 Sep 2023 11:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695320955; x=1695925755; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wwcbO19kHoooGXVXpd3ZWHbtBSLBsnmpj+7juMc3wkU=;
        b=3PZrgb1nRUzH+q34WXjmHZtiDYbauRH6ZureE/sLaQKEcv8oVAXwj1eWrHEhRvjm1h
         9d+JC16iwfuIoilg/Yr118CqhDgJ3UPADorZJFI2Wgc4ggtUzRxFBvfaLh4pFBAPz7DD
         y6cOLDNAtnFpbpjtuArdh5ZZwukRny0qkl+xlZODxqowZHqYb1FvYNzKDgYfQ/NrqVUM
         y7x7RJ9d1UM62rcDjPYri4+4azKb3znmMxJDNlLMe6pkHe0EKksZRODiCJiBEwRCZKfx
         /X9rNKLAFdx1sqZOhUnmlJVBCkleJzXdSmOHiKHacWG/Z2yXt2gSJjz3XE318ySbMDxD
         jxtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695320955; x=1695925755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wwcbO19kHoooGXVXpd3ZWHbtBSLBsnmpj+7juMc3wkU=;
        b=U6YVgsaZsvuKHH5qIYHS5MenMeGu2FVbak3hgBZEXJB6GhJt/eTeFFq60UWzSuzyD2
         u7PXCOH9Gk2a0XhfGyi4F6H3x2CsZpQX1fFHDBs2Zx0KoK7rEqUoBkVipvX6AtYGDQaD
         PCjF0aZS1dG05Z14+Sb+HIqoGIBk4roEuO9rrFJIjEOL5A3yKAH/P7CXWB297ID0qsc6
         JxhsjArIRrY1+YlEy9IsauatS4sUfJHyaD1Jm/RuxV/GnKxLSwqOQzcMy9gdq6kc1gHr
         IQ58yFZy/0uyX7IM2EyAYiitmye+aBn1kikymIG6k6QdWA9g7qpohdU4RdTO5nVC5yhE
         o3Hg==
X-Gm-Message-State: AOJu0YyxAnU1dT18ERmWM0h5qWMryvJGqhe91SFKvsQRXK10cqFGKcyf
        g5X0DahwXnMXjwCbjaa1okMQeSgRToQudYoVrgu51g==
X-Google-Smtp-Source: AGHT+IGHwyaEomy/zYb0m5iH1+xev/kGc2neOyBfwfCE6efVjwCyU3nluV/6eZCqeHaJ1+RHGRHC6A==
X-Received: by 2002:a05:6602:2c0a:b0:790:958e:a667 with SMTP id w10-20020a0566022c0a00b00790958ea667mr8177590iov.2.1695320954925;
        Thu, 21 Sep 2023 11:29:14 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o25-20020a02c6b9000000b0042b227eb1ddsm500441jan.55.2023.09.21.11.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 11:29:13 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/8] futex: move FUTEX2_VALID_MASK to futex.h
Date:   Thu, 21 Sep 2023 12:29:01 -0600
Message-Id: <20230921182908.160080-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230921182908.160080-1-axboe@kernel.dk>
References: <20230921182908.160080-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index a06030a1a27b..a173a9d501e1 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -52,6 +52,8 @@ static inline unsigned int futex_to_flags(unsigned int op)
 	return flags;
 }
 
+#define FUTEX2_VALID_MASK (FUTEX2_SIZE_MASK | FUTEX2_PRIVATE)
+
 /* FUTEX2_ to FLAGS_ */
 static inline unsigned int futex2_to_flags(unsigned int flags2)
 {
diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
index 8200d86d30e1..2b5cafdfdc50 100644
--- a/kernel/futex/syscalls.c
+++ b/kernel/futex/syscalls.c
@@ -179,8 +179,6 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 	return do_futex(uaddr, op, val, tp, uaddr2, (unsigned long)utime, val3);
 }
 
-#define FUTEX2_VALID_MASK (FUTEX2_SIZE_MASK | FUTEX2_PRIVATE)
-
 /**
  * futex_parse_waitv - Parse a waitv array from userspace
  * @futexv:	Kernel side list of waiters to be filled
-- 
2.40.1

