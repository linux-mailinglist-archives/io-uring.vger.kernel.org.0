Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06734178D4
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344635AbhIXQhc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347584AbhIXQgm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:36:42 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BA2C0617BC
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:47 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id ee50so38224513edb.13
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aM2DvxedSyxmPyluuSIjdTUJVWHKYl6F+53Wg27XMYY=;
        b=azz7hhpM15yyx9iiz5E5jgvoPsL+dtw+BBSXFYDdffLGg+o4RZD4tE7OPdc0RM9jKk
         9UraodHI4a+zegTwKh8JSAHobFhHeMcmp1Eb/LRXOcT7dCgO/r5uvNOMsAIr+IwniHVH
         xn1gJqANb2dxaW4sBwgVFUOKdeSRVCg5wjvMouyRw0wT+5C4i8/vZR+R/DhLXmLndJRV
         4wefUw1HcLwqHbgrIG2wVk6q8PEy5+/s4F+BjFdFLGTvYCTMIcmTvDBfsr4x0Q7NFE6y
         lneRQTHbBb15k4ymn5xbyDXvuSUuu7ljDVfm8Vykbcl2jstCdlCHuN3M1mG/6mX6f6nd
         NJPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aM2DvxedSyxmPyluuSIjdTUJVWHKYl6F+53Wg27XMYY=;
        b=LEVIBRok9sXgK7lnf3BNBvp5fFROnaAAYar2MtsrQdcE+WGvwRL43W+EaOG+eMw9up
         xT5+hrEHiG5MQ/4RMu29XCejxzvOo802k2Aedg5sGUx7ri71tbtKVyO+b1Nt7R5XZBk/
         +ypExFtGj3JZ6FQC6Qko1+cOoQP8zuIhT1zRKitZiyb4XNFlw3j5uTWyD+IwQ1sme86z
         EMCZP1u6i/J3Ts9TJj8YWtWEt4KtUX0aVqURlrE8a30TNxkq1NEwaPhSbZw8++MqAIzW
         0K99t2jWnyx1j8TUiSYOkrgiUQYCC4NHcPkin2j9tMuZannB8eOT388wEhmihUyqgSGu
         9ATQ==
X-Gm-Message-State: AOAM532+G8OK0Gf/84ggtIwvzR1H4DHZhhuKEncp/IGJ+udB5YXTjS1S
        EN8KZ/W41vUnZUFPR1igW07S0a6JQB0=
X-Google-Smtp-Source: ABdhPJyqjLDwlckuZfUvNeLBlxpG11nrrP4CA3cEY8PQb1T5QWsCM0zZpOX+mQ3HhHe8FuUPYDbwCQ==
X-Received: by 2002:a17:906:1289:: with SMTP id k9mr12407947ejb.2.1632501166372;
        Fri, 24 Sep 2021 09:32:46 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:32:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [RFC][PATCHSET 00/23] rework/optimise submission+completion paths
Date:   Fri, 24 Sep 2021 17:31:38 +0100
Message-Id: <cover.1632500264.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

tested with fio/t/io_uring nops all batching=32:
24 vs 31.5 MIOPS, or ~30% win

WARNING: there is one problem with draining, will fix in v2

There are two parts:
1-14 are about optimising the completion path:
- replaces lists with single linked lists
- kills 64 * 8B of caches in ctx
- adds some shuffling of iopoll bits
- list splice instead of per-req list_add in one place
- inlines io_req_free_batch() and other helpers

15-22: inlines __io_queue_sqe() so all the submission path
up to io_issue_sqe() is inlined + little tweaks


Pavel Begunkov (23):
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

 fs/io-wq.h    |  60 +++++-
 fs/io_uring.c | 503 +++++++++++++++++++++++---------------------------
 2 files changed, 283 insertions(+), 280 deletions(-)

-- 
2.33.0

