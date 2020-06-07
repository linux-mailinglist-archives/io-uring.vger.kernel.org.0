Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864EE1F0C68
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2020 17:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgFGPeG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Jun 2020 11:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbgFGPeF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Jun 2020 11:34:05 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED5DC08C5C3;
        Sun,  7 Jun 2020 08:34:05 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id u13so12925871wml.1;
        Sun, 07 Jun 2020 08:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2o3QvPMuAvXtLGnv5lwxLj6qG0phhHtf5j/mBFrQWX8=;
        b=T7Jzkz7ikIc5D1pUfCwNeC8rqL7NCIYixAiV7fhBPoSx7udCUKh1WAe97YiyFnqctU
         K6c5EK4wmPeTv+0MxxaMv8vVVYR2zJ3LQL0yDCDPQYokPZ4xITxf06VuSPocGzd7JVQP
         yv32gmNlQI6S4kawq3XRxur08Fni+EBVCmw3n3uUZG9GLHQX5T0rqFur8UwbOI7rpDsa
         XNTT85AciWBhtc8ALOWWo++LtrVXpuBlvFavODPv8d2RQSx7dIDTm9HHSPxEEkZ7/V6b
         uO+2sEb4lqIK56zZRoUQFdfdGV+uYnSdEdKQaIhsFIDOOI04UIhkjfdX9WCJrD1LWKP8
         3tYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2o3QvPMuAvXtLGnv5lwxLj6qG0phhHtf5j/mBFrQWX8=;
        b=cWzIa7cytc91uVbJJw3qOY4rq32UzvLe3vUmwMXgTNGcycIkgIp83pNm7oRnEbSUNg
         hBeSj1vQr997YjCC9R2sSxqyuziJM6ggApR1owtVRN76Uxf/z7kJJ3wF2Gj4EcZo+b5U
         5zzIURpFdIXWo5a8TbiznxH49qVlF9C8yJlNKs+QgTFFIPELS8CLDvs51t0Rfd5SnaOk
         n8p3w9QZTiNPKulAaTvJjBikHC4i/cZIM1uVzBv/T8KsyOUvlecn2qg9AbnvF+gkT+RY
         cPfB3L01/VuXzZpAO8mq+C+7SyBmXjZPSVUN7iFJKZR/xFyXkmpzHvHKh1xkPWTwhJI+
         5uXg==
X-Gm-Message-State: AOAM5335HJtqZz1Lu/lrPwdeMDwx7qlTcJ0M6Q/OMpwHzxdrwcHydi/W
        i9aOWrkuOjn1rpV0/etw3ZiLHgSw
X-Google-Smtp-Source: ABdhPJwW0EH8q+M6K5oIxSIYYpIB4JOeHqAhVn31rq9Yp6uMNRnBJfwDp1t2vDzlYFiR5qWkLzEZPQ==
X-Received: by 2002:a1c:7903:: with SMTP id l3mr12025809wme.50.1591544043835;
        Sun, 07 Jun 2020 08:34:03 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id 1sm19589015wmz.13.2020.06.07.08.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 08:34:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] cancel all reqs of an exiting task
Date:   Sun,  7 Jun 2020 18:32:20 +0300
Message-Id: <cover.1591541128.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring_flush() {
        ...
        if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
                io_wq_cancel_pid(ctx->io_wq, task_pid_vnr(current));
}

This cancels only the first matched request. The pathset is mainly
about fixing that. [1,2] are preps, [3/4] is the fix.

The [4/4] tries to improve the worst case for io_uring_cancel_files(),
that's when they are a lot of inflights with ->files. Instead of doing
{kill(); wait();} one by one, it cancels all of them at once.

Pavel Begunkov (4):
  io-wq: reorder cancellation pending -> running
  io-wq: add an option to cancel all matched reqs
  io_uring: cancel all task's requests on exit
  io_uring: batch cancel in io_uring_cancel_files()

 fs/io-wq.c    | 108 ++++++++++++++++++++++++++------------------------
 fs/io-wq.h    |   3 +-
 fs/io_uring.c |  29 ++++++++++++--
 3 files changed, 83 insertions(+), 57 deletions(-)

-- 
2.24.0

