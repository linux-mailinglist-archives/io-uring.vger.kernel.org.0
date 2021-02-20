Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53549320692
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 19:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhBTSI3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 13:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhBTSI2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 13:08:28 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD742C061574
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 10:07:47 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id b3so14407349wrj.5
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 10:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fBNuUz2jga1yCcG2na8HyV+sr1B1XgbaErJoQxN6UD8=;
        b=HBW4bXH8Z6bBcqZcG+L0C0hihOBwLlQXyuVCCtdKq8/mbkP1MX/2OjAHc2d4mEKO0e
         XifzALHDRMUBD00qoaK4+b/Nc4zK+v6VDGW222kgTwyUCWbhsw7v6gBJFHqoxEolnylO
         I5bsIh6liIUZuxlhnXcL9+Xtn4PzNG1z5Y/k5jkcJA35vMujl2khuhcvZvuCCkZr8CjW
         2IidW2PWH7IvB3iXYhvam71Wj9XYgYR2WjA6p4JxiQ/Na2CAUkCIYld9FUS+2aBCx/en
         69SlkkKnB6hs8HANY8nHMGRfCdoV4VS/yQgCswoNTR/nTl2Tzbv8LZtpryM/8gEdViDc
         ljug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fBNuUz2jga1yCcG2na8HyV+sr1B1XgbaErJoQxN6UD8=;
        b=sIU6/VWkxpMASjPT2uOssJyfHbDtDYtyR0gX0MNJ6zYfjLk19APUdIUz201HKfV9CY
         JVSQRuK6so1RjkLtuMA1uwRtqvXIHnfjtyTUbQGFuDjPFh1LdfPWxQ6GFm4MzEGgAWcg
         bs4vHlxQ1/29zrGyMTX98WFpwFF12s9JJhriiTQg7HSvSxQvynlQFY2qomsUD6f/IZKP
         wbFL58UUPRZiTNIpnrZy8ET37ZVMu8vnMPh2XK+USkOmUOt/0xm3ciF1W+a4XIBE3ifF
         BSbXK1MEZCdOSSQfuZhkPZn24WbWxZzFI5f0Z1HH+i5ZQCReulysx26uqoSXHay4GACm
         tpUg==
X-Gm-Message-State: AOAM530QY3rAoTP/2UtKUIWGLeLgqlQxIm3oALvGVVed0PYEQgl4a0FP
        A51C1LBT0SxEEUXiQFTAbgJ2itpllv5WNg==
X-Google-Smtp-Source: ABdhPJyVBaGsV2QBNB0BTtiH7iP0XGzU0PUtuepHR0w06NSywWEVTGB06rlshYnRnYb70UQHy2DOZw==
X-Received: by 2002:a05:6000:c1:: with SMTP id q1mr14871301wrx.114.1613844466387;
        Sat, 20 Feb 2021 10:07:46 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id b83sm13594918wmd.4.2021.02.20.10.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 10:07:45 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 0/4] rsrc quiesce fixes/hardening v2
Date:   Sat, 20 Feb 2021 18:03:46 +0000
Message-Id: <cover.1613844023.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

v2: concurrent quiesce avoidance (Hao)
    resurrect-release patch

Pavel Begunkov (4):
  io_uring: zero ref_node after killing it
  io_uring: fix io_rsrc_ref_quiesce races
  io_uring: keep generic rsrc infra generic
  io_uring: wait potential ->release() on resurrect

 fs/io_uring.c | 96 ++++++++++++++++++++++++---------------------------
 1 file changed, 45 insertions(+), 51 deletions(-)

-- 
2.24.0

