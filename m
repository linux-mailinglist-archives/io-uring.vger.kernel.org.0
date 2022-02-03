Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E18F4A88EB
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 17:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352359AbiBCQpJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 11:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235795AbiBCQpH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 11:45:07 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36527C06173B
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 08:45:07 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id n8so2511927wmk.3
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 08:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GkmgjzPDmiTZDo4dS1/4itPIhM2CrOgkYLrZJY0fN5E=;
        b=WD3D6KgXTzr6asrsMV7sbcmqXABfIFtEhk4/9RhynJg7Qf6VydY6Xx6TdFfBw3BKc5
         gTRgT0Nv73YM8RUvFMwoB8my2lqGSZq1W3Ud1fOWI5ol9AxTqVsv0Mz5r0mXepo0g0Ic
         RwKz3nyxPvZS9yLWgOrJm/uZVykvZfHOUXyZ45mCR7nMv7kpaMD5VbgAxXR9qawmPd0O
         7iiBm+cOSkxf8rGmkhgIrwdaXHyz8+Xza1iw8gy7DVB6OjG3t9bs5FKyyN/XVh8RXJsC
         gxi5pzbHK8fItdoW2K0mfDBIiK4+NJ+PKbYT3hffKXuMMUg5QXhpIPnKfVEnyZr7yP1p
         rpaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GkmgjzPDmiTZDo4dS1/4itPIhM2CrOgkYLrZJY0fN5E=;
        b=Glh9MXvHchk2PG8neIufcKlR8eGKO4X0dTsU2ei6/I/p79xVmZpUH14R/Vy8S4q6cn
         ybu4pxLvchMo329BiqLEMP3ZLvmH0AibcE2P7jLLdrTdHgyT6UEGKIxocbHC2iDg/pip
         zbjaH3lS29qDcQnOGTvpYY8e2dg4TvXg0mlGUBzwwJ7cxvwzDDpe8r6q8a+W+m09Uahi
         7KuLC8/fidDsr3FoJ0w154nIZSyA4tmMRQ3LLixFBxRgupq1AInjxor5qcV2XFqAQHL+
         RBm9zTHmaVGBwhO9LNk+dzCsh6Urkpjw1oAWPqnfCZCSehC6SIyvBCI3SaQ6nzL4C9Xb
         0CtA==
X-Gm-Message-State: AOAM530o/YMwgLIzhleNpOlKIYI0fCSTqo/Ts8Ye36JscQbeWBjdYoC5
        gT/LfUiwqJeRvOCX8rg+iEnWF/O8/RJVAQ==
X-Google-Smtp-Source: ABdhPJzRvucaBMs/agf4AhjeTwO8qjVnaidyVzbGAqCj5AnqQuSlddxyiT9kAyh6Yaluujy7sUha1Q==
X-Received: by 2002:a7b:ce95:: with SMTP id q21mr11202942wmj.94.1643906705724;
        Thu, 03 Feb 2022 08:45:05 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6d:f804:0:28c2:5854:c832:e580])
        by smtp.gmail.com with ESMTPSA id n14sm21412831wri.80.2022.02.03.08.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 08:45:05 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v2 0/3] io_uring: avoid ring quiesce in io_uring_register for eventfd opcodes
Date:   Thu,  3 Feb 2022 16:45:00 +0000
Message-Id: <20220203164503.641574-1-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is done by creating a new RCU data structure (io_ev_fd) as part of
io_ring_ctx that holds the eventfd_ctx, with reads to the structure protected
by rcu_read_lock and writes (register/unregister calls) protected by a mutex.

With the above approach ring quiesce can be avoided which is much more
expensive then using RCU lock. On the system tested, io_uring_reigster with
IORING_REGISTER_EVENTFD takes less than 1ms with RCU lock, compared to 15ms
before with ring quiesce.

The first patch creates the RCU protected data structure and removes ring
quiesce for IORING_REGISTER_EVENTFD and IORING_UNREGISTER_EVENTFD.

The second patch builds on top of the first patch and removes ring quiesce
for IORING_REGISTER_EVENTFD_ASYNC.

---
v1->v2:
- Added patch to remove eventfd from tracepoint (Patch 1) (Jens Axboe)
- Made the code of io_should_trigger_evfd as part of io_eventfd_signal (Jens Axboe)

Usama Arif (3):
  io_uring: remove trace for eventfd
  io_uring: avoid ring quiesce while registering/unregistering eventfd
  io_uring: avoid ring quiesce for IORING_REGISTER_EVENTFD_ASYNC

 fs/io_uring.c                   | 124 ++++++++++++++++++++++----------
 include/trace/events/io_uring.h |  13 ++--
 2 files changed, 93 insertions(+), 44 deletions(-)

-- 
2.25.1

