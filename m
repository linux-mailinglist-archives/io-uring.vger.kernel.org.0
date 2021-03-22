Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684BE34366D
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 02:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhCVBuc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 21:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhCVBuL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 21:50:11 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA91C061574
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 18:50:08 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id j18so14994928wra.2
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 18:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6XY7/QDUNtKjIKqSNiLqXsNMIV8y6lenxaK8FTbB4Cw=;
        b=pNUazxw/BInMPWqoAa47gsDfpIOvVpkY+0m1ohMUiF+9YkcVktAfoCewiBsUXyhjy8
         uQ74C8+dLImd1zRSkXxQ1Ofy5hYuz9KuOQXA7WoMocT64wUjkIFfAFSCbkm2stM9PICJ
         ySzUUVc1oyyjWCJSHA/CcMIXat91rGIcD2dQyzeVGYLExAa6ebx6fR26PPZ3GmY3Mhki
         rZzr+qXczHoKAB5nDH3tbntUIq578RJp/tZGCbZwY990aijmRN+cpY653kCBmfZOCX6u
         U/+BBS/174pBF/PPO44jpGI1WZJ1iTCdkZ9eWsfInF1PZx/k6oJufQmCPxf9mn2TBNDw
         Y0rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6XY7/QDUNtKjIKqSNiLqXsNMIV8y6lenxaK8FTbB4Cw=;
        b=NvhbDbMURyVCs1Wb7S9DCaTHyL80aFVyzdpk8n+7S/hg0nzLdjYCVZrcT7tMD4EUsX
         2ybLrDFbSFlVSA6DzqLaKNvfz8fMECw6TiPL4h/R56fZu/YChijKdiX/embynq11Hy6w
         15F/QGmGxWsYDLsjwhXvpGFLbb/NQt5hIfgEAZUGwWYX5IkisfcXqCJ6vIllHmIhrPil
         0T7o+LbI7ahuG7qiXIN1k7InxM2EY8kcs2OkhOFpqH6zN8ZA52P/2PDU5eJEibnJ0DT1
         XVBM06/SogruW0ebyRTMtwxci2j3+pW00XMyOdBH/pZ9omtKHqOAHOB00DiKZmZzxOcb
         VNEQ==
X-Gm-Message-State: AOAM531KY0SOy8UXOK2UHHqnlx2nHKZO7QNIL3lcbvW/jS8BPHWEpirL
        /ZAQrG1YAC+/LONBnG2KJmbL4tHXUwUSXw==
X-Google-Smtp-Source: ABdhPJxSlTLlT7SIbMxCqllH173N3JlyWS2kx0p8AallzxncumtmklLMEHr+d5FsdrCy86LPEmvO0Q==
X-Received: by 2002:adf:82af:: with SMTP id 44mr15054383wrc.279.1616377807251;
        Sun, 21 Mar 2021 18:50:07 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.202])
        by smtp.gmail.com with ESMTPSA id x13sm17653138wrt.75.2021.03.21.18.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 18:50:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12 0/2] minor fixes
Date:   Mon, 22 Mar 2021 01:45:57 +0000
Message-Id: <cover.1616366969.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Two minor fixes, nothing serious

Pavel Begunkov (2):
  io_uring: correct io_queue_async_work() traces
  io_uring: don't skip file_end_write() on reissue

 fs/io_uring.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

-- 
2.24.0

