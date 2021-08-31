Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185123FC7F3
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 15:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhHaNOp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 09:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbhHaNOp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 09:14:45 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370E2C061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 06:13:50 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id u15so11213805wmj.1
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 06:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RWXXNwZPshEi+F+t9LUlORdDtRq5RYAWXRlhz752ctc=;
        b=ZGWzcHE52Ie4voy4D8FKmEMbf83qefVNXayEydCbzV26NAMWUIoHL5ZUBXsL1gnNBm
         Cbg18+6MvB4BbixvTHevBzGv6rsuKQ/1U226ftJGh/iqggwtI4ztZn3BDxklW2TIOhTB
         BeqLbarHdRFFopvZQPtGTMKpie69Tt0bPrHx4mDmXgtLZEQQDjiiYz5Oe4hbcdJPUvxP
         0FcW5x5yIM4ZUmtfdv65BTiwQQl9AnIK5CvpgvCxXYwyLq9TjI+xm7VVnPEEYu4F4H8M
         lEgMy2hN6CVOrqesK/U0Dx/DToKzLVF/RL43VLBs36hRDPJC9KojRNHxF7K5x5w44n5B
         QNRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RWXXNwZPshEi+F+t9LUlORdDtRq5RYAWXRlhz752ctc=;
        b=oG9e/V6UqaroEqOTrJHGJSUuUdedk6XYWyybHkuw2WMsPpZnmI/TDuBwKulUgZlCa2
         tHLjVl2sGddhi+1+5TQY5955g1Fuep01UDl/8DXtBTBh1fuPLdABXejPQ/xuUKuF24cX
         QT6pTenGAEbbddxmzCHHMsqjKqnuq86f1mw++CJvzX+C7FzIepcVH3MN5tdVBXdSswDk
         RuWUGbe4iZWO0NbaU5PnAk3JGX3q/drMc4/dwack9dnZPQeLYDPsTFULePz3YSWcABIe
         j1yCzFq6kyLAwT2IAj7rr4/Ok9T/a+rpLiqdotcXhE7AlvCyf+H0tqilrshVHfjosOY3
         oiUw==
X-Gm-Message-State: AOAM5304x2idf4BB4oARWqo0O8nVChCS/9yrahzjgLi2Q0kia/4+gIjr
        U/vSKgsMxRE2ctfedhMyO44=
X-Google-Smtp-Source: ABdhPJxg0kyxR4s1Hj32wfjNhbaClMaNHUF3qcNb8lNbo7eLU4z5go1DNJHHMe7zJhLkO+wKs31YsQ==
X-Received: by 2002:a05:600c:1c91:: with SMTP id k17mr3070050wms.84.1630415628792;
        Tue, 31 Aug 2021 06:13:48 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id t14sm18246586wrw.59.2021.08.31.06.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 06:13:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Hao Xu <haoxu@linux.alibaba.com>
Subject: [PATCH v2 0/2] fix failing request submission
Date:   Tue, 31 Aug 2021 14:13:09 +0100
Message-Id: <cover.1630415423.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fix small problems with new link fail logic

v2: set REQ_F_LINK after clearing HARDLINK, leaking reqs otherwise (Hao)

Pavel Begunkov (2):
  io_uring: fix queueing half-created requests
  io_uring: don't submit half-prepared drain request

 fs/io_uring.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

-- 
2.33.0

