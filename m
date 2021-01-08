Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49EB2EF9D4
	for <lists+io-uring@lfdr.de>; Fri,  8 Jan 2021 22:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbhAHVBp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jan 2021 16:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbhAHVBp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jan 2021 16:01:45 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCFDC061574
        for <io-uring@vger.kernel.org>; Fri,  8 Jan 2021 13:01:05 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id i9so10254738wrc.4
        for <io-uring@vger.kernel.org>; Fri, 08 Jan 2021 13:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PoXYfRLPnvZkeiyjzD3+h2Vxmzsd349sD6Vh94+wpAg=;
        b=GplZRafIiCdTYp4rYeQrJmqw27SQJvLcSxbHuvTmEVUgGAV/4AoM6XvC01GjpLdfBK
         P/8zIqwvYEd9vU14e7TSF2Ll7f6YZRFdlef11Qkyx3FuVJ6DY8mk5IAnoEOy4gqOKjdH
         ilPhFEm7Z3OMNMDzPOop7odsU5ERvF7osvXVjlMWtJ5d1aqKpWjKyLsUHxxMzYx57hAk
         szyaIv9g8qz6BFDiHoIM14gyowQrqHN7VJBPCMg+9XAJR+HUqdtEKKgyYkrpUtgqclPj
         Iagxp1c8FyB3TYwhgPI/A6St6jUVKF1mscuBCkJzUr2UCeTTbZEY/xeMZnxpEo42w9la
         YSwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PoXYfRLPnvZkeiyjzD3+h2Vxmzsd349sD6Vh94+wpAg=;
        b=dPC2z53f0QBzEyZvBGBITgBjHP/nh5miKQeG1PwsX8J1k61zcsa5Ei4Wiero+I/Af4
         2GdyhWGuxkK/3pfZGJnIh9q6pame8VLrOaNKDryapy8INzxgU/Mv5TsKAVlzydZCY1wl
         V2fZ9VIxufkLkvo7QCLu/woeTGEQpCWMkHULbSRrPqboqGxqtx1dqlTStOuwR5JeNEEQ
         aJeu/f9tX6RAiD96sdc/IV6JADS1627t7IzqggdPjAWOfwe0dB05StTrhP8+lkzcyjxK
         wtK2SF8yKTw6rNvtszZx5vi5Unav54vsmQ4idX2YGdNJ9cH9N0pdLNn76PeJJjIrrFHF
         ASKg==
X-Gm-Message-State: AOAM532qRsPQhmq+WCpP9+l9LLoEk9DhHwL5CXH/WrKXcTS83rkF7Vg+
        niVMpYiQzzG9O6AResZAcRGw1KvIoRzJxw==
X-Google-Smtp-Source: ABdhPJwdQ3Tt5aU/nUDKRokX0Frcn5H4OZ2ww1HGezWo/7cq3jiqSmULU3QFBq3ew24zZr5agfk2Yw==
X-Received: by 2002:a5d:4641:: with SMTP id j1mr5445074wrs.94.1610139663991;
        Fri, 08 Jan 2021 13:01:03 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id r2sm14919211wrn.83.2021.01.08.13.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 13:01:03 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/4] fix SQPOLL and exit races
Date:   Fri,  8 Jan 2021 20:57:21 +0000
Message-Id: <cover.1610139268.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The series prevents submissions from SQPOLL thread when sqo_task is
getting killed (or exec()ed). That should solve races introduced by a
patch that allowed task_works during cancellation.

Jens, IIRC you said that io_rw_reissue() is called only during
submission, right? 4/4 depends on that, so 1/4 should help to catch any
misbehaviour. I reduced nr_requests but wasn't able to trigger
io_resubmit_prep() for iopoll or not. What was the trick again?

4/4 is actually fairly simple, but safety measures and comments make it
to bloat. The overhead is pretty negligible, and it allows to kill more,
but that's for-next.

Pavel Begunkov (4):
  io_uring: io_rw_reissue lockdep annotations
  io_uring: inline io_uring_attempt_task_drop()
  io_uring: add warn_once for io_uring_flush()
  io_uring: stop SQPOLL submit on creator's death

 fs/io_uring.c | 97 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 71 insertions(+), 26 deletions(-)

-- 
2.24.0

