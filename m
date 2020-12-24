Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A715C2E2441
	for <lists+io-uring@lfdr.de>; Thu, 24 Dec 2020 06:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725446AbgLXFId (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Dec 2020 00:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgLXFId (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Dec 2020 00:08:33 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39267C061794
        for <io-uring@vger.kernel.org>; Wed, 23 Dec 2020 21:07:53 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id s15so758354plr.9
        for <io-uring@vger.kernel.org>; Wed, 23 Dec 2020 21:07:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=NmwshT4pdaDEz5eKdc3Wncz4ablhnMQ/phyOFYW26hw=;
        b=Er/iRpfd4ZKWgHmd+goJlZBgTCztqCdLIPUbe0dl50nSMISIvqrhha25HUHUlWQvFN
         hX6vKcYiN6g2MtFOHSCBpH/Shx5Ju0xp8JrKkxMlfiECTwxDIkSjEsrti4JSdtpQ4o3H
         RjCuZXiIPMlfmfy8aSmfqXtE1II3GzK2pkYi6OdPNXH4JTym5a2pCfvDa5f0gasDZh/5
         2PFYP5wMnXLPq6F2fbLNxODT8J2Vv4O0L9KXjFNRaeQDYPZObZtgpn2Zh9fRyP2WiXQC
         sSD/w/liW0xohdUAK4eOaayxoF6XUGU4EKDKOK5vtd86Tuiiv2DA4SpO3sfhIDRUmuzZ
         5BgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=NmwshT4pdaDEz5eKdc3Wncz4ablhnMQ/phyOFYW26hw=;
        b=HQOoLOBkJtP4Q49S+0ij68nXi/cBSfZOjP7eud/aw3mAHiNtMhsn7W0i7u3eevEdQe
         071n791+Xs3HqIl0GHiTc2FRHuuT1P57tBOK1kctjGwu9kWhbdrUcxAQHwLQEoJRElBk
         gxDgJ+SlyOWhYBQiO9JyojCGqRhb8dtTPvFmfQYsl43rVgiJ/U2W50Eet90tpMk4E+Rx
         vtndh48LpWjGbG0W7p87TaVlBPUd1yKVsLEyTZx3KrTstbEkUa/1mMPvOJsTL3hG0ZMA
         3qkad3vVx0sNOF1GOVqnfxEMQADasY14lthBy6UtjxYH4EeJRGjZPtZVjB8/ZWzrLOdS
         0z4g==
X-Gm-Message-State: AOAM530WVkI8S/zuaI5fF5CYhlcrp41KevH7XrpawRQM34kJI2NOCEow
        la+1cU+0ttC/WbaTmCuOcPnPNMqpDN9hZw==
X-Google-Smtp-Source: ABdhPJy0xBzTAE/DhjFWRbWjH+YFuPbE/mPmiOXKEHBZib/VRyXLoCihHSORFtSabjUrVs0HRFX82A==
X-Received: by 2002:a17:90b:90f:: with SMTP id bo15mr2741129pjb.148.1608786472376;
        Wed, 23 Dec 2020 21:07:52 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u3sm1240814pjf.52.2020.12.23.21.07.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Dec 2020 21:07:51 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.11-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Message-ID: <fa99db76-1b26-d6e1-3e73-0765a5fb54d3@kernel.dk>
Date:   Wed, 23 Dec 2020 22:07:49 -0700
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

Fixes that should go into 5.11-rc1. All straight fixes, or a prep patch
for a fix, either bound for stable or fixing issues from this merge
window. In particular:

- Fix new shutdown op not breaking links on failure

- Hold mm->mmap_sem for mm->locked_vm manipulation

- Various cancelation fixes (me, Pavel)

- Fix error path potential double ctx free (Pavel)

- IOPOLL fixes (Xiaoguang)

Please pull!

 
The following changes since commit 009bd55dfcc857d8b00a5bbb17a8db060317af6f:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma (2020-12-16 13:42:26 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.11-2020-12-23

for you to fetch changes up to c07e6719511e77c4b289f62bfe96423eb6ea061d:

  io_uring: hold uring_lock while completing failed polled io in io_wq_submit_work() (2020-12-22 17:14:53 -0700)

----------------------------------------------------------------
io_uring-5.11-2020-12-23

----------------------------------------------------------------
Jens Axboe (4):
      io_uring: break links on shutdown failure
      io_uring: hold mmap_sem for mm->locked_vm manipulation
      io_uring: make ctx cancel on exit targeted to actual ctx
      io-wq: kill now unused io_wq_cancel_all()

Pavel Begunkov (11):
      io_uring: cancel reqs shouldn't kill overflow list
      io_uring: remove racy overflow list fast checks
      io_uring: consolidate CQ nr events calculation
      io_uring: inline io_cqring_mark_overflow()
      io_uring: limit {io|sq}poll submit locking scope
      io_uring: close a small race gap for files cancel
      io_uring: fix 0-iov read buffer select
      io_uring: always progress task_work on task cancel
      io_uring: end waiting before task cancel attempts
      io_uring: fix ignoring xa_store errors
      io_uring: fix double io_uring free

Xiaoguang Wang (2):
      io_uring: fix io_wqe->work_list corruption
      io_uring: hold uring_lock while completing failed polled io in io_wq_submit_work()

 fs/io-wq.c    |  30 +--------
 fs/io-wq.h    |   3 +-
 fs/io_uring.c | 210 +++++++++++++++++++++++++++++++++-------------------------
 3 files changed, 120 insertions(+), 123 deletions(-)

-- 
Jens Axboe

