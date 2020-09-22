Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F200027473B
	for <lists+io-uring@lfdr.de>; Tue, 22 Sep 2020 19:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgIVRHU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Sep 2020 13:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgIVRHU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Sep 2020 13:07:20 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B60C061755
        for <io-uring@vger.kernel.org>; Tue, 22 Sep 2020 10:07:20 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x22so8217583pfo.12
        for <io-uring@vger.kernel.org>; Tue, 22 Sep 2020 10:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=qN7SFU2dhcxyjoItGgpNRR8UnnLTaYdcEBc0FU5f+iY=;
        b=FeZg+yMPXx4Qr4+Bh/ENN8vowhkjIiqpvpa3CZsDhYFPJwLlvTeP6PsDssoUxNsG9G
         OvMu7TPFGZ79XvT9lkB/8Or1tjcI/liACPbTY5Ox/DToMYPkDKzrvyi1OEpJaYDeRMsm
         tDjuBb1JIlnoK80FQVe1M4m9py/sc2Z0JMkLJZZeJ1ubcxEGIpmHTv55M72Dz3cAZuhc
         5AmMhCQhf4CsyBNDPN8j4TjwhxqJZ46zGHrrKgIOlX9dDmHEqUircaxvQkie8Bh6Frvm
         TnwZjVUwu6RKT42edZPLru4SR0iLVmHL51K2p2vzPJUG8gbk2asl6adaUl69P2QnSpUY
         k5wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=qN7SFU2dhcxyjoItGgpNRR8UnnLTaYdcEBc0FU5f+iY=;
        b=Qdziiung5QGFtdnIsdZCaBwL7dHIhxcpg8i8f4NR1KAQTqiYKHM+U+S7F77cSUTexR
         CgUN6pN39TBSInlaDTlK9C+AtN15HGqEySMhE6QIV9QKYCLaqW0Fd/Ypd57QxZ8MqLr7
         mq/m8w6mYRG+76ylVD+6Oyzfr/T0l04khgz01fqNUZiWT+tYQ0Zehhg9IjEgfrscMv3/
         ZZ/ZCJmi/99ZDbj1KlsRaroO8//2HLLufGzHZLeNyhNJHQ0YQ4mO9mSyy83RBPYhcuO9
         Dvku3e5Xj0EBvF37B7fNVgR44VRYeq1j5G5g/Lrb9AZOiKzh8gFPAIy1feOKqaSsPyH/
         Z8QQ==
X-Gm-Message-State: AOAM530WkUE5yvIE9JQ2a2+NHElnytbndXwYASHYXWQ3uVALxmkAu9Om
        dM9f9GijGpsuTgbS7ed2vAM16g==
X-Google-Smtp-Source: ABdhPJy60TbV4qhSIZFZBwhLm1nvhVxJ2xB14oZxPIRrCmVohH/YxLbDwsWgrlTpW6I7Ieg2/PMBWw==
X-Received: by 2002:a62:7743:0:b029:13c:1611:658e with SMTP id s64-20020a6277430000b029013c1611658emr4834552pfc.11.1600794439731;
        Tue, 22 Sep 2020 10:07:19 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 72sm15396669pfx.79.2020.09.22.10.07.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 10:07:19 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.9-rc
Message-ID: <14cc3fb9-2f6e-ef49-c98b-994048c0b4d3@kernel.dk>
Date:   Tue, 22 Sep 2020 11:07:18 -0600
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

A few fixes - most of them regression fixes from this cycle, but also a
few stable heading fixes, and a build fix for the included demo tool
since some systems now actually have gettid() available.

Please pull.


The following changes since commit c127a2a1b7baa5eb40a7e2de4b7f0c51ccbbb2ef:

  io_uring: fix linked deferred ->files cancellation (2020-09-05 16:02:42 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.9-2020-09-22

for you to fetch changes up to 4eb8dded6b82e184c09bb963bea0335fa3f30b55:

  io_uring: fix openat/openat2 unified prep handling (2020-09-21 07:51:03 -0600)

----------------------------------------------------------------
io_uring-5.9-2020-09-22

----------------------------------------------------------------
Douglas Gilbert (1):
      tools/io_uring: fix compile breakage

Jens Axboe (7):
      io_uring: grab any needed state during defer prep
      io_uring: drop 'ctx' ref on task work cancelation
      io_uring: don't run task work on an exiting task
      io_uring: don't re-setup vecs/iter in io_resumit_prep() is already there
      io_uring: don't use retry based buffered reads for non-async bdev
      io_uring: mark statx/files_update/epoll_ctl as non-SQPOLL
      io_uring: fix openat/openat2 unified prep handling

 fs/io_uring.c                   | 49 ++++++++++++++++++++++++++++++++---------
 tools/io_uring/io_uring-bench.c |  4 ++--
 2 files changed, 40 insertions(+), 13 deletions(-)

-- 
Jens Axboe

