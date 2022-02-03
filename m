Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBA84A912F
	for <lists+io-uring@lfdr.de>; Fri,  4 Feb 2022 00:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355962AbiBCXen (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 18:34:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355781AbiBCXen (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 18:34:43 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B335C06173B
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 15:34:43 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id j16so7973372wrd.8
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 15:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jg2HQIwBrRe3o77m7am+d1x3dh2EVdYu2F2MEWZU1To=;
        b=oxpxJKZmkfxOsupANpn/hBsE8u2+0gQLCxhBzZHrrHvJp5zvPWw9Y+2g08Z2QUzigM
         hS7hQ+QlZpNBVXviMyMJaGLRq6Wkddyg517Yg61DM06iUmQaie4GcGE/Kzwv4U1MQ7uO
         XILqwqUGj/0f40BCqnjUrDvKFBvaNzlVemnlyYvVU9J/mqewsneqwcb4fmQzjl98FjVS
         KgKoQ4LDKstNTpt2uV36BKBQxQgAG3+byrB2sTu4kRVikoeoxQZZzHZe+dTypKOZOKpp
         X0uyMbqaR2xvDlCz9SXwAyqIC7k9UzOcnFXo/07HKqAUz0B2uIuATJwMkyf2+9W8ze+z
         Fmgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jg2HQIwBrRe3o77m7am+d1x3dh2EVdYu2F2MEWZU1To=;
        b=MQkmv4zjeIRpGtWmxd3FqVs/87WqDyQXrfDW75qxWLYXF92aa9mVpUpBiD0SGykXBO
         UV6GHJl8UTLeh9w2dSLi9n5j+Y9kwYVg5PP417g9XfYvU7pVWQxKh1eBF/l0OVvU8gXK
         9VF4GVFcavxUF9PIq8KyAaouFuMkPLxBe2O0/HaqUFVwGBzlZiKZmC2WOVuBmj+hgjQU
         Hk0OrP96xGIFJlfJnwRK0sn6bbOk252R3FdgfRnjETeDsRs1biQNCsXzOki+rnAQpXY8
         mGUUBZpEC85HafYu80J21YnM68SfJ1VoIkYVt7O80G+rxcIyEGY22z1FD0KWc3V3LoWO
         dOBQ==
X-Gm-Message-State: AOAM5330TBaoFVuz+AQzMb/7uWme3/23HxwJBIC9jami5Sz/m96Q66/Q
        cVbEhJD0G/Oe3w//lWax20fNrnjSw92h6A==
X-Google-Smtp-Source: ABdhPJxJYFmnJnN1g4G/SIpauCA4iLH3fVj/+kjjIPTG6YgrA4z3lwyzs37Y1EIVmgB/WtR8Ds1jkw==
X-Received: by 2002:a5d:6da4:: with SMTP id u4mr183208wrs.611.1643931281591;
        Thu, 03 Feb 2022 15:34:41 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6d:f804:0:28c2:5854:c832:e580])
        by smtp.gmail.com with ESMTPSA id j15sm148494wmq.19.2022.02.03.15.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 15:34:41 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v5 0/4] io_uring: remove ring quiesce in io_uring_register
Date:   Thu,  3 Feb 2022 23:34:35 +0000
Message-Id: <20220203233439.845408-1-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For opcodes relating to registering/unregistering eventfds, this is done by
creating a new RCU data structure (io_ev_fd) as part of io_ring_ctx that
holds the eventfd_ctx, with reads to the structure protected by
rcu_read_lock and writes (register/unregister calls) protected by a mutex.

With the above approach ring quiesce can be avoided which is much more
expensive then using RCU lock. On the system tested, io_uring_reigster with
IORING_REGISTER_EVENTFD takes less than 1ms with RCU lock, compared to 15ms
before with ring quiesce.

The second patch creates the RCU protected data structure and removes ring
quiesce for IORING_REGISTER_EVENTFD and IORING_UNREGISTER_EVENTFD.

The third patch builds on top of the second patch and removes ring quiesce
for IORING_REGISTER_EVENTFD_ASYNC.

The fourth patch completely removes ring quiesce from io_uring_register,
as IORING_REGISTER_ENABLE_RINGS and IORING_REGISTER_RESTRICTIONS dont need
them.

---
v4->v5:
- Remove ring quiesce completely from io_uring_register (Pavel Begunkov)
- Replaced rcu_barrier with unregistering flag (Jens Axboe)
- Created a faster check for ctx->io_ev_fd in io_eventfd_signal and cleaned up
io_eventfd_unregister (Jens Axboe)

v3->v4:
- Switch back to call_rcu and use rcu_barrier incase io_eventfd_register fails
to make sure all rcu callbacks have finished.

v2->v3:
- Switched to using synchronize_rcu from call_rcu in io_eventfd_unregister.

v1->v2:
- Added patch to remove eventfd from tracepoint (Patch 1) (Jens Axboe)
- Made the code of io_should_trigger_evfd as part of io_eventfd_signal (Jens Axboe)

Usama Arif (4):
  io_uring: remove trace for eventfd
  io_uring: avoid ring quiesce while registering/unregistering eventfd
  io_uring: avoid ring quiesce for IORING_REGISTER_EVENTFD_ASYNC
  io_uring: remove ring quiesce for io_uring_register

 fs/io_uring.c                   | 202 ++++++++++++++++----------------
 include/trace/events/io_uring.h |  13 +-
 2 files changed, 107 insertions(+), 108 deletions(-)

-- 
2.25.1

