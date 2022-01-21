Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E903B495FDD
	for <lists+io-uring@lfdr.de>; Fri, 21 Jan 2022 14:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350625AbiAUNlB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jan 2022 08:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235175AbiAUNlB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jan 2022 08:41:01 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7D5C061574
        for <io-uring@vger.kernel.org>; Fri, 21 Jan 2022 05:41:01 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id y22so10809090iof.7
        for <io-uring@vger.kernel.org>; Fri, 21 Jan 2022 05:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=baTMGVNcOO2CyLwWywpn3gvJeYK8c9XpKdqmhxeUFlo=;
        b=s+56BfDbgofHRz5Vhn093axL6U43jzXMkcCwkyFQtbS6bc7Ll00wikqNTpRWRSXHaz
         8h72FtHpNr2k/goQrXwYMkSDWlaKwlgzOs9iogk7HWvvfeZ8x5F0IVyl+0W3Vw3Gv3X9
         b8fOTW0ubTYuTRADktWdRwF/5CCEpr8XLvnNiJ0FllSIyHcnb344NO9YYfzvq3DVc0C/
         oKOHXYf2U1J2ihOHukICI+plpYjzzvoZwWbkvObSulpxPX1+hBv3GUdTeN8OrfZbHxKc
         moJ5dx0S5YeilBjhIAwvnwg2YGZsEe4MvueJWQ8GcWWjrE68JsTHpOVc73ZWWf0ikf2M
         aViw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=baTMGVNcOO2CyLwWywpn3gvJeYK8c9XpKdqmhxeUFlo=;
        b=o7Shs///RFyDaVeN95EG5C5o1tXjR2RouvnTu1Al8jBDsOe+AwYGhJpnso7N65f/mY
         7O+T4YFd0VLDriq6JD4X0JclhsQBasa1yueN195EELzFcRNOUDk4MabOPXBHVz1EMEuj
         Ls08HooAaRvA7uP0JmuypwyK+KZYwVwGkIMav+svYUOh8/dGKEWYXiuWJn27yV3Wmr1F
         7dMR/pdoHSPj+qkjO8cs0pI41e37/f7oQ7UF/Ro4ZCfP1ilMxPu07mTt1hTO41o5B95S
         paddZ/RohL9CNJ+yBXXzOiltM9hc0RD7U7m3isar8CCEAS9G+XlhbF4ryK+erfMLZN5E
         Pgjw==
X-Gm-Message-State: AOAM53131QcvmQvrPdikyMmIkn4/gad1P0REnF81SsefWejWy1Tnu+VR
        tX3G4Irr5aHxWDqtObqErrLyfB8KJd024g==
X-Google-Smtp-Source: ABdhPJxBm7lAX38tsol0Rsy6fsaLWKCfPQduO+By3G94bF02naAgwQ8tilHANUiCPuLYai1sr6AK5Q==
X-Received: by 2002:a05:6638:628:: with SMTP id h8mr1666121jar.192.1642772460503;
        Fri, 21 Jan 2022 05:41:00 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id d16sm1532410iow.13.2022.01.21.05.40.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jan 2022 05:40:59 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.17-rc1
Message-ID: <8d84c26c-cee8-64c7-1b86-16638a68e977@kernel.dk>
Date:   Fri, 21 Jan 2022 06:40:56 -0700
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

io_uring fixes for the 5.17-rc1 merge window:

- Fix the io_uring POLLFREE handling, similarly to how it was done for
  aio (Pavel)

- Remove (now) unused function (Jiapeng)

- Small series fixing an issue with work cancelations. A window exists
  where work isn't locatable in the pending list, and isn't active in a
  worker yet either. (me)

Please pull!


The following changes since commit fb3b0673b7d5b477ed104949450cd511337ba3c6:

  Merge tag 'mailbox-v5.17' of git://git.linaro.org/landing-teams/working/fujitsu/integration (2022-01-13 11:19:07 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.17-2022-01-21

for you to fetch changes up to 73031f761cb7c2397d73957d14d041c31fe58c34:

  io-wq: delete dead lock shuffling code (2022-01-19 13:11:58 -0700)

----------------------------------------------------------------
io_uring-5.17-2022-01-21

----------------------------------------------------------------
Jens Axboe (7):
      io-wq: remove useless 'work' argument to __io_worker_busy()
      io-wq: make io_worker lock a raw spinlock
      io-wq: invoke work cancelation with wqe->lock held
      io-wq: perform both unstarted and started work cancelations in one go
      io-wq: add intermediate work step between pending list and active work
      io_uring: perform poll removal even if async work removal is successful
      io-wq: delete dead lock shuffling code

Jiapeng Chong (1):
      io_uring: Remove unused function req_ref_put

Pavel Begunkov (1):
      io_uring: fix UAF due to missing POLLFREE handling

 fs/io-wq.c    | 91 ++++++++++++++++++++++++++++++++++++-----------------------
 fs/io_uring.c | 79 ++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 116 insertions(+), 54 deletions(-)

-- 
Jens Axboe

