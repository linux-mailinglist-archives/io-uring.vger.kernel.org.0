Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8281297D16
	for <lists+io-uring@lfdr.de>; Sat, 24 Oct 2020 17:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760890AbgJXPNg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 24 Oct 2020 11:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760887AbgJXPNf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 24 Oct 2020 11:13:35 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3014DC0613CE
        for <io-uring@vger.kernel.org>; Sat, 24 Oct 2020 08:13:35 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o1so803763pjt.2
        for <io-uring@vger.kernel.org>; Sat, 24 Oct 2020 08:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=xYdTJcIhuMX4J21lerIfFWuYJafeMxGPcZ58YQMTDXY=;
        b=OKbqc49FjAC7C3uixgSUlnRbWODWzQ2F0tdwRVclyAPdieHu1+rjhId0Cd8eryjUMz
         CkTAx1jOZV/9/BTxvenI6/znEKxeT3IinqPm0pKC/eOSv9VICej1cMaLOXUB/C/FjYil
         +MRyswMEt+Yxc0+CUpKaUPfCckMAaFsaR5X9my29heSMTe5NjbdKCBW5MyboOPYlTrd6
         L67ss+d4S3lpKBLUwM58zL4RSvAf7yipjYOQhKyo2yQgwJK+sk8x7g7aJURqpmB6BAWb
         /aEZpVRZIuBWntk10fCoADFkWBXpgVFT95kxJh0UuRMD9vTDpQBpkiLVJ4NM4UgJjCvG
         tyVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=xYdTJcIhuMX4J21lerIfFWuYJafeMxGPcZ58YQMTDXY=;
        b=AGNlW6NQWoMRoFmWnaLqkVKYEMcjVntpW1kUALTwxYMDlkwXoYcntZrJ3BucEu8OOb
         ld7c7PghebJs+PBrEUbL+7TS3v9jGLKXOiXar9NrcHZeIEXwkOY23TC7avNo6ou3ZXOY
         taQTY1N/GK0CXTE4kulEhMoRLNDt4scbcW6DlgSZFuQXy3p3WfUrelzn8JjQ22u+gX8G
         vMqtVwWkqR4lAWg8kzlAfYXFhfpIfH2kTrYl32QmGDF0MXSzr8SthnGCn5fCfIDSZK/L
         w61TfYiUKH9zEKgaN4BRNWhLReHU7k458YRG6AQBlOh4jQ48l9PiHS0EQWnTRBhXonx1
         49EQ==
X-Gm-Message-State: AOAM530g/BxWePzlo0Ph/atO54Ic94ubryf3Kn8B9/Tuq0T5RF+B93Sd
        RGuDq/6jWKaxtZx82h0fBBxZMKUoDgX9rg==
X-Google-Smtp-Source: ABdhPJydcLyBumfi/Qws9T5CL09x+d3rGJkSMSJ8ZUw7JY4FNFm4YFBSbEeuDDBB1PMs7PqfBCAifQ==
X-Received: by 2002:a17:902:8e89:b029:d5:fefd:9637 with SMTP id bg9-20020a1709028e89b02900d5fefd9637mr4812758plb.39.1603552414650;
        Sat, 24 Oct 2020 08:13:34 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s4sm6332119pjp.17.2020.10.24.08.13.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Oct 2020 08:13:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.10-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <1f4b24d8-e9f3-e74b-02be-e0483dc45b42@kernel.dk>
Date:   Sat, 24 Oct 2020 09:13:33 -0600
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

Set of fixes that should go into -rc1:

- fsize was missed in previous unification of work flags

- Few fixes cleaning up the flags unification creds cases (Pavel)

- Fix NUMA affinities for completely unplugged/replugged node for io-wq

- Two fallout fixes from the set_fs changes. One local to io_uring, one
  for the splice entry point that io_uring uses.

- Linked timeout fixes (Pavel)

- Removal of ->flush() ->files work-around that we don't need anymore
  with referenced files (Pavel)

- Various cleanups (Pavel)

Please pull!


The following changes since commit 9ba0d0c81284f4ec0b24529bdba2fc68b9d6a09a:

  io_uring: use blk_queue_nowait() to check if NOWAIT supported (2020-10-19 07:32:36 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-10-24

for you to fetch changes up to ee6e00c868221f5f7d0b6eb4e8379a148e26bc20:

  splice: change exported internal do_splice() helper to take kernel offset (2020-10-22 14:15:51 -0600)

----------------------------------------------------------------
io_uring-5.10-2020-10-24

----------------------------------------------------------------
Jens Axboe (4):
      io_uring: unify fsize with def->work_flags
      io-wq: re-set NUMA node affinities if CPUs come online
      io_uring: make loop_rw_iter() use original user supplied pointers
      splice: change exported internal do_splice() helper to take kernel offset

Pavel Begunkov (10):
      io_uring: flags-based creds init in queue
      io_uring: kill ref get/drop in personality init
      io_uring: inline io_fail_links()
      io_uring: make cached_cq_overflow non atomic_t
      io_uring: remove extra ->file check in poll prep
      io_uring: inline io_poll_task_handler()
      io_uring: do poll's hash_node init in common code
      io_uring: fix racy REQ_F_LINK_TIMEOUT clearing
      io_uring: don't reuse linked_timeout
      io_uring: remove req cancel in ->flush()

 fs/io-wq.c             |  68 +++++++++++++++++--
 fs/io-wq.h             |   1 +
 fs/io_uring.c          | 173 ++++++++++++++++++++++---------------------------
 fs/splice.c            |  63 ++++++++++++++----
 include/linux/splice.h |   4 +-
 5 files changed, 191 insertions(+), 118 deletions(-)

-- 
Jens Axboe

