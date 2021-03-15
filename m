Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0406133C337
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 18:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235689AbhCORC6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 13:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234777AbhCORCC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 13:02:02 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214C6C06174A
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 10:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=vtty5IpP2oK2LJohAC8vSmzn3W4EcicaPi9Ux/Qfoqg=; b=dT6K089WeUGHCJjnLMK/HhJf+/
        Uo/I4UxZ3XA0sB2bQgrPqyy/ecSQh3bOQTx7jqKqFUq/HgSoVO0bMQApts6aVBa2qyEDeKKORGJmK
        JemoCCu5pqlTXHxyEAMkoEBhZlyEiAPB6S+xB7BF2LFwjkfGITg6HZoHltRT3NfV39vW4DlIQuKdF
        SdHacXbsSKEsPVYcGL3NGvjj3ZeAj0uTKoHiFpk6CUcaSgmRQ/DTMWIqntD/LN0I/nJVsxmitFjyr
        wBdqywge924Wok4IrsrUYmRy9ZHQ/j8I9jcaMW/WjmW5iZZhpsXghHGKWNjofEZm/OVRlrpa1HHOp
        8vsEwHs8eeOTmUc+0vjao2PTemgohVY6DFdhiX+Czclg13BpIWG/8mO1RkDXzyuXrxIcBGCvUNtaG
        3aoLzy44fodCO6nmC3oWaOk9y/I5wNcU1MmxcoVySOWTKi4tk0pnMRkfuB5KTZoLATwTJBRpfgQWT
        gT5VSrNJ3+tovWae1BFAvAMc;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lLqbP-00056L-Lb; Mon, 15 Mar 2021 17:01:59 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [RFC PATCH 00/10] Complete setup before calling wake_up_new_task() and improve task->comm
Date:   Mon, 15 Mar 2021 18:01:38 +0100
Message-Id: <cover.1615826736.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

now that we have an explicit wake_up_new_task() in order to start the
result from create_io_thread(), we should things up before calling
wake_up_new_task().

There're also some improvements around task->comm:
- We return 0 bytes for /proc/<pid>/cmdline
- We no longer allow a userspace process to change
  /proc/<pid>/[task/<tid>]/comm
- We dynamically generate comm names (up to 63 chars)
  via io_wq_worker_comm(), similar to wq_worker_comm()

While doing this I noticed a few places we check for
PF_KTHREAD, but not PF_IO_WORKER, maybe we should
have something like a PS_IS_KERNEL_THREAD_MASK() macro
that should be used in generic places and only
explicitly use PF_IO_WORKER or PF_KTHREAD checks where the
difference matters.

There are also quite a number of cases where we use
same_thread_group(), I guess these need to be checked.
Should that return true if userspace threads and their iothreds
are compared?

I've compiled but didn't test, I hope there's something useful...

Stefan Metzmacher (10):
  kernel: always initialize task->pf_io_worker to NULL
  io_uring: io_sq_thread() no longer needs to reset
    current->pf_io_worker
  io-wq: call set_task_comm() before wake_up_new_task()
  io_uring: complete sq_thread setup before calling wake_up_new_task()
  io-wq: protect against future set_task_comm() overflows.
  io_uring: protect against future set_task_comm() overflows.
  fs/proc: hide PF_IO_WORKER in get_task_cmdline()
  fs/proc: protect /proc/<pid>/[task/<tid>]/comm for PF_IO_WORKER
  io-wq: add io_wq_worker_comm() helper function for dynamic
    proc_task_comm() generation
  fs/proc: make use of io_wq_worker_comm() for PF_IO_WORKER threads

 fs/io-wq.c      | 118 ++++++++++++++++++++++++++++++++++++++++++++----
 fs/io-wq.h      |   4 ++
 fs/io_uring.c   |  33 +++++++++-----
 fs/proc/array.c |   3 ++
 fs/proc/base.c  |  18 ++++++--
 kernel/fork.c   |   1 +
 6 files changed, 154 insertions(+), 23 deletions(-)

-- 
2.25.1

