Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8716840FAA0
	for <lists+io-uring@lfdr.de>; Fri, 17 Sep 2021 16:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhIQOq1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Sep 2021 10:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhIQOpx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Sep 2021 10:45:53 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16A8C061764
        for <io-uring@vger.kernel.org>; Fri, 17 Sep 2021 07:44:30 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id a22so12484080iok.12
        for <io-uring@vger.kernel.org>; Fri, 17 Sep 2021 07:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=+L7ROLwGNbEc6N0aiE0xTqt2AcozCRFG1j8eIZyaeZ4=;
        b=TpTWN8umAVC+xG81DJGOpPRSZ/u7cFMgDVDoru9uUHP481EuareWcKU33FudyXQ/2X
         lG2XB8WLXppCZ4bHocAKkH+bsQ4yb3JW8xtmsmWusrVjRCVTgp+9x4spaq4hGPAh+Vxd
         k1h9Ueg5ijWMxeptntxoEo818uHTU3p2gN1kGROejHbePNiYGryZXOwaEikH5fmvYBo0
         nQq5D/iJ0TbSSEqzj8F7KfhRCyAxHqBLvjZXfW0BFkPUwGF4w+rlwOWjBVOqrEoghwcs
         5Nbb/08PjhKR5RgZKYEN23oEtoZn727wIDRDORgP/OnV0pfjAGMsggUl+uKZ+QP28m6R
         TX6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=+L7ROLwGNbEc6N0aiE0xTqt2AcozCRFG1j8eIZyaeZ4=;
        b=OKWgAGrt82CGWEhhmM1QMwh7Sw+ZHsRPI3Qj+LQI8OE8r0gZK08u+2rBYaS8uqbck5
         i/QjvYWMrhYTKNb8O6cUt5SZO7MUHw+o5k7KxMpOrAhEYKkr2dpyS8obcgxuIztIrfDq
         z0U4IrcGt45RVCwQZlpYaaj7uhRPsL5Ff5DJlUjuozaxtyiRIllCexyJHToASkjOp0Lk
         uJrGxf3lLH3XY8kelIe4RuA+6BIbofYZIvYaux94FmfTjfsSWTUiVcUb/So+lDGUDPAg
         vZ44dWh0X8roknQIjgQnGY9sqzDU10WfkMeMcA13SUmb1zH9CF7G5B+RopqnVA2GSawV
         ktTg==
X-Gm-Message-State: AOAM5338h4C22lt+ga/GjobDFbr053dJjs9d1clNlIxfGfeXKBq8Xx0l
        90J/mh9GMg/6/Kd1gjCtCiQ3ob1KrLJ8rqKjvUI=
X-Google-Smtp-Source: ABdhPJz3wGDOe7gB0XwGRpbkzCxHp5I+3wV0F6yV1FxVWFLfmnWuyP1Ii5hJaOlJdWXHg27yXE6/TA==
X-Received: by 2002:a02:b605:: with SMTP id h5mr9141942jam.119.1631889870022;
        Fri, 17 Sep 2021 07:44:30 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f3sm3737650iow.3.2021.09.17.07.44.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Sep 2021 07:44:29 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.15-rc2
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Message-ID: <a80f867d-ae3f-02d4-405d-2e9e0fa56439@kernel.dk>
Date:   Fri, 17 Sep 2021 08:44:28 -0600
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

Mostly fixes for regressions in this cycle, but also a few fixes that
predate this release. The odd one out is a tweak to the direct files
added in this release, where attempting to reuse a slot is allowed
instead of needing an explicit removal of that slot first. It's a
considerable improvement in usability to that API, hence I'm sending it
for -rc2.

- io-wq race fix and cleanup (Hao)

- loop_rw_iter() type fix

- SQPOLL max worker race fix

- Allow poll arm for O_NONBLOCK files, fixing a case where it's
  impossible to properly use io_uring if you cannot modify the file
  flags

- Allow direct open to simply reuse a slot, instead of needing it
  explicitly removed first (Pavel)

- Fix a case where we missed signal mask restoring in cqring_wait, if we
  hit -EFAULT (Xiaoguang)

Please pull!


The following changes since commit 6880fa6c56601bb8ed59df6c30fd390cc5f6dd8f:

  Linux 5.15-rc1 (2021-09-12 16:28:37 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.15-2021-09-17

for you to fetch changes up to 5d329e1286b0a040264e239b80257c937f6e685f:

  io_uring: allow retry for O_NONBLOCK if async is supported (2021-09-14 11:09:42 -0600)

----------------------------------------------------------------
io_uring-5.15-2021-09-17

----------------------------------------------------------------
Eugene Syromiatnikov (1):
      io-wq: provide IO_WQ_* constants for IORING_REGISTER_IOWQ_MAX_WORKERS arg items

Hao Xu (2):
      io-wq: code clean of io_wqe_create_worker()
      io-wq: fix potential race of acct->nr_workers

Jens Axboe (3):
      io_uring: ensure symmetry in handling iter types in loop_rw_iter()
      io_uring: pin SQPOLL data before unlocking ring lock
      io_uring: allow retry for O_NONBLOCK if async is supported

Pavel Begunkov (1):
      io_uring: auto-removal for direct open/accept

Xiaoguang Wang (1):
      io_uring: fix missing sigmask restore in io_cqring_wait()

 fs/io-wq.c                    |  27 ++++++-----
 fs/io_uring.c                 | 105 +++++++++++++++++++++++++++---------------
 include/uapi/linux/io_uring.h |   8 +++-
 3 files changed, 88 insertions(+), 52 deletions(-)

-- 
Jens Axboe

