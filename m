Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3693535977B
	for <lists+io-uring@lfdr.de>; Fri,  9 Apr 2021 10:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhDIIRs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Apr 2021 04:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbhDIIRr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Apr 2021 04:17:47 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AE6C061760
        for <io-uring@vger.kernel.org>; Fri,  9 Apr 2021 01:17:34 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id o20-20020a05600c4fd4b0290114265518afso2488500wmq.4
        for <io-uring@vger.kernel.org>; Fri, 09 Apr 2021 01:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bpRGRoSCrQQjRuZ3jZzdyiArlPM/qzb9HplZd8FPdzg=;
        b=EXr7CQErUvmslkXQU3dzTRARBqG42JV1yIdLJh539hc2gC/0ESSugMaDJ3BrZWR7wC
         w1NIf61XTw4u04QfmNdEYY3wjs0Gl/BJJtumVVrdS/LPwABDxvHOW6f/1gcG6yPAw3tk
         eqzmRVgTzxim3e2xAs5eiJhBczhJYqVkUDITbnreMmP3Hmk+8nRG/q3wB1ExPIyBFR4o
         3y3PDDCEn9zVAiObFKBWYPzCcfzYnwECvni8Wmmo1ont+mx46gIHM54vYB+G47KTPNsC
         vLUzoow/YUKXiJ8CqN++BIQqSW4DvnV4NJl+d4Bhh2tF807MsJgdjomqpSPFSlkFxdCn
         e9Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bpRGRoSCrQQjRuZ3jZzdyiArlPM/qzb9HplZd8FPdzg=;
        b=DX+ZaAH6UPc3OhtJjFE5f24wl9hhIaXOarpKNMLUkXAKt04fitpBCMOIV12cDGgcsN
         JVyVEtmHW6mrFUbCdzG/UgXHQTedLZlBEGKe81wvrKApB5f7fYYQhF6LSCsWL0n08cMG
         eeX6t9nNsdqfEJ6iWmXoLgYkDdUTdRLm03sHX/cYp9CL3LM9nJds9cXE93wuLVqHH6Fv
         Ki8PV/W3eTDrj4cN/EqemDGMAmkls7+16ZaXebR9iRee8FvAsZYL6vU/IDOtT0TZ040D
         JXH3ILONDJ+AaJoE7xuSqDvbC6WGlJcOvOWUA+Jk9MdsdmGJW5aYZ0kZ7fnRB/KdnqCN
         VsyQ==
X-Gm-Message-State: AOAM530JpvBOpsL90Ff1dxNuaZdEnb8QIuB86ROAkeQ0eAV4/KDLSF7f
        HNXkJ0WbUSmL7rLgKjrxzmLXYcPanQ7Mtw==
X-Google-Smtp-Source: ABdhPJzJ/GELYqlCs2G8wBgdyL61RKkUvE99To4jtU1mQQlRZgxyct372jTeoz+GcMfeOsYTF+BAUQ==
X-Received: by 2002:a05:600c:414d:: with SMTP id h13mr12528074wmm.170.1617956253662;
        Fri, 09 Apr 2021 01:17:33 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.224])
        by smtp.gmail.com with ESMTPSA id d2sm3262133wrq.26.2021.04.09.01.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 01:17:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/3] first batch of poll cleanups
Date:   Fri,  9 Apr 2021 09:13:18 +0100
Message-Id: <cover.1617955705.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Few early readability changes for poll found while going through it.

# ./poll-mshot-update fails sometimes as below, but true w/o patches
submitted -16, 500
poll-many failed

p.s. not more expected changes for 5.12

Pavel Begunkov (3):
  io_uring: clean up io_poll_task_func()
  io_uring: refactor io_poll_complete()
  io_uring: simplify apoll hash removal

 fs/io_uring.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

-- 
2.24.0

