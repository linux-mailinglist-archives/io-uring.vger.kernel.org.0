Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF1E3F02F6
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 13:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbhHRLoE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Aug 2021 07:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbhHRLoA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Aug 2021 07:44:00 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B2EC061764
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 04:43:23 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id h13so3082122wrp.1
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 04:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UMO2PG04CZIcZHNusA2fYjA8tXW3+jCJHQD0ejsu6OA=;
        b=hm8gHi0dSdAowaeTexs/mHHxz3O34tUBsFVrD77VNaZbhjVsf4TT0QsxGAmSjnEGHs
         +EjLDmU4imYPrycFa5VJBeoMNbJRfUZef1WQ5Kn/ygfYjpr5wu7YR5fEjTOO35MBEBW+
         Qge4RfHfZnQpHA51mqd6IWxeThZry1s4ChDHii9q3dbeaFEswlM3pT3k22fIzipuYOzN
         7CyfMj8L6DijetWCQzYVKwuLwilIm3owcXiJ4hgPG51Vg2PL6cybDpNcXErMlk9it7Ru
         uMQ7toHtiGiqNVdNBgyxN7YXE/6lAArfW/1/CcZ+tBr+4N2qhD5jXAIMY/mbO+VOxgjS
         /kPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UMO2PG04CZIcZHNusA2fYjA8tXW3+jCJHQD0ejsu6OA=;
        b=bZSuqPSSR3TD37tZXzzisSGrHFAjnYq598og74xok0EPpiGkB/P8SGu2fw0GVyoGtz
         0v5RVzG04wS9/t83X2WUmkhKkMCGWqDdAeEwfHPLFa9wNWNARjKypW/qcQUlQLovzZLn
         G43ouhQ16nKJjP0YZkc+4lVOYnIEchtOusaDggM1CwPL6p99iQ1LcY8GuWm0AmAxmian
         LXQy973lDcI0l4P2k2CWJUis1BAlDU31Gs+EsRSd/rg+yWrGbZOPdRm1zvhNEZexO72i
         q9UhGq9dFLtVhwyegYk952VSAIFLerq5hQhmp4wHNbbbHR/B+F1WgYs+CKHlgtC4aX+1
         FTjA==
X-Gm-Message-State: AOAM5319wh+xBpVqDvQwIg/+FowiTeXdzgQsjHzu5gnPLFnrWXx+TkPH
        aB//P4R0oZsA5jpkQ4uxfpU=
X-Google-Smtp-Source: ABdhPJygrl/haH7pbXPtDzWtxot8BYiChyTk8pdHTkwUk4M3M9zHg8UjJ43gYRHsdFBxrz3lAl5JIQ==
X-Received: by 2002:a5d:6186:: with SMTP id j6mr10350781wru.115.1629287002647;
        Wed, 18 Aug 2021 04:43:22 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.2])
        by smtp.gmail.com with ESMTPSA id c7sm4581918wmq.13.2021.08.18.04.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 04:43:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/3] tw mutex & IRQ rw completion batching
Date:   Wed, 18 Aug 2021 12:42:44 +0100
Message-Id: <cover.1629286357.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In essence, it's about two features. The first one is implemented by
1-2 and saves ->uring_lock lock/unlock in a single call of
tctx_task_work(). Should be useful for links, apolls and BPF requests
at some moment.

The second feature (3/3) is batching freeing and completing of
IRQ-based read/write requests.

Haven't got numbers yet, but just throwing it for public discussion.

P.S. for the new horrendous part of io_req_task_complete() placing
state->compl_reqs and flushing is temporary, will be killed by other
planned patches.

Pavel Begunkov (3):
  io_uring: flush completions for fallbacks
  io_uring: batch task work locking
  io_uring: IRQ rw completion batching

 fs/io_uring.c | 103 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 69 insertions(+), 34 deletions(-)

-- 
2.32.0

