Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA5348B9D9
	for <lists+io-uring@lfdr.de>; Tue, 11 Jan 2022 22:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239779AbiAKVrD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jan 2022 16:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbiAKVrD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jan 2022 16:47:03 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3664CC06173F
        for <io-uring@vger.kernel.org>; Tue, 11 Jan 2022 13:47:03 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id o7so766932ioo.9
        for <io-uring@vger.kernel.org>; Tue, 11 Jan 2022 13:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=cZk48kd6bA2PV4kFyQg1ywtY0+Zzl3UKJpARdClfP80=;
        b=e9l+Yz+4sj0Ebhv168lFVNCXu3aIUNEgXbh5U98YESD2vwlPHxbmnAIFD2jkM5xDs0
         k1pzrlwK/HM24x8DuPQdQXcUPlmQh0FR3brTh0x5jLYEPHU85ALIp1UvOnjgwihxLd+6
         ce8eSqRZRx6w5HQcGnO4WZ7uQu/8u2iQMSj6cMJHgd9tmoGHl4Fbi5DcJUwOJYVC5jb0
         aR2rZccpofvty2Y1i95Cph7RKzPmhISd3H5FJDYyEbAHT38aM21Pc1bsV2IWvvMDTK/8
         FUnVP55KfXjPJ7RGNmDG1MK8sn6cXcoLnDp5ZuWQ6slBrA7kfv0DIK0wha/p3w94EpUk
         //TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=cZk48kd6bA2PV4kFyQg1ywtY0+Zzl3UKJpARdClfP80=;
        b=pV2dGLr5eGDdHiKmloMzB7YFOa3w/d+8AKw3PcdoaaIktfeBbNa+ymom1LJNcUxWsT
         Q42MAOUNTAd2xzknsP34avHSB2Han0RHScRtvG69c/xLiXf89W7JcPe9BHkLY4n+CZyW
         tS8S+1M3cWUAoYGS8ekyYb3E9hKsLoJLMnXWWj98D3kaNat4ZY3qnJG5Xz6hhodADOQg
         V3IkYnBS2KwJsUoMGYumv8iDpHdfeCgpthB9tvaXeU911lzoVqh4zxSnI7cmjZKIm31G
         jjTx1iPvJ25Obqs5lQUYgZZYsYFSnZTtvA8u+P60VfR0cdkTuhCCh9OpNLdwQnUDwsKs
         xeJw==
X-Gm-Message-State: AOAM530N1oZfsZnL7AcGc3EXhxcMNtM5ozOWrTBcVpp1HnQyZx4WDK3l
        c9vJ+kAEvxCRIGLwgNUaIDX2KrzvVrL0sQ==
X-Google-Smtp-Source: ABdhPJyWSRCZiS9XdzD9LYkjOx9pWykKdu0zM2rgDu51b/V6UQJ7tYsWhxxBtan9fzT5cKAsVGldeQ==
X-Received: by 2002:a05:6602:160b:: with SMTP id x11mr3256650iow.211.1641937622318;
        Tue, 11 Jan 2022 13:47:02 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a8sm6154319ila.87.2022.01.11.13.47.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 13:47:01 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring updates for 5.17-rc
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Message-ID: <b5dc115b-b549-aa6d-6845-3244660ee680@kernel.dk>
Date:   Tue, 11 Jan 2022 14:47:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Here are the io_uring changes scheduled for this merge window. This pull
request contains:

- Support for prioritized work completions (Hao)

- Simplification of reissue (Pavel)

- Add support for CQE skip (Pavel)

- Memory leak fix going to 5.15-stable (Pavel)

- Re-write of internal poll. This both cleans up that code, and gets us
  ready to fix the POLLFREE issue (Pavel)

- Various cleanups (GuoYong, Pavel, Hao)

You'll hit a trivial merge conflict pulling this due to a function name
change in 5.16-late.

Please pull!


The following changes since commit 136057256686de39cc3a07c2e39ef6bc43003ff6:

  Linux 5.16-rc2 (2021-11-21 13:47:39 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/for-5.17/io_uring-2022-01-11

for you to fetch changes up to 3cc7fdb9f90a25ae92250bf9e6cf3b9556b230e9:

  io_uring: fix not released cached task refs (2022-01-09 09:22:49 -0700)

----------------------------------------------------------------
for-5.17/io_uring-2022-01-11

----------------------------------------------------------------
GuoYong Zheng (2):
      io_uring: remove unused function parameter
      io_uring: remove redundant tab space

Hao Xu (9):
      io_uring: fix no lock protection for ctx->cq_extra
      io_uring: better to use REQ_F_IO_DRAIN for req->flags
      io_uring: move up io_put_kbuf() and io_put_rw_kbuf()
      io-wq: add helper to merge two wq_lists
      io_uring: add a priority tw list for irq completion work
      io_uring: add helper for task work execution code
      io_uring: split io_req_complete_post() and add a helper
      io_uring: batch completion in prior_task_list
      io_uring: code clean for some ctx usage

Pavel Begunkov (19):
      io_uring: simplify reissue in kiocb_done
      io_uring: improve send/recv error handling
      io_uring: clean __io_import_iovec()
      io_uring: improve argument types of kiocb_done()
      io_uring: clean cqe filling functions
      io_uring: add option to skip CQE posting
      io_uring: don't spinlock when not posting CQEs
      io_uring: disable drain with cqe skip
      io_uring: simplify selected buf handling
      io_uring: tweak iopoll CQE_SKIP event counting
      io_uring: reuse io_req_task_complete for timeouts
      io_uring: remove double poll on poll update
      io_uring: refactor poll update
      io_uring: move common poll bits
      io_uring: kill poll linking optimisation
      io_uring: poll rework
      io_uring: single shot poll removal optimisation
      io_uring: use completion batching for poll rem/upd
      io_uring: fix not released cached task refs

Ye Bin (1):
      io_uring: validate timespec for timeout removals

 fs/io-wq.h                    |   22 +
 fs/io_uring.c                 | 1140 +++++++++++++++++++++--------------------
 include/uapi/linux/io_uring.h |    4 +
 3 files changed, 612 insertions(+), 554 deletions(-)

-- 
Jens Axboe

