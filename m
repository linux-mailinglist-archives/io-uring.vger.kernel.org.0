Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4AE3ABA59
	for <lists+io-uring@lfdr.de>; Thu, 17 Jun 2021 19:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhFQRQm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Jun 2021 13:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbhFQRQl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Jun 2021 13:16:41 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CDDC061574
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:33 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id f16-20020a05600c1550b02901b00c1be4abso6881764wmg.2
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zbp/Dld44JaBO1R2DDZV0iKjQqTwEF0wtaWB3tGJ7jU=;
        b=LTp0mclbHwt/Wpg1kcuWZwE/x2EN1EsMHrqHTrRDP42WOLL+LVayka4HYANKJZeusK
         01kRq4NU4/Cxh9AtY8Itq70rChhP0oXR5h8NY5jSDwnJfE3l7AD2IkiLajWsak9OY0dV
         IBz2uNZQ4eN6o86aTCyw3V4sDwhKyJpeTj0GqbR3cYDP4ugoqXmoQecD2O7Zp1wcI1eN
         bjmJqQwW69N1vR0odiEFdJPj6YgYtAvIRo278nM/GhaglTxfCABLlOZQpSotWCZzN8P2
         HWfdb4rvslG9GiJYnmODziXpXtL8+KuPv125nmSB5/E2d/Hqlf1ZnblX20H6My1oNrZL
         lRxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zbp/Dld44JaBO1R2DDZV0iKjQqTwEF0wtaWB3tGJ7jU=;
        b=Dvv41y4TRLtMBRPZgTAMhv+NstolABVsG67Z/pGysOD4M8pvAceaKl7dSwcLqYG3tJ
         lOYtc3Y7Q/JFg847begjij9MMaly/DuoQPPfubgkPPNbz60O6lPHiPR+ngDVmXxiosW4
         byQLbFZnhsMqf/Zy2vo6KvCQaWjTxQ2i2pvNPHZFfQZN9gsV0Sm7kvu6GXHt+Uue81bi
         zfw9+DAHf+nB8nFISCCJ2Vz3ejIWUIBstCwnhj/NpNZOLWSb15R31ykPljVVnIu+UMGt
         oQMoumJ88w+RucUVxxnbLBWzqIh4A1T+vNdOAs/v6woCwaiKCYR8c/IK4pygeq4qk8CB
         sssA==
X-Gm-Message-State: AOAM531Z9bwAFQmYElISt888s4aLuxnjT2NVCxBOYPM4xLx/JSZqSzm4
        dkH+CxPpYt2q7MaJfGtLjcYFHlqgsguraQ==
X-Google-Smtp-Source: ABdhPJxOk0jXizPkaZ7v8H+7LEhoDuH1mFpDCNbsd8vr6oXunv2FpYojBKISx6N5Rilwev5kD7fDqw==
X-Received: by 2002:a7b:c394:: with SMTP id s20mr6480647wmj.24.1623950072463;
        Thu, 17 Jun 2021 10:14:32 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id g17sm6208033wrp.61.2021.06.17.10.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 10:14:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next 00/12] another round of 5.14 optimisations
Date:   Thu, 17 Jun 2021 18:13:58 +0100
Message-Id: <cover.1623949695.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1-7 are random patches.

8-12 are optimisations for running req-backed task works. For task_work
and/or linking heavy use cases, also should make io_req_task_work_add()
called from inside of tctx_task_work() much lighter.

Pavel Begunkov (12):
  io_uring: fix false WARN_ONCE
  io_uring: refactor io_submit_flush_completions()
  io_uring: move creds from io-wq work to io_kiocb
  io_uring: track request creds with a flag
  io_uring: simplify iovec freeing in io_clean_op()
  io_uring: clean all flags in io_clean_op() at once
  io_uring: refactor io_get_sequence()
  io_uring: inline __tctx_task_work()
  io_uring: optimise task_work submit flushing
  io_uring: refactor tctx task_work list splicing
  io_uring: don't resched with empty task_list
  io_uring: improve in tctx_task_work() resubmission

 fs/io-wq.c    |   5 +-
 fs/io-wq.h    |   1 -
 fs/io_uring.c | 134 +++++++++++++++++++++++++-------------------------
 3 files changed, 71 insertions(+), 69 deletions(-)

-- 
2.31.1

