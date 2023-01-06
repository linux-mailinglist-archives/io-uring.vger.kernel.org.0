Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D76466042D
	for <lists+io-uring@lfdr.de>; Fri,  6 Jan 2023 17:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbjAFQZQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Jan 2023 11:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjAFQZQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Jan 2023 11:25:16 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A38976234
        for <io-uring@vger.kernel.org>; Fri,  6 Jan 2023 08:25:15 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id y2so1203199ily.5
        for <io-uring@vger.kernel.org>; Fri, 06 Jan 2023 08:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t+8G4QfxbpTv5YBCLuTWIxiK4PDsqbSxIEOgf3QdsJI=;
        b=L026DA7Q+RKVPsZ0l4qluIx2M7FRdm0zVtJkmIeR7EyM7sbuW6FtO3AYxnIDgzFrfq
         kohmJMGu6pflrgqLCx/8mje0FoZtvUsyGKecP/nY5la4gGIgaf9tZfYrOdQh7xrx5Rfg
         JmHiwQPpmEvBxiA7wVcK+gsapuS+ehMxFAndWmnBYPE8qTh74kMLA2iE/98CTBFuSxUl
         NYCY/hPxZGtX/E1Cls+utP08M2hYKj9hX9NK/AbCH05IVtiYA/bqMLddlh+B7ZH2a3yp
         UnGS2eAy1WZYBLchNn5Ao1TkvBIOSsgeHeZkki/KcAmLlK4SxopX9M1g4inmliWRZYH2
         HDOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=t+8G4QfxbpTv5YBCLuTWIxiK4PDsqbSxIEOgf3QdsJI=;
        b=kSU9xQPf1MJx0StC+VZ6YS6vjHfOA3ERvZs+e5DhteClEecyaVNc3MVJJqqr2y+ejy
         pxJw7q8u/JahH+RkjkNRviY/7bwWuEUVwTy1eT7PUM6GW/gcSeeVysf5J5JMv5f5Tsx7
         bl7EJ1HYXaz0dXe5KEMdbDyfl2jlkhVzdLYBpmc9583iR4aCnScJ+6roIZTT/gMC4xy9
         yLFL3+XTRRzfRK1+uaDUTUk+evIhWlItJ4y3XahilmuU4FZyEPD7ndhBU7jYdzT42CAv
         oTXF71V6zkjyzMARHBteanq0+pJVYmeOwaLCOweC6eU9JltvJstJQuIYNvIchmaY6YUn
         Rryw==
X-Gm-Message-State: AFqh2kpziq8PemPC74ybHph/7NZ7wf7aust+fms2EXLPW1yjXfyo8JKi
        d74WVusG6BS8UaEDeBG/FlvL8n+oAnz+FRWF
X-Google-Smtp-Source: AMrXdXslydYvU1X43TTz2XoRJ7Vf4SWWg7+yKU4CeF97v8ih1IWaQhoZsg1diMmCV7tXGSrtSFNcOw==
X-Received: by 2002:a92:1306:0:b0:30c:4991:2eac with SMTP id 6-20020a921306000000b0030c49912eacmr2791753ilt.0.1673022314885;
        Fri, 06 Jan 2023 08:25:14 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a7-20020a027a07000000b003753b6452f9sm431985jac.35.2023.01.06.08.25.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 08:25:14 -0800 (PST)
Message-ID: <2caed411-58e8-2286-2c4d-c0eaf91f26e1@kernel.dk>
Date:   Fri, 6 Jan 2023 09:25:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.2-rc3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A few minor fixes that should go into the 6.2 release:

- Fix for a memory leak in io-wq worker creation, if we ultimately end
  up canceling the worker creation before it gets created (me)

- lockdep annotations for the CQ locking (Pavel)

- A regression fix for CQ timeout handling (Pavel)

- Ring pinning around deferred task_work fix (Pavel)

- A trivial member move in struct io_ring_ctx, saving us some memory
  (me)

Please pull!


The following changes since commit 9eb803402a2a83400c6c6afd900e3b7c87c06816:

  uapi:io_uring.h: allow linux/time_types.h to be skipped (2022-12-27 07:32:51 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-2023-01-06

for you to fetch changes up to 12521a5d5cb7ff0ad43eadfc9c135d86e1131fa8:

  io_uring: fix CQ waiting timeout handling (2023-01-05 08:04:47 -0700)

----------------------------------------------------------------
io_uring-2023-01-06

----------------------------------------------------------------
Jens Axboe (2):
      io_uring/io-wq: free worker if task_work creation is canceled
      io_uring: move 'poll_multi_queue' bool in io_ring_ctx

Pavel Begunkov (3):
      io_uring: pin context while queueing deferred tw
      io_uring: lockdep annotate CQ locking
      io_uring: fix CQ waiting timeout handling

 include/linux/io_uring_types.h |  3 ++-
 io_uring/io-wq.c               |  1 +
 io_uring/io_uring.c            | 19 ++++++++++++-------
 io_uring/io_uring.h            | 15 +++++++++++++++
 4 files changed, 30 insertions(+), 8 deletions(-)

-- 
Jens Axboe

