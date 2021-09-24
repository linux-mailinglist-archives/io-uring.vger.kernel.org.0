Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C002417CA6
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346442AbhIXVCY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbhIXVCY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:24 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B140C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:50 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id bx4so40993289edb.4
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1hjwyKtQzgs6bspXRCKsY4DK7mP37s9NuDiUQX2aoKg=;
        b=TQ6hLXSsMtSJ7whhMuNRoc7uR8GBtnK7vHQookruUWLCvFchnQBJS94fEIQT29zKXM
         AtOiPtA88fZfU0wUJMQmhK5Rn+0XIs6nsNx5EN7uDDNNHoC+atfSqk0Kc5Gisp2QYrNq
         8grRVpl7cIG38A7U/BhNJkbvWoZqTSse1RtJKWEn2CzWFW4jLOvCVusDMIEF+BbwMlzp
         NqWtntZPHF/Dgggmgr5B7VfH0sDWyVAfCOK9oUpuYJBhsrv6XBXttpYVThKI1wUKamdv
         njgxP3nJTJU7uJox1NdgCop4aRQS0OP8B/20/SZlyjdvZYI12mHW8mmnD4RbNeRawEKX
         594w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1hjwyKtQzgs6bspXRCKsY4DK7mP37s9NuDiUQX2aoKg=;
        b=gxXFTzUR/H/Tqp1kXtqmPY3gwsbhxK3SfFK+LIAQf3A9YqTC3SW+9UGs9BZp0kx1Ts
         e3gn63lkzakdg+byYkElMrKot8NCA+SLAHTx6kRXI8RPBpwiypYSbQssIuonCjl4HkLu
         6Er16ryGKRFlqD3QLaPeUY/bdqj5RmpcVBxg+McgmQoTwYJk92Z03xE+BPEIzErAd6CF
         pCcVWIQ80bG05MLftyVcEhECMg7WXSPqSfkV6VVOobD6UGRqMvmOErNGPdB/psvfvSv2
         RTijdM/1/2Nio8WfNQDz3a4d6AR4m/r99wlFEZgVoboC/DjAWmFAbSL14UwH0zew8us7
         Z5jw==
X-Gm-Message-State: AOAM530hzkKR5TfmWwe7MeLeyp/KFJcM2nu+kPjLA/IqZaxnJllUi33u
        FSHUOze3qAdqzsmbNy86DKIn17WQsqU=
X-Google-Smtp-Source: ABdhPJy7aN31zZIsFhSV7KQ78W04l67yrkc9AleCu7/rtxivr1TTIsD3wDB4B4Wo3OVEOLwxzxAlJg==
X-Received: by 2002:a50:cfcb:: with SMTP id i11mr969404edk.347.1632517248933;
        Fri, 24 Sep 2021 14:00:48 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:00:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 00/24] rework and optimise submission+completion paths
Date:   Fri, 24 Sep 2021 21:59:40 +0100
Message-Id: <cover.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

24 MIOPS vs 31.5, or ~30% win for fio/t/io_uring nops batching=32
Jens mentioned that with his standard test against Optane it gave
yet another +3% to throughput.

1-14 are about optimising the completion path:
- replaces lists with single linked lists
- kills 64 * 8B of caches in ctx
- adds some shuffling of iopoll bits
- list splice instead of per-req list_add in one place
- inlines io_req_free_batch() and other helpers

15-22: inlines __io_queue_sqe() so all the submission path
up to io_issue_sqe() is inlined + little tweaks

v2: rebase for-5.16/io_uring

    multicqe_drain was hanging because it's a bit buggy, i.e. doesn't
    consider that requests may get punted, but still add 24th patch to
    avoid it.

Pavel Begunkov (24):
  io_uring: mark having different creds unlikely
  io_uring: force_nonspin
  io_uring: make io_do_iopoll return number of reqs
  io_uring: use slist for completion batching
  io_uring: remove allocation cache array
  io-wq: add io_wq_work_node based stack
  io_uring: replace list with stack for req caches
  io_uring: split iopoll loop
  io_uring: use single linked list for iopoll
  io_uring: add a helper for batch free
  io_uring: convert iopoll_completed to store_release
  io_uring: optimise batch completion
  io_uring: inline completion batching helpers
  io_uring: don't pass tail into io_free_batch_list
  io_uring: don't pass state to io_submit_state_end
  io_uring: deduplicate io_queue_sqe() call sites
  io_uring: remove drain_active check from hot path
  io_uring: split slow path from io_queue_sqe
  io_uring: inline hot path of __io_queue_sqe()
  io_uring: reshuffle queue_sqe completion handling
  io_uring: restructure submit sqes to_submit checks
  io_uring: kill off ->inflight_entry field
  io_uring: comment why inline complete calls io_clean_op()
  io_uring: disable draining earlier

 fs/io-wq.h    |  60 +++++-
 fs/io_uring.c | 508 +++++++++++++++++++++++---------------------------
 2 files changed, 287 insertions(+), 281 deletions(-)

-- 
2.33.0

