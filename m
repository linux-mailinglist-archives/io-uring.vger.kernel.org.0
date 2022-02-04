Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7314A9B72
	for <lists+io-uring@lfdr.de>; Fri,  4 Feb 2022 15:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242720AbiBDOvX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Feb 2022 09:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357195AbiBDOvW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Feb 2022 09:51:22 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E68C06173D
        for <io-uring@vger.kernel.org>; Fri,  4 Feb 2022 06:51:22 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id d15so3035616wrb.9
        for <io-uring@vger.kernel.org>; Fri, 04 Feb 2022 06:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FPOz8xdK3mu3IlbLy0Cgt0QVaMof28Afhuj4OwC3evg=;
        b=umAwh8Qx03ObZU5SEan58et+4+onfkoHH3Dyl9pVgt7ENuK72PjpLhEswYoLiFzM5/
         j5+y3dq9BVFpRRVF08Og2+DNE7g/DXBhgirJUtror9WVAb9O1okN2JzHQzIySfkk7edp
         sd0JHkNmmPsk9cWqj25QX3AfKAyw4FTdFaq5DXlcK4ZhGFUUBglSKovpmjoYEn3Fq1ZJ
         Ek9E9RXQ3slyyTczuQcuOSKuZEy2jZxdAmkeQ74jTdJpWDX6ElkGismkTyt9tCKwqaRh
         5/EJwh2HgHV0JiOGN80zO4Rg3RECPiFdGdCyTxsjS/GNz6GjiCJvclwo95YAwAb0nOGF
         WbDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FPOz8xdK3mu3IlbLy0Cgt0QVaMof28Afhuj4OwC3evg=;
        b=Jr4OHTZkrOliVLohWsR4nIFm1f9sKfxiVqeoozjIcHuk5y3w78RnWhk6HqpMG7rgfZ
         7ihwgyp3iDo73tpKA+Z8fQdp5Bz6xnW7P4l4tcsniS8vM+mqiKvC3LqSBGDW51+R+Xif
         0LHGHq4edQI/LsaajxxzbCRFgIoCh3XIl7THoGU82qKWeXVWPMdQ5w6vxJT1FDxmp9CU
         PavbPj9O49JwhEFKdUuxoIvbYq6Y5S5zJ4t3NiGYWtq6a2X/64lpPk72lZq6C5GCszlB
         hwMCtlK0MXJw1pauz0DJONSvJ6fypDnspt8feOFjtHmT55ttBntts9ESaAW7oz4BcKeu
         H/eQ==
X-Gm-Message-State: AOAM531YPRkBhQjGaPcUPK78nUWFLvCyoKLpGRlZxNuQ+8oubVEJCPPD
        WUymvv1d+AGz4XBg55htxYutdh3J7DtP7Q==
X-Google-Smtp-Source: ABdhPJzgAXQi8499aCkXTKHeRrnKHF5eTseah0AEPz+svB0ce2j2k6zCIL6TpUSarhpjDKDZzE/1iQ==
X-Received: by 2002:a5d:47a9:: with SMTP id 9mr2814375wrb.31.1643986281163;
        Fri, 04 Feb 2022 06:51:21 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6d:f804:0:e94c:d0f2:1084:a0d3])
        by smtp.gmail.com with ESMTPSA id c11sm2552898wri.43.2022.02.04.06.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 06:51:20 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v6 0/5] io_uring: remove ring quiesce in io_uring_register
Date:   Fri,  4 Feb 2022 14:51:12 +0000
Message-Id: <20220204145117.1186568-1-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ring quiesce is currently used for registering/unregistering eventfds,
registering restrictions and enabling rings.

For opcodes relating to registering/unregistering eventfds, ring quiesce
can be avoided by creating a new RCU data structure (io_ev_fd) as part
of io_ring_ctx that holds the eventfd_ctx, with reads to the structure
protected by rcu_read_lock and writes (register/unregister calls)
protected by a mutex.

With the above approach ring quiesce can be avoided which is much more
expensive then using RCU lock. On the system tested, io_uring_reigster with
IORING_REGISTER_EVENTFD takes less than 1ms with RCU lock, compared to 15ms
before with ring quiesce.

IORING_SETUP_R_DISABLED prevents submitting requests and
so there will be no requests until IORING_REGISTER_ENABLE_RINGS
is called. And IORING_REGISTER_RESTRICTIONS works only before
IORING_REGISTER_ENABLE_RINGS is called. Hence ring quiesce is
not needed for these opcodes.

---
v5->v6:
- Split removing ring quiesce completely from io_uring_register into
2 patches (Pavel Begunkov)
- Removed extra mutex while registering/unregistering eventfd as uring_lock
can be used (Pavel Begunkov)
- Move setting ctx->evfd to NULL from io_eventfd_put to before call_rcu
(Pavel Begunkov)

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

Usama Arif (5):
  io_uring: remove trace for eventfd
  io_uring: avoid ring quiesce while registering/unregistering eventfd
  io_uring: avoid ring quiesce while registering async eventfd
  io_uring: avoid ring quiesce while registering restrictions and
    enabling rings
  io_uring: remove ring quiesce for io_uring_register

 fs/io_uring.c                   | 179 +++++++++++++-------------------
 include/trace/events/io_uring.h |  13 +--
 2 files changed, 75 insertions(+), 117 deletions(-)

-- 
2.25.1

