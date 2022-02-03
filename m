Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31C94A8A4E
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 18:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352956AbiBCRlP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 12:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234927AbiBCRlO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 12:41:14 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E529EC06173B
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 09:41:13 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id l12-20020a7bc34c000000b003467c58cbdfso7710900wmj.2
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 09:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xd4DGUq9kw+BfMNHUHiY9oIyyvEkpc0zUEM7H44Lzxw=;
        b=0a8Wi66hKFd4gzwxxrTzgOyaolxmgnD5w8kDd5YSm7hJnlvkZ9e0k+TW3guNhdvgX8
         imhCo/OrBK1U8K5HlkHiqGxUQB5X0wg3ilb7xpQI+ZWICoQfF2qCJVhtmwS22eh4yB+p
         aQg2TQO6Wy4c6tLFkGqxTPyRXRbs+Vv/CChNaf5qy2xr2dOb+uICIzD8p3wiC7fDWP8X
         LOUwo5UuSer8fZw9+QN4mn8Tmyy5BnH1SJ4mK6RZvmr6Onfk0o3qyvMiGQdE/ysjH2+m
         kvcWfnxRW0Uk9EDLHPiVwpwib1zYRRWY9UE33peC8T/RtAx2kmmnVFyOefsGLt17rxjd
         ouWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xd4DGUq9kw+BfMNHUHiY9oIyyvEkpc0zUEM7H44Lzxw=;
        b=yBAm3Ehg5CDElvqgfEpupuGipqGK67F5yn5wNFGe3H9a+04kIzVsem/PaC8/IOCAoB
         QrjfaYw1YzTznQmyQe4aletsTPOvli3F9EtjFdySmFGyUkn49riLainq3khy+9rmnEJJ
         1uUNdKHQgJN12vCl+Lj7gBeBYQEJgcI8gmyBqoMGoziYzC1yIn7EI8xFfrzuSiDIaqo/
         kGF+/9otUZ7bTcykxDMfSqAtrpXXW/Y+yEJjSI5AtsuOjfS/blcaH/lXJPiQ3csLHrbz
         Ocg1UI4E8OPuuw4weDzG9oBrDSptiri6xqJcdPQlcUsF6OZ9ySnWoOZjjbdW2SyyXedq
         LoRA==
X-Gm-Message-State: AOAM5308E9YUA7R6zkTSRWPaRwcVO8PcXayULeuj8PdD2fKVzvk2VL7a
        gJDJQIDMiW8m/pGfkL+NZzgqwBryXRCl9w==
X-Google-Smtp-Source: ABdhPJzVT1OY/XzCqUg2UtiNztthnmGyprdElBBn0f8cMpgmct1ulBSwVBM9qhJwo/QKj3s/er6nVA==
X-Received: by 2002:a05:600c:348f:: with SMTP id a15mr11167648wmq.154.1643910072284;
        Thu, 03 Feb 2022 09:41:12 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6d:f804:0:28c2:5854:c832:e580])
        by smtp.gmail.com with ESMTPSA id r2sm10166178wmq.24.2022.02.03.09.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 09:41:11 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v3 0/3] io_uring: avoid ring quiesce in io_uring_register for eventfd opcodes
Date:   Thu,  3 Feb 2022 17:41:05 +0000
Message-Id: <20220203174108.668549-1-usama.arif@bytedance.com>
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
v2->v3:
- Switched to using synchronize_rcu from call_rcu in io_eventfd_unregister

v1->v2:
- Added patch to remove eventfd from tracepoint (Patch 1) (Jens Axboe)
- Made the code of io_should_trigger_evfd as part of io_eventfd_signal (Jens Axboe)

Usama Arif (3):
  io_uring: remove trace for eventfd
  io_uring: avoid ring quiesce while registering/unregistering eventfd
  io_uring: avoid ring quiesce for IORING_REGISTER_EVENTFD_ASYNC

 fs/io_uring.c                   | 114 ++++++++++++++++++++++----------
 include/trace/events/io_uring.h |  13 ++--
 2 files changed, 83 insertions(+), 44 deletions(-)

-- 
2.25.1

