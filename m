Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25A22A9699
	for <lists+io-uring@lfdr.de>; Fri,  6 Nov 2020 14:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgKFNDl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Nov 2020 08:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727251AbgKFNDl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Nov 2020 08:03:41 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D920FC0613CF
        for <io-uring@vger.kernel.org>; Fri,  6 Nov 2020 05:03:40 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id h22so1274365wmb.0
        for <io-uring@vger.kernel.org>; Fri, 06 Nov 2020 05:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N60wmeZTq6F60Z5p4BzJTkPy2uU9SQML2Rash6LOysc=;
        b=gsp2SrDrwmRb0pWUSox7XMrtHDxTC3uH2kx5fkv+NoUwLzRDxlahIBiNhwtBbCxT48
         vbenkrloHeqP+EXzOHyvvANSpyVkuakJNOZC91oztJ+HdRfL+H88yQ0yMcNGBfjccq/r
         lSctz/iNUkyo24egfCwgpH18cXru9OyJMiNu3C4gTUPgfkqkxxoUxUARSlpA2srrcZOh
         MUIewFy/6xWnMg/L/PQdeLNdbf8haKSszOpDbIfBXXhfxNcqn0lf4/EpHHQzm1r28q1i
         M58M8JLZm4+JMaDg2KWVXC6JRbA8WF6WyFDjslAMo2qX7+lAE2sup4PQk3uODD07Xoz2
         j+HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N60wmeZTq6F60Z5p4BzJTkPy2uU9SQML2Rash6LOysc=;
        b=TlGItcD7/gACaw9xWMAN4iJBpa0tgs811VL4rMGwBCbSmFU2E01aDjqkPljV+xgha1
         9wvhVG0ldYxHOOnWkkTUvG+u/I/L7kmAdGIfa1hIukhHZqWIAhv6KZXlOZX1rJ9rsDru
         goD6ZdBs/oelRPrdlU47xlqPmm915C9J9ki9yxHilBbyjzaowQBEgb47VWpA4yIRsW8r
         iY+HhdMpzojcaQqlcUGHVlXv8gLJ8QQ5s/5lSPRR4Vr26rkkuTKkyZBLPkm3+RQHr+7j
         McroZ8c4ieyk5N0b26AO+BEWbXT/H2Zx+eMPWN5vmGL/urBWjDl8ZEabuH6ZKvpk97hU
         D9SQ==
X-Gm-Message-State: AOAM5333sn60wy5Yd50MKH8USv/N417GSvDm7/Sgo1pdT04Yhx7+DNZD
        ywv1wjPjHN1K+fIhVcDcZ6Q=
X-Google-Smtp-Source: ABdhPJzXeU5tZa6F5EouYaX0EtRAYoHdtxkzW2LMrsEDkPiq1udgyeci66Xjcy9rrt0D61OHrFN1Uw==
X-Received: by 2002:a7b:c0d7:: with SMTP id s23mr2576518wmh.54.1604667818762;
        Fri, 06 Nov 2020 05:03:38 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id e5sm1931839wrw.93.2020.11.06.05.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 05:03:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next 0/6] cleanup task/files cancel
Date:   Fri,  6 Nov 2020 13:00:20 +0000
Message-Id: <cover.1604667122.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

That unifies cancellation/matching/etc., so we can kill all that going
out of hand zoo of functions.

Jens, [3/6] changes the behaviour, but as last time it's less
restrictive and doesn't kill what we don't need to kill. Though, it'd
prefer you to check the assumption in light of the cancel changes you've
done.

Based on for-5.11/io_uring + "io_uring: fix link lookup racing with link
timeout", should apply ok after you merge everything.

Pavel Begunkov (6):
  io_uring: simplify io_task_match()
  io_uring: add a {task,files} pair matching helper
  io_uring: cancel only requests of current task
  io_uring: don't iterate io_uring_cancel_files()
  io_uring: pass files into kill timeouts/poll
  io_uring: always batch cancel in *cancel_files()

 fs/io-wq.c    |  10 --
 fs/io-wq.h    |   1 -
 fs/io_uring.c | 260 ++++++++++++++------------------------------------
 3 files changed, 69 insertions(+), 202 deletions(-)

-- 
2.24.0

