Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6A8349E25
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 01:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhCZAlR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 20:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbhCZAkr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 20:40:47 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF57C061761
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 17:40:47 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id v8so74762plz.10
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 17:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u31N5Wr92UrFihPVzfkVhThkgUf8nV6eK/V9ieSsv2s=;
        b=W8MjlAynV2PBwCxaVG1EzhkOH8TEqd+g9rkxajjr7j0TWk9FOdMAcKQEyT4F9Z5ij3
         ++XkBhY7GQUZXY2cOHUoW7FldybK4vJhbwo3YPIWNb4G3lWiVIrCq8sxh6c0HGY55LcF
         4s+Lu/Mjon51sfo0NSkddEvHt+Vi6+cx3oM/spENBEHII5sdMNj44dJY78cYXYvbygfQ
         4koToRAxKyUGLuf0xa/rdZl2+o2oSInjRE6ZyUQH98Tg3j4U3zmNEPn2jCH1Eh1AZ/6v
         30afjrJRawb3Asem0+wYTZKp8DUaDH9Ai/3iQY0mG9TY5XA0wPpel6iFCt5HbY7Upx9x
         isKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u31N5Wr92UrFihPVzfkVhThkgUf8nV6eK/V9ieSsv2s=;
        b=FekE+mG9NrHQnp6knysGNEJa3bCwbHUXEdfY2RbvxX66ZSsKxL+9+YZLQL0gA/w+2i
         G4QWinXvsA+CvKgEW8Jze4E1rYfPDlOgqHoOD6jXLRWdFahj8/nTj3EfjQOtTgNQMv5c
         aq3FDDedQaCanfQtWoGS1S6BeNQX3neIkWXbSpOgxcVy07OsxTTpwokKUwVDvBrN0AEs
         MHcHQWd61UgtfMBJIZRstyj6XGOSSm8HDJ5O90TSzBwmrAf7CliK/gR4g4xDtji9cmRS
         6WPvzq32zaf/5qPbDnBMceFFNQ8o6c+bFHXD6iuCJsgXEGxbQbWYmmBaaqg/yxqeLyKg
         FQzA==
X-Gm-Message-State: AOAM530lIlcXVcPBxHmssqEMxnsn0C2jlKUGEkWBRk3iQ3zVyZb/7ZUM
        3PxLO7MTep9dbarIMfjuZzE5iEEq0b7PfA==
X-Google-Smtp-Source: ABdhPJy7vsfJNBLwHgnzRH31OPsdSQtbR59v+kNYslmRYkcdcU9HoQTNxWJwhyLRSDeDb8ZODZmh6A==
X-Received: by 2002:a17:90a:bc06:: with SMTP id w6mr10859453pjr.44.1616719246498;
        Thu, 25 Mar 2021 17:40:46 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c128sm6899448pfc.76.2021.03.25.17.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 17:40:46 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/8] io_uring: handle signals for IO threads like a normal thread
Date:   Thu, 25 Mar 2021 18:39:24 -0600
Message-Id: <20210326003928.978750-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326003928.978750-1-axboe@kernel.dk>
References: <20210326003928.978750-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We go through various hoops to disallow signals for the IO threads, but
there's really no reason why we cannot just allow them. The IO threads
never return to userspace like a normal thread, and hence don't go through
normal signal processing. Instead, just check for a pending signal as part
of the work loop, and call get_signal() to handle it for us if anything
is pending.

With that, we can support receiving signals, including special ones like
SIGSTOP.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c    | 21 +++++++++++++++++----
 fs/io_uring.c | 10 ++++++++--
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index b7c1fa932cb3..2dbdc552f3ba 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -505,8 +505,14 @@ static int io_wqe_worker(void *data)
 		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
 		if (try_to_freeze() || ret)
 			continue;
-		if (fatal_signal_pending(current))
-			break;
+		if (signal_pending(current)) {
+			struct ksignal ksig;
+
+			if (fatal_signal_pending(current))
+				break;
+			get_signal(&ksig);
+			continue;
+		}
 		/* timed out, exit unless we're the fixed worker */
 		if (test_bit(IO_WQ_BIT_EXIT, &wq->state) ||
 		    !(worker->flags & IO_WORKER_F_FIXED))
@@ -715,8 +721,15 @@ static int io_wq_manager(void *data)
 		io_wq_check_workers(wq);
 		schedule_timeout(HZ);
 		try_to_freeze();
-		if (fatal_signal_pending(current))
-			set_bit(IO_WQ_BIT_EXIT, &wq->state);
+		if (signal_pending(current)) {
+			struct ksignal ksig;
+
+			if (fatal_signal_pending(current))
+				set_bit(IO_WQ_BIT_EXIT, &wq->state);
+			else
+				get_signal(&ksig);
+			continue;
+		}
 	} while (!test_bit(IO_WQ_BIT_EXIT, &wq->state));
 
 	io_wq_check_workers(wq);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 54ea561db4a5..3a9d021db328 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6765,8 +6765,14 @@ static int io_sq_thread(void *data)
 			timeout = jiffies + sqd->sq_thread_idle;
 			continue;
 		}
-		if (fatal_signal_pending(current))
-			break;
+		if (signal_pending(current)) {
+			struct ksignal ksig;
+
+			if (fatal_signal_pending(current))
+				break;
+			get_signal(&ksig);
+			continue;
+		}
 		sqt_spin = false;
 		cap_entries = !list_is_singular(&sqd->ctx_list);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
-- 
2.31.0

