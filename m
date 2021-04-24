Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE71036A393
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 01:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbhDXX1M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 24 Apr 2021 19:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbhDXX1K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 24 Apr 2021 19:27:10 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74E5C061574
        for <io-uring@vger.kernel.org>; Sat, 24 Apr 2021 16:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=Qa49ru3tr2Ruzg+RyqK06FZnXXKocYRzJqRAX/emBW4=; b=GQkRc2r8Xu3zK+k3C/FnoAWrNU
        aN81ZFRbClEvFmq8hoKYDd+lAVfmJFAiIFe0AeSLNjVEoe68q/A8n/Exhc3TK4LVNPjuFH4zRdP9f
        SEOkvD61vOYF+fri4evlLRQQaIVcsG9WEbW2fQigkqqy51qdclqukYKBM+LkDXPsnKVvPTn9FT7Jf
        89MJJM0hFlHAv03Y0EnXydclbP+cOBnXJQkvAYoM8l9dMf8Zs+LGu9Vf1SRoK1ZY6KuP6gty+OjCh
        vUfm0p3skg0H35ZUIF0P60Bb3atybewroIkZBewf896/lxUN++1q0mJRwjH85puvhX1cqdE5f6i3t
        AVkM6fRudbiH141n2v9Yh7c0K2kX+jo2qJ5mq5aUVL+RWj5s6B6vuifESZkiMeTRtn6TZTS4ghesa
        xX2/AJ8b7Lw4M/bWZMV4v0WDQqQ2x0TmwfuQL0bpih1u4GKj2Wp9uE4npLqgDlRGlkIXeXZcvAGWC
        rYfIhSFDXulNtPuJr2lng20q;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1laRfI-0007Vd-G1; Sat, 24 Apr 2021 23:26:20 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v3 0/6] Complete setup before calling wake_up_new_task()
Date:   Sun, 25 Apr 2021 01:26:02 +0200
Message-Id: <cover.1619306115.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

now that we have an explicit wake_up_new_task() in order to start the
result from create_io_thread(), we should set things up before calling
wake_up_new_task().

Changes in v3:
 - rebased on for-5.13/io_uring.
 - I dropped this:
  fs/proc: hide PF_IO_WORKER in get_task_cmdline()
 - I added:
  set_task_comm() overflow checks

Changes in v2:

- I dropped/deferred these changes:
  - We no longer allow a userspace process to change
    /proc/<pid>/[task/<tid>]/comm
  - We dynamically generate comm names (up to 63 chars)
    via io_wq_worker_comm(), similar to wq_worker_comm()

Stefan Metzmacher (6):
  kernel: always initialize task->pf_io_worker to NULL
  io_uring: io_sq_thread() no longer needs to reset
    current->pf_io_worker
  io-wq: call set_task_comm() before wake_up_new_task()
  io_uring: complete sq_thread setup before calling wake_up_new_task()
  io-wq: warn about future set_task_comm() overflows.
  io_uring: warn about future set_task_comm() overflows.

 fs/io-wq.c    | 20 ++++++++++++++++----
 fs/io_uring.c | 34 +++++++++++++++++++++++-----------
 kernel/fork.c |  1 +
 3 files changed, 40 insertions(+), 15 deletions(-)

-- 
2.25.1

