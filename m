Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA59220926
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 11:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730820AbgGOJss (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 05:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730612AbgGOJss (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 05:48:48 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6E3C061755
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 02:48:48 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id rk21so1531101ejb.2
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 02:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N6JSLRMkReAslwRoJulIfJe/fsP9R2luaz39vZ3I1LU=;
        b=USCneLT/75ZdNx+UhhAxiWcOHauVijPfb5C40ShWkpvChJj12tKUkRFt8665Mh2qNE
         0Q2zjxdZaPKRBLy31DxTVK2lc7oL8ojOLihdzJvCYpXuvqV+U48ZHnDUgcIwwJ5N0tC8
         wF6ZrLHPmF4tsZHBkOZ3XzxRj1fPlwNjL7CqPDkSVNNXQunS99ioPpPGLc6EDwzfde69
         V5TYcoUJ76lYIq6FEsVfLTmNCSxa9BlJAhL2xlqdBmATR3Sm9iEabPU7lqyVUl1VMtj0
         7YrEAmirhop2TFILvW/INEEchbkoRxh9UGKJdsnd/3iolr57Wbuvzv2ECtjsiSBUL3dY
         Km0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N6JSLRMkReAslwRoJulIfJe/fsP9R2luaz39vZ3I1LU=;
        b=HkRLIFP+0UfNYVQ6fqhHG25Xj6Cc+KWJRaODLM18qw0ync9vWdKqnVwotvsO7vf3CP
         rMfKdhnue+QRQI9wvFn12V2dUpYzCvjsCXiyMBSWVt+nIMmgipq+sGQF19bisfIdSq1+
         EuUtp2vwWB3JcaMxDAdL2/i8/3zAIpJqA/ajm3GCoBp6zR9a1lQ/+6JHZDa1UZScuQka
         OE3gCmIWki9CnbpPyhBGlW4y+Or9+6wM2LAUnjIrgJktNTn5WHnc4svX5gemNECp5pd8
         IaLvxUSrmf6HoGzsG26tYYcLgoBc/sJqr7JH6tK/6VAHn4+kLrbDRhsPxFV2/aS7xBCl
         3vPQ==
X-Gm-Message-State: AOAM531+wKLgxOYqNA5zKuO/xsiKPQdzAshSgnk3y55BfI24ij8jc9XI
        T0k1TGpwqMBBgPGvo0ismyU=
X-Google-Smtp-Source: ABdhPJz7tXYXP8sk8Ebqvt62gvkbMcNHurdwH7PIL55gNHOtHKQcdn13gxvPzjectspgzwcocfGjPA==
X-Received: by 2002:a17:906:c04d:: with SMTP id bm13mr8262664ejb.321.1594806526771;
        Wed, 15 Jul 2020 02:48:46 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id d13sm1635690edv.12.2020.07.15.02.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 02:48:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/4] quick unrelated cleanups
Date:   Wed, 15 Jul 2020 12:46:48 +0300
Message-Id: <cover.1594806332.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Probably, can be picked separately, but bundled for
convenience.

Pavel Begunkov (4):
  io_uring: inline io_req_work_grab_env()
  io_uring: remove empty cleanup of OP_OPEN* reqs
  io_uring: alloc ->io in io_req_defer_prep()
  io_uring/io-wq: move RLIMIT_FSIZE to io-wq

 fs/io-wq.c    |  1 +
 fs/io-wq.h    |  1 +
 fs/io_uring.c | 95 +++++++++++++++++++--------------------------------
 3 files changed, 37 insertions(+), 60 deletions(-)

-- 
2.24.0

