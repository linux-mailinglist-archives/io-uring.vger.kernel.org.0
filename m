Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F19D1F6F7E
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2020 23:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgFKVf0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Jun 2020 17:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbgFKVf0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Jun 2020 17:35:26 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FF2C08C5C1
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2020 14:35:24 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id m2so2914694pjv.2
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2020 14:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=jYhsRw+x2h3yVSINWDasBRC/3u0YL3yghV7G1msGuR4=;
        b=un0XfoiDgSk4wtPUKLmHvaXQpKehMEh5W496xGe1kRdp16yYLb3iMN7OlsJQdbDUqG
         wvtgiZ3CkfBI2Vx31Zi767jvOgp1CfhiyIHSkyzomGkhjEw14+maecf1VuFOe2bFm4kt
         jVhp6C8bel81wvlwStrRpPAFRcCCSHe6873WhL3LS9tMLxIMvyxD3U4y/HdSLA04YfVX
         iu4n2GmjrFdLXrx92itNoryNJvqgI/yngY+LvKPx/OgeUdcVv8bflL7cV+C3C/5GeGJL
         6otbzy0mqN1+/KgXJcJoU8g05XCafp3YXYtME3fE7fDNnb2cq2m57H6AlnnX3yKHJEKf
         a5og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=jYhsRw+x2h3yVSINWDasBRC/3u0YL3yghV7G1msGuR4=;
        b=muaD7a/x1p6zfiEMRDHXHobesVD1iTTz9WSZlvJX7EKZvLtbR84X7kLRnkpYI/z1b2
         35/htijuus95mn1KPr2sOf/mz8eU7JspFzrFJBVg+RDulVu7NhsEDSLxIRADJ0pYlrv9
         9AWubnb4qiWw/oDnr2DpNAnZqAqfzQdYDKmVUlKElbwMR+ywKAE1fLC6ywNF/HH5ui6R
         ujQ+zzlcvGGXPkxKwNAiz8w/M21EaAhrEhz45ouJD+pm+nVRSqoYs/5GHXFHVy1crOvn
         ZDf/ehRghbhW4CYKlei6dGpbtMBU4kgb2djpyXoQ199gknWmGXm/9JtsMIJ4mVkgpVDk
         1TVA==
X-Gm-Message-State: AOAM533gm7xgpXHNn+A3ppduCBrdTP//FvDs0k00iv2FR4VEM1Q7RuPs
        0QvyajnjUAhofZWKx9E4Dt7H9P28fWOloQ==
X-Google-Smtp-Source: ABdhPJy5zd/3yYQcwfqRlrE+wFjsgiDmvvDuslpeFCJBBqEgSdOVIihwI6XBdxBumxneVZwEWT0KLQ==
X-Received: by 2002:a17:90a:1117:: with SMTP id d23mr9982887pja.136.1591911324223;
        Thu, 11 Jun 2020 14:35:24 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id nl8sm3786740pjb.13.2020.06.11.14.35.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2020 14:35:23 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.8-rc1
Message-ID: <75aa6bc8-488a-07dd-feea-545500e51966@kernel.dk>
Date:   Thu, 11 Jun 2020 15:35:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A few late stragglers in here. In particular:

- Validate full range for provided buffers (Bijan)

- Fix bad use of kfree() in buffer registration failure (Denis)

- Don't allow close of ring itself, it's not fully safe. Making it fully
  safe would require making the system call more expensive, which isn't
  worth it.

- Buffer selection fix

- Regression fix for O_NONBLOCK retry

- Make IORING_OP_ACCEPT honor O_NONBLOCK (Jiufei)

- Restrict opcode handling for SQ/IOPOLL (Pavel)

- io-wq work handling cleanups and improvements (Pavel, Xiaoguang)

- IOPOLL race fix (Xiaoguang)

Please pull!

The following changes since commit 1ee08de1e234d95b5b4f866878b72fceb5372904:

  Merge tag 'for-5.8/io_uring-2020-06-01' of git://git.kernel.dk/linux-block (2020-06-02 15:42:50 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.8-2020-06-11

for you to fetch changes up to 65a6543da386838f935d2f03f452c5c0acff2a68:

  io_uring: fix io_kiocb.flags modification race in IOPOLL mode (2020-06-11 09:45:21 -0600)

----------------------------------------------------------------
io_uring-5.8-2020-06-11

----------------------------------------------------------------
Bijan Mottahedeh (1):
      io_uring: validate the full range of provided buffers for access

Denis Efremov (1):
      io_uring: use kvfree() in io_sqe_buffer_register()

Jens Axboe (3):
      io_uring: disallow close of ring itself
      io_uring: re-set iov base/len for buffer select retry
      io_uring: allow O_NONBLOCK async retry

Jiufei Xue (1):
      io_uring: check file O_NONBLOCK state for accept

Pavel Begunkov (8):
      io_uring: fix {SQ,IO}POLL with unsupported opcodes
      io_uring: do build_open_how() only once
      io_uring: deduplicate io_openat{,2}_prep()
      io_uring: move send/recv IOPOLL check into prep
      io_uring: don't derive close state from ->func
      io_uring: remove custom ->func handlers
      io_uring: don't arm a timeout through work.func
      io_wq: add per-wq work handler instead of per work

Xiaoguang Wang (3):
      io_uring: avoid whole io_wq_work copy for requests completed inline
      io_uring: avoid unnecessary io_wq_work copy for fast poll feature
      io_uring: fix io_kiocb.flags modification race in IOPOLL mode

 fs/io-wq.c    |  10 +-
 fs/io-wq.h    |   8 +-
 fs/io_uring.c | 424 ++++++++++++++++++++++++++--------------------------------
 3 files changed, 201 insertions(+), 241 deletions(-)

-- 
Jens Axboe

