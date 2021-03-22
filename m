Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9058343678
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 03:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhCVCCo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 22:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbhCVCCn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 22:02:43 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BAEC061574
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:43 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id k8so14994939wrc.3
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m9iakSfSm7QA4GmcLSXa6Xx3QKwRHBtG8eLBc4nnOrQ=;
        b=pNfh8oQhqD1gV5YsQaA2XNX7m+npjqSEocSEU+pQenjLUPTZuAJpDFyJY+dkavhWZP
         jxotG/+OLLv6RKwu70SgttbFiwBMNzVZPCa4gtAE3P9MhHL8Y2WsSE6PwQYMtUAH42zy
         9yRUqU8qWTRx+R4usoLjA+UctKI9LV3dUhy8RhIhhUow6E5dlgkKuoze6j7D3Mj3JAsX
         QQeojokDxcl7hqZDf8V5UFhdFSXCFNsSuTr0DnvkdKkSWqvrXpSnjiJZZ9rzSzjkOnA4
         eC469mKjE2h/f10/At5U8Tv0E+S6mqpvP5y6f2zx3Dpr5zPPlFHFtf2ovRLZiYMB8sBC
         sa4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m9iakSfSm7QA4GmcLSXa6Xx3QKwRHBtG8eLBc4nnOrQ=;
        b=pjO7kCufe/f5V63A2iRqS3pA3y0EX2gY5yhnG64Zl4mIX7njsJyv/6XcYUwA+FgV6Z
         SrraCiuqtYXIgSz7XhYPSBEl/Kz2xy3mbGK4k9V23N3IRbXRyBG+PXL2e41s3zk/J0nn
         +bF/I7VJK1aVImiEAVH6nO7bAZquepN64DApPHDqHp6/g1WidbWZWOIXXeuUG3wpsjcl
         oGXv2nYoQfVuCETDOQYnvEZWN4E5PcQ2oIqSmrwAz9OlaZnv/lcUG8fXPTeG2N1XDnne
         IMmt8Oqgyjvn6DkrcuXmqQfu/ze9zLVoHaYXcG/7PcxqHu6lLb7+jH7UFPc/82Y+EUZY
         77hQ==
X-Gm-Message-State: AOAM531uiCWYE5OHRyLXvVmuyjq7Gh+DZJyk5ccIcv5vQ0vgM7L7DXA7
        wo3zLHbGCZY3gW5jfAfTxROWbUTV7XM/XQ==
X-Google-Smtp-Source: ABdhPJwVIMNEYCQh5Z04YeygjdVAVHxTergUNSUzVPjyssfKwT+Ncxf9VnsFA2BE5rludYHF22UAkw==
X-Received: by 2002:a5d:570b:: with SMTP id a11mr15591517wrv.281.1616378562276;
        Sun, 21 Mar 2021 19:02:42 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.202])
        by smtp.gmail.com with ESMTPSA id i8sm15066695wmi.6.2021.03.21.19.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 19:02:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.13 00/11] yet another series of random 5.13 patches
Date:   Mon, 22 Mar 2021 01:58:23 +0000
Message-Id: <cover.1616378197.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Random improvements for the most part, 8-11 are about optimising rw and
rw reissue.

Pavel Begunkov (11):
  io_uring: don't clear REQ_F_LINK_TIMEOUT
  io_uring: don't do extra EXITING cancellations
  io_uring: optimise out task_work checks on enter
  io_uring: remove tctx->sqpoll
  io-wq: refactor *_get_acct()
  io_uring: don't init req->work fully in advance
  io_uring: kill unused REQ_F_NO_FILE_TABLE
  io_uring: optimise kiocb_end_write for !ISREG
  io_uring: don't alter iopoll reissue fail ret code
  io_uring: hide iter revert in resubmit_prep
  io_uring: optimise rw complete error handling

 fs/io-wq.c    |  17 +++----
 fs/io_uring.c | 128 +++++++++++++++++++++++++-------------------------
 2 files changed, 72 insertions(+), 73 deletions(-)

-- 
2.24.0

