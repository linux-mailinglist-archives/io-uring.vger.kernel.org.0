Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833E2679D81
	for <lists+io-uring@lfdr.de>; Tue, 24 Jan 2023 16:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234943AbjAXPa6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Jan 2023 10:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233939AbjAXPa5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Jan 2023 10:30:57 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998D11027B
        for <io-uring@vger.kernel.org>; Tue, 24 Jan 2023 07:30:56 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id k13so15124410plg.0
        for <io-uring@vger.kernel.org>; Tue, 24 Jan 2023 07:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dS3w2964782F3Sx+cMiPT7RDUOdL2Qr1g0a7zgvaPjI=;
        b=Q02o8jB4JhOGi0u5itUK0wN6WYc8xbhIYpAXwkBvp5R4bXz2VY3f5wJnU0rPgyCCGb
         lWHqKcHAuKsj4wEwEPU7YHkD9eP7vKe8ORtTqMM/817Kvq+hNmXRhWAKudczC94IAMqx
         egFr7PPeHZXHFlZIxtUu0qrqRB638pRMTf/A7TPC0wnkzsBDGsOBfH1hz9+8uNcD/O4I
         JbVl20upe6yYZzTl/IoDuK0Rsv1bUjrQ+eL3U5DWs/bGFYLKvFeZE/XN0rb04zVOnYk3
         c6B9kj9sGi5bQj6xRbNqkYUuby6jysAOjgX/JRgZtTz4tyopxpSk195nwf6wSCibRQRm
         +Hjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dS3w2964782F3Sx+cMiPT7RDUOdL2Qr1g0a7zgvaPjI=;
        b=LoqjsJ4+cOk59QoSpp1gHs287WpTO2SGllLQjl+a/Yo6aSAnW7gravqGHzCq0ekogX
         Gaz6n/BPF46QQmugKRrygXw6iBJQPC8H7uZhMmA7OjNtAc+2luIku0pvNnts7QZm2wSw
         53+ymAbORDhjZyeEhEplLkxW/2cVVN+b/EH7A4Zy2WgNOfGcm0aSA/eyqQCzf/KjAOt8
         rVaPnpAc0czvMCgKUfUpTdWN8ZPpmSH0BvV9sG963uS738xb24vgaP4GfIBJEqI/B7eg
         3r3Mt3ldr5nx8UIIMvE7uamSqrhnhMkbA8bdNtOcwOAip+FqtcDjlvK2PsDiOROjxwck
         Ahfw==
X-Gm-Message-State: AFqh2kp10V4iuRsQ9aJHbPkML5GVAqyJHq3TGtxPpfpQy7Zo40UlUYDY
        4uIgLDqm8psrQxgK0FlVceRf6g9VaJMPUiW9
X-Google-Smtp-Source: AMrXdXvSXQ4pEpk5l+C7SemInwREWcgVQvONp8ITLdnBUXXRxJpxtK5wkC4Hd/WEQfL9zHOjfRP8+g==
X-Received: by 2002:a17:902:848d:b0:189:f460:d24b with SMTP id c13-20020a170902848d00b00189f460d24bmr7114461plo.5.1674574255778;
        Tue, 24 Jan 2023 07:30:55 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jd6-20020a170903260600b0018958a913a2sm1793892plb.223.2023.01.24.07.30.55
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 07:30:55 -0800 (PST)
Message-ID: <be6fa09b-8a27-412b-52af-1cd3bc896ad4@kernel.dk>
Date:   Tue, 24 Jan 2023 08:30:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: handle TIF_NOTIFY_RESUME when checking for
 task_work
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If TIF_NOTIFY_RESUME is set, then we need to call resume_user_mode_work()
for PF_IO_WORKER threads. They never return to usermode, hence never get
a chance to process any items that are marked by this flag. Most notably
this includes the final put of files, but also any throttling markers set
by block cgroups.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index ab4b2a1c3b7e..e532dea68773 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -3,6 +3,7 @@
 
 #include <linux/errno.h>
 #include <linux/lockdep.h>
+#include <linux/resume_user_mode.h>
 #include <linux/io_uring_types.h>
 #include <uapi/linux/eventpoll.h>
 #include "io-wq.h"
@@ -270,6 +271,13 @@ static inline int io_run_task_work(void)
 	 */
 	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
 		clear_notify_signal();
+	/*
+	 * PF_IO_WORKER never returns to userspace, so check here if we have
+	 * notify work that needs processing.
+	 */
+	if (current->flags & PF_IO_WORKER &&
+	    test_thread_flag(TIF_NOTIFY_RESUME))
+		resume_user_mode_work(NULL);
 	if (task_work_pending(current)) {
 		__set_current_state(TASK_RUNNING);
 		task_work_run();

-- 
Jens Axboe

