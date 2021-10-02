Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D691541F94A
	for <lists+io-uring@lfdr.de>; Sat,  2 Oct 2021 04:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbhJBCHt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 22:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbhJBCHs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 22:07:48 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE463C061775
        for <io-uring@vger.kernel.org>; Fri,  1 Oct 2021 19:06:03 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id n71so13830435iod.0
        for <io-uring@vger.kernel.org>; Fri, 01 Oct 2021 19:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=9GxyXrxkG4P9XbDCbHpWzWcwlvlTFbTdmmi5BAfT/5o=;
        b=VdEbxWIBVh3fMECFAy8NJZU76wRwQ2JNfvmSMriJNWTa5kM7zzSrFfoMvwVx2/XoDv
         OK6clPgjAcFFMTAZ38A3Jw0J9wmfLopOgTK2H8ZavW4dmakyXDUSueTlPuiIeTGFx52l
         2pDvXIi3EEx8TvyhFDTc5A1VqCZiKxP4QrvJdntKqIsMIz/Rw4mAho6aXRxQURf1H0Io
         +7gFqWDxC2wSoRIqPFbRjaOPJjWxEGfhWCDRf6zAbRbRw1bxx1nmxl8KqRj9Ij0IQOUf
         C6QgArUnf7pjRO8dETUKuHilhpu7kKgzWgiG3E9IB3sV/UFvjVNDyCgXJLamAsGEpCou
         O4Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=9GxyXrxkG4P9XbDCbHpWzWcwlvlTFbTdmmi5BAfT/5o=;
        b=pCBy7Q3+uhsIxX/NbvYraF6oZM8pZuWDZRn6ag5r16D+6GqU5KOQSy4o/WUnLyBC/v
         q1vRx6Kd+2y1BYmR321WfTWfN1C1U5NpUbyhg4R9Oz/CC4sFOwwzDVERrWEgjc4k1Z3w
         lT8iRO/2CXm0ytV7Ce4mfbKHADk3KJCVm19U1nh4kCcsRJPTBRMyM1T1KcEBBskN4o9M
         KFGe33fV2cKnGZVQ6YTQGlAs1+LDcA0mm8euYvcIy3uJtsMucjRX38VXJUN0NG0pbkLq
         IId0O4MGJ6atyPqjq7UlB3yvWNgx/nORzLsvMRnJ2OFMNgszll5EHabtsMcMNUVTQX51
         NwTQ==
X-Gm-Message-State: AOAM532akplM6EFwJbIVdp7zGfl2/96FAUyQ1urB3a1M8XQbDDhxUb8S
        KRwloI7ZcL4XVaLQPoENWhz2y/G+HHLS9A==
X-Google-Smtp-Source: ABdhPJx8xoziPs8unAGe+8H6PCHrvbdJyltYzVEhMxH6EW6FyM9J+0I6rISUZ7szF8MO89VMu1HT3Q==
X-Received: by 2002:a5e:c101:: with SMTP id v1mr869211iol.90.1633140362638;
        Fri, 01 Oct 2021 19:06:02 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id b6sm4251238iod.55.2021.10.01.19.06.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 19:06:02 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.15-rc4
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Message-ID: <4aecbb63-a279-0fcc-3c8f-418c32b52810@kernel.dk>
Date:   Fri, 1 Oct 2021 20:06:01 -0600
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

Two fixes in here:

- The signal issue that was discussed start of this week (me).

- Kill dead fasync support in io_uring. Looks like it was broken since
  io_uring was initially merged, and given that nobody has ever
  complained about it, let's just kill it (Pavel).

Please pull!


The following changes since commit 7df778be2f61e1a23002d1f2f5d6aaf702771eb8:

  io_uring: make OP_CLOSE consistent with direct open (2021-09-24 14:07:54 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.15-2021-10-01

for you to fetch changes up to 3f008385d46d3cea4a097d2615cd485f2184ba26:

  io_uring: kill fasync (2021-10-01 11:16:02 -0600)

----------------------------------------------------------------
io_uring-5.15-2021-10-01

----------------------------------------------------------------
Jens Axboe (1):
      io-wq: exclusively gate signal based exit on get_signal() return

Pavel Begunkov (1):
      io_uring: kill fasync

 fs/io-wq.c    |  5 +----
 fs/io_uring.c | 17 ++---------------
 2 files changed, 3 insertions(+), 19 deletions(-)

-- 
Jens Axboe

