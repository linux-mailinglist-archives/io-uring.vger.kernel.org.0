Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC5532F998
	for <lists+io-uring@lfdr.de>; Sat,  6 Mar 2021 12:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhCFLGf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 Mar 2021 06:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhCFLGV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 6 Mar 2021 06:06:21 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC0EC06175F
        for <io-uring@vger.kernel.org>; Sat,  6 Mar 2021 03:06:20 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id l22so3233717wme.1
        for <io-uring@vger.kernel.org>; Sat, 06 Mar 2021 03:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=emv0k9FQK7DN8+7nQxQl7dM/N/S4Jsb3zXQlbvdMT2c=;
        b=P8CENAiDVajSde8GM9t0uDsBxRuyZkbmt/RUTU9TBxd1Yl/9sa03njkX44qkn5Q3Z8
         U85UIOS6ScYAXyFMjUiOVDHlCqt+W843axRs3jsSIhFCAs6uDnY1NK06A07ZJjCTmcwH
         FvmtzENDnwQsX0yGmJgzePdWwti29TYo9PCgaTV5ue4TVyZ1Ko3ibwj/X8SBCIDGtcK9
         HjcjKuyLmcY+OyRGRBp4A8Mn4WxzmyQKbtqImWFVvFFhHn5FhJ7/nSI8vwoWV2tVXNNM
         umZiWDnmMkf5831rbGfXO8YrEb8nOCF4tuyVlQypPfW2bNN6yXCOpD0DLRAvZBTFT6V3
         1x/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=emv0k9FQK7DN8+7nQxQl7dM/N/S4Jsb3zXQlbvdMT2c=;
        b=BR+uq2zGiEMoOw15jHOWj37FaqM1pEA+qS6EJJ3iYqTLV8VaWM35RAzIv3FI2OAtD3
         ButDapCbDCJP+a+KFK7ZFVpcR71s8z0xh2BNHga1pyyHMhSOG8kPzsCnNp0UrPU4UBZz
         iXUn72QBUmAQrIPfI40uQKpUkAfTKe/yKdrlT/ErEgWBSmgk8XaMwrN2EP5UetzA/TxC
         uUm4j8TmpH0gr4FNJGzn+kuLTbJKbNVxOH8PcZ78NX+Gn5l2mP9WV0r8KS3ckitMI6MI
         p5pCvwZ+C30/6NIEWVihbHkL9IU7zYHxO+/z4EC5tnFYkNN075WaQB8TGJRfIHEBkqzp
         tT0Q==
X-Gm-Message-State: AOAM533Yl36WYPzl2uw0xWO3P4MrrGRWdu/SXKEq4PJNyWApnC0MJFxL
        oH2pxCxhYj69gmftkT4Z1yE97ewcBVdvag==
X-Google-Smtp-Source: ABdhPJwSR2ypvKk3ovku4m5GmgAjd7aZDI9wl4tYa54QKlYUfk6WNyqYzOWPLiexJmdpQqw9wjfG1w==
X-Received: by 2002:a05:600c:4282:: with SMTP id v2mr12668804wmc.80.1615028779022;
        Sat, 06 Mar 2021 03:06:19 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.8])
        by smtp.gmail.com with ESMTPSA id h2sm9442365wrq.81.2021.03.06.03.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 03:06:18 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 5.12 0/8] remove task file notes
Date:   Sat,  6 Mar 2021 11:02:10 +0000
Message-Id: <cover.1615028377.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce a mapping from ctx to all tctx, and using that removes
file notes, i.e. taking a io_uring file note previously stored in
task->io_uring->xa. It's needed because we don't free io_uring ctx
until all submitters die/exec, and it became worse after killing
 ->flush(). There are rough corner in a form of not behaving nicely,
I'll address in follow-up patches. Also use it to do cancellations
right.

The torture is as simple as below. It will get OOM in no time. Also,
I plan to use it to fix recently broken cancellations.

while (1) {
	assert(!io_uring_queue_init(8, &ring, 0));
	io_uring_queue_exit(&ring);
}

WARNING: hangs without reverting sq park refactoring

v2: rebase (resolve conflicts)
    drop taken 2 patches
v3: use jiffies in 6/6 (Jens)
v4: 2 patches, 7/8 fix cancellation regressions

Pavel Begunkov (8):
  io_uring: make del_task_file more forgiving
  io_uring: introduce ctx to tctx back map
  io_uring: do ctx initiated file note removal
  io_uring: don't take task ring-file notes
  io_uring: index io_uring->xa by ctx not file
  io_uring: warn when ring exit takes too long
  io_uring: cancel reqs of all iowq's on ring exit
  io-wq: warn on creating manager awhile exiting

 fs/io-wq.c               |   2 +
 fs/io_uring.c            | 173 ++++++++++++++++++++++++++++++++-------
 include/linux/io_uring.h |   2 +-
 3 files changed, 147 insertions(+), 30 deletions(-)

-- 
2.24.0

