Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167D0471215
	for <lists+io-uring@lfdr.de>; Sat, 11 Dec 2021 07:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhLKGJu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Dec 2021 01:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhLKGJu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Dec 2021 01:09:50 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE6BC061714
        for <io-uring@vger.kernel.org>; Fri, 10 Dec 2021 22:09:50 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id k6-20020a17090a7f0600b001ad9d73b20bso9238861pjl.3
        for <io-uring@vger.kernel.org>; Fri, 10 Dec 2021 22:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=+H3vzDiULG89UBP6LJ1q5qFUCsZyGr7+u27ISsVNZjk=;
        b=SISyXOaTJJzNWTXKZjPFGtNR1BpeXDeHsaOkiryIF3JNYwPlV206+VPyDSDe3uq4gd
         05Ox+lQrRRKoIMfR4agZ2NYAlFyegH2kG28O6B+KChKDokVps50slTEJIWSDuQuUUPm9
         QslVmoxvV8NGTsX/vYNZ7M+D8rBtMgV4s5Z8P1CNtQS9oiT52NkAx8AUT0NJx+zexbEO
         FPsYv7J5NKKZv/UWqBZh7LyBDH2EOF5FvAE86hYPjYg1SN8ppCXYGcRerW4XOze59uc4
         Gew3xnpX140hc9JXEbihk0kHWsQOfY15QzRmT45J8OR2zvFV3nBeXPkXlMy5EVK36MeK
         3yVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=+H3vzDiULG89UBP6LJ1q5qFUCsZyGr7+u27ISsVNZjk=;
        b=hCk8b1PPFfJ3ocJY8QtIhLAEgTt6sqQIHbsY1XUXA6hwsxPdt3BJItOxbawtssxbSY
         zD/d1RDXS4GSLBtFAGtUoRz+UTWp4947J8RCVBo/ZlTJevuYnhfVs4tsb6rp9sg6LyN9
         klL2JGTbE7FFI6/oBk69wpKYH9zrIPPJsOis726P+XWMHlqwgtAKeBaE79lvc5usJXjI
         frouljWK63BaNoRJ0XtnPHBgCfYJ+mbIbeM31UVPm1vgcUER7UxjxPGu35KZoczDIWCr
         DUzRb9qLDTzX3GPumhB8Mrj1XyPCfGn1CvkVYJ9SWYbnqXqBIY7/jK3R6Y/bLuiOyHDK
         8xOA==
X-Gm-Message-State: AOAM533cfvkejW/40Q0VN8KP5kjaXRSIoIirZvtP+GodWH8wVUypHA+j
        hhSZWAmii56sh5rQ3Lb6Nt9u/NrbfC52tQ==
X-Google-Smtp-Source: ABdhPJwjyvELok4CW18d65GaPMDwCCYhsyfwhhmHBi0GMHWKUHluR7RF3MK8yTvSE/Yzv6qDAzcABA==
X-Received: by 2002:a17:90a:fe87:: with SMTP id co7mr28784350pjb.21.1639202988428;
        Fri, 10 Dec 2021 22:09:48 -0800 (PST)
Received: from [172.20.4.26] ([66.185.175.30])
        by smtp.gmail.com with ESMTPSA id o124sm5132313pfb.177.2021.12.10.22.09.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 22:09:48 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.16-rc5
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Message-ID: <a32963b8-3453-1af5-3544-3d533aa30c3e@kernel.dk>
Date:   Fri, 10 Dec 2021 23:09:46 -0700
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

A few fixes that are all bound for stable:

- Two syzbot reports for io-wq that turned out to be separate fixes, but
  ultimately very closely related.

- io_uring task_work running on cancelations.

Please pull!


The following changes since commit a226abcd5d427fe9d42efc442818a4a1821e2664:

  io-wq: don't retry task_work creation failure on fatal conditions (2021-12-03 06:27:32 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-12-10

for you to fetch changes up to 71a85387546e50b1a37b0fa45dadcae3bfb35cf6:

  io-wq: check for wq exit after adding new worker task_work (2021-12-10 13:56:28 -0700)

----------------------------------------------------------------
io_uring-5.16-2021-12-10

----------------------------------------------------------------
Jens Axboe (3):
      io-wq: remove spurious bit clear on task_work addition
      io_uring: ensure task_work gets run as part of cancelations
      io-wq: check for wq exit after adding new worker task_work

 fs/io-wq.c    | 29 +++++++++++++++++++++++------
 fs/io_uring.c |  6 ++++--
 2 files changed, 27 insertions(+), 8 deletions(-)

-- 
Jens Axboe

